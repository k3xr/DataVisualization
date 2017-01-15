# ui.R

library(shiny)

shinyUI(fluidPage(
  titlePanel("EuropeVis"),
  tabsetPanel(
    tabPanel("Explore",
             sidebarLayout(
               sidebarPanel(
                 helpText("Create map with information from European countries"),
                 
                 selectInput("var", 
                             label = "Choose a variable to display",
                             choices = c("Area", "GDP", "Inflation", "Life Expect", "Military", "Population Growth",
                                         "Unemployment"),
                             selected = "Area"),
                 
                 sliderInput("range", 
                             label = "Range of interest:",
                             min = 0, max = 100, value = c(0, 100))
               ),
               mainPanel(plotOutput("map"))
             ),
             
             fluidRow(
               column(10,
                      h3("Ranking"),
                      plotOutput("ranking")
               )
             )
    ),
    tabPanel("Discover",
             sidebarLayout(
               sidebarPanel(
                 helpText("Discover correlations between the attributes from the data."),
                 
                 selectInput("compareAttr1", 
                             label = "Choose the first attribute to compare",
                             choices = c("Area", "GDP", "Inflation", "Life Expect", "Military", "Population Growth",
                                         "Unemployment"),
                             selected = "Area"),
                 selectInput("compareAttr2", 
                             label = "Choose the second attribute to compare",
                             choices = c("Area", "GDP", "Inflation", "Life Expect", "Military", "Population Growth",
                                         "Unemployment"),
                             selected = "GDP"),
                 helpText("Their level of correlation is"),
                 textOutput("correlation")
               ),
               mainPanel(plotOutput("correlationPlot"))  
             )
             
    )
  )
)
)