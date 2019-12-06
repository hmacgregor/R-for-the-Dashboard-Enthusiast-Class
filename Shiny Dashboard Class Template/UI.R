#### Shiny Dashboard UI Page ####

#### Neccessary Libraries ########
## Libraries are loaded on the UI page since this page is ran before the Server page is ##
library(shiny)            ## For shiny use (allows shiny apps to happen)
library(shinydashboard)   ## For the template for a shiny dashboard
library(leaflet)          ## For interactive maps
library(ggplot2)          ## For static plots
library(dplyr)            ## For piping/easier data manipulation
library(DT)               ## For Datatables
library(openxlsx)         ## For reading excel files
library(rgdal)            ## For readOGR (mapping)
library(readr)            ## For read_csv()
library(tidyr)            ## For pivot_wider()

####-----------------------------------------------------------------------------####

#### Reading in Data for the app ####
## Data read in on the UI Page because this page is ran first ##
distanceGreenBlue <- read.xlsx("./distanceToGreenandBlueSpace.xlsx")

#### Reading in Shape files for use for the interactive map ####
shape <- readOGR(dsn = "./Files for Maps",layer = "Scotland1")
#codes <- read_csv("./Files for Maps/LA_codes for maps.csv") %>% as.data.frame()

####-------------------------------------------------------------------------------####
## The library "shinydashboard" comes with a template of 3 "components" which all interact with each other:
##        - Header (using dashboardHeader())
##        - Sidebar (using dashboardSidebar())
##        - Body (using dashboardBody())
## It's easier to deal with these individually and then put them into the UI later by putting it into a
## Page (dashboardPage())

#### Dashboard Header ####
## Header for the dashboard - same across all pages ##
header1 <- dashboardHeader(title = "Dashboard Test")

#### Dashboard Sidebar ####
## Mainly used for the menu - same across all pages ##
sidebar1 <- dashboardSidebar(
  sidebarMenu(id = "tabs",
              menuItem("Home Page", tabName = "home1", icon = icon("home")),
              menuItem("Interactive Map", tabName = "map1", icon = icon("map-marked-alt")),
              menuItem("Static Graph", tabName = "graph1", icon = icon("chart-line")),
              menuItem("Data Table", tabName = "table1", icon = icon("table"))
  )
)

#### Dashboard Body ####
## Main part of the app, where graphs and tables and things to be displayed will go ##
## Is different dependent on the page ##
body1 <- dashboardBody(
  tabItems(
    #### Home Page ####------------------------------------####
    tabItem(tabName = "home1",
            fluidRow(
              box(width = 12, title = "Introduction",
                  p(paste('This is an introduction on how to make dashboards using the shinydashboard library.',
                          'The data used within this dashboard is the "Distance to Green or Blue Space" from the Scottish Household Survey.',
                          'This was pulled from the Open Data Platform using a SPARQL query, but was then saved as an excel file for easier use.')),

                  p(paste("This demo contains an interactive map, a static graph and a datatable for demonstration, which are available for viewing by clicking on the side bar menu.",
                          "The code behind each of these will be worked on during the session and will also be available after the class has ended."
                          )),
                  p(paste("Feel free to ask any questions during the class."))
              )
            )
    ),
    #### First tab: Interactive map ####--------------------####
    tabItem(tabName = "map1",
            fluidRow(
              box(width = 4, title = "User Input Choices for Map",
                  ## Creating a Drop-Down menu for the category ##
                 h5(""),
                  ## Creating Radio Buttons for the Year Choice ##
                 h5("")

                  ## The results of these inputs are "listened to" on the Server page and will influence the output ##
              ),
              box(width = 8, title = "Interactive Map",
                  ## The result of the server page will be shown here ##
                  h5("")
              )
            )
    ),
    #### Second tab: Static Graph ####--------------------####
    tabItem(tabName = "graph1",
            fluidRow(
              ## User Inputs ##
              box(width = 4, title = "User Input Choices for Graph",
                  ## Creating Checkbox Group Input to select Local Authorities from ##
                  h5(""),

                  ## Creating Radio Buttons for the category selection ##
                  h5("")
              ),

              ## Graph results ##
              box(width = 8, title = "Static Graph",
                  ## Displaying Graph that was created in the Server File ##
                  h5("")
              )
            )

    ),
    #### Third tab: Data Tables ####--------------------####
    tabItem(tabName = "table1",
            fluidRow(
              box(width = 12, title = "User Inputs for Data Table",
                  ## Drop Down Menu for the local authority selection ##
                  h5(""),

                  ## Slider Bar for Year selection for the data table ##
                  h5("")


              ),
              box(width = 12, title = "Data Table Result",
                  h5("")
              )

            )
    )
  )
)

#### Beginning of UI Page ####
## Puts the UI components into a dashboard page ##
## Global options can be put here (e.g. theme colours or enabling javascript across the app)
dashboardPage(
  skin = "blue", ## Changed the colour of the app
  header1,
  sidebar1,
  body1
)