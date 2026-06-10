# Demo 2 — "Explore your data": scan pairs of iris variables (x / y / color).
#
# Run:  shiny::runApp("demos/02-iris-explore.R")
# Needs: ggpaintr, shiny
#
# Compare against demos/04-iris-handwritten-shiny.R, which builds the SAME app
# by hand (56 lines of ui + server wiring). Here it is one formula.

library(ggpaintr)

ptr_app(
  ggplot(iris, aes(x = ppVar(Sepal.Length),
                   y = ppVar(Sepal.Width),
                   color = ppVar(Species))) +
    geom_point()
)
