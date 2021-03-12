<!-- README.md is generated from README.Rmd. Please edit that file -->

# html2latex

<!-- badges: start -->

<!-- badges: end -->

Convert `sjPlot::tab_model()` html tables to tex and pdf.

## Installation

html2latex is currently only available on Github.

``` r
# remotes::install_github("gorkang/html2latex")
library("html2latex")
```

## Requirements

We use [Libreoffice](https://www.libreoffice.org/) to convert `html` to `odt` and [Writer2latex](https://sourceforge.net/projects/writer2latex/files/writer2latex/) for the `odt` to `tex` step. You will also need a TeX compiler if you want to use the integrated pdf compilation.

`html2pdf()` function uses a *Writer2latex* script which is sourced from the src folder.

## Example

Create a `sjPlot::tab_model()` and save it as html.

``` r
library(html2latex)
library(lme4)
library(sjPlot)

# This is a terrible model
model = lmer(mpg ~ cyl * disp + (1|vs), mtcars)

# We save the sjPlot table to an .html file
sjPlot::tab_model(
  model,
  show.r2 = TRUE,
  show.icc = FALSE,
  show.re.var = FALSE,
  p.style = "scientific",
  emph.p = TRUE,
  file = "temp.html")
```

![](img/sjplot.png)


---  

Using the `html2pdf()` we can transform the html output of `sjPlot::tab_model()` to .tex. We can also compile to pdf in one step.


``` r

html2pdf(
  filename = "temp.html",
  table_width = 13,
  silent = TRUE,
  style = TRUE,
  build_pdf = TRUE,
  clean = TRUE
)
```

The end result looks like this:

![](img/html2latex.png)
