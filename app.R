library(tidyverse)
library(shiny)

source("app-functions.R")

ui <- fluidPage(
  
  # app theme and styling
  theme = shinythemes::shinytheme("lumen"),
  shinyWidgets::chooseSliderSkin("Nice"),
  #shinyWidgets::setSliderColor(rep("#8FBC8F", 4), 1:4),
  
  # app title
  titlePanel("QMS Benchmarking App (dummy version)"),
  # app subtitle
  h4(HTML("Prepared for QMS Livestock Enterprise Costing Tender, 16/07/2020")),
  
  sidebarLayout(
    
    sidebarPanel(
      
      # kpi inputs
      numericInput(inputId = "kpi1",
                   label =  "KPI 1",
                   min = 1, max = 10, value = 4, step = 0.1),
      
      numericInput(inputId = "kpi2",
                   label =  "KPI 2",
                   min = 1, max = 40, value = 7, step = 0.5),
      
      numericInput(inputId = "kpi3",
                   label =  "KPI 3",
                   min = 1, max = 15, value = 5, step = 0.5),
      
      numericInput(inputId = "kpi4",
                   label =  "KPI 4",
                   min = 1, max = 8, value = 3.5, step = 0.1),
      
      includeMarkdown("app-footer.Rmd")
      
    ),
    
    mainPanel(
      
      plotOutput(outputId = "mainplot"),
      
      tableOutput(outputId = "maintable")
      
    )
    
  )
)

server <- function(input, output) {
  
  # reactive values for main data
  data <- reactiveValues(base_data = read_rds("dummy-data.rds"))
  
  # main plot
  output$mainplot <- renderPlot({
    build_violin_plot(list(kpi1 = input$kpi1,
                           kpi2 = input$kpi2,
                           kpi3 = input$kpi3,
                           kpi4 = input$kpi4),
                      data$base_data)
  })
  
  # main table
  output$maintable <- renderTable({
    build_stats(list(kpi1 = input$kpi1,
                     kpi2 = input$kpi2,
                     kpi3 = input$kpi3,
                     kpi4 = input$kpi4),
                data$base_data)
  })
  
}

shinyApp(ui, server)