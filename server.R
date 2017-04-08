
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(rdataretriever)

shinyServer(function(input, output) {
  
  output$text1 <- renderText({ 
    "You have selected this"
  })
  
}
)
