# enrich
issn_l <- readr::read_tsv("~/Downloads/issnltables20251207/20251207.ISSN-to-ISSN-L.txt", col_names = c("issn", "issn_l")) |>
  mutate(issn_l = substr(issn_l, start = 1, stop = 9))
jct_jn <- readr::read_csv("data/jct_jn_all.csv")

jct_jn_short <- jct_jn |>
  pivot_longer(cols = c(issn_print, issn_online),
               names_to = "issn_type",
               values_to = "issn") %>%
  filter(!is.na(issn)) |>
  left_join(issn_l, by = c("issn")) |>
  distinct(esac_id,
           issn_l,
   #        issn,
           time_last_seen,
   commit_hash)

write_csv(jct_jn_short, "data/jct_jn_short.csv")

#Upload
