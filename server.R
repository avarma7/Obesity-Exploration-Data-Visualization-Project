library(leaflet)
library(tidyverse)
library(usmap)
library(plotly)
library(DT)

# Load and prep data

country_rates <- read.csv("Obesity_Country_Rates.csv")
us_data <- read.csv("Nutrition__Physical_Activity__and_Obesity_US.csv")
physical_data <- read.csv("physical_activity.csv")
vegetable_data <- read.csv("vegetable_data.csv")

# World obesity map
country_rates <- subset(country_rates, select = c("country", "obesityRatesByCountry_obesityRate"))

colnames(country_rates)[1] <- "region"
colnames(country_rates)[2] <- "rate"


transform(country_rates, rate = as.numeric(rate))
transform(us_data, Data_Value = as.numeric(Data_Value))
us_data <- us_data %>% drop_na(Data_Value)


country_rates$region[country_rates$region == 'DR Congo'] <- 'Democratic Republic of the Congo'

country_rates$region[country_rates$region == 'Republic of the Congo'] <- 'Republic of Congo'

country_rates$region[country_rates$region == 'United States'] <- 'USA'

country_rates$region[country_rates$region == 'United Kingdom'] <- 'UK'

country_rates <- country_rates %>% add_row(region = "Greenland", rate = 0.0)

world_map <- map_data('world')

world_obesity <- world_map %>% left_join(country_rates, by = "region")

# World vegetable
veg_2020_world <- vegetable_data %>% filter(Year == "2020" & !str_detect(Entity, '(FAO)'))

colnames(veg_2020_world)[1] <- "region"
colnames(veg_2020_world)[4] <- "veg_kgs"
veg_2020_world$region[veg_2020_world$region == 'Democratic Republic of Congo'] <- 'Democratic Republic of the Congo'
veg_2020_world$region[veg_2020_world$region == 'United States'] <- 'USA'

world_veg <- country_rates %>% left_join(veg_2020_world) 
world_veg <- na.omit(world_veg)

# World physical
physical_data <- physical_data %>% drop_na(FactValueNumeric)

physical_region <- physical_data %>% group_by(ParentLocation) %>% 
  filter(Dim1 == "Both sexes") %>% summarise(avg = mean(FactValueNumeric))


# US obesity
us_rates <- us_data %>% group_by(LocationDesc) %>% 
  filter(Question == "Percent of adults aged 18 years and older who have obesity" &
           YearStart == "2021") %>% 
  summarize(rate = mean(Data_Value))

colnames(us_rates)[1] <- "state"

florida_rate <- mean(us_data$Data_Value[us_data$LocationDesc == "Florida"& us_data$YearStart == "2020"& us_data$Question == "Percent of adults aged 18 years and older who have obesity"])

us_rates <- us_rates %>% add_row(state = "Florida", rate = florida_rate)


# US vegetable
us_vegetable <- us_data %>% group_by(LocationDesc) %>% 
  filter(Question == "Percent of adults who report consuming vegetables less than one time daily" &YearStart == "2021") %>% 
  summarize(veg_rate = mean(Data_Value))

colnames(us_vegetable)[1] <- "state"

florida_rate <- mean(us_data$Data_Value[us_data$LocationDesc == "Florida"& us_data$YearStart == "2019"& us_data$Question == "Percent of adults who report consuming vegetables less than one time daily"])

us_vegetable <- us_vegetable %>% add_row(state = "Florida", veg_rate = florida_rate)

us_rates <- us_rates %>% left_join(us_vegetable, by = "state")


# US physical
us_physical <- us_data %>% group_by(LocationDesc) %>% 
  filter(Question == "Percent of adults who engage in no leisure-time physical activity" &YearStart == "2021") %>% 
  summarize(physical_rate = mean(Data_Value))


colnames(us_physical)[1] <- "state"

florida_rate <- mean(us_data$Data_Value[us_data$LocationDesc == "Florida"& us_data$YearStart == "2020"& us_data$Question == "Percent of adults who engage in no leisure-time physical activity"])

us_physical <- us_physical %>% add_row(state = "Florida", physical_rate = florida_rate)

us_rates <- us_rates %>% left_join(us_physical, by = "state") 


function(input, output, session) {
  
  output$scale_note1 = renderText({"Note: Different scale from other maps."})
  output$scale_note2 = renderText({"Note: Different scale from other maps."})
  output$scale_note3 = renderText({"Note: Different scale from other maps."})
  
  output$veg_related = renderText({"Explore if an Association Exists Between Vegetable Consumption and Obesity."})
  output$phys_related = renderText({"Explore if an Association Exists Between Physical Activity and Obesity."})
  
  output$countryObesityTable = renderDataTable(country_rates %>% arrange(desc(rate)),
                                               colnames = c("Country", "Obesity Rate"),
                                               rownames = FALSE)
  
  output$stateObesityTable = renderDataTable(us_rates %>% select(state, rate) %>%  
                                               arrange(desc(rate)),
                                               colnames = c("State", "Obesity Rate"),
                                               rownames = FALSE)
  
  output$stateVegTable = renderDataTable(us_rates %>% select(state, veg_rate) %>%  
                                               arrange(desc(veg_rate)),
                                             colnames = c("State", "Insufficient Veg Consumption Rate"),
                                             rownames = FALSE)
  
  output$statePhysTable = renderDataTable(us_rates %>% select(state, physical_rate) %>%  
                                           arrange(desc(physical_rate)),
                                         colnames = c("State", "Insufficient Physical Activity Rate"),
                                         rownames = FALSE)
  
  
  output$obesity_world = renderPlot({
    obesity_world_map = ggplot(world_obesity, aes(x = long, y = lat, group = group)) +
      geom_polygon(aes(fill = rate), color = "black") +
      scale_fill_gradient2(name = "Obesity Rate\n(Percentage)", mid="lightblue",
                           low="darkolivegreen1", high = "darkblue", midpoint = 20) + 
      coord_cartesian(xlim = c(-180, 180), ylim = c(-50, 90)) +
      theme_bw() +
      theme(plot.background = element_blank(),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            axis.title.x = element_blank(),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank(),
            plot.title = element_text(size = 20,face="bold"),
            plot.subtitle = element_text(size = 15),
            legend.title = element_text(size = 13, face = "bold"),
            legend.text = element_text(size = 13)) + 
      labs(title = "Global Obesity Rates by Country 2023",
           subtitle = "How do Obesity Rates Differ Globally?")
    
    print(obesity_world_map)
  })

  output$obesity_us_map = renderPlot({
    obesity_us_map = plot_usmap(data = us_rates, values = "rate", regions = "states") +
      scale_fill_gradient2(name = "Obesity Rate\n(Percentage)", low="darkolivegreen1",
                           mid="lightblue", high = "darkblue", midpoint = 32) + 
      theme_bw() + 
      theme(plot.background = element_blank(),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            axis.title.x = element_blank(),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank(),
            plot.title = element_text(size = 20,face="bold"),
            plot.subtitle = element_text(size = 15),
            legend.title = element_text(size = 13, face = "bold"),
            legend.text = element_text(size = 13),
            legend.position = c(1.03, 0.5)) + 
      labs(title = "United States Obesity Rates in Adults by State 2021",
           subtitle = "How do Obesity Rates Differ Across States?")
    
    print(obesity_us_map)
  })

  
  output$vegetable_world = renderPlot({
    vegetable_world = ggplot(data = world_veg, mapping = aes(rate, veg_kgs)) + 
      geom_point(size = 2, shape = 21, fill = "springgreen") +
      scale_x_continuous(n.breaks = 7) +
      geom_smooth(method = lm, se = TRUE, color = "blue", fill = "cornflowerblue") +
      geom_text(mapping = aes(label = "1. Average per capita vegetable consumption, measured in kilograms per person per year.", x = 35, y = 380), color = "black", size = 5) +
      labs(x = "Obesity Rate (2023)",
           y = expression(paste(bold("Vegetable Consumption in kgs (2020) "^1))),
           title = "Vegetable Consumption vs. Obesity Rate per Country",
           subtitle = "Is there any Association between Vegetable Consumption and Obesity Rates Globally?") + 
      theme(axis.text = element_text(size=13),
            axis.title.x = element_text(size=15, face = "bold"),
            axis.title.y = element_text(size=15, face = "bold"),
            plot.title = element_text(size = 20,face="bold"),
            plot.subtitle = element_text(size = 15))
    
    print(vegetable_world)
  })
  
  output$vegetable_us_map = renderPlot({
    vegetable_us_map = plot_usmap(data = us_rates, values = "veg_rate", regions = "states") +
      scale_fill_gradient2(name = "Insufficent \nConsumption Rate\n(Percentage)", low="darkolivegreen1",
                           mid="lightblue", high = "darkblue", midpoint = 21) + 
      #xlim(-2100000, 3200000) +
      geom_text(mapping = aes(label = "1. Percent of adults who report consuming vegetables less than one time daily.", x = 300000, y = -2700000), color = "black", size = 4.2) +
      theme_bw() + 
      theme(plot.background = element_blank(),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            axis.title.x = element_blank(),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank(),
            plot.title = element_text(size = 17,face="bold"),
            plot.subtitle = element_text(size = 15),
            legend.title = element_text(size = 13, face = "bold"),
            legend.text = element_text(size = 13),
            legend.position = c(1.09, 0.5)) + 
      labs(title = expression(bold(paste("United States Insufficient Vegetable Consumption Rates"^1, " by State 2021"))),
           subtitle = "How do Insufficient Vegetable Consumption Rates Differ Across States \nand is there a Similar Pattern to Obesity Rates?")
    
    print(vegetable_us_map)
  })

  output$vegetable_us_scatter = renderPlot({
    vegetable_us_scatter = ggplot(data = us_rates, mapping = aes(rate, veg_rate)) + 
      geom_point(size = 2, shape = 21, fill = "springgreen") +
      geom_smooth(method = lm, se = TRUE, color = "blue", fill = "cornflowerblue") +
      geom_text(mapping = aes(label = "1. Percent of adults who report consuming vegetables less than one time daily.", x = 31.5, y = 3), color = "black", size = 5) +
      ylim(0, 35) + 
      labs(x = "Obesity Rate",
           y = expression(paste(bold("Insufficient Vegetable Consumption Rate "^1))),
           title = "Insufficient Vegetable Consumption vs. Obesity Rate per State 2021",
           subtitle = "Is there any Association between Physical Activity and Obesity Rates in the United States?") + 
      theme(axis.text = element_text(size=13),
            axis.title.x = element_text(size=15, face = "bold"),
            axis.title.y = element_text(size=15, face = "bold"),
            plot.title = element_text(size = 20,face="bold"),
            plot.subtitle = element_text(size = 15))
    
    print(vegetable_us_scatter)
  })
  
  output$physical_world = renderPlot({
    physical_world = ggplot(data = physical_region, aes(x = reorder(ParentLocation, avg), y = avg, fill = ParentLocation)) +
      geom_bar(stat = "identity") + 
      geom_text(aes(label = round(avg, 2)), vjust = -0.4, size = 5, face = "bold") +
      labs(x = "Geographical Region",
           y = "Average % of Insufficient Physical Activity",
           title = "Average Rate of Insufficient Physical Activity Among Adults by Region",
           subtitle = "How Does Physical Activity Vary Between Regions and is there a Similar Pattern to Obesity Rates?") +
      scale_x_discrete(labels=c("Africa", "South/East \nAsia", "Western \nPacific",
                                "Europe", "Eastern \n Mediterranean", "Americas")) +
      theme(axis.text.x =element_text(size = 13, face = "bold"),
            axis.text.y = element_text(size = 13),
            axis.title.x = element_text(size=15, face = "bold"),
            axis.title.y = element_text(size=15, face = "bold"),
            plot.subtitle = element_text(size = 15),
            plot.title = element_text(size = 20, face = "bold"),
            legend.position = "none")
    
    print(physical_world)
  })

  output$physical_us_map = renderPlot({
    physical_us_map = plot_usmap(data = us_rates, values = "physical_rate", regions = "states") +
      scale_fill_gradient2(name = "Insufficent \nActivity Rate\n(Percentage)", low="darkolivegreen1",
                           mid="lightblue", high = "darkblue", midpoint = 23) + 
      geom_text(mapping = aes(label = "1. Percent of adults who engage in no leisure-time physical activity.", x = 300000, y = -2700000), color = "black", size = 5) +
      theme_bw() + 
      theme(plot.background = element_blank(),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            axis.title.x = element_blank(),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank(),
            plot.title = element_text(size = 18,face="bold"),
            plot.subtitle = element_text(size = 15),
            legend.title = element_text(size = 13, face = "bold"),
            legend.text = element_text(size = 13),
            legend.position = c(1.09, 0.5)) + 
      labs(title = expression(bold(paste("United States Insufficient Physical Activity Rates"^1, " by State 2021"))),
           subtitle = "How do Insufficient Physical Activity Rates Differ Across States \nand is there a Similar Pattern to Obesity Rates?")
    
    print(physical_us_map)
  })

  output$physical_us_scatter = renderPlot({
    physical_us_scatter = ggplot(data = us_rates, mapping = aes(rate, physical_rate)) + 
      geom_point(size = 2, shape = 21, fill = "lightslateblue") +
      geom_smooth(method = lm, se = TRUE, color = "purple", fill = "mediumorchid1") +
      geom_text(mapping = aes(label = "1. Percent of adults who engage in no leisure-time physical activity.", x = 31.5, y = 3), color = "black", size = 5) +
      ylim(0, 35) +
      labs(x = "Obesity Rate",
           y = expression(paste(bold("Insufficient Physical Activity Rate "^1))),
           title = "Insufficient Physical Activity vs. Obesity Rate per State 2021",
           subtitle = "Is there any Association between Physical Activity and Obesity Rates in the United States?") + 
      theme(axis.text = element_text(size=13),
            axis.title.x = element_text(size=15, face = "bold"),
            axis.title.y = element_text(size=15, face = "bold"),
            plot.title = element_text(size = 20,face="bold"),
            plot.subtitle = element_text(size = 15))
    
    print(physical_us_scatter)
  })
  
}
