library(shinythemes)
library(shinydashboard)


header <- dashboardHeader(
  title = "Rat Sightings in NYC"
)

body <- dashboardBody(
  tabItems(
    tabItem("dashboard",
            h2("Dashboard"),
  fluidRow(
### map ###################################    
    column(width = 9,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput(outputId = "map", height = 675)
           )
    ),
### Control Widgets #######################
    column(width = 3,
           box(width = NULL, status = "warning",
               uiOutput("ZoningSelect"),
               dateRangeInput('dateRange',
                              label = 'Date range input: yyyy-mm-dd',
                              format = "yyyy-mm-dd",
                              start = '2010-01-01', end = '2017-09-16',
                              min = '2010-01-01', max = '2017-09-16'),
               checkboxGroupInput("Zoning", "Show",
                                  choices = c(
                                    "Residential" = "Residential",
                                    "Mixed Use" = "Mixed Use",
                                    "Commercial" = "Commercial",
                                    "Exterior/Vacant Buildings" = "Exterior/Vacant Buildings",
                                    "Other (Unknown)" = "Other (Unknown)"
                                  ), selected = ("Residential")
               )
               
           ),
### Histogram ############################           
           box(width = NULL, status = "warning",
               plotOutput("hist")
               )
    ) 
)
),

### Tab 2 ################################
  tabItem("tables",
        h2("Tables and Histogram"),
        fluidRow(
          column(width = 9,
### Histogram ################################
          box(width = NULL, solidHeader = TRUE,
              plotOutput("hist2")
          ),
                 
### DataTable ################################
                  box(width = NULL, solidHeader = TRUE,
                       DT::dataTableOutput("CloseTable")  
                      #htmlOutput(outputId = "CloseTable")
                 )),
### Control Widgets #######################
          column(width = 3,
                 box(width = NULL, status = "warning",
                     uiOutput("ZoningSelect2"),
                     dateRangeInput('dateRange2',
                                    label = 'Date range input: yyyy-mm-dd',
                                    format = "yyyy-mm-dd",
                                    start = '2010-01-01', end = '2017-09-16',
                                    min = '2010-01-01', max = '2017-09-16'),
                     checkboxGroupInput("Zoning2", label = "Show",
                                        choices = c(
                                          "Residential" = "Residential",
                                          "Mixed Use" = "Mixed Use",
                                          "Commercial" = "Commercial",
                                          "Exterior/Vacant Buildings" = "Exterior/Vacant Buildings",
                                          "Other (Unknown)" = "Other (Unknown)"
                                        ), selected = ("Residential")
                     )

                 ),
                 box(width = NULL, solidHeader = TRUE,
                     ### Table #################################
                     # DT::dataTableOutput("RatSumTable2")
                     htmlOutput(outputId = "RatSumTable2")
                 )


          )
        )
),

### Tab 3  #################################
  tabItem(tabName = "weather",
        h2("Effects of Weather"),
        fluidRow(column(width = 6,
                        box(width = NULL, status = "warning",
### Scatterplot Temp #####################
                          plotOutput('scatRat'),
               selectizeInput(
                 "Scatter", "Enter Year(s)",
                 choices = c(
                   "2010" = "2010",
                   "2011" = "2011",
                   "2012" = "2012",
                   "2013" = "2013",
                   "2014" = "2014",
                   "2015" = "2015",
                   "2016" = "2016",
                   "2017" = "2017"), multiple = TRUE
               )
               )),
### Scatterplot Precipitation ###########
                column(width = 6,
                box(width = NULL, status = "warning",
                    height = 500,
              plotOutput('scatRain')
              )
           )
        )),
### Tab 4 ################################
tabItem(tabName = "timeseries",
        h2("Time Series Decomposition",
           fluidRow( column(width = 9,
                            box(width = NULL, status = 'warning',
### Time Series Breakdown ################
                                plotOutput('decomposedRat')
                                ))
             
           ))
        
        )
    )
)


dashboardPage(
  header,
  dashboardSidebar(sidebarMenu(
    menuItem("Map", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Tables and Histogram", tabName = "tables",icon = icon("table")),
    menuItem("Weather", tabName = "weather", icon = icon("thermometer")),
    menuItem("Timeseries Breakdown", tabName = "timeseries", icon = icon("clock-o"))
  )
                   ),
  body
)
