# PDF extractor

library(grImport)
library(tidyverse)

rm(list=ls())

setwd("~/Documents/GitHub/scrapR/")


# Load functions
source("R/scrape_functions.R")

# - - - 
# Simulate some cartoon data

simulate_data()

# - - - 
# STEP 1:
# Open your plot in Affinity/Illustrator and remove everything except the lines with data you want,
# and four tick marks (2 on x-axis, 2 on y-axis) that will be used to calibrate the scale
# - - - 

# Load PDF data from file and plot to align
load_data(file_name="figure1.pdf",file_path='data/figure1.pdf')


# - - - 
# STEP 2:
# Edit `data/[FIGURE NAME].guide.csv` so the letters match up with your orignal four tick marks
# - - - 

# Extract data from file and output results
extract_data(file_name = "figure1.pdf")

