# Stat 451 Final Project

# Question:
How do obesity rates differ globally between countries and regionally within the United States? 
Many claim that physical activity and diet may be related to obesity. So, do factors such as the amount of physical activity and vegetable consumption have an association with obesity rates globally and within the United States? Are these trends, if any, globally and regionally within the United States, consistent with each other?

# Datasets:
Obesity Rates by Country:
[Obesity_Country_Rates.csv](https://github.com/avarma7/Stat-451-Final-Project/files/13384666/Obesity_Country_Rates.csv)

Vegetable Consumption by Country:
[vegetable_data.csv](https://github.com/avarma7/Stat-451-Final-Project/files/13384677/vegetable_data.csv)

Insufficient Physical Activity Rate among Adults by Country:
[physical_activity.csv](https://github.com/avarma7/Stat-451-Final-Project/files/13519026/physical_activity.csv)


United States obesity rates, vegetable consumption rates, physical activity rates by State (file too large):
Link: https://catalog.data.gov/dataset/nutrition-physical-activity-and-obesity-behavioral-risk-factor-surveillance-system

# Visualization Analysis
Global Obesity Rates by Country 2023: 

The aim of this visualization is not to quantify the obesity rates by country but to easily show the general trend of obesity rates globally through color hue and explore any patterns. Darker shades (blue) reflect high obesity rates and lighter shades (light green) reflect low obesity rates. From the map, it is easy to see that obesity rates tend to be higher in the Americas, especially the United States, the Middle East, and Oceania. We can also see that obesity rates tend to be lower in many Asian countries such as India and China, and central African countries such as Sudan. Now that we know the general pattern of how obesity rates differ between countries, we can look at factors such as physical activity and diet between these countries and compare them to this map to see if they reflect any similar/opposite pattern to the obesity rates, indicating a possible association.


United States Obesity Rates by State 2021:

Similar to the previous visual, the goal of this visual is to easily show the general trend of average obesity rates within the United States through color hue and explore any patterns. Darker shades (blue) reflect high obesity rates and lighter shades (light green) reflect low obesity rates. From the map, we can see that states located on the west and east coasts such as California and New York tend to have lower obesity rates. We can also see that obesity rates tend to be higher in states in the Midwest like South Dakota and Oklahoma and in some states in the South such as Mississippi and Alabama, which have the highest rates. Again, now that we know the general pattern of obesity rates across the states, we can look at factors such as physical activity and diet across the states and compare them to this map to see if they reflect any similar/opposite pattern to the obesity rates, indicating a possible association.


Vegetable Consumption vs. Obesity Rate per Country:

To explore if there is an association between the obesity rate and vegetable consumption globally, I have plotted each country's average per capita vegetable consumption per person per year in 2020 against its obesity rate in 2023 which was shown in the first visual. Although the vegetable consumption metric is from 2020, it has not changed much in the past three years so we would expect to see similar results with little variation in the data if we were to use 2023 data. I decided to use a scatter plot so the viewer can easily notice any patterns or correlations between the two variables, for example, if the data follows a line or some other well-known function. Inherently, we would expect to see that as the obesity rate increases vegetable consumption decreases, but from the plot we can see that this is not the case. From this scatter plot, although the country with a low obesity rate has the highest vegetable consumption and the country with the highest obesity rate has a low vegetable consumption, there appears to be no distinct pattern among the data. The points are highly scattered and varied especially between countries that have an obesity rate between 10 and 30 percent. The 95% confidence interval shown with the regression line widens quite a bit at the end of the plot and it looks like 0 is within the interval. This indicates that there may not be an association between obesity rate and vegetable consumption on a global scale.


United States Insufficient Vegetable Consumption Rates by State 2021:

This visual shows the general trend of the average insufficient vegetable consumption rates (defined as percent of adults who report consuming vegetables less than one time daily) within the United States through color hue and explore any patterns and if it is similar to the pattern of obesity rates. Darker shades (blue) reflect high insufficient consumption rates and lighter shades (light green) reflect low insufficient consumption rates. Instinctively, we would believe that states with high obesity would have high insufficient consumption rate and would expect the same color distribution as the US obesity map. However, from the map, we can see that there are different colors spread out all across the map, which may indicate that there is no general pattern between a region of states and the consumption rate. The colors of the states also do not show a similar or opposite pattern to the colors of the states from US obesity map which may indicate that there is no relation between vegetable consumption and obesity in the United States. 


Insufficient Vegetable Consumption vs. Obesity Rate per State 2021:

To formally explore if there is an association between the obesity rate and vegetable consumption within the United States, I have plotted each state's average insufficient vegetable consumption rate against its average obesity rate in 2021. I decided to use a scatter plot so the viewer can easily notice any patterns or correlations between the two variables, for example, if the data follows a line or some other well-known function. Again, we would, instinctively, expect to see that as the obesity rate increases insufficient vegetable consumption also increases, but from the plot, we can see that this is not the case. The regression line appears to have little to no slope and the 95% confidence interval also appears to have 0 within the interval. This indicates that there may not be an association between vegetable consumption and obesity rate. This is consistent with our findings on the global scale which solidifies our conclusion that there is no relationship between the two variables, contrary to what we originally suspected.


Average Rate of Insufficient Physical Activity Among Adults by Region:

To explore if there is an association between the obesity rate and physical activity globally, I have created a bar plot where each bar represents the average insufficient physical activity rate for a region of the world in 2016. We would likely expect to see that the regions we found that had high obesity rates from the world map, would also have high insufficient physical activity rates. From the bar plot, we find this to be true. In the obesity map we saw that areas such North America and the Middle East had high obesity rates. From the bar plot, we see that the regions with the highest insufficient physical activity rates are also the Americas and the Middle East. We also see that the regions with the lowest insufficient physical activity rates, Africa and Asia, also had low obesity rates according to the map. This indicates that there may be a positive association between obesity rate and insufficient physical activity rate, or more generally, there may be a negative association between physical activity and obesity globally.


United States Insufficient Physical Activity Rates by State 2021:

This visual shows the general trend of the average insufficient physical activity rates (defined as percent of adults who engage in no leisure-time physical activity) within the United States through color hue and explore any patterns and if it is similar to the pattern of obesity rates. Darker shades (blue) reflect high insufficient activity rates and lighter shades (light green) reflect low insufficient activity rates. Instinctively, we would believe that states with high obesity would have high insufficient actvity rate and would expect the same color distribution as the US obesity map. From the map, we find this to be relatively true. The areas that were darker shades in the obesity map, the South and Midwest regions, are also darker shades in this map. The same can be said about the lighter-shaded regions. Overall, the colors of the states in this map relatively follow a similar pattern to the colors of the states from US obesity map which may indicate that there is a positive relation between insufficient physical activity and obesity in the United States, or there is a negative association between physical activity and obesity in the United States.



Insufficient Physical Activity vs. Obesity Rate per State 2021:

To formally explore if there is an association between the obesity rate and physical activity within the United States, I have plotted each state's average insufficient physical activity rate against its average obesity rate in 2021. I decided to use a scatter plot so the viewer can easily notice any patterns or correlations between the two variables, for example, if the data follows a line or some other well-known function. Again, we would, instinctively, expect to see that as the obesity rate increases insufficient physical activity rate also increases. From the plot, we can see that this is true. The regression line appears to have a positive slope and the 95% confidence interval does not appear to have 0 within the interval. This indicates that there may be a positive association between insufficient physical activity and obesity. This is consistent with our findings on the global scale which solidifies our conclusion that there is a negative association between the two variables, as physical activity increases, obesity decreases. This is consistent with what we originally suspected.






