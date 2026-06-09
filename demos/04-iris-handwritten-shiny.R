# Demo 4 — the SAME iris exploration, written as a hand-coded Shiny app.
# This is the "cost" side of the motivation: every control is named twice
# (UI + server), column names must be indirected with .data[[input$...]],
# the plot is declared on both sides, and each optional layer needs its own
# if-branch. 56 lines, and each new control multiplies the work.
#
# (Manuscript Appendix Listing A3 -- iris-3.)
#
# Run:  shiny::runApp("demos/04-iris-handwritten-shiny.R")
# Needs: shiny, ggplot2

library(shiny)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Iris scatter"),
  sidebarLayout(
    sidebarPanel(
      selectInput("x", "X variable",
                  choices = names(iris)[1:4], selected = "Sepal.Length"),
      selectInput("y", "Y variable",
                  choices = names(iris)[1:4], selected = "Sepal.Width"),
      selectInput("color", "Color variable",
                  choices = names(iris), selected = "Species"),
      selectInput("facet", "Facet by",
                  choices = c("None" = "", names(iris)), selected = ""),
      selectInput("smooth_method", "Smoothing method",
                  choices = c("None" = "", "lm", "loess", "gam", "glm"),
                  selected = ""),
      textInput("title", "Plot title", value = "Iris scatter"),
      actionButton("draw", "Draw", class = "btn-primary")
    ),
    mainPanel(plotOutput("plot"))
  )
)

server <- function(input, output, session) {
  plot_data <- eventReactive(input$draw, {
    list(
      x = input$x, y = input$y, color = input$color,
      facet = input$facet, smooth_method = input$smooth_method,
      title = input$title
    )
  }, ignoreNULL = FALSE)

  output$plot <- renderPlot({
    p <- plot_data()
    g <- ggplot(iris, aes(x = .data[[p$x]],
                          y = .data[[p$y]],
                          color = .data[[p$color]])) +
      geom_point() +
      labs(title = p$title)

    if (nzchar(p$smooth_method)) {
      g <- g + geom_smooth(method = p$smooth_method)
    }
    if (nzchar(p$facet)) {
      g <- g + facet_wrap(vars(.data[[p$facet]]))
    }
    g
  })
}

shinyApp(ui, server)
