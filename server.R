shinyServer(function(input, output, session) {
# NYC Rat Map #########################
maptab <- reactive({
  Ratsclean %>%
    filter(Date >= input$dateRange[1] &
             Date <= input$dateRange[2]) %>%
    filter(Zoning %in% input$Zoning) 
  })
# NYC Rat Map for tab 2 ###############
maptab2 <- reactive({
  Ratsclean %>%
    filter(Date >= input$dateRange2[1] &
             Date <= input$dateRange2[2]) %>%
    filter(Zoning %in% input$Zoning2) 
})
### Creating the Histogram2 ########

output$hist2 <- renderPlot({
  ggplot(maptab2(), aes(x = Julian)) + geom_histogram(bins = 30) + facet_wrap(~Year)
})
### Data for Summary Table 2 ########
sumtable2 <- reactive({
  maptab2() %>%
    group_by(Borough, Date) %>%
    summarise(Daily2 = n()) %>%
    group_by(Borough) %>%
    summarise(Sightings = sum(Daily2), Max = max(Daily2), Average = mean(Daily2))
})
output$RatSumTable2 <- renderGvis({
  gvisTable(sumtable2())
})

## Creating the actual map ############
output$map <- renderLeaflet({
  leaflet() %>% 
    addTiles() %>%
    setView(lng =-73.92838 ,lat =40.73009, zoom = 10 )
})

### Creating the Markers ########
observe({
    proxy <- leafletProxy("map", data = maptab()) %>%
      clearMarkerClusters() %>%
      clearMarkers() %>%
      addMarkers(~Longitude, ~Latitude,
                       clusterOptions = markerClusterOptions(),
                       group ="CLUSTER",
                       icon = ratIcon,
                       popup = ~paste('<b>', 'Date Reported:', Date,'</b>',
                                      '<br/>', Incident.Address,
                                      '<br/>', City,
                                      Incident.Zip,
                                      '<br/>', 'Location type:', Location.Type,
                                      '<br/>', 'Status:', Status)) %>%
      addCircleMarkers(~Longitude, ~Latitude, radius = 1, color = 'black',
                       stroke = FALSE,
                       fillOpacity = .4,
                       group = "CIRCLE") %>%
      addLayersControl(
        baseGroups = c("CLUSTER", "CIRCLE"),
        options = layersControlOptions(collapsed = FALSE)
      )
  })
### Creating the Histogram ########

output$hist <- renderPlot({
  ggplot(maptab(), aes(x = Julian)) + geom_histogram() + facet_wrap(~Year)
 
  
})
### Data for Summary Table ########
sumtable <- reactive({
  maptab() %>%
    group_by(Borough, Date) %>%
    summarise(Daily = n()) %>%
    group_by(Borough) %>%
    summarise(Sightings = sum(Daily), Max = max(Daily), Average = mean(Daily))
  
  
})  
### Creating the summary table ####

# ratTable <- gvisTable(sumtable(),
# formats=list(Population="#,###",
#              '% of World Population'='#.#%'),
 # options=list(page='enable')
# )
output$RatSumTable <- renderDataTable({
  sumtable()
  #gvisTable(sumtable())

})

### Data for Time to Close ########
closingtime <- reactive({
  maptab2() %>%
    filter(!is.na(Closed.Date)) %>%
    filter(Closed.Date > Created.Date) %>%
    group_by(Borough) %>%
    summarise("Min days to close" = min(timetoclose),
              "max days to close" = max(timetoclose),
              "avg days to close" = median(timetoclose))
})
### Table for Close time ##########
output$CloseTable <- DT:: renderDataTable({
  closingtime()
  #renderGvis({
  #gvisTable(data = closingtime())
  
})


### Data for Scatter Plot #########
ratScatter <- reactive({
  Ratsum %>%
    filter(Year %in% input$Scatter)
})
### Creating the Scatter Plot #####

output$scatRat <- renderPlot({ratScatter() %>%
  ggplot(aes(x = temp, y = sightings, shape = Year, color = Year)) + 
  geom_point() +
  geom_smooth(method = "lm", se =TRUE)
})  
output$scatRain <- renderPlot({ratScatter() %>%
    ggplot(aes(x = rainfall, y = sightings, shape = Year, color = Year)) + 
    geom_point() +
    geom_smooth(method = "lm", se =TRUE)
}) 
output$decomposedRat <- renderPlot({plot(stl(ratTS, s.window = "periodic"))
})


# put histogram and making a larger version and table
# put diagraph versions of time series (1 to 2 hours)
# is there a decrease in time 
})
