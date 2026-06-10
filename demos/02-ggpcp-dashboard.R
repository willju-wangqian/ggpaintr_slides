# Demo 1 — "Present your results": a published ggpcp parallel-coordinate plot
# turned into a Shiny dashboard, with TWO custom placeholders.
#
# Run:  shiny::runApp("demos/01-ggpcp-dashboard.R")   (or paste into an R console)
# Needs: ggpaintr, ggpcp, dplyr, palmerpenguins, shiny, rlang
#
# This is the manuscript's first use case (Section 5.1). Source is verbatim from
# ggpaintr/dev/scripts/screenshots.R.

library(ggpaintr)
library(rlang)        # %||% (base R only ships it from 4.4)
library(shiny)
library(ggpcp)
library(dplyr)
library(palmerpenguins)

# --- custom CONSUMER placeholder: pick several columns at once ----------------
ppVars <- ptr_define_placeholder_consumer(
  keyword = "ppVars",
  build_ui = function(node, cols, data, label = NULL, selected = NULL, ...) {
    retained <- intersect(selected %||% character(0), cols)

    selectizeInput(node$id, label = label %||% "Columns",
                   choices = union(retained, cols), selected = retained, multiple = TRUE,
                   options = list(plugins = list("drag_drop")))

    # selectInput(node$id, label = label %||% "Columns",
    #             choices = cols, selected = retained, multiple = TRUE)
  },
  resolve_expr = function(value, node, ...) {
    if (length(value) == 0L) return(NULL)
    rlang::call2("c", !!!as.list(value))   # c(col1, col2, ...) for pcp_select
  },
  parse_positional_arg = ptr_arg_string(vector = TRUE),
  ui_text_defaults = list(label = "Columns for {param}")
)

# --- custom VALUE placeholder: choose a scaling method ------------------------
ppScaleMethod <- ptr_define_placeholder_value(
  keyword = "ppScaleMethod",
  build_ui = function(node, label = NULL, selected = NULL, ...) {
    choices <- c(
      "Raw (no scaling)"                  = "raw",
      "Standardize (mean / sd)"           = "std",
      "Robust (median / MAD)"             = "robust",
      "Uni min-max (per variable 0..1)"   = "uniminmax",
      "Global min-max (across vars 0..1)" = "globalminmax"
    )
    sel <- if (length(selected) == 1L && nzchar(selected)) selected else "raw"
    selectInput(node$id, label = label %||% "Scaling method",
                choices = choices, selected = sel)
  },
  resolve_expr = function(value, node, ...) {
    if (length(value) != 1L || is.na(value) || !nzchar(value)) return(NULL)
    as.character(value)
  },
  parse_positional_arg = ptr_arg_string(),
  ui_text_defaults = list(label = "Scaling method for {param}")
)

#
# oranges <- c("#FDBF6F", "#F89D38", "#F37A00")
# purples <- c("#CAB2D6", "#9A78B8", "#6A3D9A")
# greens <- c("#b2df8a", "#73C05B", "#33a02c")
#
# cols <-  c(oranges[2], greens[2], purples[2])



# --- one formula -> the whole dashboard --------------------------------------
ptr_app(
  ppUpload(penguins) |>
    ppVerbSwitch(filter(!is.na(sex)), TRUE,
                 label = "Drop rows with missing sex") |>
    pcp_select(
      ppVars(c("bill_depth_mm", "bill_length_mm",
               "flipper_length_mm", "body_mass_g",
               "sex", "species"))) |>
    pcp_scale(method = ppScaleMethod("uniminmax")) |>
    pcp_arrange() |>
    ggplot(aes_pcp()) +
    geom_pcp_axes() +
    geom_pcp(aes(colour = ppVar(species)),
             alpha = ppNum(0.8), overplot = "none") +
    geom_pcp_labels()
)
