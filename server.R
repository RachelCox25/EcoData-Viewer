#QUESTIONS TO ASK
# 1. Can character classes be used like a factor? (i.e. in the box-whisker plots)
# 2. Is there a ggplot for scatterplot?
# 3. ggplot wasn't working for variable names for graphing (i.e. choice1 and choice2 instead of yr and dy)


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
salmonData <- read_tsv("salmon.txt")
# Load this first, so that the app doesn't have to do it with every call.
portal <- rdataretriever::fetch("portal")
abalone <- rdataretriever::fetch("abalone-age")
# LOOK INTO THE "updateSelectInput(session ...) function maybe 

shinyServer(function(input, output) {
  
  #IF THE DATA INPUT IS NOT BIRD SURVEY, GRAPH OUTPUT IS DYNAMIC WITH DYNAMIC UI aka this is not hard coded
  output$ui <- renderUI({
    if(input$selectData != "Bird Survey"){
      # Establish the list of numerics and factors from the dataset
      numerics <- c()
      count <- 1
      
      if(input$selectData == "Portal"){
        colNamesList <- colnames(portal$main)
        
        for (variable in lapply(portal$main, class)) {
         # find out which variable type it is
          if (variable == "integer" || variable == "numeric") {
            # add it to the numerics list
            numerics <- c(numerics, colNamesList[count])
          }
        count <- count + 1
        }
      
      }else if(input$selectData == "Salmon Trends"){
        colNamesList <- colnames(salmonData)
        
        for (variable in lapply(salmonData, class)) {
          # find out which variable type it is
          if (variable == "integer") {
            # add it to the numerics list
            numerics <- c(numerics, colNamesList[count])
          }
          count <- count + 1
        }
      } else if (input$selectData == "Abalone Age Prediction") {
        colNamesList <- colnames(abalone$abalone_age_data)
        
        for (variable in lapply(abalone$abalone_age_data, class)) {
          # find out which variable type it is
          if (variable == "integer" || variable == "numeric") {
            # add it to the numerics list
            numerics <- c(numerics, colNamesList[count])
          }
          count <- count + 1
        }
      }
      
      
      switch(input$graphType,
             "Histogram" = checkboxGroupInput(inputId = "histogramVariableOptions", 
                                              label = "Select ONE numeric variable to graph",
                                              choices = numerics, 
                                              selected = numerics[1]
             ),
             "Scatter Plot" = checkboxGroupInput(inputId = "scatplotVariableOptions", 
                                                 label = "Select TWO numeric variables to graph",
                                                 choices = numerics,
                                                 selected = c(numerics[1], numerics[2])
             ),
             "Box-Whisker" = checkboxGroupInput(inputId = "boxVariableOptions1", 
                                                label = "Select ONE numeric variable to graph", 
                                                choices = numerics,
                                                selected = numerics[1]
             )
      )
    
    }
  })
  
  #Have to have a second render UI to have a second set of check boxes
  output$ui2 <- renderUI({
    
    if(input$selectData != "Bird Survey" && input$graphType == "Box-Whisker"){
      factors <- c()
      count <- 1
      
      if(input$selectData == "Portal"){
        colNamesList <- colnames(portal$main)
        for (variable in lapply(portal$main, class)) {
          # find out which variable type it is
          if (variable == "factor") {
            # add it to the factor list
            factors <- c(factors, colNamesList[count]) 
          }
          count <- count + 1
        }
        
      }else if(input$selectData == "Salmon Trends"){
        colNamesList <- colnames(salmonData)
        for (variable in lapply(salmonData, class)) {
          # find out which variable type it is
          if (variable == "factor") {
            # add it to the factor list
            factors <- c(factors, colNamesList[count]) 
          }
          count <- count + 1
        }
      }
      
      checkboxGroupInput(inputId = "boxVariableOptions2", label = "Select ONE factor variable to graph", choices = factors, selected=factors[1])
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
      #portal dataset graphing stuff
    }else if(input$selectData == "Portal"){
      
        if (input$graphType == "Histogram" ) {
          if (length(input$histogramVariableOptions) == 1) {
            hist(portal$main[[input$histogramVariableOptions]], col = "slategray" , main=paste("Histogram of", input$histogramVariableOptions), xlab = input$histogramVariableOptions)
          } else {
            # have them select one variable from the list
          }
          
        } else if (input$graphType == "Scatter Plot") {
          # run ggplot on portal$main, with aes set to the variable names defined in their selected choices
          # ggplot(portal$main, aes(Choice1,Choice2)) <---- still not sure how to get these choices 
          if (length(input$scatplotVariableOptions) == 2) {
            choice1 <- input$scatplotVariableOptions[1]
            choice2 <- input$scatplotVariableOptions[2]
            #ggplot(portal$main, aes(choice1,choice2)) + geom_point(shape=1)
            plot(portal$main[[choice1]], portal$main[[choice2]], main = "Your Variable Scatterplot", ylab=choice2, xlab=choice1)
          } else {
            # have them select two variables from the list
          }
          
        } else if (input$graphType == "Box-Whisker") {
          if (length(input$boxVariableOptions1) == 1 && length(input$boxVariableOptions2) == 1) {
            boxplot(portal$main[[input$boxVariableOptions1]], portal$main[[input$boxVariableOptions2]])
          } else {
            # Have them select one numeric and one factor variable
          }
        }
      
      #Salmon trends graphing stuff
    }else if(input$selectData == "Salmon Trends"){
      if (input$graphType == "Histogram" ) {
        if (length(input$histogramVariableOptions) == 1) {
          hist(salmonData[[input$histogramVariableOptions]], col = "salmon" , main=paste("Histogram of", input$histogramVariableOptions), xlab = input$histogramVariableOptions)
        } else {
          # have them select one variable from the list
        }
        
      } else if (input$graphType == "Scatter Plot") {
        # run ggplot on portal$main, with aes set to the variable names defined in their selected choices
        # ggplot(portal$main, aes(Choice1,Choice2)) <---- still not sure how to get these choices 
        if (length(input$scatplotVariableOptions) == 2) {
          choice1 <- input$scatplotVariableOptions[1]
          choice2 <- input$scatplotVariableOptions[2]
          #ggplot(portal$main, aes(choice1,choice2)) + geom_point(shape=1)
          plot(salmonData[[choice1]], salmonData[[choice2]], main = "Your Variable Scatterplot", ylab=choice2, xlab=choice1)
        } else {
          # have them select two variables from the list
        }
        
        #this won't work right now because no factor variables
      } else if (input$graphType == "Box-Whisker") {
        if (length(input$boxVariableOptions1) == 1 && length(input$boxVariableOptions2) == 1) {
          boxplot(salmonData[[input$boxVariableOptions1]], salmonData[[input$boxVariableOptions2]])
        } else {
          # Have them select one numeric and one factor variable
        }
      }
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