library("choroplethr")
library("choroplethrMaps")

percent_map <- function(var, color, min = 0, max = 100) {
  countries <- read.csv("./Datasets/europe.csv", header = TRUE, sep = ",")
  target<-c("austria","belgium","bulgaria","croatia","czech republic","denmark",
            "estonia","finland","germany","greece","hungary","iceland","ireland","italy",
            "latvia","lithuania","luxembourg","netherlands","norway","poland","portugal","slovakia","slovenia",
            "spain","sweden","switzerland","ukraine","united kingdom")
  datas<-data.frame(region=target, value=var)
  datas$region<-as.character(datas$region)
  data(country.map)
  data(country.regions)
  country_choropleth(datas, legend="%", num_colors=1, zoom=target)
}

selectData <- function(var, countries){
  data <- switch(var, 
                  "Area" = countries$Area,
                  "GDP" = countries$GDP,
                  "Inflation" = countries$Inflation,
                  "Life Expect" = countries$Life.expect,
                  "Military" = countries$Military,
                  "Population Growth" = countries$Pop.growth,
                  "Unemployment" = countries$Unemployment)
  return(data)
}

selectColour <- function(var, countries){
  colour <- switch(var, 
                   "Area" = "darkgreen",
                   "GDP" = "red",
                   "Inflation" = "blue",
                   "Life Expect" = "darkyellow",
                   "Military" = "green",
                   "Population Growth" = "darkorange",
                   "Unemployment" = "darkviolet")
  return(colour)
}


minMaxNorm <- function(arr){
  output <- (arr-min(arr))/(max(arr)-min(arr))
  return(output)
}