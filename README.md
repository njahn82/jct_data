## Fetch and Safeguard Transformative Aggreement Data 

This repo fetches [public transformative agreement data](https://journalcheckertool.org/transformative-agreements/) as provided by the [Journal Checker Tool](https://journalcheckertool.org/) from the [cOAlition S](https://www.coalition-s.org/) using GitHub Actions. Because agreements, which are no longer current, are not listed in the Journal Checker Tool, data changes are safed using git and github on a weekly basis.

## Data

Data are stored in the `data/` folder, comprising two files

- `data/jct_journals.csv`: journals and their properties
- `data/jct_institutions.csv`: institutions and their properties

## License

CCO