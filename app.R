# Install required packages:
# install.packages("pak")
# pak::pak('surveydown-dev/surveydown') # Development version from github

# Load packages
library(surveydown)
library(dplyr)

# sd_db_config()
# sd_db_show()


db <- sd_db_connect()


# Server setup
server <- function(input, output, session) {

  cars <- data.frame(
    make = c("Chevrolet", "Chevrolet", "Tesla", "Tesla"),
    model = c("Bolt", "Equinox", "Model S", "Model 3")
  )
  cars$make_lower <- tolower(cars$make)
  cars$model_lower <- tolower(cars$model)

  makes_df <- distinct(cars, make, make_lower)
  makes <- makes_df$make_lower
  names(makes) <- makes_df$make

  sd_question(
    type   = "select",
    id     = "make",
    label  = "Make:",
    option = makes
  )

  observe({
    make_selected_df <- cars[which(input$make == cars$make_lower),]
    models <- make_selected_df$model_lower
    names(models) <- make_selected_df$model

    sd_question(
      type   = "select",
      id     = "model",
      label  = "Model:",
      option = models
    )
  })

  # Database designation and other settings
  sd_server(
    db = db,
    all_questions_required = TRUE
  )
}

# shinyApp() initiates your app - don't change it
shiny::shinyApp(ui = sd_ui(), server = server)
