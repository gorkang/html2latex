#' tex2Rmd
#' @description extracts the table code
#'    (from `\begin{longtable}` to `\end{longtable}`)
#'    from the Tex file which is
#'    generated with [html2pdf]
#' @name html2pdf
#' @param filename TeX file to read
#' @return txt file
#' @export
tex2Rmd <- function(filename, output_file = "table.txt") {
  # filename = "temp.tex"
  raw_file = readLines(filename)

  begin_longtable = grep("begin\\{longtable\\}", raw_file)
  end_longtable = grep("end\\{longtable\\}", raw_file)

  table_code = raw_file[begin_longtable:end_longtable]
  writeLines(table_code, con = output_file)
  message("\nFile with table code created in: ", output_file)

}
