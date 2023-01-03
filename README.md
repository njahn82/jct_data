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



gert::git_log() 
```

# A tibble: 1 × 6
  commit                          author time                files merge message
* <chr>                           <chr>  <dttm>              <int> <lgl> <chr>  
1 3d003f9e82aecc069914c545649162… najah… 2023-01-03 18:30:33    NA TRUE  "Merge…

## Latest Stats as on 2023-01-03



- 5 transformative agreements with ESAC ID
- 947 journal titles covered
- 48 institutions participating 
- 47 institutions covered have a ROR-ID

## License

CCO
