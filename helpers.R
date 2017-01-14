percent_map <- function(var, color, min = 0, max = 100) {
  countries <- read.csv("Datasets/europe.csv", header = TRUE, sep = ",")
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