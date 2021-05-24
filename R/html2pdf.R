#' html2pdf
#' @description Convert [sjPlot::tab_model()] html tables to tex and pdf
#' @name html2pdf
#' @param filename Name of the sjPlot table object
#' @param build_pdf TRUE/FALSE
#' @param clean TRUE/FALSE clean intermediate files
#' @param silent TRUE/FALSE
#' @param path_w2l Path to the Writer2latex files
#' @param OS String identifying operating system (Linux, macOS or Windows)
#' @param table_width Width of the table
#' @param page_width In inches
#' @param page_height In inches
#' @param style makes table somewhat prettier
#' @return TeX file
#' @export
#'
#' @examples
#' \dontrun{
#' model = lmer(mpg ~ cyl * disp + (1|vs), mtcars)
#'
#' # We save the sjPlot table to an .html file
#' sjPlot::tab_model(
#'   model,
#'   show.r2 = TRUE,
#'   show.icc = FALSE,
#'   show.re.var = FALSE,
#'   p.style = "scientific",
#'   emph.p = TRUE,
#'   file = "temp.html")
#'
#' # Create tex and pdf
#' html2pdf(filename = "temp.html", table_width = 13, silent = TRUE,
#'           style = TRUE, build_pdf = TRUE, clean = TRUE)
#' }

html2pdf <-
  function(filename,
           table_width = 30,
           page_width = 8.5,
           page_height = 11,
           build_pdf = FALSE,
           clean = FALSE,
           style = TRUE,
           silent = TRUE,
           # mac = FALSE,
           OS = NULL,
           path_w2l = NULL) {

    if (is.null(path_w2l)) {
      path_w2l <- system.file("extdata", package = "html2latex")
    }

    # Find w2l files
    w2l_file <- list.files(path = path_w2l, pattern = "w2l", recursive = TRUE)

    if (length(w2l_file) == 0) {
      stop(
        "Writer2latex not found in folder: '", path_w2l, "'\n",
        "You can use the parameter 'path_w2l' to tell me where Writer2latex is, or: \n\n",
        " 1. Download: https://sourceforge.net/projects/writer2latex/files/writer2latex/Writer2LaTeX%201.6/ \n",
        " 2. Extract 'w2l' and 'writer2latex.jar' to a folder in the project where this function is called \n",
        " 3. chmod +x w2l (see http://writer2latex.sourceforge.net/doc1.6/user-manual10.html)"
      )
    }

    # Operative system detection
    if (is.null(OS)) OS = Sys.info()["sysname"]

    if (OS == "Linux") {
      # Necessary to run soffice command in Ubuntu 20.04
      Sys.setenv(LD_LIBRARY_PATH = "/usr/lib/libreoffice/program/")
      soffice <- "soffice"

    } else if (OS == "Windows") {
      soffice <- "C:\\Program Files\\LibreOffice\\program\\soffice.bin"
      if (!file.exists(soffice)) stop("Did not locate Libreoffice in C:\\Program Files\\LibreOffice\\program\\soffice.bin")
      if (!grepl("\\.bat", w2l_file)) w2l_file = paste0(w2l_file, ".bat")

    } else if (OS == "Darwin" | OS == "macOS") {
      soffice <- "/Applications/LibreOffice.app/Contents/MacOS/soffice"

    } else {
      stop("Not sure about your operative system. Use the parameter 'OS' with either 'Linux', 'macOS' or 'Windows'")
    }



    # Location of files
    odt_file <- gsub("html$", "odt", paste0(getwd(), "/", basename(filename))) # Location of generated odt file
    tex_file <- gsub("html$", "tex", paste0(getwd(), "/", basename(filename))) # Location of generated tex file
    pdf_file <- gsub("html$", "pdf", paste0(getwd(), "/", basename(filename))) # Location of generated pdf file

    # Output files
    tex_file_output <- gsub("html$", "tex", paste0(getwd(), "/", filename))
    pdf_file_output <- gsub("html$", "pdf", paste0(getwd(), "/", filename))

    if (silent) {
      # invisible(system(paste(soffice, "--convert-to odt", filename), intern = TRUE)) # HTML to ODT
      invisible(system2(soffice, paste0("--convert-to odt ", filename), intern = TRUE)) # HTML to ODT
      # invisible(system(paste0(file.path(path_w2l, w2l_file), " ", odt_file), intern = TRUE))  # ODT to TEX
      invisible(system2(paste0(file.path(path_w2l, w2l_file), " ", odt_file), intern = TRUE))  # ODT to TEX
    } else {
      # system(paste(soffice, "--convert-to odt", filename))
      system2(soffice, paste0("--convert-to odt ", filename))  # HTML to ODT
      # system(paste0(file.path(path_w2l, w2l_file), " ", odt_file)) # ODT to TEX
      system2(paste0(file.path(path_w2l, w2l_file)), odt_file) # ODT to TEX
    }

    if (style) {
      clean_tex(tex_file_output, table_width = table_width,
                page_width = page_width, page_height = page_height)
    }
    if (build_pdf) {
      build_PDF(tex_file_output, silent = silent, filename = filename,
                pdf_file = pdf_file, pdf_file_output = pdf_file_output)
    }
    if (clean) {
      clean_debris(filename)
    }
    if (filename != basename(filename)) file.copy(tex_file, tex_file_output, overwrite = TRUE)
    if (filename != basename(filename)) file.remove(gsub("html", "tex", basename(filename)))
    message("\ntex file created in: ", tex_file_output)
  }


#' Minimal improvements to format
#' @name clean_tex
#' @param file TeX file
#' @param table_width With of the table
#' @param page_width In inches
#' @param page_height In inches
#' @keywords internal
#' @importFrom stringr str_count
#' @return TeX file
clean_tex <- function(file, table_width, page_width, page_height) {
  # Get rid of linejumps
  raw_file <- readLines(file)
  clean_file <- gsub("\\\\newline", "", raw_file)
  # Replace supertabular by longtable (so we can control the width of the table and the columns will adjust automagically)
  supertabular_line_n1 <- grep("begin\\{supertabular\\}", clean_file)
  supertabular_line_n2 <- grep("\\usepackage\\{supertabular\\}", clean_file)
  document_class_line <- grep("documentclass", clean_file)
  supertabular_line <- clean_file[supertabular_line_n1]

  number_columns <- stringr::str_count(supertabular_line, "m\\{") - 1
  longtable_line <- paste0("\\begin{longtable}{p{", table_width, "em}l", paste(rep("c", number_columns), collapse = ""), "}") # Table width
  clean_file[supertabular_line_n1] <- longtable_line
  clean_file <- append(clean_file, "\\usepackage{longtable}", after = supertabular_line_n2)
  clean_file <- append(clean_file, paste0("\\usepackage[paperheight=", page_height, "in,paperwidth=", page_width, "in]{geometry}"), after = document_class_line) # Page width

  clean_file <- gsub("\\\\end\\{supertabular\\}", "\\\\end\\{longtable\\}", clean_file)

  # Write re-formatted version
  writeLines(clean_file, file)
}


#' Build pdf to check
#' @name build_pdf
#' @param file TeX file
#' @keywords internal
#' @return pdf file
build_PDF <- function(file, silent, pdf_file, pdf_file_output, filename){

  if (silent) {
    invisible(system(paste0("pdflatex ", file), intern = TRUE))
  } else {
    system(paste0("pdflatex ", file))
  }

  if (filename != basename(filename)) file.copy(pdf_file, pdf_file_output, overwrite = TRUE)
  message("\npdf file created in: ", pdf_file_output)
}

#' Clean up latex debris
#' @name clean_debris
#' @param filename file path to clean up
#' @keywords internal
#' @return pdf file
clean_debris <- function(filename) {
  file.remove(gsub("html", "out", basename(filename)))
  file.remove(gsub("html", "aux", basename(filename)))
  file.remove(gsub("html", "log", basename(filename)))
  if (filename != basename(filename)) file.remove(gsub("html", "pdf", basename(filename)))
  # Clean up odt
  file.remove(gsub("html", "odt", basename(filename)))
}
