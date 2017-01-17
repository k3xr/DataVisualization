# ui.R

library(shiny)

shinyUI(fluidPage(
  titlePanel("EuropeVis"),
  tabsetPanel(
    tabPanel("Explore and Compare",
             sidebarLayout(
               sidebarPanel(
                 helpText("Map with information from European countries"),
                 
                 selectInput("rankingVar", 
                             label = "Choose a variable to display",
                             choices = c("Area", "GDP", "Inflation", "Life Expectancy", "Military", "Population Growth",
                                         "Unemployment"),
                             selected = "Area"),
                 sliderInput("range",
                             label = "Select a range to filter the data",
                             min=0, max=100, value = c(0, 100)
                 )
                 
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
    tabPanel("Correlation",
             
             sidebarLayout(
               sidebarPanel(
                 helpText("Discover correlations between the attributes from the data."),
                 
                 selectInput("compareAttr1", 
                             label = "Choose the first attribute to compare",
                             choices = c("Area", "GDP", "Inflation", "Life Expectancy", "Military", "Population Growth",
                                         "Unemployment"),
                             selected = "Area"),
                 selectInput("compareAttr2", 
                             label = "Choose the second attribute to compare",
                             choices = c("Area", "GDP", "Inflation", "Life Expectancy", "Military", "Population Growth",
                                         "Unemployment"),
                             selected = "GDP"),
                 helpText("Their level of correlation is"),
                 textOutput("correlation")
               ),
               mainPanel(plotOutput("correlationPlot"))  
             )
    ),
    tabPanel("Cluster Analyisis",
             
             sidebarLayout(
               sidebarPanel(
                 helpText("Visualize the results of hierarchical clustering analysis."),
                 
                 selectInput("clusterAttr1", 
                             label = "Choose the first attribute to see the clustering",
                             choices = c("Area", "GDP", "Inflation", "Life Expectancy", "Military", "Population Growth",
                                         "Unemployment"),
                             selected = "Area"),
                 selectInput("clusterAttr2", 
                             label = "Choose the second attribute to see the clustering",
                             choices = c("Area", "GDP", "Inflation", "Life Expectancy", "Military", "Population Growth",
                                         "Unemployment"),
                             selected = "GDP"),
                 
                 selectInput("clusterNum",
                             label = "The number of clusters is",
                             choices = c(3 , 4, 5, 6, 7, 8, 9, 10),
                             selected = 3)
               ),
               mainPanel(
                 
                 plotOutput("clusterTree")
               )
               
             ),
             fluidRow(style='padding-left:20px',
                      h3("Cluster groups"),
                      plotOutput("clusterPlot")       
             ),
             fluidRow(
               style='padding-left:20px',
               column(5,
                      
                      h3("Countries by cluster"),
                      tableOutput("clusterGroups")
               ),
               column(7,
                      plotOutput("clusterMap")  
               )
             ),
             fluidRow(
               style='padding-left:20px',
               h3("Clusters Data (average)"),
               tableOutput("clusterTable")
             )   
    )
  )
)
)