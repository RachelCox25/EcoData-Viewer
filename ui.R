
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

# testing to see if push works
library(shiny)
library(rdataretriever)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("EcoData Viewer"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create informative graphs with datasets from the EcoData Retriever."),
      
      selectInput(inputId = "selectData",
                  label="Choose the dataset to graph",
                  choices = c("Bird Survey", "Vertnet-Fishes")
                  ),
      
      radioButtons(inputId = "graphType",
                   label = "Select the desired graph",
                   choices = c("Histogram", "Scatter Plot", "Box-Whisker")
                   )
    ),
    
    #mainpage goes here
    mainPanel(
      plotOutput("graph"))
  )
))
