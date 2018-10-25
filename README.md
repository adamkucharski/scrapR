# scrapR

`R` package to extract data from PDF figures

## Installation

The easiest way to install the development version of `scrapR` is to use the `devtools` package:

```r
# install.packages("devtools")
library(devtools)
install_github("adamkucharski/scrapR")
library(scrapR)

# load dependencies
# install.packages("tidyverse")
# install.packages("grImport")
library(tidyverse)
library(grImport)

```

## Example

First we need a figure to extract data from. You can use `simulate_data()` to generate a simulated figure if needed.

![Screenshot](data/figure0.pdf)

<div align="center">
    <img src="https://github.com/adamkucharski/scrapR/blob/master/data/figure1.pdf" width="400px"></img> 
</div>

Before extracting data, it's worth removing unnecessary parts of the vector graphic. Create a copy of your plot in Affinity/Illustrator and delete everything except the lines with data you want and four tick marks (2 on x-axis, 2 on y-axis) that will be used to calibrate the scale.

![Screenshot](data/figure1.pdf)

Navigate to the directory containing the simplified figure and import the data

```r
load_data(file_name="[FIGURENAME].pdf")
```

This will output a raw RDS file and a figure (`[FIGURENAME].guide.pdf`) with the different components labelled with letters. 

![Screenshot](data/figure1.pdfguide.pdf)


If the tick marks are not labelled as "A,B,C,D" in some order, edit `[FIGURE NAME].guide.csv` so the letters match up with your orignal four tick marks.

point   | value | axis
------------- | -------------  | -------------  
B | 5 | x
C | 30 | x
D | 0 | y
E | 800 | y

Then extract the data using the RDS file and guide CSV file:

```r
extract_data(file_name = "figure1.pdf")
```

The resulting data for the line(s) will be output as `[FIGURENAME][INDEX].csv`