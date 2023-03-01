
# pxRRead

<!-- badges: start -->
<!-- badges: end -->

## About

The px file format is a format for offering statistical tables
in an interactive way. It was introducted by the Statistics office of Schweden and
is also used by statistical offices in other countries.

See here for a specification of this format: [px file format specification](https://www.scb.se/en/services/statistical-programs-for-px-files/px-file-format/)

The goal of pxRRead is parse px cube files:
- from a download url for a px cube file
- from a px cube file that has been downloaded previously

## Installation

You can install the development version of pxRRead from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("SDSC-ORD/pxRRead")
```

## Usage

``` r
library(pxRRead)
scan_px_file('px-x-0102020203_110.px')
scan_px_file('https://www.pxweb.bfs.admin.ch/DownloadFile.aspx?file=px-x-0602000000_107')
```

## Output

In this first version of the parser the following is done:

The output consist of a list of data and metadata:
- `output$metadata` includes all base px keys, but not the translations
- `output$tdf` is a tibble with the length of the `DATA` of the px cube 
- The dimensions in "STUB" and "HEADING" of the px cube are all turned into columns of the tibble

``` r
output <- scan_px_file('https://www.pxweb.bfs.admin.ch/DownloadFile.aspx?file=px-x-0602000000_107')
output$metadata
output$tdf
```

### Restrictions

In this first version of the parser the following assumptions are made:

- translations are assumed to be in the languages `de`, `fr`, `en`, `it`
- `CHARSET` is `ANSI`
- `PX-AXIS` Version is `2010`
