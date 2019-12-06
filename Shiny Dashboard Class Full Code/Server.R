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
  mapCategoryChoice <- eventReactive(input$MapDropDown,{
    category <- input$MapDropDown
    return(category) ## return() finished the function and specifies what the function will give back to the rest of the code
  })
  mapYearChoice <- eventReactive(input$mapRadioButton,{
    year <- input$mapRadioButton
    return(year)
  })

  ## Testing for User Input Reactivity, results in console
  #observe({
  #  print(c("Category: ",mapCategoryChoice()))
  #  print(c("Year: ",mapYearChoice()))
  #})

  ## Narrowing Down the Data to the category and year of choice ##
  dataMap <- reactive({
    data1 <- distanceGreenBlue %>%
      filter(Distance == mapCategoryChoice()) %>%
      filter(Year == mapYearChoice()) %>%
      distinct() %>%
      rename("local_authority" = AreaName)
    return(data1)
  })

  ## Creating A Leaflet Map to be displayed on the page ##
  output$interactive_map <- renderLeaflet({
    ## Getting Data together ##
    data1 <- dataMap()

    ## Getting a "Performance" rating for each
    data1 <- merge(data1, codes, by = "local_authority")
    data1$Performance <- cut(as.numeric(data1$Figure), breaks = c(0,20,40,60,80,100),
                             labels = c("0-20%", "21-40%", "41-60%", "61-80%", "81-100%"))

    ## Creating a variable to show text when the user clicks on the map ##
    data1 <- data1 %>%
      mutate(text_click = paste(
        format(Figure, nsmall = 0, digits = 0, big.mark = ","),
        "%",
        sep = ""
      ))

    ## Merging with shape file for the map ##
    shape@data <- left_join(shape@data, data1, by = c("NAME" = "local_authority"))

    ## Setting a colour palette to show the performance ##
    palette1 <- colorFactor(palette = "Blues", domain = shape@data$Performance)

    ## Creating leaflet map ##
    leaflet_map <- leaflet(shape) %>%

      ## Add Map to place shape file onto ##
      addProviderTiles("CartoDB.PositronNoLabels") %>%

      ## Adding palette colours for the performance and the text for when the user clicks
      addPolygons(fillColor = ~palette1(Performance), ## Uses the colour palette we defiend earlier
                  popup = ~paste(NAME, text_click, sep = " - "), ## Text the user sees when they click on a shape
                  stroke = TRUE, ## Enables borders around the shapes for local authorities
                  weight = 1.5,
                  fillOpacity = 1,
                  opacity = 1,
                  color = "black"
                  ) %>%

      ## Adding Legend for the map ##
      addLegend(pal = palette1, values = ~Performance, title = "Percentage",
                opacity = 1, na.label = "Missing Data")

    return(leaflet_map)
  })
  ####------------------------------------------------------------------------####
  #### Processing Second Tab - Static Graphs ####
  ## Listening to the User Inputs ##
  dropDownGraph <- eventReactive(input$dropDownGraph,{
    areas <- input$dropDownGraph
    return(areas)
  })

  radioButtonGraph <- eventReactive(input$graphRadioButton,{
    category <- input$graphRadioButton
    return(category)
  })

  ## Narrowing down the data to area wanted ##
  dataGraph <- reactive({
    data1 <- distanceGreenBlue %>%
      filter(AreaName %in% dropDownGraph()) %>%
      filter(Distance == radioButtonGraph()) %>%
      distinct()

    return(data1)
  })

  ## Creating Graph to be returned to UI page ##
  output$staticGraph1 <- renderPlot({
    ## Getting Data from earlier ##
    data1 <- dataGraph()

    ## Putting Data into Graph ##
    graph1 <- ggplot(data = data1, aes(x = Year, y = Figure, group = AreaName, color = AreaName)) +

      ## Setting the type of graph ##
      geom_line(size = 2) +

      ## Modifying the y axis to suit needs ##
      scale_y_continuous(limits = c(0,100), breaks = seq(0,100, length.out = 5)) +

      ## Setting the title and labels ##
      labs(
        color = "Local Authority",
        y = "Percentage (%)",
        title = radioButtonGraph(),
        caption = "Source: Scottish Household Survey"
      ) +

      ## Setting the overall theme
      theme_minimal()

    return(graph1)

  })
  ####------------------------------------------------------------------------####
  #### Processing Third Tab - Data table ####
  ## Getting User Inputs from the UI Page ##
  tableDropDown <- eventReactive(input$dropDownTable,{
    areas <- input$dropDownTable
    return(areas)
  })

  tableSlider <- eventReactive(input$sliderTable,{
    year <- input$sliderTable
    return(year)
  })

  ## Getting Data Together to be displayed in the table ##
  dataTable1 <- reactive({
    data1 <- distanceGreenBlue %>%
      filter(AreaName %in% tableDropDown()) %>%
      filter(Year == tableSlider()) %>%
      arrange(Distance, AreaName, -Figure) %>%  ## Sorting it
      mutate(Figure = paste(
        format(Figure, nsmall = 0, digits = 0, big.mark = ","),
        "%",
        sep = ""
      )) %>% ## Formatting Figures and adding a percentage sign
      spread(key = Distance, value = Figure) %>%
      rename("Area" = AreaName) %>%
      select(-Year) %>%
      as.data.frame()

    return(data1)
  })

  ## Printing Data table to be presented in the app ##
  output$dataTable1 <- renderDT({
    ## Getting Data from Earlier ##
    data1 <- dataTable1() %>% as.data.frame()

    ## Presenting data table ##
    datatable1 <- DT::datatable(data = data1,
                                selection = "single",
                                options = list(
                                  dom = "t" ## Just showing the table
                                ),
                                rownames = FALSE
                                )

    return(datatable1)
  })
}

