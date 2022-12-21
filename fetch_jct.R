#' Get journal information from the Journal Checker Tool
#'
#' <https://journalcheckertool.org/transformative-agreements/>
library(dplyr)
library(purrr)
library(readr)
library(progress)
jct_raw <-
  readr::read_csv(
    "https://docs.google.com/spreadsheets/d/e/2PACX-1vStezELi7qnKcyE8OiO2OYx2kqQDOnNsDX1JfAsK487n2uB_Dve5iDTwhUFfJ7eFPDhEjkfhXhqVTGw/pub?gid=1130349201&single=true&output=csv"
  ) 

jct_short <- jct_raw |>
  select(esac_id =  `ESAC ID`, data_url = `Data URL`)

#' Helper function fetching all journal info by ESAC agreement
jct_fetch <- function(data_url = NULL) {
  
  # Progress
  message(paste("Fetching:", data_url))
  # Download spreadsheet
  req <- readr::read_csv(
    data_url,
    col_types = "cccccccc",
    show_col_types = FALSE,
    progress = FALSE
  )
  
  # Journal-level data
  jn_df <- req|>
    select(
      journal_name = 1,
      issn_print = 2,
      issn_online = 3,
      first_seen = 4,
      last_seen = 5
    )|>
    filter(!is.na(journal_name)) |>
    mutate(data_url = data_url)
  
  # Institutional-level data
  inst_df <- req |>
    select(
      inst_name = 6,
      ror_id = 7,
      inst_first_seen = 8,
      ins_last_seen = 9
    ) |>
    filter(!is.na(inst_name)) |>
    mutate(data_url = data_url)
  
  # Return
  list(jn_df = jn_df, inst_df = inst_df)
}

# Call
jct_journal_out <-
  purrr::map(jct_raw$`Data URL`, purrr::safely(jct_fetch))
# Get journal data
jn_df <- purrr::map(jct_journal_out, "result") |>
  purrr::map_df("jn_df")
# add esac id
jn_df|>
  inner_join(jct_short, by = "data_url") |>
  write_csv("data/jct_journals.csv")
# Get inst data
inst_df <- purrr::map(jct_journal_out, "result") |>
  purrr::map_df("inst_df") 

inner_join(inst_df, jct_short, by = "data_url") |>
  write_csv("data/jct_institutions.csv")

# Print error log
purrr::map(jct_journal_out, "error")


