# ui.R

library(shiny)

shinyUI(fluidPage(
  titlePanel("EuropeVis"),
  tabsetPanel(
    tabPanel("Explore",
             sidebarLayout(
               sidebarPanel(
                 helpText("Map with information from European countries"),
                 
                 selectInput("var", 
                             label = "Choose a variable to display",
                             choices = c("Area", "GDP", "Inflation", "Life Expect", "Military", "Population Growth",
                                         "Unemployment"),
                             selected = "Area")
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
    ),
    tabPanel("Clustering",
             
             sidebarLayout(
               sidebarPanel(
                 helpText("Visualize the results of hierarchical clustering."),
                 
                 selectInput("clusterAttr1", 
                             label = "Choose the first attribute to see the clustering",
                             choices = c("Area", "GDP", "Inflation", "Life Expect", "Military", "Population Growth",
                                         "Unemployment"),
                             selected = "Area"),
                 selectInput("clusterAttr2", 
                             label = "Choose the second attribute to see the clustering",
                             choices = c("Area", "GDP", "Inflation", "Life Expect", "Military", "Population Growth",
                                         "Unemployment"),
                             selected = "GDP"),
                 
                 selectInput("clusterNum",
                             label = "The number of clusters is",
                             choices = c(3 , 4, 5, 6, 7, 8, 9, 10),
                             selected = 3)
               ),
               mainPanel(plotOutput("clusterPlot"))
             )
    )
  )
)
)