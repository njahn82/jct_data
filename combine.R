library(tidyverse)
library(gert)

jct_git_log <- git_log(max = 1000, repo = ".") |>
  filter(grepl("Update data", message))

#' Read specific version of the file
read_git_version <- function(commit_hash, file = "data/jct_institutions.csv") {
  print(commit_hash)
  system(paste("git checkout", commit_hash))
  readr::read_csv(file, col_types = cols(.default = "c")) |>
    mutate(commit = commit_hash)
}

## Journals
jct_jn_all <- map_df(jct_git_log$commit, read_git_version,
                     file = "data/jct_journals.csv")

jct_jn_top <- jct_git_log |>
  select(commit, time) |>
  inner_join(jct_jn_all, by = "commit") |>
  group_by(esac_id) |>
  slice_max(time, n = 1) |>
  ungroup()

jct_jn <- jct_jn_top |>
  distinct(esac_id,
         journal_name,
         issn_print,
         issn_online,
         time_last_seen = time,
         commit)
write_csv(jct_jn, "data/jct_jn_all.csv")

## Institutions
jct_inst_all <- map_df(jct_git_log$commit, read_git_version)

jct_inst_top <- jct_git_log |>
  select(commit, time) |>
  inner_join(jct_inst_all, by = "commit") |>
  group_by(esac_id) |>
  slice_max(time, n = 1) |>
  ungroup()

jct_inst_ <- jct_inst_top |>
  filter(esac_id != "_ghost TA") |>
  distinct(esac_id,
 #          inst_name,
           ror_id,
           time_last_seen = time,
           commit)
write_csv(jct_inst_, "data/jct_inst_all.csv")

## Add ESAC data
esac_fetch <- function(data_url = "https://keeper.mpdl.mpg.de/f/7fbb5edd24ab4c5ca157/?dl=1") {
  tmp <- tempfile()
  download.file(data_url, tmp)
  readxl::read_xlsx(tmp, skip = 2) |>
    janitor::clean_names()
}

esac <- esac_fetch()

esac_df <- esac |>
  mutate(
    jct_jn = id %in% jct_jn$esac_id,
    jct_inst = id %in% jct_inst_$esac_id)

write_csv(esac_df, "data/esac_df.csv")
