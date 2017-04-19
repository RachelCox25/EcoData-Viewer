
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

#load the rdataretriever package
library(rdataretriever)
library(readr)
library(ggplot2)
library(dplyr)

#load dataset options, this isn't working
#birdSurvey = rdataretriever::fetch('breed-bird-survey') #from Coyle et. al.

#load datasets from ggplot2 assignment that uses dataset from EcoData retreiver


occupancyData <- read_tsv("Occupancy_Data.txt")
locationData <- read_tsv("Location_Data.txt")

#portal <- rdataretriever::fetch("portal")

shinyServer(function(input, output) {
  
  #IF THE DATA INPUT IS NOT BIRD SURVEY, GRAPH OUTPUT IS DYNAMIC WITH DYNAMIC UI aka this is not hard coded
  output$ui <- renderUI({
    if(input$selectData != "Bird Survey"){
      switch(input$graphType,
             "Histogram" = checkboxGroupInput(inputId = "histogramVariableOptions", 
                                              label = "Select a numeric variable to graph",
                                              choices = c(10, 344, 567)
             ),
             "Scatter Plot" = checkboxGroupInput(inputId = "scatplotVariableOptions", 
                                                 label = "Select two numeric variables to graph",
                                                 choices = c(10, 344, 567)
             ),
             "Box-Whisker" = checkboxGroupInput(inputId = "boxVariableOptions1", 
                                                label = "Select one numeric variable to graph", 
                                                choices = c(10, 344, 567)
             )
      )
    }
  })
  
  #Have to have a second render UI to have a second set of check boxes
  output$ui2 <- renderUI({
    if(input$selectData != "Bird Survey" && input$graphType == "Box-Whisker"){
      checkboxGroupInput(inputId = "boxVariableOptions2", label = "Select one factor variable to graph", choices = c("factor1", "factor2", "factor3"))
    }
  })
  
  #IF THE DATA INPUT IS BIRD SURVEY, THE GRAPH OUTPUT IS DIFFERENT aka this is hard coded
  output$graph <- renderPlot({
    
    if(input$selectData == "Bird Survey"){
      if(input$graphType == "Histogram"){
        ggplot(locationData, aes(PredominantSpeciesType)) + geom_bar(fill=c("red", "blue")) + xlab("Predominant Species Type: Core or Transient") + ylab("Species Type Count")
        
      }else if(input$graphType == "Scatter Plot"){
        ggplot(locationData, aes(NumSpecies,NDVI)) + geom_point(aes(colour = factor(PredominantSpeciesType), size = Elevation)) + xlab("Total Number of Species")
      
      }
   
  #IF THE DATA INPUT IS NOT BIRD SURVEY, GRAPH OUTPUT IS DYNAMIC WITH DYNAMIC UI aka this is not hard coded   
    }else{
      #just get a different graph to show up if not bird survey
      hist(AirPassengers)
    }
  })
  
  #just for looks adding an error message for if box-whisker is chosen for bird survey
  output$error <- renderText({
    if(input$selectData == "Bird Survey" && input$graphType == "Box-Whisker"){
      "ERROR: This graph is currently unavailable"
    }
  })
  
}
)