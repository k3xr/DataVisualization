# server.R

library(shiny)
library(maps)
library(mapproj)
library(ggplot2)
countries <- read.csv("./Datasets/europe.csv", header = TRUE, sep = ",")
source("helpers.R")

shinyServer(
  function(input, output,session) {
    
    #Reactive clustering to avoid executing it more than 1 time per plot
    clusterResult <- reactive({
      data1 <- selectData(input$clusterAttr1, countries)
      data2 <- selectData(input$clusterAttr2, countries)
      hierarchicalCluster(countries, input$clusterAttr1, input$clusterAttr2, data1, data2, input$clusterNum)
    })

    rankingData <- reactive({
      selectedVar <- input$rankingVar
      data <- selectData(input$rankingVar, countries)
      dataMax <- max(data)
      dataMin <- min(data)
      updateSliderInput(session,"range", max=dataMax, min=dataMin,value=c(dataMin, dataMax))
      data
    })
    
    output$map <- renderPlot({
      data <- rankingData()
      inputMin <- input$range[1]
      inputMax <- input$range[2]

      if (inputMin != min(data) || inputMax != max(data)){
        data[data > inputMax] <- inputMin
        data[data < inputMin] <- inputMin 
        data[data > inputMin] <- inputMax
      }
      
      color <- selectColour(input$rankingVar)
      percent_map(input$rankingVar, 
                  data, 
                  color)
    })
    output$ranking <- renderPlot({
      data <- rankingData()
      inputMin <- input$range[1]
      inputMax <- input$range[2]
      
      filteredDf = data.frame("Country"=countries$Country,"Data"=data)
      
      if (inputMin != min(data) || inputMax != max(data)){
        filteredDf <- filteredDf[filteredDf$Data >= inputMin,]
        filteredDf <- filteredDf[filteredDf$Data <= inputMax,]
      }
      color <- selectColour(input$rankingVar)
      
      plot <- ggplot(filteredDf, aes(y=Data, x=reorder(Country, Data)))
      plot <- plot + geom_bar(stat='identity', fill=color)
      plot <- plot + coord_flip() + labs(y=input$rankingVar, x="Country")
      plot <- plot + geom_text(aes(label = filteredDf$Data), position = position_stack(vjust = 0.5))
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
    
    output$clusterPlot <- renderPlot({
      clusterResult()$ggPlot
    })
    output$clusterTree <- renderPlot({
      plot(clusterResult()$treePlot, labels=countries$Country, xlab="Countries hierarchical clusters by euclidean distance",sub="")
    })
    output$clusterTable <- renderTable({
      clusterResult()$clustersData
    })
    output$clusterGroups <- renderTable({
      clusterResult()$clusterGroups
    })
    
    output$clusterMap <- renderPlot({
      data <- clusterResult()$clusterCut
      color <- getColor(n = strtoi(input$clusterNum))
      percent_map("Clusters", 
                  data, 
                  color, percentage = FALSE)
    })
  }
)