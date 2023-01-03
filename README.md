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
  dplyr::select(`Time updated` = time, `Snapshot` = commit) |>
  knitr::kable()
```



|Time updated        |Snapshot                                 |
|:-------------------|:----------------------------------------|
|2023-01-02 02:19:56 |fd749477fbe5e0d58040bdaa4466e63886e9fb17 |
|2022-12-26 02:19:15 |9816f3c9f6fd9679b38a8f8279549c723dbc19ba |

## Latest Stats as on 2023-01-03



- 5 transformative agreements with ESAC ID
- 947 journal titles covered
- 48 institutions participating 
- 47 institutions covered have a ROR-ID

## License

CCO
