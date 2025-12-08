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

jct_esac_ids <- jct_jn_all |>
  inner_join(my_jct, by = "commit_hash") |>
  distinct(commit_hash, time_stamp, esac_id)
#' Create anayltical data set
#'
#' Commit datetimes
my_dates <- jct_esac_ids |>
  distinct(time_stamp) |>
  arrange(time_stamp) |>
  pull(time_stamp)

#' Get rolling sum for esac id
all_counts <- tibble(time = as.POSIXct(character()), all = integer())
for (datetime in my_dates) {
  cumulative_ids <- jct_esac_ids |>
    distinct(time_stamp, esac_id) |>
    filter(time_stamp <= datetime) |>
    distinct(esac_id) |>
    nrow()

  all_counts <- all_counts |>
    bind_rows(tibble(time = as.POSIXct(datetime, origin = "1970-01-01"), all = cumulative_ids))
}
#' Calculate active esac ids per time stamp
current_esac_counts <- jct_esac_ids |>
  group_by(time_stamp) |>
  summarise(active = n_distinct(esac_id))

my_jct_df <- inner_join(all_counts, current_esac_counts, by = c("time" = "time_stamp")) |>
  # Remove test case with five contracts
  filter(active != 5) |>
  mutate(vanished = all - active) |>
  pivot_longer(c(active, vanished)) |>
  mutate(name = fct(name, levels = c("active", "vanished")))

#' Plot :-)
ggplot(my_jct_df, aes(time, value, fill = fct_rev(name))) +
  geom_area(color = "#575656", linewidth = 0.2) +
  scale_fill_manual("Agreements in Journal Checker Tool",
                    values = c(active = "#56B4E9", vanished = "#b3b3b3a0"),
                    labels = c(active= "Included", vanished = "Archived")) +
  scale_x_datetime(date_breaks = "2 month", labels = scales::label_date_short()) +
  scale_y_continuous(
    labels = function(x) format(x, big.mark = ",", scientific = FALSE),
    limits = c(0, NA),
    expand = expansion(mult = c(0, 0.05))) +
  guides(fill = guide_legend(reverse = TRUE)) +
  labs(x = "", y = "ESAC agreements") +
  theme_minimal(base_size = 10) +
  theme(legend.position = "top")

ggsave("jct_development.pdf",
       dpi = 300,
       width = 6, height = 4)
