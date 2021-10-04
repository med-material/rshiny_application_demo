# plot_ggplot_UI
# This is the UI function of our module.
# It works similar to ui.R, except when creating outputs
# you have to remember to encapsulate them with ns()
# ns() concatenates the module ID to your outputs.
plot_ggplot_UI <- function(id) {
  ns = NS(id)
  plotOutput(ns("speedPlot"))
}

# plot_ggplot
# This is our server function of the module.
# Beyond storing the namespace, all computations must happen inside the
# plotlyOutput reactive context.
plot_ggplot <- function(input, output, session, df) {
  
  output$speedPlot <- renderPlot({
    #validate() ensures that our code is only executed if the dataframe
    # is available. The dataframe may not be present if the user hasnt uploaded
    # any csv file yet. The "vis" errorClass is used to show where the plot will
    # be plotted (optional).
    validate(need(df(), "Waiting for data."), errorClass = "vis")
    # To read the reactive dataframe 'df', we need to "evaluate" it.
    # We do this by calling it as a function df(). 
    df_vis <- df()

    # Now we can create a plot of the data.
    plot <- df_vis %>% ggplot(aes(x=MoleIndexX, y = MoleActivatedDuration)) + geom_point()
    
    return(plot)
  })
  
}