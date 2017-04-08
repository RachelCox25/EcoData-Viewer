
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

#load the rdataretriever package
library(rdataretriever)

#load dataset options
birdSurvey = rdataretriever::fetch('breed-bird-survey') #from Coyle et. al.



shinyServer(function(input, output) {
  output$graph <- renderPlot({
    
    #check to see what the graph is
    if(input$selectData == "Bird Survey" && input$graphType == "Histogram"){
      
      #Got stuff working and then it stopped working
      #hist(bird_size$bird_size_species[,2])
      #hist(birdSurvey)
      
      #just to show a histogram will appear with the right options chosen
      hist(AirPassengers)
      
      
      
      
    }
    
  })
  
}
)
