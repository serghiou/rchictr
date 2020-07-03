#' rchictr: Import study records from chictr.org.cn
#'
#' Retrieves the full study records of the desired studies from
#' chictr.org.cn and downloads a dataset of the most commonly used fields.
#'
#' @docType package
#' @importFrom magrittr %>%
#' @importFrom magrittr %<>%
"_PACKAGE"

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if (getRversion() >= "2.15.1") utils::globalVariables(c("."))
