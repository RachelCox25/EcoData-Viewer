
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
      
      if(input$graphType == "Histogram"){
        checkboxGroupInput(inputId = "histogramVariableOptions", label = "Select a numeric variable to graph", choices = c(10, 344, 567))
      
      }else if(input$graphType == "Scatter Plot"){
        checkboxGroupInput(inputId = "scatplotVariableOptions", label = "Select two numeric variables to graph", choices = c(10, 344, 567))
      
      }else if(input$graphType == "Box-Whisker"){
        checkboxGroupInput(inputId = "boxVariableOptions1", label = "Select one numeric variable to graph", choices = c(10, 344, 567))
        checkboxGroupInput(inputId = "boxVariableOptions2", label = "Select one factor variable to graph", choices = c("factor1", "factor2", "factor3"))
      }
      
      # switch(input$graphType,
      #        "Histogram" = checkboxGroupInput(inputId = "histogramVariableOptions", label = "Select a numeric variable to graph",
      #                                         choices = c(10, 344, 567)
      #        ),
      #        "Scatter Plot" = checkboxGroupInput(inputId = "scatplotVariableOptions", label = "Select two numeric variables to graph",
      #                                            choices = c(10, 344, 567)
      #        ),
      #        "Box-Whisker" = (checkboxGroupInput(inputId = "boxVariableOptions1", label = "Select one numeric variable to graph",
      #                                           choices = c(10, 344, 567)
      #        ) checkboxGroupInput(inputId = "boxVariableOptions2", label = "Select one factor variable to graph", choices = c("factor1", "factor2"))) 
      #        
      # )
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
  
  
  
  
  
  
  # output$graph <- renderPlot({
  #   
  #   #check to see what the graph is
  #   if(input$selectData == "Bird Survey"){
  #     if(input$graphType == "Histogram"){
  #       
  #       #Got stuff working and then it stopped working
  #       #hist(bird_size$bird_size_species[,2])
  #       #hist(birdSurvey)
  #       
  #       ggplot(locationData, aes(PredominantSpeciesType)) + geom_bar(fill=c("red", "blue")) + xlab("Predominant Species Type: Core or Transient") + ylab("Species Type Count")
  #     
  #     }else if(input$graphType == "Scatter Plot"){
  #       ggplot(locationData, aes(NumSpecies,NDVI)) + geom_point(aes(colour = factor(PredominantSpeciesType), size = Elevation)) + xlab("Total Number of Species")
  #         
  #       
  #     }else{
  #       print("Graph unavailable for this dataset")
  #         
  #       }
  #    
  #     #If the dataset isn't bird survey than it should be dynamic
  #     #bird survey data is hard coded
  #   }else if(input$selectData != "Bird Survey"){
  #     output$ui <- renderUI({
  #       if(is.null(input$graphType))
  #         return()
  #       
  #       switch(input$graphType,
  #              "Histogram" = checkboxGroupInput(inputId = "histogramVariableOptions", label = "Select a variable to graph",
  #                                               choices = c(10 = "option1", 344 = "option2", 567 = "option3")
  #               ),
  #              "Scatter Plot" = checkboxGroupInput(inputId = "scatplotVariableOptions", label = "Select two variables to graph",
  #                                                  choices = c(10 = "option1", 344 = "option2", 567 = "option3")
  #               ),
  #              "Box-Whisker" = checkboxGroupInput(inputId = "boxVariableOptions1", label = "Select one below",
  #                                                 choices = c(10 = "option1", 344 = "option2", 567 = "option3")
  #               ) 
  #              
  #              )
  #       
  #     })
  #     
  #     #just trying to get a graph to show up if it's not bird survey
  #     output$graph <- renderPlot({
  #       hist(AirPassengers)
  #       
  #     })
  #     
  #     
  #     
  #   }
  #   
  #   
  # })
  
}
)

# function(input, output) {
#   
#   output$ui <- renderUI({
#     if (is.null(input$input_type))
#       return()
#     
#     # Depending on input$input_type, we'll generate a different
#     # UI component and send it to the client.
#     switch(input$input_type,
#            "slider" = sliderInput("dynamic", "Dynamic",
#                                   min = 1, max = 20, value = 10),
#            "text" = textInput("dynamic", "Dynamic",
#                               value = "starting value"),
#            "numeric" =  numericInput("dynamic", "Dynamic",
#                                      value = 12),
#            "checkbox" = checkboxInput("dynamic", "Dynamic",
#                                       value = TRUE),
#            "checkboxGroup" = checkboxGroupInput("dynamic", "Dynamic",
#                                                 choices = c("Option 1" = "option1",
#                                                             "Option 2" = "option2"),
#                                                 selected = "option2"
#            ),
#            "radioButtons" = radioButtons("dynamic", "Dynamic",
#                                          choices = c("Option 1" = "option1",
#                                                      "Option 2" = "option2"),
#                                          selected = "option2"
#            ),
#            "selectInput" = selectInput("dynamic", "Dynamic",
#                                        choices = c("Option 1" = "option1",
#                                                    "Option 2" = "option2"),
#                                        selected = "option2"
#            ),
#            "selectInput (multi)" = selectInput("dynamic", "Dynamic",
#                                                choices = c("Option 1" = "option1",
#                                                            "Option 2" = "option2"),
#                                                selected = c("option1", "option2"),
#                                                multiple = TRUE
#            ),
#            "date" = dateInput("dynamic", "Dynamic"),
#            "daterange" = dateRangeInput("dynamic", "Dynamic")
#     )
#   })
#   
#   output$input_type_text <- renderText({
#     input$input_type
#   })
#   
#   output$dynamic_value <- renderPrint({
#     str(input$dynamic)
#   })
#   
# }
