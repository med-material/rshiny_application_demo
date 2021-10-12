# ui.R - Bastian I. Hougaard
# Here we define the design and layout of our R Shiny application (Bootstrap).
shinyUI(
  fluidPage(
  fileInput("file", "Choose file"),
  plotOutput("speedPlot"),
  sliderInput("timeslider", "Time Range", value = c(19,39), min=19, max=150)
  )
)