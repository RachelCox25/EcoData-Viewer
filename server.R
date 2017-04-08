
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

#load the rdataretriever package
library(rdataretriever)

#load dataset options, this isn't working
#birdSurvey = rdataretriever::fetch('breed-bird-survey') #from Coyle et. al.

#load datasets from ggplot2 assignment that uses dataset from EcoData retreiver
occupancyData <- read_tsv("Occupancy_Data.txt")
locationData <- read_tsv("Location_Data.txt")



shinyServer(function(input, output) {
  output$graph <- renderPlot({
    
    #check to see what the graph is
    if(input$selectData == "Bird Survey"){
      if(input$graphType == "Histogram"){
        
        #Got stuff working and then it stopped working
        #hist(bird_size$bird_size_species[,2])
        #hist(birdSurvey)
        
        #just to show a histogram will appear with the right options chosen
        #hist(AirPassengers)
        
        ggplot(locationData, aes(PredominantSpeciesType)) + geom_bar(fill=c("red", "blue")) + xlab("Predominant Species Type: Core or Transient") + ylab("Species Type Count")
      
      }else if(input$graphType == "Scatter Plot"){
        ggplot(locationData, aes(NumSpecies,NDVI)) + geom_point(aes(colour = factor(PredominantSpeciesType), size = Elevation)) + xlab("Total Number of Species")
          
        
      }else{
        print("Graph unavailable for this dataset")
          
        }
     
    }
    
    
  })
  
}
)
