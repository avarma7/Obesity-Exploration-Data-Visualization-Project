library(shiny)
library(shinydashboard)

header <- dashboardHeader(title = "Explore Obesity Rates and Possibly Associated Factors Across the World and the United States",
                          titleWidth = 900)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(HTML("Obesity"), tabName = "obesity"),
    menuItem(HTML("Vegetable Consumption"), tabName = "vegetable"),
    menuItem(HTML("Physical Activity"), tabName = "activity")
  )
  
)

body <- dashboardBody(
  tabItems(
    tabItem(
      tabName = "obesity",
      tabsetPanel(id = "obesityTabs", span(textOutput("scale_note1"), style = "font-size: 15px; color:red"),
        tabPanel("World Stats", 
                 plotOutput(width = 900, height = 500, "obesity_world"),
                 dataTableOutput("countryObesityTable")
        ),
        tabPanel("US Stats",
                 verticalLayout(
                   plotOutput("obesity_us_map"),
                   dataTableOutput("stateObesityTable")
                 )
        )
      )
    ),
    tabItem(
      tabName = "vegetable",
      tabsetPanel(id = "vegetableTabs", span(textOutput("veg_related"), style = "font-size: 20px"),
        tabPanel("World Stats",
                 plotOutput("vegetable_world")
        ),
        tabPanel("US Stats",
                 verticalLayout(
                   span(textOutput("scale_note2"), style = "font-size: 15px; color:red"),
                   plotOutput("vegetable_us_map"),
                   plotOutput("vegetable_us_scatter"),
                   dataTableOutput("stateVegTable")
                 )
        )
      )
    ),
  tabItem(
    tabName = "activity",
    tabsetPanel(id = "activityTabs", span(textOutput("phys_related"), style = "font-size: 20px"),
      tabPanel("World Stats",
               plotOutput("physical_world")
      ),
      tabPanel("US Stats",
               verticalLayout(
                 span(textOutput("scale_note3"), style = "font-size: 15px; color:red"),
                 plotOutput("physical_us_map"),
                 plotOutput("physical_us_scatter"),
                 dataTableOutput("statePhysTable")
               )
      )
    )
  )
))

dashboardPage(header, sidebar, body)
