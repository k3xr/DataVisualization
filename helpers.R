library("choroplethr")
library("choroplethrMaps")
library("ggplot2")

#http://stackoverflow.com/questions/8197559/emulate-ggplot2-default-color-palette
getColor <- function(n = 6, h = c(0, 360) + 15){
  if ((diff(h) %% 360) < 1) h[2] <- h[2] - 360/n
  hcl(h = (seq(h[1], h[2], length = n)), c = 100, l = 65)
}

percent_map <- function(varname, var, my_color, percentage = TRUE, numColors = 1) {
  countries <- read.csv("./Datasets/europe.csv", header = TRUE, sep = ",")
  target<-c("austria","belgium","bulgaria","croatia","czech republic","denmark",
            "estonia","finland","germany","greece","hungary","iceland","ireland","italy",
            "latvia","lithuania","luxembourg","netherlands","norway","poland","portugal","slovakia","slovenia",
            "spain","sweden","switzerland","ukraine","united kingdom")
  datas<-data.frame(region=target, value=var)
  datas$region<-as.character(datas$region)
  data(country.map)
  data(country.regions)
  
  if(percentage) {
    gg <- country_choropleth(datas, legend = varname, num_colors=1, zoom=target)
    gg <- gg + xlim(-31.266001, 39.869301)
    gg <- gg + ylim(27, 72)
    gg <- gg + coord_map("lambert", lat0=27, lat1=72)
    gg <- gg + scale_fill_continuous(low="white", high=my_color)
  }
  else {
    gg <- country_choropleth(datas, legend = varname, zoom=target)
    gg <- gg + xlim(-31.266001, 39.869301)
    gg <- gg + ylim(27, 72)
    gg <- gg + coord_map("lambert", lat0=27, lat1=72)
    gg <- gg + scale_fill_continuous(low=my_color, high=my_color[length(my_color)], guide="legend")
    gg <- gg + scale_fill_manual(values = c("red", "green", "blue",
                                            "yellow", "orange", "grey",
                                            "purple", "magenta", "cyan",
                                            "darkGreen", "brown", "white"), guide = guide_legend(reverse = TRUE))
  }
  gg
}

selectData <- function(var, countries){
  data <- switch(var, 
                 "Area" = countries$Area,
                 "GDP" = countries$GDP,
                 "Inflation" = countries$Inflation,
                 "Life Expectancy" = countries$Life.expect,
                 "Military" = countries$Military,
                 "Population Growth" = countries$Pop.growth,
                 "Unemployment" = countries$Unemployment)
  return(data)
}

selectColour <- function(var, countries){
  my_colors <- getColor(n=7)
  
  selectedColour <- switch(var, 
                           "Area" = my_colors[1],
                           "GDP" = my_colors[2],
                           "Inflation" = my_colors[3],
                           "Life Expectancy" = my_colors[4],
                           "Military" = my_colors[5],
                           "Population Growth" = my_colors[6],
                           "Unemployment"= my_colors[7])
  
  return(selectedColour)
}


hierarchicalCluster <- function(csvData, name1, name2, data1, data2, clusterNum){
  #Prepare the data
  #mData = as.matrix(cbind(countries$Area, countries$GDP),ncol=2)
  mData = as.matrix(cbind(data1, data2),ncol=2)
  mData = scale(mData)
  clusters <- hclust(dist(mData))
  clusterCut <- cutree(clusters, clusterNum)
  plotData = data.frame(mData, factor(clusterCut))
  colnames(plotData) <- c("var1","var2", "Cluster")
  plot <- ggplot(plotData, aes(var1, var2, color=Cluster)) + geom_point() + labs(x=name1, y=name2)
  
  #Visualize tree
  treePlot <- clusters
  
  #Aggregate the data by Clusters
  newDf = data.frame(csvData, cluster=clusterCut)
  
  newDf = aggregate(newDf, by=list(Cluster = newDf$cluster),FUN= function(x){if (class(x)=="factor"){paste(x, collapse=', ')}else{mean(x)}})
  newDf = newDf[,-(dim(newDf)[2])]
  groupsDf = newDf[,1:2]
  newDf = newDf[,-2]
  newDf[,2:dim(newDf)[2]] = round(newDf[,2:dim(newDf)[2]], digits=4)
  resultList <- list("ggPlot" = plot, "treePlot" = treePlot, "clustersData" = newDf, "clusterGroups" = groupsDf, "clusterCut"=clusterCut)
}


minMaxNorm <- function(arr){
  output <- (arr-min(arr))/(max(arr)-min(arr))
  return(output)
}