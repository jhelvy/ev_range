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
    make_label = c("Chevrolet", "Chevrolet", "Tesla", "Tesla"),
    model_label = c("Bolt", "Equinox", "Model S", "Model 3")
  )
  cars$make_value <- tolower(cars$make_label)
  cars$model_value <- tolower(cars$model_label)

  makes_df <- distinct(cars, make_label, make_value)
  makes <- makes_df$make_value
  names(makes) <- makes_df$make_label

  sd_question(
    type   = "select",
    id     = "make",
    label  = "Make:",
    option = makes
  )

  observe({
    make_selected_df <- cars[which(input$make == cars$make_value),]
    models <- make_selected_df$model_value
    names(models) <- make_selected_df$model_label

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
