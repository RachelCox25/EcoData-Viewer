
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(rdataretriever)

#Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("EcoData Viewer"),

  sidebarLayout(
    sidebarPanel(
      helpText("Create informative graphs with datasets from the EcoData Retriever."),

      selectInput(inputId = "selectData",
                  label="Choose the dataset to graph",
                  choices = c("Bird Survey", "Portal")
                  ),

      radioButtons(inputId = "graphType",
                   label = "Select the desired graph",
                   choices = c("Histogram", "Scatter Plot", "Box-Whisker")
                   ),
      
      #pops up checkbox based on what the graphType is..right?
      uiOutput("ui"),
      
      #Have to have a second render UI to have a second set of check boxes
      uiOutput("ui2")
      
    ),

    #mainpage goes here
    mainPanel(
      plotOutput("graph"),
      textOutput("error")
      )
  )
))

