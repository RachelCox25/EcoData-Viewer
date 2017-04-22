
library(shiny)

#load the rdataretriever package
library(rdataretriever)
library(readr)
library(ggplot2)
library(dplyr)

# Make a dictionary to match selection names to the actual data
nameToData <- new.env()

occupancyData <- read_tsv("Occupancy_Data.txt")
locationData <- read_tsv("Location_Data.txt")
#salmonData <- read_tsv("salmon.txt")
salmonData <- read.table("salmon.txt", sep="\t", header=TRUE, row.names=NULL, check.names=FALSE)
# Load this first, so that the app doesn't have to do it with every call.
portal <- rdataretriever::fetch("portal")
abalone <- rdataretriever::fetch("abalone-age")
antarcticBirdData <- rdataretriever::fetch("antarctic-breed-bird")
iris <- rdataretriever::fetch("iris")

# Set the data values to the readable parts of the data
  # the key needs to be whatever will be in input$selectData
  # the value needs to be a dataframe that contains the data you want to use
abalone <- abalone$abalone_age_data
portal <- portal$main
antarcticBirdData <- antarcticBirdData$antarctic_breed_bird_species
iris <- iris$Iris

# Add the values to the nameToData data holder
nameToData$"Portal" <- portal
nameToData$"Salmon Trends" <- salmonData
nameToData$"Abalone Age Prediction" <- abalone
nameToData$"Antarctic Bird Species" <- antarcticBirdData
nameToData$"Iris" <- iris
# an exampe of accessing this data type at the abalone data:
#   nameToData[["Abalone Age Prediction]]

# Make a list to hold the specific color values we want to use on our graphs
graphColors <- list()
# set the specific color values for each dataset
  # the key needs to be whatever will be in input$selectData
  # the value needs to be a string color name
graphColors["Portal"] <- "darkseagreen2"
graphColors["Salmon Trends"] <- "salmon"
graphColors["Abalone Age Prediction"] <- "lightblue"
graphColors["Antarctic Bird Species"] <- "cadetblue"
graphColors["Iris"] <- "darkorchid"
# an exampe of accessing this data type at the abalone data:
#   nameToData[["Abalone Age Prediction]]


shinyServer(function(input, output) {
  
  #IF THE DATA INPUT IS NOT BIRD SURVEY, GRAPH OUTPUT IS DYNAMIC WITH DYNAMIC UI aka this is not hard coded
  output$ui <- renderUI({
    if(input$selectData != "Bird Survey"){
      # Establish the list of numerics and factors from the dataset
      numerics <- c()
      count <- 1
      
      colNamesList <- colnames(nameToData[[input$selectData]])
      for (variable in lapply(nameToData[[input$selectData]], class)) {
        # find out which variable type it is
         if (variable == "integer" || variable == "numeric") {
           # add it to the numerics list
           numerics <- c(numerics, colNamesList[count])
         }
       count <- count + 1
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
    
    if(input$selectData != "Bird Survey" && input$graphType == "Box-Whisker" || input$graphType == "Scatter Plot"){
      factors <- c()
      count <- 1
      
      colNamesList <- colnames(nameToData[[input$selectData]])
      for (variable in lapply(nameToData[[input$selectData]], class)) {
        # find out which variable type it is
        if (variable == "factor") {
          # add it to the numerics list
          factors <- c(factors, colNamesList[count])
        }
        count <- count + 1
      }
      
      if(input$graphType == "Box-Whisker"){
        checkboxGroupInput(inputId = "boxVariableOptions2", label = "Select ONE factor variable to graph", choices = factors, selected=factors[1])
      }else{
        checkboxGroupInput(inputId = "boxVariableOptions2", label = "Optional: Select ONE factor variable to graph", choices = factors)
      }
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
    }
    #IF THE DATA INPUT IS NOT BIRD SURVEY, GRAPH OUTPUT IS DYNAMIC WITH DYNAMIC UI aka this is not hard coded 
    #portal dataset graphing stuff
    else {
      # use ggplot hist instead of just hist
      if (input$graphType == "Histogram" ) {
        if (length(input$histogramVariableOptions) == 1) {
          ggplot(nameToData[[input$selectData]], aes_string(input$histogramVariableOptions)) + geom_histogram(col="gray28", fill=graphColors[[input$selectData]]) + xlab(input$histogramVariableOptions) + ggtitle(paste("Histogram of", input$histogramVariableOptions))
        } else {
          # have them select one variable from the list
        }
        
      } else if (input$graphType == "Scatter Plot") {
        # run ggplot on portal$main, with aes set to the variable names defined in their selected choices
        # ggplot(portal$main, aes(Choice1,Choice2)) <---- still not sure how to get these choices 
        if ((length(input$scatplotVariableOptions) == 2) && (length(input$boxVariableOptions2) != 1)) {
          choice1 <- input$scatplotVariableOptions[1]
          choice2 <- input$scatplotVariableOptions[2]

          ggplot(nameToData[[input$selectData]], aes_string(choice1,choice2)) + geom_point(colour = graphColors[[input$selectData]]) + xlab(choice1) + ylab(choice2)

        } else if(length(input$boxVariableOptions2) == 1){
          choice1 <- input$scatplotVariableOptions[1]
          choice2 <- input$scatplotVariableOptions[2]
          
          ggplot(nameToData[[input$selectData]], aes_string(choice1,choice2)) + geom_point(aes_string(colour = input$boxVariableOptions2)) + xlab(choice1) + ylab(choice2)
          
        }else {
          # have them select two variables from the list
        }
        
      } else if (input$graphType == "Box-Whisker") {
        if (length(input$boxVariableOptions1) == 1 && length(input$boxVariableOptions2) == 1) {
          ggplot(nameToData[[input$selectData]], aes_string(input$boxVariableOptions2, input$boxVariableOptions1)) + geom_boxplot(fill=graphColors[[input$selectData]]) #+ coord_cartesian(ylim = c(0, 100))
          
          #boxplot(nameToData[[input$selectData]][[input$boxVariableOptions1]], nameToData[[input$selectData]][[input$boxVariableOptions2]])
        } else {
          # Have them select one numeric and one factor variable
        }
      }
    }
  })
  
}
)