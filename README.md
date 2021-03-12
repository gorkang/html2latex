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

<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm;  text-align:left; ">
 
</th>
<th colspan="3" style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm; ">
mpg
</th>
</tr>
<tr>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  text-align:left; ">
Predictors
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
Estimates
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
CI
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
p
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
(Intercept)
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
49.04
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
39.23 – 58.85
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
<strong>1.144e-22</strong>
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
cyl
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-3.41
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-5.05 – -1.76
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
<strong>5.058e-05</strong>
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
disp
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-0.15
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-0.22 – -0.07
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
<strong>2.748e-04</strong>
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
cyl \* disp
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.02
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.01 – 0.03
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
<strong>1.354e-03</strong>
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
N <sub>vs</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
2
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm; border-top:1px solid;">
Observations
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left; border-top:1px solid;" colspan="3">
32
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
Marginal R<sup>2</sup> / Conditional R<sup>2</sup>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.809 / NA
</td>
</tr>
</table>

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
