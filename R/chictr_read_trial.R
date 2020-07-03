#' Read fields of interest from a specific trial
#'
#' Takes the URL of a specific trial, downloads the XML file, reads the fields
#'     that are most commonly of interest and returns a tibble.
#'
#' @param trial_url The URL of a specific trial as a string
#' @return A tibble of the trial's most commonly used fields.
#' @examples
#' \dontrun{
#' # Copy-paste the trial URL from the ChiCTR.org.cn website
#' trial_url <- "http://www.chictr.org.cn/showprojen.aspx?proj=55654"
#' # Extract the fields of interest
#' trial <- chictr_read_trial(trial_url)
#' }
#' @export
chictr_read_trial <- function(trial_url){

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

  # Define XPath to the fields of interest
  xpath <- c(
    registration_number = "Triall/main/trial_id",
    date_registration = "Triall/main/date_registration",
    date_enrolment = "Triall/main/date_enrolment",
    public_title = "Triall/main/public_title",
    scientific_title = "Triall/main/scientific_title",
    primary_sponsor = "Triall/main/primary_sponsor",
    recruitment_status = "Triall/main/recruitment_status",
    study_type = "Triall/main/study_type",
    study_design = "Triall/main/study_design",
    phase = "Triall/main/phase"
  )

  xpath %>%
    lapply(.get_text, xml_document = xml_document) %>%
    tibble::as_tibble() %>%
    dplyr::mutate(extraction_date = date()) %>%
    dplyr::mutate_all(stringr::str_squish)
}


#' Get the desired text from the xml_document
#'
#' Returns the text desired according to XPath.
#'
#' @param xpath The XPath as a character, e.g. "Triall/main/trial_id"
#' @param xml_document The ChiCTR trial as an XML document
#' @return The desired text as a character; if not found, then `character()`
.get_text <- function(xml_document, xpath) {

  xml_document %>%
    xml2::xml_find_all(xpath) %>%
    xml2::xml_contents() %>%
    xml2::xml_text() %>%
    paste(collapse = "; ")

}
