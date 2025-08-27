library(shiny)
library(shinymanager)
library(DBI)
library(RPostgres)
library(pool)

# Get env variables, this works with posit connect
pg_host <- Sys.getenv("PGHOST")
pg_port <- Sys.getenv("PGPORT", unset = "5432")
pg_dbname <- Sys.getenv("PGDATABASE")
pg_user <- Sys.getenv("PGUSER")
pg_password <- Sys.getenv("PGPASSWORD")

# pool connection, works well with shiny
pool <- dbPool(
  drv = RPostgres::Postgres(),
  host = pg_host,
  port = as.integer(pg_port),
  dbname = pg_dbname,
  user = pg_user,
  password = pg_password
)

# --- IMPORTANT ---
# Postgres must have a table called "credentials" like this:
# CREATE TABLE credentials (
#   user TEXT PRIMARY KEY,
#   password TEXT,
#   admin BOOLEAN,
#   expire DATE
# );
# Passwords should be hashed with sodium::password_store()

# Default app
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
  
  # Authentication against Postgres credentials table
  auth <- secure_server(
    check_credentials = check_credentials(
      db = pool,
      passphrase = Sys.getenv("DB_PASSPHRASE"),
      table = "credentials"
    )
  )
  
  output$distPlot <- renderPlot({
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(
      x, breaks = bins, col = 'darkgray', border = 'white',
      xlab = 'Waiting time to next eruption (in mins)',
      main = 'Histogram of waiting times'
    )
  })
}

#Stop db connection
onStop(function() {
  poolClose(pool)   
})

shinyApp(ui, server)
