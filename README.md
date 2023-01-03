## Weekly Transformative Aggreement Data dumps

This repo contains weekly dumps of [public transformative agreement data](https://journalcheckertool.org/transformative-agreements/) as provided by the [Journal Checker Tool](https://journalcheckertool.org/) from the [cOAlition S](https://www.coalition-s.org/). 

## Data

Data are stored in the `data/` folder, comprising two files

- `data/jct_journals.csv`: journals and their properties
- `data/jct_institutions.csv`: institutions and their properties

## Snapshots


```r
library(gert)
library(dplyr)
library(knitr)

gert::git_clone("https://github.com/njahn82/jct_data/")
setwd("jct_data/")

gert::git_log() |>
  dplyr::filter(time > as.POSIXct("2022-12-22")) |>
  dplyr::filter(grepl("Update data", message)) |>
  dplyr::mutate(link = paste0("<a href='https://github.com/njahn82/jct_data/tree/", commit, "/data'>",commit, "</a>")) |>
  dplyr::select(`Time updated` = time, `Snapshot` = link) |>
  knitr::kable()
```



|Time updated        |Snapshot                                                                                                                                      |
|:-------------------|:---------------------------------------------------------------------------------------------------------------------------------------------|
|2023-01-03 19:06:57 |<a href='https://github.com/njahn82/jct_data/tree/af75fc6ef8bea99bb57a7eba2790b6426d5ee3eb/data'>af75fc6ef8bea99bb57a7eba2790b6426d5ee3eb</a> |
|2023-01-02 02:19:56 |<a href='https://github.com/njahn82/jct_data/tree/fd749477fbe5e0d58040bdaa4466e63886e9fb17/data'>fd749477fbe5e0d58040bdaa4466e63886e9fb17</a> |
|2022-12-26 02:19:15 |<a href='https://github.com/njahn82/jct_data/tree/9816f3c9f6fd9679b38a8f8279549c723dbc19ba/data'>9816f3c9f6fd9679b38a8f8279549c723dbc19ba</a> |

## Latest Stats as on 2023-01-03



- 400 transformative agreements with ESAC ID
- 21394 journal titles covered
- 7587 institutions participating 
- 3530 institutions covered have a ROR-ID

## License

CCO
