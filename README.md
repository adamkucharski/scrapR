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

First you need a figure to extract data from. If you want a simple test figure, you can run:
```r
simulate_PDF_data()
```
to generate a simulated set of lines and output as `figure1.pdf`.

<img src="https://user-images.githubusercontent.com/8329046/47551859-3016ed80-d8fb-11e8-82f4-52cfdfd1a5f0.png" width="600px" />

Next, navigate to the directory containing your PDF figure and import the data:

```r
load_PDF_data(file_name="figure1.pdf")
```

This will output a raw RDS file and a figure (`[FIGURENAME].guide.pdf`) with the different components labelled with numbers. 

<img src="https://user-images.githubusercontent.com/8329046/47551865-34430b00-d8fb-11e8-916b-62884f3ff37e.png" width="600px" />

If the data fails to import, it's probably because the vector graphic has too many surrounding features. In this case, use an editor like Affinity/Illustrator etc. to delete unnecessary surrounding content, making sure to leave the lines with data you want and at least four tick marks (2 on x-axis, 2 on y-axis), which will be used to calibrate the scale.

Once you've run `load_PDF_data()`, edit/create `[FIGURE NAME].guide.csv` so numbers match up with two x-axis tick marks and two y-axis tick marks, and specify which data you want to extract:

point   | value | axis
------------- | -------------  | -------------  
5 | 5 | x
10 | 30 | x
13 | 200 | y
16 | 800 | y
2 | NA | data
18 | NA | data

Then extract the data using the RDS file and guide CSV file:

```r
extract_PDF_data(file_name = "figure1.pdf")
```

The resulting data for the line(s) will be output as `[FIGURENAME][INDEX].csv`