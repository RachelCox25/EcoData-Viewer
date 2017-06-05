First to use this product you will need R, RStudio, and the Data Retriever program

To download R: https://cran.rstudio.com/ </br>
To download RStudio: https://www.rstudio.com/products/rstudio/download/ </br>
To download Data Retriever and add package to RStudio: http://www.data-retriever.org/

Next in RStudio you need to install the following packages by typing the commands below in the console:
```R
install.packages("shiny")
install.packages("readr")
install.packages("ggplot2")
install.packages("dplyr")
```

Now you can run the program two different ways:
1. To just view the application click the "Run App" button in RStudio
2. To view the application with the code type the following command in the console (replacing PATH, with your path to the project file):
```R
runApp("PATH", display.mode = "showcase")
```

To add datasets from the EcoData Retriever to the application:
1. Run the following command in the console to view the available datasets:
```R
rdataretriever::datasets()
```
2. Give your selected dataset a name in the ui.R file where you see:
```R
selectInput(inputId = "selectData",
                  label="Choose the dataset to graph",
                  choices = c("Bird Survey", "Abalone Age Prediction", "Portal", "Salmon Trends", "Antarctic Bird Species")
                  )
```
3. Retrieve the dataset you want by adding it where you see:
```R
#Datasets from the EcoData Retriever
#Load this first, so that the app doesn't have to do it with every call.
portal <- rdataretriever::fetch("portal")
example <- rdataretriever::fetch("dataset_name")
```
4. Select the part of the dataset you want the application to select the variables from:
```R
# Set the data values to the readable parts of the data
# the key needs to be whatever will be in input$selectData
# the value needs to be a dataframe that contains the data you want to use
portal <- portal$main
example <- example$example
```
5. Add dataset to a data holder (the part in quotes should match the name you gave it in the ui.R file):
```R
# Add the values to the nameToData data holder
nameToData$"Portal" <- portal
nameToData$"Example" <- example
```
6. Give the dataset a color for when it's graphed (a list of color options in RStudio can be found here - https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/colorPaletteCheatsheet.pdf):
```R
graphColors["Portal"] <- "darkseagreen2"
graphColors["Example"] <- "color_name"
```
You're dataset is added!
