library(tidyverse)

#' Obtain git history only where data was updated in a file
my_jct <- readr::read_tsv(
  pipe('git log --pretty=format:"%H%x09%ad%x09%an%x09%s" --date=iso-strict --grep="Update data"'),
  col_names = c("commit_hash", "time_stamp", "user", "commit_message")
)

#' Get ESAC-IDS from journal list using git show
jct_jn_all <- map_df(
  my_jct$commit_hash, function(x) {
    bash_cmd <- paste0('git show ', x, ':data/jct_journals.csv')
    readr::read_csv(pipe(bash_cmd), col_types = cols(.default = "c")) |>
      mutate(commit_hash = x)
  }
)

#' Get journal metadata from the latest version by ESAC id
jct_jn_top <- my_jct |>
  select(commit_hash, time_stamp) |>
  inner_join(jct_jn_all, by = "commit_hash") |>
  group_by(esac_id) |>
  slice_max(time_stamp, n = 1) |>
  ungroup()

#' Safeguard data
jct_jn <- jct_jn_top |>
  distinct(esac_id,
           journal_name,
           issn_print,
           issn_online,
           time_last_seen = time_stamp,
           commit_hash)
write_csv(jct_jn, "data/jct_jn_all.csv")

#' Institutions

#' Get jct institution data using git show
jct_inst_all <- map_df(
  my_jct$commit_hash, function(x) {
    bash_cmd <- paste0('git show ', x, ':data/jct_institutions.csv')
    readr::read_csv(pipe(bash_cmd), col_types = cols(.default = "c")) |>
      mutate(commit_hash = x)
  }
)

jct_inst_top <- my_jct |>
  select(commit_hash, time_stamp) |>
  inner_join(jct_inst_all, by = "commit_hash") |>
  group_by(esac_id) |>
  slice_max(time_stamp, n = 1) |>
  ungroup()

jct_inst_ <- jct_inst_top |>
  filter(esac_id != "_ghost TA") |>
  distinct(esac_id,
           inst_name,
           ror_id,
           time_last_seen = time_stamp,
           commit_hash)
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
