

## OVERVIEW TAB INFO
          
overview_tab <- tabPanel("Crime Rate vs. Minimum Wage: Introduction",
   h1("Overview of Data Analysis"),
   p("This group project for INFO 201 is conducted by Kevin Lee, 
     Maikanh Tran, and Nicholas Chou"),
   p("Minimum Wage in states throughout the United States in 1973: 
      Do they have any correlation?
      In 1973, the enivironment of the United States had many 
      socio-economic dynamics, from the debate around the minimum wage becoming
      a populat discussion topic to the increase in crimes as the US became
      more developed. Would a higher minimum wage 
      deter crime by providing individuals with the economic means to escape poverty, 
      or are crime rates unaffected by wage policies, driven instead by more 
      complex social factors? We believe that crime exists whether people are being 
      kept alive or not. 
      The government has long been in denial that the minimum wage should have any influence on crime, and 
      maybe that assumption is not off-base.")
)

## VIZ 1 TAB INFO
## Introduction, viz tab 1, conclusion by Kevin Lee

# searches the loaded csv file for minimum wage of the input(state)
viz_1_main_panel <- mainPanel(
  h4("Minimum Wage in 1973:"),
  DTOutput("Search_result")
  # plotlyOutput(outputId = "your_viz_1_output_id")
)

viz_1_tab <- tabPanel("Minimum Wage in States",
                      sidebarPanel(
                        tags$h3("Input:"),
                        textInput("search_input", "State", ""),
                        actionButton("search_button", "Search")
                        ),
                      mainPanel(
                        verbatimTextOutput("results"),
                        plotlyOutput(outputId = "state_graph")
                      ) # sidebarPanel
)


## VIZ 2 TAB INFO
# Maikhanh Tran
viz_2_sidebar <- sidebarPanel(
  h2("Compare different crimes within states"),
  selectInput("selectedState", "Select a State:", choices = unique(cleandata$State)),
  selectInput("selectedCrime", "Select Crime Category:", choices = c("Murder", "Assault", "Rape"))
)

viz_2_main_panel <- mainPanel(
  h2("Crime Statistics by State"),
  plotlyOutput("crimePlot")
)

viz_2_tab <- tabPanel("Crimes by state",
                      sidebarLayout(
                        viz_2_sidebar,
                        viz_2_main_panel
                      )
)

## VIZ 3 TAB INFO
# Nicholas Chou
viz_3_sidebar <- sidebarPanel(
  h2("Interactive Scatter Plot by State"),
  selectInput("stateSelect", "Select State:",
              choices = unique(cleandata$State),
              selected = NULL)
)

viz_3_main_panel <- mainPanel(
  h2("Assault Rates vs. Minimum Wage by Selected State"),
  plotlyOutput("crimeWagePlot")
)

viz_3_tab <- tabPanel("Assault Rates vs. Minimum Wage",
                      sidebarLayout(
                        viz_3_sidebar,
                        viz_3_main_panel
                      )
)

## CONCLUSIONS TAB INFO

conclusion_tab <- tabPanel("Conclusion",
 h1("Conclusion"),
 p("In our analysis, the state minimum wage has no bearing on the rate of crime
   in the same state. The key to finding out if minimum wage has any bearing on 
   crime requires a more comprehensive dataset. Our project has concluded that within 
   a single year crime has relatively little correlation to minimum wage."),
 p("Initially, our cleaned data looked as if that there was a connection between
   minimum wage and assault rates, but after cleaning and closely analyzing the data,
   we found that there is no correlation between the two, and criminal activity is 
   impacted by a lot of factors that determine whether an individual would commit to it 
   or not. This analysis 
   will not only contribute to historical economic 
  research but may also inform current policy discussions. By understanding the past, 
  we can make more informed decisions for the future.")
)



ui <- navbarPage("INFO 201 - Crime Rates vs. Minimum Wage 1973",
  overview_tab,
  viz_1_tab,
  viz_2_tab,
  viz_3_tab,
  conclusion_tab
)
