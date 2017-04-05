
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("Basic widgets"),
  
  fluidRow(
    column(3,
           selectInput("select", label = h3("Select Your Dataset"), 
                       choices = list("Dataset 1" = 1, "Dataset 2" = 2,
                                      "Dataset 3" = 3), selected = 1)),
    column(3,
           radioButtons("radio", label = h3("Graphs"),
                        choices = list("Histogram" = 1, "Scatter Plot" = 2,
                                       "Box-Whisker" = 3),selected = 1))
  )
  
  
))
