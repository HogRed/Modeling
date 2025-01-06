# Check and install required packages if not already installed
required_packages <- c("shiny", "DT", "shinythemes")
missing_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(missing_packages)) {
  install.packages(missing_packages)
}

# Load libraries
invisible(lapply(required_packages, library, character.only = TRUE))

# Define the UI for the application
ui <- fluidPage(
  theme = shinythemes::shinytheme("darkly"),  # Apply a dark theme to the app
  titlePanel("The Power (Force) of Shiny Dashboards"),  # Set the title of the app
  
  # Add custom CSS to style the data table with a white background
  tags$head(
    tags$style(HTML("
                    .dataTables_wrapper {
                      background-color: white;  # Set the background of the table to white
                      color: black;  # Set the text color to black
                      border: 1px solid #ccc;  # Add a border around the table
                      border-radius: 4px;  # Round the corners of the table
                      padding: 10px;  # Add padding around the table
                    }
                    "))
  ),
  
  # Create a tabbed layout for the app
  tabsetPanel(
    tabPanel(
      "Galactic Hub",  # Title of the first tab
      sidebarLayout(
        sidebarPanel(
          h3("Harness the Force"),  # Header for the sidebar
          numericInput("num", "Enter a number:", value = 1, min = 1),  # Input for entering a number
          actionButton("surprise", "Get a Star Wars Quote!"),  # Button to display a random quote
          h3(''), # Spacing
          img(src = "https://upload.wikimedia.org/wikipedia/commons/6/6c/Star_Wars_Logo.svg", 
              alt = "Star Wars Logo", width = "100%")  # Add a Star Wars logo image
        ),
        mainPanel(
          h4("Calculated Power"),  # Header for the calculated power output
          verbatimTextOutput("result"),  # Display the calculated power result
          h4("Galactic Plot"),  # Header for the plot
          plotOutput("plot"),  # Display the plot
          h4("Your Quote:"),  # Header for the random quote output
          verbatimTextOutput("quote")  # Display the random quote
        )
      )
    ),
    tabPanel(
      "Planet Explorer",  # Title of the second tab
      sidebarLayout(
        sidebarPanel(
          h3("Explore the Galaxy"),  # Header for the sidebar
          checkboxInput("show_planets", "Show Planets", value = TRUE)  # Checkbox to toggle the table
        ),
        mainPanel(
          DTOutput("data_table")  # Display the interactive data table
        )
      )
    )
  )
)

# Define the server logic for the application
server <- function(input, output, session) {
  
  # Reactive calculation: Compute the square of the entered number
  output$result <- renderText({
    paste("The square of", input$num, "is", input$num^2)
  })
  
  # Render a plot: Display numbers and their squares
  output$plot <- renderPlot({
    x <- seq(1, input$num)  # Generate a sequence of numbers from 1 to the input
    y <- x^2  # Compute the square of each number
    plot(x, y, type = "b", pch = 19, col = "gold", 
         main = "Harnessing the Power of Numbers", xlab = "Number", 
         ylab = "Power", bg = "black")
  })
  
  # Display a random Star Wars quote when the button is clicked
  quotes <- c(
    "Do or do not. There is no try. - Yoda",
    "The Force will be with you. Always. - Obi-Wan Kenobi",
    "In my experience, there's no such thing as luck. - Han Solo"
  )
  output$quote <- renderText({
    if (input$surprise > 0) {  # Check if the button has been clicked
      sample(quotes, 1)  # Randomly select a quote
    } else {
      "Press the button for a quote!"  # Default message
    }
  })
  
  # Render a data table: Display Star Wars planet data
  star_wars_data <- data.frame(
    Planet = c("Tatooine", "Alderaan", "Naboo", "Coruscant", "Hoth"),
    Climate = c("Arid", "Temperate", "Temperate", "Urban", "Frozen"),
    Population = c(200000, 2000000000, 4500000000, 1000000000, "Unknown")
  )
  output$data_table <- renderDT({
    if (input$show_planets) {  # Check if the checkbox is selected
      datatable(star_wars_data, options = list(pageLength = 5), class = "display compact")  # Display the table
    } else {
      datatable(data.frame(Message = "Check 'Show Planets' to hide this table."))  # Display a message
    }
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)