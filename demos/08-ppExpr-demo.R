library(ggpaintr)

{
  iris |>
    filter(ppExpr(Sepal.Length > 6)) |>
    ggplot(aes(x = Sepal.Length, y = Sepal.Width)) +
    geom_point() +
    facet_grid(ppExpr(. ~ Species))
} |>
  ptr_app()
