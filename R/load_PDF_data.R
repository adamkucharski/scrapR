#' Load PDF data from figure
#'
#' This function extracts PDF data and creates a guide figure to align extraction
#' @export
#' @param file_name File to load
#' @examples
#' load_PDF_data()

load_PDF_data <- function( file_name = "figure1.pdf" ) {
  
  # Generate vector data
  PostScriptTrace(file_name) # Trace vector and store as xml
  figure_data <- readPicture(paste0(file_name,".xml")) # Import xml
  unlink(paste0(file_name,".xml")) # Remove xml file
  
  # Extract and store co-ordinates
  npaths <- length(figure_data@paths)
  
  store_data <- list()
  
  for(ii in 1:npaths){
    
    data_store <- cbind(as.numeric(figure_data@paths[ii]$path@x),as.numeric(figure_data@paths[ii]$path@y)) %>% data.frame()
    names(data_store) <- c("x","y")
    store_data[[ii]] <- data_store
    
  }
  
  # Define plot range
  
  xxlim <- (figure_data@summary@xscale %>% as.numeric())
  yylim <- (figure_data@summary@yscale %>% as.numeric())
  
  # XX Extract plot elements here? XX
  
  
  # Build calibration plot
  
  par(mar=c(0,0,0,0))
  plot(0,xlim=xxlim,ylim=yylim,bty="l",col="white",xaxt="n",yaxt="n",ylab="",xlab="")
  
  for(ii in 1:npaths){
    
    plotval <- round(length(store_data[[ii]]$x)/2)
    
    lines(store_data[[ii]]$x,store_data[[ii]]$y )
    text(ii,x=store_data[[ii]]$x[plotval],y=store_data[[ii]]$y[plotval],col="red")
    
  }
  
  dev.copy(pdf,paste0(file_name,"guide.pdf",sep=""),width=10,height=6)
  dev.off()
  
  write_rds(store_data,paste0(file_name,".RDS"))
  
}
