library("choroplethr")
library("choroplethrMaps")
library("ggplot2")

percent_map <- function(varname, var, color) {
  countries <- read.csv("./Datasets/europe.csv", header = TRUE, sep = ",")
  target<-c("austria","belgium","bulgaria","croatia","czech republic","denmark",
            "estonia","finland","germany","greece","hungary","iceland","ireland","italy",
            "latvia","lithuania","luxembourg","netherlands","norway","poland","portugal","slovakia","slovenia",
            "spain","sweden","switzerland","ukraine","united kingdom")
  datas<-data.frame(region=target, value=var)
  datas$region<-as.character(datas$region)
  data(country.map)
  data(country.regions)
  gg <- country_choropleth(datas, legend = varname, num_colors=1, zoom=target)
  gg <- gg + xlim(-31.266001, 39.869301)
  gg <- gg + ylim(27, 72)
  gg <- gg + coord_map("lambert", lat0=27, lat1=72)
  gg <- gg + scale_fill_continuous(low="white", high=color)
  gg
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
                   "Life Expect" = "black",
                   "Military" = "green",
                   "Population Growth" = "darkorange",
                   "Unemployment" = "darkviolet")
  return(colour)
}


minMaxNorm <- function(arr){
  output <- (arr-min(arr))/(max(arr)-min(arr))
  return(output)
}