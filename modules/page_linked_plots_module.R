# page_data_investigator_UI
# This is a page module. Typically page modules have a contain (mainPanel)
# and define what goes on inside that page. Page modules may also render
# text or plot graphs, but can also delegate that to submodules.
page_linked_plots_UI <- function(id) {
  ns = NS(id)
  mainPanel(width = 12,
            fluidRow(
              tags$h3("Linked Plots"),
              tags$p("Use the box select to learn more about which mole belongs the given timeline."),
              
              # Here we let a submodule do the graph plot for us.
              plot_linked_UI(ns("spatial_whack_plot"))
            )
  )
}

page_linked_plots <- function(input, output, session, df, meta) {
  ns <- session$ns
  
  # Calling Plot Submodule Example
  callModule(plot_linked, "spatial_whack_plot", df)
  
}