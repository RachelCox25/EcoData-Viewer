
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
# Load this first, so that the app doesn't have to do it with every call.
portal <- rdataretriever::fetch("portal")
factors <- c() # factors needs to be accessed outside both loops

shinyServer(function(input, output) {
  
  #IF THE DATA INPUT IS NOT BIRD SURVEY, GRAPH OUTPUT IS DYNAMIC WITH DYNAMIC UI aka this is not hard coded
  output$ui <- renderUI({
    if(input$selectData == "Portal"){
      # Get the list of numerics and factors from portal
      numerics <- c()
      
      count <- 1
      colNamesList <- colnames(portal$main)
      for (variable in lapply(portal$main, class)) {
        # find out which variable type it is
        if (variable == "integer") {
          # add it to the numerics list
          numerics <- c(numerics, colNamesList[count])
        } else if (variable == "factor") {
          # add it to the factor list
          factors <- c(factors, colNamesList[count]) 
        }
        count <- count + 1
      }
      switch(input$graphType,
             "Histogram" = checkboxGroupInput(inputId = "histogramVariableOptions", 
                                              label = "Select ONE numeric variable to graph",
                                              choices = numerics
             ),
             "Scatter Plot" = checkboxGroupInput(inputId = "scatplotVariableOptions", 
                                                 label = "Select TWO numeric variables to graph",
                                                 choices = numerics
             ),
             "Box-Whisker" = checkboxGroupInput(inputId = "boxVariableOptions1", 
                                                label = "Select ONE numeric variable to graph", 
                                                choices = numerics
             )
      )
    }
  })
  
  #Have to have a second render UI to have a second set of check boxes
  output$ui2 <- renderUI({
    if(input$selectData != "Bird Survey" && input$graphType == "Box-Whisker"){
      checkboxGroupInput(inputId = "boxVariableOptions2", label = "Select ONE factor variable to graph", choices = factors)
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