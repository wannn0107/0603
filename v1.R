library(shiny)
library(googlesheets4)
library(googledrive)

# UI ----------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Downloading Data"),
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", "Choose a dataset:",
                  choices = c('每日資訊','發病日','新確診數','死亡數','地圖',
                              '地圖2','人口數(110.04)','檢驗量','估算死亡個數',
                              'ICU','Mechanical ventilation','mortality risk',
                              'literature-SEVERE','literature-LIFT','progression',
                              'severe not by age','醫療院所病床數','三高盛行率','hospitalized')),
      # Button
      downloadButton("downloadData", "Download")),
    # Main panel for displaying outputs ----
    mainPanel(
      tableOutput("table"))
  ))

# server ----------------------------------------------------------------------
server <- function(input, output) {
  outtbl<- reactive({
    req(input$dataset)
    googlesheets4::read_sheet('https://docs.google.com/spreadsheets/d/1mLKyntxDWUV1LDDfdNN3tnk2LA7UYnBmc8_t7WgVENQ/edit#gid=1946089651',
                              sheet= input$dataset,
                              col_names= F, col_types= 'c')
  })
  # Table of selected dataset ---- content
  output$table <- renderTable({
    outtbl()
  })
  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$dataset, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(outtbl(), file, row.names = FALSE)
    }
  )
  
}

# Create Shiny app ----
shinyApp(ui, server)