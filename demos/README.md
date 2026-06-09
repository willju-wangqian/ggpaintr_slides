# Demo apps for the ggpaintr talk

Each file is a self-contained, runnable Shiny app. Launch from the
`ggpaintr_slides/` directory:

```r
shiny::runApp("demos/01-ggpcp-dashboard.R")
```

| # | File | Slide / scenario | Extra packages |
|---|------|------------------|----------------|
| 1 | `01-ggpcp-dashboard.R` | Motivation — *present results*; also the custom-placeholder example | ggpcp, dplyr, palmerpenguins, rlang |
| 2 | `02-iris-explore.R` | Motivation — *explore data* (the ggpaintr version) | — |
| 3 | `03-penguins-demo.R` | "Demo with penguins data" (headline live demo) | dplyr, palmerpenguins |
| 4 | `04-iris-handwritten-shiny.R` | Motivation — the hand-written Shiny cost | ggplot2 |
| 5 | `05-multimodule-plotly.R` | Extensibility — embed, multi-instance, shared, own plotly render | plotly, palmerpenguins, rlang |
| 6 | `06-custom-placeholder.R` | Extensibility — minimal custom placeholder | rlang, palmerpenguins |

## Setup

```r
install.packages(c("shiny", "ggplot2", "dplyr", "palmerpenguins",
                   "plotly", "rlang"))
# ggpcp may be on GitHub: remotes::install_github("yaweige/ggpcp")
# ggpaintr: install your working copy, or load it in development with
#   pkgload::load_all("~/Research/ggpaintr")
# before runApp(), then drop the `library(ggpaintr)` line.
```

All demo code is taken verbatim from the manuscript and from
`ggpaintr/dev/scripts/screenshots.R`, so what runs here matches the listings on
the slides.
