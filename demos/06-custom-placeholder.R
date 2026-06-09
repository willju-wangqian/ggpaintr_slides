# Demo 6 — the smallest possible CUSTOM placeholder.
# A new value placeholder `ppPercent`: a 0-100 slider whose value is divided
# by 100 before it is spliced back into the formula. Once registered it behaves
# exactly like a built-in -- parsed into a node, substituted at draw time, and
# echoed in the code panel -- with no extra wiring.
#
# Run:  shiny::runApp("demos/06-custom-placeholder.R")
# Needs: ggpaintr, shiny, palmerpenguins

library(ggpaintr)
library(shiny)
library(rlang)            # %||% (base R only ships it from 4.4)
library(palmerpenguins)

ppPercent <- ptr_define_placeholder_value(
  keyword = "ppPercent",
  build_ui = function(node, label = NULL, selected = NULL, ...) {
    val <- if (length(selected) == 1L && !is.na(selected)) selected * 100 else 80
    sliderInput(node$id, label = label %||% "Percent",
                min = 0, max = 100, value = val, step = 5)
  },
  resolve_expr = function(value, node, ...) {
    if (length(value) != 1L || is.na(value)) return(NULL)
    as.numeric(value) / 100          # the literal spliced into the formula
  },
  parse_positional_arg = ptr_arg_numeric(),
  ui_text_defaults = list(label = "Percent for {param}")
)

ptr_app(
  ggplot(penguins, aes(flipper_length_mm, body_mass_g, color = ppVar(species))) +
    geom_point(alpha = ppPercent(0.8))     # the slider drives point transparency
)
