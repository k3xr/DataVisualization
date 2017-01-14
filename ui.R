# ui.R

library(shiny)

shinyUI(fluidPage(
  titlePanel("EuropeVis"),
  
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
  )
))