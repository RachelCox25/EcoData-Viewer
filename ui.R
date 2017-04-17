
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(rdataretriever)

# Define UI for application that draws a histogram
#shinyUI(fluidPage(
#  titlePanel("EcoData Viewer"),
  
#  sidebarLayout(
#    sidebarPanel(
#      helpText("Create informative graphs with datasets from the EcoData Retriever."),
      
#      selectInput(inputId = "selectData",
#                  label="Choose the dataset to graph",
#                  choices = c("Bird Survey", "Vertnet-Fishes")
#                  ),
      
#      radioButtons(inputId = "graphType",
#                   label = "Select the desired graph",
#                   choices = c("Histogram", "Scatter Plot", "Box-Whisker")
#                   )
#    ),
    
    #mainpage goes here
#    mainPanel(
#      plotOutput("graph"))
#  )
#))

fluidPage(
  titlePanel("Dynamically generated user interface components"),
  fluidRow(
    
    column(3, wellPanel(
      selectInput("input_type", "Input type",
                  c("slider", "text", "numeric", "checkbox",
                    "checkboxGroup", "radioButtons", "selectInput",
                    "selectInput (multi)", "date", "daterange"
                  )
      )
    )),
    
    column(3, wellPanel(
      # This outputs the dynamic UI component
      uiOutput("ui")
    )),
    
    column(3,
           tags$p("Input type:"),
           verbatimTextOutput("input_type_text"),
           tags$p("Dynamic input value:"),
           verbatimTextOutput("dynamic_value")
    )
  )
)

