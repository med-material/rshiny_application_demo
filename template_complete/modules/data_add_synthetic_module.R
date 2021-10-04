# data_add_synthetic_UI
# This is a module which demonstrates modifying
# incoming data and sending it back to the app.
# In this particular example, we add extra data points
# to the loaded dataset everytime the button is clicked.

data_add_synthetic_UI <- function(id) {
  ns = NS(id)
  list(
    fluidRow(
      uiOutput(ns("syntheticDataCount")),
      actionButton(ns("addData"), "Add Synthetic Data"),
    )
  )
}

# data_add_synthetic
# This is our server function of the module.
data_add_synthetic <- function(input, output, session, df) {
  ns <- session$ns
  
  # 1) Reactive Value Structure 
  # Because this module will return reactive data (our dataframe, df)
  # we need a reactiveValues() structure to hold it.
  toReturn <- reactiveValues(
    df = NULL,
    trigger = 0
  )
  
  # 2) Synthetic Data Counter
  # This creates a UI that keeps track of how
  # much synthetic data was added (e.g. how many
  # times the button was pressed).
  output$syntheticDataCount <- renderUI({
    validate(need(df(), "Waiting for data."))

    df_data <- df()

    ui <- HTML(paste(
      "<p>",
      "Synthetic Data Count:",
      toReturn$trigger,
      "</p>"
    ))
    return(ui)
  })
  
  # Here we observe whether our actionButton is pressed.
  # If it is pressed, we create a new row in the dataset
  # with synthetic numbers.
  observeEvent(input$addData, {
    validate(need(df(), ".."))
    df_data = df()
    
    maxTime = max(df_data$GameTimeSpent)
    minTime = 0
    maxActivation = max(df_data$MoleActivatedDuration)
    minActivation = 0
    synthTime = runif(1,min=minTime, max=maxTime)
    synthActivation = runif(1, min=minActivation, max=maxActivation)
    
    df_data = df_data %>% add_row(Event = "Synthetic Mole",
                   GameTimeSpent = synthTime,
                   MoleActivatedDuration = synthActivation)
    
    toReturn$df <- df_data
    toReturn$trigger <- toReturn$trigger + 1
  })
  
  # Finally we return our reactive values, so that 
  # we can update our dataframe.
  return(toReturn)
  
}