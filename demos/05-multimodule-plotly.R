# Demo 5 — embedding in a calling app: two coordinated modules in one session.
#   * one SHARED species picker drives the color of BOTH panels
#   * the "body" panel uses ggpaintr's default output
#   * the "bill" panel is rendered through the calling app's OWN plotly output
#
# (Manuscript Section 5.2.) Source verbatim from
# ggpaintr/dev/scripts/screenshots.R.
#
# Run:  shiny::runApp("demos/05-multimodule-plotly.R")
# Needs: ggpaintr, plotly, palmerpenguins, shiny, rlang

library(shiny)
library(ggpaintr)
library(plotly)
library(palmerpenguins)
library(rlang)            # expr()

# two formulas, stored as quoted expressions so several can live in one list;
# both carry the SAME shared key "grp" on the color aesthetic
plots <- list(
  expr(ggplot(penguins, aes(x = ppVar(flipper_length_mm),
                            y = ppVar(body_mass_g),
                            color = ppVar(species, shared = "grp"))) +
         geom_point(alpha = 0.7)),
  expr(ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm,
                            color = ppVar(species, shared = "grp"))) +
         geom_point(alpha = 0.7))
)

obj <- ptr_shared(plots)            # build the coordinator once

ui <- fluidPage(
  titlePanel("Penguins, two views"),
  ptr_shared_panel(obj),            # the single shared species picker
  fluidRow(
    column(6, ptr_ui(plots[[1]], "body", shared = obj)),               # default output
    column(6, ptr_ui_controls(plots[[2]], "bill", shared = obj),       # controls only ...
           plotly::plotlyOutput(NS("bill")("scatter")))                # ... + our own plotly
  )
)

server <- function(input, output, session) {
  sh <- ptr_shared_server(obj)                                  # drive the shared control
  ptr_server(plots[[1]], "body", shared_state = sh)             # default render path
  state <- ptr_server(plots[[2]], "bill", shared_state = sh)    # we own the render path

  output[[NS("bill")("scatter")]] <- plotly::renderPlotly({
    res <- state$runtime()                                      # read the runtime state
    shiny::req(isTRUE(res$ok), res$plot)
    plotly::ggplotly(res$plot)                                  # add our own interactivity
  })
}

shinyApp(ui, server)
