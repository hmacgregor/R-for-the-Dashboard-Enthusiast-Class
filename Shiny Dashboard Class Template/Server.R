#### Shiny Dashboard Server Page ####
#### The server page is ran 2nd, but does all the processing for the graphs/figures which are shown on
#### the UI page.

source("./UI.R", encoding = "UTF-8")

#### Beginning of Server ###-----------------------####
server <- function(input, output, session) {
  #### Stopping the session whenever the window is closed (makes it easier to test repeatedly) ####
  session$onSessionEnded(function(){
    stopApp()
  })
  ####-------------------------------------------------------------------------####
  #### Processing the First tab - Interactive Mapping ####
  ## Listening to the user inputs ##

  ## Narrowing Down the Data to the category and year of choice ##

  ## Creating A Leaflet Map to be displayed on the page ##

  ####------------------------------------------------------------------------####
  #### Processing Second Tab - Static Graphs ####
  ## Listening to the User Inputs ##


  ## Narrowing down the data to area wanted ##


  ## Creating Graph to be returned to UI page ##

  ####------------------------------------------------------------------------####
  #### Processing Third Tab - Data table ####
  ## Getting User Inputs from the UI Page ##


  ## Getting Data Together to be displayed in the table ##

}

