shinyServer(function(input, output, session) {

  r <- reactiveValues(df = NULL, source = NULL)
  
  observeEvent(input$file, {
    r$df <-  read.csv(input$file$datapath, header=TRUE, sep = ";")
  })  

  output$speedPlot <- renderPlot({
    #validate() ensures that our code is only executed if the dataframe
    # is available. The dataframe may not be present if the user hasnt uploaded
    # any csv file yet. The "vis" errorClass is used to show where the plot will
    # be plotted (optional).
    validate(need(r$df, "Waiting for data."), errorClass = "vis")
    # To read the reactive dataframe 'df', we need to "evaluate" it.
    # We do this by calling it as a function df(). 
    df_vis <- r$df
    
    # Now we can create a plot of the data.
    plot <- df_vis %>% ggplot(aes(x=MoleIndexX, y = MoleActivatedDuration)) + geom_point()
    
    return(plot)
  })

  
})