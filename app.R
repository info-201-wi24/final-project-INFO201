#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#



# Define UI for application that draws a histogram
library(shiny)
library(shinythemes)
library(DT)
library(leaflet)
library(tidyverse)
library(lubridate)
library(promises)
library(future)
library(plotly)

ui <- fluidPage(theme = shinytheme("superhero"),
                navbarPage(
                  "Crime in States, VS Minimum Wage, 1973",
                  tabPanel("Introduction",
                           mainPanel(
                             h1("Introduction:"),
                             h4("Minimum Wage in states throughout the United States: Do they have any correlation?
                                We believe that crime exists whether people are being kept alive or not. The government
                                has long been in denial that the minimum wage should have any influence on crime, and 
                                maybe that assumption is not off-base.")
                           )),
                  tabPanel("Minimum Wage in States",
                           sidebarPanel(
                             tags$h3("Input:"),
                             textInput("search_input", "State", ""),
                             actionButton("search_button", "Search")
                             
                           ), # sidebarPanel
                           mainPanel(
                             h4("Minimum Wage in 1973:"),
                             DTOutput("Search_result")
                             
                           ) # mainPanel
                           
                  ), # Navbar 1, tabPanel
                  tabPanel("Interactive Map", "This map will show the crime rate for each state."), # interactive map
                  tabPanel("Interactive Scatterplot", "This scatterplot will show the crime rate compared
                           between each state.",
                           plotlyOutput(outputId = "Crime_Vs_Min_Wage_Plot")), # interactive histogram
                  tabPanel("Conclusion")
                ) # navbarPage
) # fluidPage


# Define server function  
server <- function(input, output) {
  
  # read in the csv file
  data <- read.csv("cleandata.csv") # says cannot read the file as the file doesn't exist
  # but the file is there within the project directory
  output$Crime_Vs_Min_Wage_Plot <- renderPlotly({
    my_plot <- ggplot(data) +
      geom_point(mapping = aes (
        x = State.Minimum.Wage,
        y = Assault
      ))
    
   # return(plot name)
  })
  
  search_data <- eventReactive(input$search_button, {
    search_term <- input$search_input
    subset_data <- subset(data, grepl(search_term, data$Column_to_Search, ignore.case = TRUE))
    return(subset_data)
  })
  
  
  output$search_result <- renderDT({
    search_data()
  })
  
} # server


# Create Shiny object
shinyApp(ui = ui, server = server)
