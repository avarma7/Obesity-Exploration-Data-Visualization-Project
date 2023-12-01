# Data Cleaning for Plots

# Load Data
country_rates <- read.csv("Obesity_Country_Rates.csv")
us_data <- read.csv("Nutrition__Physical_Activity__and_Obesity_US.csv")
physical_data <- read.csv("physical_activity.csv")
vegetable_data <- read.csv("vegetable_data.csv")


# Change data values to numeric and drop na values
country_rates <- subset(country_rates, select = c("country", "obesityRatesByCountry_obesityRate"))
transform(country_rates, rate = as.numeric(rate))
transform(us_data, Data_Value = as.numeric(Data_Value))
us_data <- us_data %>% drop_na(Data_Value)


# For obesity rate world map
# Make country_rates compatible with the column values for the ggplot world map to left join
colnames(country_rates)[1] <- "region"
colnames(country_rates)[2] <- "rate"
country_rates$region[country_rates$region == 'DR Congo'] <- 'Democratic Republic of the Congo'

country_rates$region[country_rates$region == 'Republic of the Congo'] <- 'Republic of Congo'

country_rates$region[country_rates$region == 'United States'] <- 'USA'

country_rates$region[country_rates$region == 'United Kingdom'] <- 'UK'

country_rates <- country_rates %>% add_row(region = "Greenland", rate = 0.0)



# For vegetable consumption world map
# Make 2020 vegetable data compatible with column values for country_rates to left join
veg_2020_world <- vegetable_data %>% filter(Year == "2020" & !str_detect(Entity, '(FAO)'))

colnames(veg_2020_world)[1] <- "region"
colnames(veg_2020_world)[4] <- "veg_kgs"
veg_2020_world$region[veg_2020_world$region == 'Democratic Republic of Congo'] <- 'Democratic Republic of the Congo'
veg_2020_world$region[veg_2020_world$region == 'United States'] <- 'USA'

world_veg <- country_rates %>% left_join(veg_2020_world) 
world_veg <- na.omit(world_veg)


# For physical activty world bar plot
physical_data <- physical_data %>% drop_na(FactValueNumeric)

physical_region <- physical_data %>% group_by(ParentLocation) %>% 
  filter(Dim1 == "Both sexes") %>% summarise(avg = mean(FactValueNumeric))



# For obesity rate US map
us_rates <- us_data %>% group_by(LocationDesc) %>% 
  filter(Class == "Obesity / Weight Status" & YearStart == "2021") %>% 
  summarize(rate = mean(Data_Value))

# Florida rate was unavailable for 2021 so had to add 2020 metric
florida_rate <- mean(us_data$Data_Value[us_data$LocationDesc == "Florida"& us_data$YearStart == "2020"& us_data$Class == "Obesity / Weight Status"])

# Have to make us_rates compatible with usmap and add the Florida data
colnames(us_rates)[1] <- "state"
us_rates <- us_rates %>% add_row(region = "florida", rate = florida_rate)


# For US vegetable consumption map and scatter plot
us_vegetable <- us_data %>% group_by(LocationDesc) %>% 
  filter(Question == "Percent of adults who report consuming vegetables less than one time daily" &YearStart == "2021") %>% 
  summarize(veg_rate = mean(Data_Value))

colnames(us_vegetable)[1] <- "state"

# Florida rate was unavailable for 2021 so had to add 2019 metric
florida_rate <- mean(us_data$Data_Value[us_data$LocationDesc == "Florida"& us_data$YearStart == "2019"& us_data$Question == "Percent of adults who report consuming vegetables less than one time daily"])

us_vegetable <- us_vegetable %>% add_row(state = "Florida", veg_rate = florida_rate)

us_rates <- us_rates %>% left_join(us_vegetable, by = "state")


# For US physical activity map and scatter plot
us_physical <- us_data %>% group_by(LocationDesc) %>% 
  filter(Question == "Percent of adults who engage in no leisure-time physical activity" &YearStart == "2021") %>% 
  summarize(physical_rate = mean(Data_Value))


colnames(us_physical)[1] <- "state"

# Florida rate was unavailable for 2021 so had to add 2019 metric
florida_rate <- mean(us_data$Data_Value[us_data$LocationDesc == "Florida"& us_data$YearStart == "2020"& us_data$Question == "Percent of adults who engage in no leisure-time physical activity"])

us_physical <- us_physical %>% add_row(state = "Florida", physical_rate = florida_rate)

us_rates <- us_rates %>% left_join(us_physical, by = "state") 
