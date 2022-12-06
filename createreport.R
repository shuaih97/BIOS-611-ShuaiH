library(pandoc)
library(rmarkdown)
rmarkdown::render("report.Rmd",output_format="pdf_document")
