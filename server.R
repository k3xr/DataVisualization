# server.R

library(shiny)
library(maps)
library(mapproj)
library(ggplot2)
countries <- read.csv("./Datasets/europe.csv", header = TRUE, sep = ",")
source("helpers.R")

shinyServer(
  function(input, output) {
    output$map <- renderPlot({
      data <- selectData(input$var, countries)
      color <- selectColour(input$var)
      
      percent_map(input$var, 
                  data, 
                  color)
    })
    output$ranking <- renderPlot({
      data <- selectData(input$var, countries)
      color <- selectColour(input$var)
      
      plot <- ggplot(countries, aes(y=data, x=reorder(countries$Country, data)))
      plot <- plot + geom_bar(stat='identity', fill=color)
      plot <- plot + coord_flip() + labs(y=input$var, x="Country")
      plot
    })
    
    output$correlationPlot <- renderPlot({
      data1 <- selectData(input$compareAttr1, countries)
      data2 <- selectData(input$compareAttr2, countries)
      
      data1 <- minMaxNorm(data1)
      data2 <- minMaxNorm(data2)
      
      color1 <- selectColour(input$compareAttr1)
      color2 <- selectColour(input$compareAttr2)
      
      plot <- ggplot(countries, aes(countries$Country, group=1))
      plot <- plot + geom_line(aes(y=data1,colour=input$compareAttr1))
      plot <- plot + geom_line(aes(y=data2,colour=input$compareAttr2))
      plot <- plot + labs(x="Country")
      plot <- plot + theme(axis.text.x=element_text(angle = -90, hjust = 0))
      plot <- plot + scale_colour_manual(name="Variables", values=c(color1,color2))
      plot
    })
    
    output$correlation <- renderText({
      data1 <- selectData(input$compareAttr1, countries)
      data2 <- selectData(input$compareAttr2, countries)
      cor(data1, data2)
    })
  }
)