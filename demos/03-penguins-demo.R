# Demo 3 — the headline live demo on the palmerpenguins data.
#
# Run:  shiny::runApp("demos/03-penguins-demo.R")
# Needs: ggpaintr, dplyr, palmerpenguins, shiny
#
# Exercises every value/consumer role at once:
#   - ppVar    x / y / color column pickers, and an OPTIONAL facet picker
#              (blank by default -> facet_wrap is pruned away)
#   - ppNum    point size and transparency
#   - ppText   smoothing method (type "lm", "loess", ...) and the title
#   - layer checkboxes for geom_smooth (toggle the trend line on/off)

library(ggpaintr)
library(dplyr)
library(palmerpenguins)

ptr_app(
  penguins |>
    filter(!is.na(sex)) |>
    ggplot(aes(x = ppVar(flipper_length_mm),
               y = ppVar(body_mass_g),
               color = ppVar(species))) +
    geom_point(size = ppNum(2), alpha = ppNum(0.8)) +
    geom_smooth(method = ppText("lm")) +
    facet_wrap(~ ppVar) +
    labs(title = ppText("Palmer penguins"))
)
