# plot_linked_UI
# This is the UI function of our module.
# It works similar to ui.R, except when creating outputs
# you have to remember to encapsulate them with ns()
# ns() concatenates the module ID to your outputs.

plot_linked_UI <- function(id) {
  ns = NS(id)
  list(
    fluidRow(
      column(6,plotlyOutput(ns("timePlot"))),
      column(6,plotlyOutput(ns("whackPlot")))
    )
  )
}

# plot_time
# This is our server function of the module.
# Beyond storing the namespace, all computations must happen inside the
# plotlyOutput reactive context.
plot_linked <- function(input, output, session, df) {
  ns <- session$ns
  
  output$timePlot <- renderPlotly({
    #validate() ensures that our code is only executed if the dataframe
    # is available. The dataframe may not be present if the user hasnt uploaded
    # any csv file yet. The "vis" errorClass is used to show where the plot will
    # be plotted (optional).
    validate(need(df(), "Waiting for data."), errorClass = "vis")

    # To read the reactive dataframe 'df', we need to "evaluate" it.
    # We do this by calling it as a function df(). 
    df_vis <- df()
    df_vis$rowID <- 1:nrow(df_vis)
    # To link timePlot to whackPlot we need to use "event_register()" and
    # specify what interaction we want to link. "plotly_selecting" sends
    # events everytime you make a selection and drag over an item.
    plot <- plot_ly() %>%
      config(scrollZoom = TRUE, displaylogo = FALSE, modeBarButtonsToRemove = c("hoverCompareCartesian", "toggleSpikelines","toImage", "sendDataToCloud", "editInChartStudio", "lasso2d", "drawclosedpath", "drawopenpath", "drawline", "drawcircle", "eraseshape", "autoScale2d", "hoverClosestCartesian","toggleHover")) %>%
      layout(dragmode = "pan", showlegend=FALSE, xaxis = list(tickformat="%H:%M:%S.%L ms"), yaxis = list(range=c(0,1.1))) %>%
      add_segments(data=df_vis, name="Event", x =~Timestamp, y=~0.2-0.02, xend =~Timestamp, yend =0, size=I(1), color=I("Gray")) %>%
      add_trace(data=df_vis, name="Game Event Label", x =~Timestamp, y =~0.2, color = ~Event, key=~rowID,
                type='scatter',mode='text', text=~Event, textfont = list(size = 8)) %>%
      layout(dragmode = "select", clickmode = 'event+select' ) %>%
      event_register("plotly_selecting")
    
    return(plot)
  })
    
  output$whackPlot <- renderPlotly({
    #validate() ensures that our code is only executed if the dataframe
    # is available. The dataframe may not be present if the user hasnt uploaded
    # any csv file yet. The "vis" errorClass is used to show where the plot will
    # be plotted (optional).
    validate(need(df(), "Waiting for data."), errorClass = "vis")
    
    # To read the reactive dataframe 'df', we need to "evaluate" it.
    # We do this by calling it as a function df(). 
    df_vis <- df()
    df_vis$rowID <- 1:nrow(df_vis)
    
    select.data <- event_data(event = "plotly_selecting")
    if (!is.null(select.data)) {
        df_vis = df_vis %>% filter(rowID %in% select.data$key)
    }

    Wall_moles <- expand.grid(0:df()$WallColumnCount[1], 0:df()$WallRowCount[1]) %>%
      rename(x = Var1, y = Var2)
    
    plot <- plot_ly() %>%
        config(scrollZoom = TRUE, displaylogo = FALSE, modeBarButtonsToRemove = c("select2d","hoverCompareCartesian", "toggleSpikelines","zoom2d","toImage", "sendDataToCloud", "editInChartStudio", "lasso2d", "drawclosedpath", "drawopenpath", "drawline", "drawcircle", "eraseshape", "autoScale2d", "hoverClosestCartesian","toggleHover")) %>%
        layout(dragmode = "pan", showlegend=FALSE, xaxis=list(dtick = 1), yaxis=list(dtick = 1)) %>%
        add_trace(data=Wall_moles,x=~x, y=~y, type='scatter',mode='markers',symbol=I('o'),marker=list(size=32),hoverinfo='none')

    # In case no markers were inside the selection, we cannot plot data. So check
    # if there are any rows.
    if (nrow(df_vis) > 0) {
      # Now we can create a plot of the data.
      plot <- plot %>%
        add_trace(data=df_vis, x=~MoleIndexX-1, y=~MoleIndexY-1, type='scatter', mode='markers',marker=list(size=32))
    }
    
    return(plot)
  })
  
}