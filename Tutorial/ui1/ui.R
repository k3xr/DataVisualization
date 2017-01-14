# ui.R

library(shiny)

shinyUI(fluidPage(
  titlePanel("title panel"),
  
  sidebarLayout(
    position = "right",
    sidebarPanel( "sidebar panel"),
    mainPanel("main panel")
  )
))