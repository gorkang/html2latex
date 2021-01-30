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
  file = "TEMP/temp.html")


# Load html2pdf.R function
source("R/html2pdf.R")

# Create tex
html2pdf(filename = "temp.html", table_width = 8, page_width = 8, page_height = 5, build_pdf = TRUE, silent = TRUE)
