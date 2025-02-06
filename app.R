# Install required packages:
# install.packages("pak")
# pak::pak('surveydown-dev/surveydown') # Development version from github

# Load packages
library(surveydown)
library(tidyverse)

# Set up car options

cars <- mpg %>%
  distinct(make = manufacturer, model) %>%
  mutate(
    make = str_to_title(make),
    model = str_to_title(model)
  )

# sd_db_config()
db <- sd_db_connect(ignore = TRUE)

# Server setup
server <- function(input, output, session) {

  makes <- unique(cars$make)
  names(makes) <- makes

  sd_question(
    type   = "select",
    id     = "make",
    label  = "Make:",
    option = makes
  )

  observe({
    make_selected_df <- cars[which(input$make == cars$make),]
    models <- make_selected_df$model
    names(models) <- models

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
