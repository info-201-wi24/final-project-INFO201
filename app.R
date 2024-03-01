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

ui <- fluidPage(theme = shinytheme("superhero"),
                navbarPage(
                  "Crime in States, VS Minimum Wage, 1973",
                  tabPanel("Minimum Wage in States",
                           sidebarPanel(
                             tags$h3("Input:"),
                             textInput("txt1", "State", ""),
                             actionButton("search_button", "Search")
                             
                           ), # sidebarPanel
                           mainPanel(
                             h1("Introduction:"),
                             h4("Minimum Wage in states throughout the United States: Do they have any correlation?
                                We believe that crime exists whether people are being kept alive or not. The government
                                has long been in denial that the minimum wage should have any influence on crime, and 
                                maybe that assumption is not off-base."),
                             h4("Minimum Wage in 1973:"),
                             DTOutput("Search_result"),
                             
                           ) # mainPanel
                           
                  ), # Navbar 1, tabPanel
                  tabPanel("Interactive Map", "This panel is intentionally left blank"), # interactive map
                  tabPanel("Interactive Histogram", "This panel is intentionally left blank") # interactive histogram
                  
                ) # navbarPage
) # fluidPage


# Define server function  
server <- function(input, output) {
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


