library(shiny)
library(shinymanager)

DB_PATH    <- Sys.getenv("SHINYMGR_DB_PATH")
PASSPHRASE <- Sys.getenv("SHINYMGR_PASSPHRASE")  

app_ui <- fluidPage(
  titlePanel("Old Faithful Geyser Data"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins", "Number of bins:", min = 1, max = 50, value = 30)
    ),
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

ui <- secure_app(app_ui)  
server <- function(input, output, session) {
  auth <- secure_server(
    check_credentials = check_credentials(
      db = DB_PATH,
      passphrase = PASSPHRASE
    )
  )

  output$distPlot <- renderPlot({
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')
  })
}

shinyApp(ui, server)
