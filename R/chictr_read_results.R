#' Search ChiCTR and read the results table
#'
#' First, navigate to www.chictr.org.cn and create the search term of interest.
#'     Then, copy-paste the resulting URL into this function. The function will
#'     download the registration number, public title, type, registration time
#'     and a linke to the full article.
#'
#' @param URL The URL of the results page after searching on chictr.org.cn.
#' @return A dataframe of the ChiCTR results table.
#' @examples
#' \dontrun{
#' # Copy-paste the URL from the ChiCTR.org.cn website
#' URL <- "http://www.chictr.org.cn/searchprojen.aspx?title=covid"
#' # Download results table
#' results_table <- chictr_read_results(URL)
#' }
#' @export
chictr_read_results <- function(URL) {

  # Convert the Chinese website into the English website
  URL %<>% stringr::str_replace("searchproj\\.", "searchprojen\\.")

  # Parse HTML
  xml_doc <- xml2::read_html(URL)

  # Extract number of pages
  n_pages <-
    xml_doc %>%
    xml2::xml_find_all("//span") %>%
    xml2::xml_text() %>%
    stringr::str_squish() %>%
    stringr::str_extract("[0-9]+$")

  # Extract the tables
  purrr::map_dfr(1:n_pages, .extract_tables, URL = URL, n_pages = n_pages)

}


#' Extract the results table from the ChiCTR results page
#'
#' Extracts the results table from each successive page of search results.
#'
#' @param index The page number to extract from as an integer or string.
#' @param URL The URL of the results page after searching on chictr.org.cn.
#' @return A dataframe of the ChiCTR results table.
#' @examples
#' \dontrun{
#' # Copy-paste the URL from the ChiCTR.org.cn website
#' URL <- "http://www.chictr.org.cn/searchprojen.aspx?title=covid"
#' # Download results table
#' results_table <- chictr_read_results(URL)
#' }
.extract_tables <- function(index, URL, n_pages) {

  if (index == 1) {

    message(sprintf("Extracting %s pages.", n_pages))

  }

  # Column names
  column_names <- c(
    "historical_versions",
    "registration_number",
    "public_title",
    "type",
    "registration_time"
  )

  # Parse HTML and identify the table node of interest
  nodeset <-
    URL %>%
    stringr::str_replace("[0-9]+$", as.character(index)) %>%
    xml2::read_html(URL) %>%
    rvest::html_nodes("table") %>%
    magrittr::extract(2)

  # Extract individual project URLs
  trial_urls <-
    nodeset %>%
    xml2::xml_find_all("tbody//p/a") %>%
    xml2::xml_attr(attr = "href") %>%
    file.path("http://www.chictr.org.cn", .)

  # Extract table and bind with individual project URLs
  out <-
    nodeset %>%
    rvest::html_table(header = T) %>%
    purrr::map_dfr(tibble::as_tibble) %>%
    dplyr::mutate_all(stringr::str_squish) %>%
    purrr::set_names(column_names) %>%
    dplyr::bind_cols(trial_urls = trial_urls)

  if (index %% 10 == 0) {

    message(sprintf("%s of %s pages extracted.", index, n_pages))

  }

  return(out)
}
