
# fsopxRRead

<!-- badges: start -->
<!-- badges: end -->

The goal of fsopxRRead is parse px cube files.

## Installation

You can install the development version of fsopxRRead from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("SDSC-ORD/fsopxRRead")
```

## Usage

``` r
library(fsopxRRead)
scan_px_file('px-x-0102020203_110.px')
```

## Output

In this first version of the parser the following is done:

The output consist of a list of data and metadata:
- `output$metadata` includes all base px keys, but not the translations
- `output$tdf` is a tibble with the length of the `DATA` of the px cube 
- The dimensions in "STUB" and "HEADING" of the px cube are all turned into columns of the tibble

```
output <- scan_px_file('px-x-0102020203_110.px')
output$metadata
output$tdf
```

### Restrictions

In this first version of the parser the following assumptions are made:

- translations are assumed to be in the languages `de`, `fr`, `en`, `it`
- `CHARSET` is `ANSI`
- `PX-AXIS` Version is `2010`
