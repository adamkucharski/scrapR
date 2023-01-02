# PDF extractor

library(grImport)
library(tidyverse)
library(devtools)
#install_github("adamkucharski/scrapR")
library(scrapR)

rm(list=ls())

setwd("~/Documents/GitHub/scrapR/")

# - - - 
# Simulate some cartoon data
scrapR::simulate_PDF_data()

# - - - 
# STEP 1:
# Open your plot in Affinity/Illustrator and remove everything except the lines with data you want,
# and four tick marks (2 on x-axis, 2 on y-axis) that will be used to calibrate the scale
# - - - 

# Load PDF data from file and plot to align
scrapR::load_PDF_data(file_name="figure1.pdf")

# - - - 
# STEP 2:
# Edit `data/[FIGURE NAME].guide.csv` so the letters match up with your orignal four tick marks
# - - - 

# Extract data from file and output results
scrapR::extract_PDF_data(file_name = "figure1.pdf",x_log_scale = F,y_log_scale = F)




