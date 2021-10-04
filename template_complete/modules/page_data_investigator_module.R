# page_data_investigator_UI
# This is a page module. Typically page modules have a contain (mainPanel)
# and define what goes on inside that page. Page modules may also render
# text or plot graphs, but can also delegate that to submodules.
page_data_investigator_UI <- function(id) {
  ns = NS(id)
  mainPanel(width = 12,
            fluidRow(
              tags$h3("Data Investigator"),
              tags$p("Upload your data and inspect data in the plot below."),
              
              # Here we let a submodule do the graph plot for us. (ggplot)
              plot_ggplot_UI(ns("speed_position")),
              
              # This submodule provides another graph (Plotly).
              plot_timeline_UI(ns("speed_timeline"))
            ),
            fluidRow(
              tags$h3("More information about my data"),
              
              # uiOutput allows us to generate HTML using renderUI in the server.
              uiOutput(ns("more_info"))
            )
  )
}

page_data_investigator <- function(input, output, session, df, meta) {
  ns <- session$ns
  
  # Calling Plot Submodule Example:
  # Below is an example of how we can call submodules from our module.
  # Important: never add ns() around the ID when using callModule().
  # Only add ns() inside the module UI function.
  callModule(plot_timeline, "speed_timeline", df)
  
  # Another calling Plot Submodule Example
  callModule(plot_ggplot, "speed_position", df)
  
  # renderUI:
  # Our page module can add dynamic text content and various
  # conditions if we need it. We can do all our computations here,
  # as long as we return the "ui" variable at the end with HTML code in it.
  output$more_info <- renderUI({
    #validate() ensures that our code is only executed if the dataframe
    # is available, otherwise showing a fallback message.
    # See another example in plot_timeline_module.R
    validate(need(df(), "No data yet."))
    
    df_data <- df()

    ui <- HTML(paste(
      "<p>",
      "Number of rows in data:",
      nrow(df_data),
      "</p>"
    ))
    return(ui)
  })
  
}