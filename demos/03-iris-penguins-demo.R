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
  ggplot(
    ppUpload(iris),
    aes(
      x = ppVar(Sepal.Length),
      y = ppVar(Sepal.Width),
      color = ppVar(Species))) +
    geom_point() +
    facet_wrap(~ ppVar(Species)) +
    geom_smooth(method = ppText("lm")) +
    labs(title = ppText("Iris app"))
)
