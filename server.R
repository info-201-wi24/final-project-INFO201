library(dplyr)
library(shiny)
library(shinythemes)
library(DT)
library(leaflet)
library(tidyverse)
library(plotly)
library(ggplot2)
library(maps)
library(mapproj)

server <- function(input, output){
  data <- read.csv("cleandata.csv", header = TRUE)
  # TODO Make outputs based on the UI inputs here
  
  #  searching the file for the right value to return
 # search_data <- eventReactive(input$search_button, {
 #   search_term <- input$search_input
 #   subset_data <- subset(data, grepl(search_term, data$State.Minimum.Wage, ignore.case = TRUE))
 #   return(subset_data)
 # })
  
  searchResults <- reactive({
    # req(input$search_button) # Require the goButton to be clicked
    search_data <- input$search_input
    # Filter data based on search input
    # subset(data, grepl(search_data, data$State.Minimum.Wage, ignore.case = TRUE))
    result <- data[data$State == search_data, "Assault"]
    return(result)
  })
  
  output$results <- renderPrint({
    searchResults()
  })
  
  # state choropleth map thingy
  # load state shapes
  state_shape <- map_data("state") 
  
  # join state shape with cleandata
  cleandatawithshape_df <- cleandata %>%
    mutate(State = tolower(State))%>%
    right_join(state_shape, by = c("State" = "region"))
  
  output$state_graph <- renderPlotly({
    # create ggplot 
    state_plot <- ggplot(data = cleandatawithshape_df) +
      geom_polygon(aes(
        x = long,
        y = lat,
        group = group,
        fill = Assault
      )) + 
      coord_map()
    
    # return using ggplotly
    return(ggplotly(state_plot))
  })
  
  # for plot for VIZ 3
  output$crimeWagePlot <- renderPlotly({
    
    filteredData <- cleandata %>%
      filter(State == input$stateSelect)
    
    p <- ggplot(filteredData, aes(x = Effective.Minimum.Wage.2020.Dollars, y = Assault)) +
      geom_point() + 
      geom_smooth(method = "lm", se = FALSE) +
      scale_x_continuous(limits = c(0, 15), name = "Minimum Wage ($)") +
      scale_y_continuous(limits = c(0, 350), name = "Assault Rates") +
      labs(title = paste("Assault Rates vs. Minimum Wage in", input$stateSelect)) +
      theme_minimal()
    
    ggplotly(p)
  })
}
