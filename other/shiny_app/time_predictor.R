library(shiny)
library(here)
library(readr)
library(shinyjs)

# Load model and data (update paths as needed)
finisher_model <- readRDS(here::here("models/finisher_model.rds"))
model_data <- read_parquet(here::here("data/analysis_data/model_data.parquet"))

# Extract IAAF categories from the dataset
iaaf_categories <- sort(unique(model_data$iaaf_category)) # Sort IAAF categories alphabetically


# Define UI
ui <- fluidPage(
  useShinyjs(), # Initialize shinyjs for JavaScript functionality
  titlePanel("Marathon Time Prediction"),
  sidebarLayout(
    sidebarPanel(
      numericInput("age", "Age:", value = 30),

      # Replace selectInput with selectizeInput for performance improvement
      selectizeInput("gender", "Gender:", choices = c("Male", "Female"), options = list(create = FALSE)),
      numericInput("races_count", "Number of Races:", min = 0, value = 5),

      # Replace selectInput with selectizeInput for performance improvement
      selectizeInput("iaaf_category", "IAAF Category:", choices = iaaf_categories, options = list(create = FALSE)),
      actionButton("predict", "Predict Time")
    ),
    mainPanel(
      verbatimTextOutput("prediction_output"),
      # Add the loading bar UI element
      div(id = "loading", style = "display: none;", "Loading... Please wait")
    )
  )
)

# Define server logic
server <- function(input, output) {
  # Reactive function to make prediction
  observeEvent(input$predict, {
    # Show the loading message
    shinyjs::show("loading")

    # Collect the input data
    input_data <- data.frame(
      age = as.numeric(input$age),
      gender = factor(input$gender, levels = c("Male", "Female")), # Ensure gender is a factor
      races_count = as.numeric(input$races_count),
      iaaf_category = input$iaaf_category
    )

    # Predict the marathon time using the model
    prediction <- predict(finisher_model, newdata = input_data)

    # Convert seconds to hours, minutes, and seconds
    hours <- floor(prediction / 3600)
    minutes <- floor((prediction %% 3600) / 60)
    seconds <- round(prediction %% 60)

    # Format the predicted time as a more readable string
    formatted_time <- paste(hours, "hours", minutes, "minutes", seconds, "seconds")

    # Display the formatted predicted time
    output$prediction_output <- renderText({
      paste("Predicted Finishing Time: ", formatted_time)
    })

    # Hide the loading message after prediction is done
    shinyjs::hide("loading")
  })
}

# Run the application
shinyApp(ui = ui, server = server)
