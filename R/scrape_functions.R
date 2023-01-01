#' Extract data from PDF
#'
#' This function uses the alignment tools to extract the raw data
#' @param file_name File to load
#' @param integer_values TRUE if the points are expected to be integer values
#' @param x_log_scale TRUE if x axis is on a log scale
#' @param y_log_scale TRUE if y axis is on a log scale
#' @export
#' @examples
#' extract_PDF_data()

extract_PDF_data <- function(file_name = "figure1.pdf",integer_values=F,x_log_scale=F,y_log_scale=F) {
  
  figure_guide <- read_csv(paste0(file_name,".guide.csv"))
  
  # Transform co-ordinate system
  xxbase <- figure_guide[figure_guide$axis=="x",]
  yybase <- figure_guide[figure_guide$axis=="y",]
  
  # Load PDF data
  store_data0 <- read_rds(paste0(file_name,".RDS"))
  
  ntotal <- length(store_data0)
  
  # Match up and extract
  x_labels <- match(xxbase$point, c(1:ntotal) ); 
  x_locations <- sapply(x_labels,function(i){store_data0[[i]]$x[1]}) # Extract tick locations
  x_locations <- x_locations[order(xxbase$value)] # Put in ascending order based on extracted values
  x_actual <- sort(xxbase$value)
  
  y_labels <- match(yybase$point, c(1:ntotal) ); 
  y_locations <- sapply(y_labels,function(i){store_data0[[i]]$y[1]})
  y_locations <- y_locations[order(yybase$value)] # Put in ascending order based on extracted values
  y_actual <- sort(yybase$value)
  
  # - - - 
  # Plot and output data
  
  entries_data <- figure_guide[figure_guide$axis=="data",]$point # Non-guide entries

  
  for(jj in 1:length(entries_data)){
    
    ii <- entries_data[jj] # index
    
    # Scale axes
    if(x_log_scale==F){
      xx <- x_actual[1]+(x_actual[2]-x_actual[1])*(store_data0[[ii]]$x - x_locations[1])/(x_locations[2]-x_locations[1])
    }
    if(y_log_scale==F){
      yy <- y_actual[1]+(y_actual[2]-y_actual[1])*(store_data0[[ii]]$y - y_locations[1])/(y_locations[2]-y_locations[1])
    }
    
    if(x_log_scale==T){
      x_actual_log = log(x_actual,10)
      xx <- x_actual_log[1]+(x_actual_log[2]-x_actual_log[1])*(store_data0[[ii]]$x - x_locations[1])/(x_locations[2]-x_locations[1])
      xx <- 10^xx
    }
    if(y_log_scale==T){
      y_actual_log = log(y_actual,10)
      yy <- y_actual_log[1]+(y_actual_log[2]-y_actual_log[1])*(store_data0[[ii]]$y - y_locations[1])/(y_locations[2]-y_locations[1])
      yy <- 10^yy
    }

    lines_store <- cbind(xx,yy) %>% data.frame()
    names(lines_store) <- c("x","y")
    
    write_csv(lines_store,paste0(file_name,ii,".csv"))
  }
  
  # dev.copy(pdf,paste0(file_name,"estimates.pdf",sep=""),width=10,height=6)
  # dev.off()
  
  
}




