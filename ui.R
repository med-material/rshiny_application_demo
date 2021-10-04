# ui.R - Bastian I. Hougaard
# Here we define the design and layout of our R Shiny application (Bootstrap).
# ui.R. will mainly have the bigger elements, such as navigation panels
# headers and footers. The rest we delegate to our modules, which we
# call in the respective places.
shinyUI(
  fluidPage(
  data_import_UI("import_game_csv"),
  # 2) Here we let a submodule do the graph plot for us. (ggplot)
  plot_ggplot_UI("speed_position"),
  )
)