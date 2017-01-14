# server.R

library(shiny)
library(maps)
library(mapproj)
countries <- read.csv("Datasets/europe.csv", header = TRUE, sep = ",")
source("helpers.R")

shinyServer(
  function(input, output) {
    output$map <- renderPlot({
      data <- switch(input$var, 
                     "Area" = countries$Area,
                     "GDP" = countries$GDP,
                     "Inflation" = countries$Inflation,
                     "Life expect" = countries$Life.expect,
                     "Military" = countries$Military,
                     "Population growth" = countries$Pop.growth,
                     "Unemployment" = countries$Unemployment)
      
      color <- switch(input$var, 
                      "Area" = "darkgreen",
                      "GDP" = "darkgreen",
                      "Inflation" = "darkgreen",
                      "Life expect" = "darkgreen",
                      "Military" = "black",
                      "Population growth" = "darkorange",
                      "Unemployment" = "darkviolet")
      percent_map(var = data, 
                  color = color,
                  max = input$range[2], 
                  min = input$range[1])
    })
  }
)