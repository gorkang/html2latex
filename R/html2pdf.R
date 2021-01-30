#' html2pdf
#' 
#' Convert jsPlot::tab_model() html tables to tex and pdf (https://github.com/gorkang/html2latex/)
#'
#' @param filename Name of the .html jsPlot::tab_model() table
#' @param table_width With of the table
#' @param build_pdf TRUE/FALSE
#' @param clean_up TRUE/FALSE
#' @param silent TRUE/FALSE
#' @param path_w2l Path to the Writer2latex files
#' @param page_width In inches
#' @param page_height In inches 
#'
#' @return
#' @export
#'
#' @examples
html2pdf <-
  function(filename,
           table_width = 30,
           page_width = 8.5,
           page_height = 11,
           build_pdf = TRUE,
           clean_up = TRUE,
           silent = TRUE,
           path_w2l = ".") {
    

  # DEBUG
  # filename = "TEMP/temp.html"
  # table_width = 30
  # page_width = 8.5
  # build_pdf = TRUE
  # clean_up = TRUE
  # silent = TRUE
  # path_w2l = "."
  
  # Find w2l files
  w2l_file = list.files(path = path_w2l, pattern = "w2l$", recursive = TRUE)
  if (length(w2l_file) == 0) stop("Writer2latex not found in folder: '", path_w2l, "'\n",
                                  "You can use the parameter 'path_w2l' to tell me where Writer2latex is, or: \n\n",
                                  " 1. Download: https://sourceforge.net/projects/writer2latex/files/writer2latex/Writer2LaTeX%201.6/ \n",
                                  " 2. Extract 'w2l' and 'writer2latex.jar' to a folder in the project where this function is called \n",
                                  " 3. chmod +x w2l (see http://writer2latex.sourceforge.net/doc1.6/user-manual10.html)")
  
  
  # Necessary to run soffice command in Ubuntu 20.04
  Sys.setenv(LD_LIBRARY_PATH = "/usr/lib/libreoffice/program/")  
  
  # Location of files
  odt_file = gsub("html$", "odt", paste0(getwd(), "/", basename(filename))) # Location of generated odt file
  tex_file = gsub("html$", "tex", paste0(getwd(), "/", basename(filename))) # Location of generated tex file
  pdf_file = gsub("html$", "pdf", paste0(getwd(), "/", basename(filename))) # Location of generated pdf file
  
  # Output files
  tex_file_output = gsub("html$", "tex", paste0(getwd(), "/", filename))
  pdf_file_output = gsub("html$", "pdf", paste0(getwd(), "/", filename))
  
  
  if (silent == TRUE) {
    invisible(system(paste0('soffice --convert-to odt ', filename), intern = TRUE)) # HTML to ODT
    invisible(system(paste0("./", w2l_file, " ", odt_file), intern = TRUE))  # ODT to TEX
  } else {
    system(paste0('soffice --convert-to odt ', filename))
    system(paste0("./", w2l_file, " ", odt_file))
  }
  
  
  # Minimal improvements to format
  
  # Get rid of linejumps
  raw_file = readLines(tex_file)
  clean_file = gsub("\\\\newline", "", raw_file)
  
  # Replace supertabular by longtable (so we can control the width of the table and the columns will adjust automagically)
  supertabular_line_n1 = grep("begin\\{supertabular\\}", clean_file)
  supertabular_line_n2 = grep("\\usepackage\\{supertabular\\}", clean_file)
  document_class_line = grep("\\\\documentclass\\[letterpaper\\]\\{article\\}", clean_file)
  supertabular_line = clean_file[supertabular_line_n1]
  
  number_columns = stringr::str_count(supertabular_line, "m\\{") - 1
  longtable_line = paste0("\\begin{longtable}{p{", table_width, "em}l", paste(rep("c", number_columns), collapse = "") , "}") # Table width
  clean_file[supertabular_line_n1] = longtable_line
  clean_file = append(clean_file, "\\usepackage{longtable}", after = supertabular_line_n2)
  clean_file = append(clean_file, paste0("\\usepackage[paperheight=", page_height, "in,paperwidth=", page_width, "in]{geometry}"), after = document_class_line) # Page width
  
  clean_file = gsub("\\\\end\\{supertabular\\}", "\\\\end\\{longtable\\}", clean_file)
  
  # Write re-formatted version
  writeLines(clean_file, tex_file)
  
  # Build pdf to check
  if (build_pdf == TRUE) {
    
    if (silent == TRUE) {
      invisible(system(paste0("pdflatex ", tex_file), intern = TRUE))
    } else {
      system(paste0("pdflatex ", tex_file))
    }
    
    if (filename != basename(filename)) file.copy(pdf_file, pdf_file_output, overwrite = TRUE)
    message("\npdf file created in: ", pdf_file_output)
    
    # Clean up latex debris
    if (clean_up == TRUE) {
      file.remove(gsub("html", "out", basename(filename)))
      file.remove(gsub("html", "aux", basename(filename)))
      file.remove(gsub("html", "log", basename(filename)))
      if (filename != basename(filename)) file.remove(gsub("html", "pdf", basename(filename)))
    }
    
  }
  
  
  # Clean up odt
  if (clean_up == TRUE) {
    file.remove(gsub("html", "odt", basename(filename)))
  }
  
  if (filename != basename(filename)) file.copy(tex_file, tex_file_output, overwrite = TRUE)
  if (filename != basename(filename)) file.remove(gsub("html", "tex", basename(filename)))
  message("\ntex file created in: ", tex_file_output)
}
