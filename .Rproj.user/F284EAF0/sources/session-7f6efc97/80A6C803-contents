library(shiny)
library(shinymanager)
library(DBI)
library(pool)
library(RSQLite)
library(sodium)

#Get env variables
DB_PATH <- Sys.getenv("SM_DB_PATH", file.path(Sys.getenv("R_USER_DIR", tempdir()), "credentials.sqlite"))
ADMIN_USER <- Sys.getenv("SM_ADMIN_USER")
ADMIN_PASSWORD <- Sys.getenv("SM_ADMIN_PASSWORD")
#Pool (only for sqlite, i think)
pool <- dbPool(
  drv = RSQLite::SQLite(),
  dbname = DB_PATH
)
onStop(function() poolClose(pool))

#Original initialization
init_schema <- function(con) {
  dbExecute(con, "
    CREATE TABLE IF NOT EXISTS credentials (
      user TEXT PRIMARY KEY,
      password TEXT NOT NULL,
      admin INTEGER NOT NULL DEFAULT 0,
      active INTEGER NOT NULL DEFAULT 1,
      created_at TEXT NOT NULL DEFAULT (datetime('now'))
    )
  ")
  n <- dbGetQuery(con, "SELECT COUNT(*) AS n FROM credentials")$n[1]
  if (n == 0) {
    if (is.na(ADMIN_USER) || is.na(ADMIN_PASSWORD)) {
      stop("Empty DB and no SM_ADMIN_USER/SM_ADMIN_PASSWORD set. Fix .Renviron.")
    }
    dbExecute(con,
              "INSERT INTO credentials (user, password, admin, active)
       VALUES (?, ?, 1, 1)",
              params = list(ADMIN_USER, password_store(ADMIN_PASSWORD))
    )
  }
}
init_schema(pool)

#Check credentials
check_credentials_db <- function(user, password) {
  row <- dbGetQuery(pool,
                    "SELECT user, password, admin, active FROM credentials WHERE user = ?",
                    params = list(user)
  )
  if (nrow(row) != 1) return(list(result = FALSE))
  if (as.integer(row$active[1]) != 1) return(list(result = FALSE))
  if (!password_verify(row$password[1], password)) return(list(result = FALSE))

  list(
    result = TRUE,
    user   = row$user[1],
    admin  = as.logical(row$admin[1]),
    expire = 60  # session expiry in minutes
  )
}

# Basic Shiny app
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
  auth <- secure_server(check_credentials = check_credentials_db)

  output$distPlot <- renderPlot({
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')
  })
}

shinyApp(ui, server)
