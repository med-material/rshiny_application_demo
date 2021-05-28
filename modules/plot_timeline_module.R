# plot_timeline_UI
# This is the UI function of our module.
# It works similar to ui.R, except when creating outputs
# you have to remember to encapsulate them with ns()
# ns() concatenates the module ID to your outputs.

plot_timeline_UI <- function(id) {
  ns = NS(id)
  list(
    fluidRow(
      plotlyOutput(ns("timelinePlot")),
    )
  )
}

# plot_timeline
# This is our server function of the module.
# Beyond storing the namespace, all computations must happen inside the
# plotlyOutput reactive context.
plot_timeline <- function(input, output, session, df) {
  ns <- session$ns
  
  output$timelinePlot <- renderPlotly({
    #validate() ensures that our code is only executed if the dataframe
    # is available. The dataframe may not be present if the user hasnt uploaded
    # any csv file yet. The "vis" errorClass is used to show where the plot will
    # be plotted (optional).
    validate(need(df(), "Waiting for data."), errorClass = "vis")

    # To read the reactive dataframe 'df', we need to "evaluate" it.
    # We do this by calling it as a function df(). 
    df_vis <- df()

    # Now we can create a plot of the data.
    plot <- plot_ly() %>% add_trace(data=df_vis, x =~GameTimeSpent, y =~MoleActivatedDuration)
    
    return(plot)
  })
  
}