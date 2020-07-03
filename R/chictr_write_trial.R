#' Download a trial as an XML
#'
#' Takes the URL of a specific trial, and downloads the available data as an
#'     XML.
#'
#' @param trial_url The URL of a specific trial as a string.
#' @param path The path to the directory in which the file should be saved. Use
#'     NULL to save in the current directory (default).
#' @param ... Additional arguments to be passed to `xml2::write_xml`.
#' @return The study record as an XML file saved at the designed path.
#' @examples
#' \dontrun{
#' # Copy-paste the trial URL from the ChiCTR.org.cn website
#' trial_url <- "http://www.chictr.org.cn/showprojen.aspx?proj=55654"
#' # Extract the fields of interest
#' chictr_write_trial(trial_url)
#' }
#' @export
chictr_write_trial <- function(trial_url, path = NULL, ...){

  # Find URL to XML document
  xml_url <-
    trial_url %>%
    xml2::read_html() %>%
    rvest::html_node(css = ".bt_subm") %>%
    rvest::html_attr("href") %>%
    file.path("http://www.chictr.org.cn/", .)

  # Read XML document
  xml_document <-
    xml_url %>%
    xml2::read_xml(xml_url)

  # Extract file name as the trial id
  file_name <-
    xml_document %>%
    xml2::xml_find_all("Triall/main/trial_id") %>%
    xml2::xml_text() %>%
    paste0(".xml")

  # Construct filepath
  if (is.null(path)) {

    filepath <- file_name

  } else {

    filepath <- file.path(path, file_name)
  }

  xml2::write_xml(xml_document, filepath, ...)
}
