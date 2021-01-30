# html2latex

Convert sjPlot::tab_model() html tables to tex and pdf.  

You will also find an example.Rmd showing how to use a sjPlot::tab_model() html table inside a Rmd document that renders as a pdf.  


We use [Libreoffice](https://www.libreoffice.org/) and [Writer2latex](https://sourceforge.net/projects/writer2latex/files/writer2latex/). To use the `html2pdf()` function you need to download the R and src folders. They contain the actual funcions and main source files from Writer2latex respectively.   


## Example  

Create a sjPlot::tab_model() and save it as html.  

```
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

The html table will look like this:  

![](img/sjplot.png)


--- 


Using the `html2pdf()` we can transform it to .tex.  


```
# Load html2pdf.R function
source("R/html2pdf.R")

# Create tex and pdf
html2pdf(filename = "temp.html", page_width = 13, build_pdf = TRUE, silent = TRUE)

```

If we create a pdf using `pdflatex` the end result looks like this:  

![](img/html2latex.png)