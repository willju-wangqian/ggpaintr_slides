library(ggpaintr)
library(rlang)        # %||% (base R only ships it from 4.4)
library(shiny)
library(ggpcp)
library(tidyverse)
library(palmerpenguins)

# ptr_options(gate_draw = FALSE)

do_pca <- function(d, cols) {
  broom::augment(prcomp(d[, cols], scale. = TRUE), d)
}

ppUpload(iris) |>
  ppVerbSwitch(drop_na(), FALSE) |>
  do_pca(ppVars(c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"))) |>
  ggplot(aes(ppVar(.fittedPC1), ppVar(.fittedPC2), color = ppVar(Species))) +
  stat_ellipse(level = 0.95, linewidth = 0.8) +
  geom_point(alpha = 0.8, size = 2) +
  scale_color_brewer(palette = "Dark2") +
  labs(title = "Iris in PC space, with 95% ellipses",
       x = "PC1", y = "PC2") +
  theme_minimal() +
  theme(legend.position = "bottom")


# --- custom CONSUMER placeholder: pick several columns at once ----------------
ppVars <- ptr_define_placeholder_consumer(
  keyword = "ppVars",
  build_ui = function(node, cols, data, label = NULL, selected = NULL, ...) {
    retained <- intersect(selected %||% character(0), cols)
    selectInput(node$id, label = label %||% "Columns",
                choices = cols, selected = retained, multiple = TRUE)
  },
  resolve_expr = function(value, node, ...) {
    if (length(value) == 0L) return(NULL)
    rlang::call2("c", !!!as.list(value))   # c(col1, col2, ...) for pcp_select
  },
  parse_positional_arg = ptr_arg_string(vector = TRUE),
  ui_text_defaults = list(label = "Columns for {param}")
)


{ppUpload(iris) |>
    ppVerbSwitch(drop_na(), FALSE) |>
    do_pca(ppVars(c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"))) |>
    ggplot(aes(ppVar(.fittedPC1), ppVar(.fittedPC2), color = ppVar(Species))) +
    stat_ellipse(level = 0.95, linewidth = 0.8) +
    geom_point(alpha = 0.8, size = 2) +
    scale_color_brewer(palette = "Dark2") +
    labs(title = "Iris in PC space, with 95% ellipses",
         x = "PC1", y = "PC2") +
    theme_minimal() +
    theme(legend.position = "bottom")} |>
  ptr_app()
