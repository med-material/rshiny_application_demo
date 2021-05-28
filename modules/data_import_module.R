#data_import_UI
# Our csv_uploadUI consists of a fileInput, an actionButton and some
# text output. We could also remove the UI and only have a server function
# which loaded a csv file with hardcoded path.
data_import_UI <- function(id) {
  ns = NS(id)
  list(fluidRow(
    column(4, fileInput(ns("file"), "Choose a CSV file",
              accept = c("text/csv","text/comma-separated-values,text/plain",".csv"))),
    column(3, textOutput(ns("statusText")))
  )
  )
}

# data_import
# This is the server function of our data import module.
data_import <- function(input, output, session) {
  ns <- session$ns
  
  # 1) Reactive Value Structure 
  # Because this module will return reactive data (our dataframe, df)
  # we need a reactiveValues() structure to hold it.
  toReturn <- reactiveValues(
    df = NULL,
    trigger = 0
  )
  
  # 2) Observe the file upload widget
  # We want to upload data when the user has submitted a CSV file.
  # We can know when this happens, if we observe it using observeEvent.
  # It is possible that the user did not select a CSV and input$file returns NULL.
  # Therefore we first check whether there is any filepath before we attempt
  # to read it.
  observeEvent(input$file, {
    toReturn$df <-  read.csv(input$file$datapath, header=TRUE, sep = ";")
    print(input$file$datapath)
    toReturn$trigger <- toReturn$trigger + 1
  })
  
  
  # 3) Observe when we have data
  # We can now observe changes made to our reactive dataframe 'df'
  # and show a text indicating that the data was received.
  observeEvent(toReturn$df, {
    req(!is.null(toReturn$df))
    output$statusText <- renderText({ "Success!" })
  })
  
  return(toReturn)
}