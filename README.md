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

git_config_global()
```

# A tibble: 6 × 3
  name                value                  level 
* <chr>               <chr>                  <chr> 
1 safe.directory      *                      system
2 filter.lfs.clean    git-lfs clean -- %f    system
3 filter.lfs.smudge   git-lfs smudge -- %f   system
4 filter.lfs.process  git-lfs filter-process system
5 filter.lfs.required true                   system
6 credential.helper   cache                  global

```r
git_config_global_set("user.name", "Jerry Johnson")
git_config_global_set("user.email", "jerry@gmail.com")

gert::git_log() |>
  dplyr::filter(time > as.POSIXct("2022-12-22")) |>
  dplyr::filter(grepl("Update data", message)) |>
  dplyr::select(`Time updated` = time, `Snapshot` = commit) |>
  knitr::kable()
```



|Time updated |Snapshot |
|:------------|:--------|

## Latest Stats as on 2023-01-03



- 5 transformative agreements with ESAC ID
- 947 journal titles covered
- 48 institutions participating 
- 47 institutions covered have a ROR-ID

## License

CCO
