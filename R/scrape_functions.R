#' Simulate data
#'
#' This function simulates data
#' @keywords simulation
#' @export
#' @examples
#' simulate_PDF_data()

# - - - 
# Simulate some cartoon data

simulate_PDF_data <- function() {
  
  set.seed(1)
  xx_weeks_model = seq(1,30,1)
  model_yy = round((1+0.5*runif(length(xx_weeks_model)))*5000*dnorm(xx_weeks_model,mean=10,sd=5))
  model_yy2 = round((1+0.9*runif(length(xx_weeks_model)))*5000*dnorm(xx_weeks_model,mean=15,sd=5))
  
  # Plot simulations
  par(mar=c(4,5,1,1),las=1)
  plot(xx_weeks_model,model_yy,pch=19,xlim=c(0,30.5),xaxs="i",yaxs="i",col='black',xlab="Weeks",ylab="Cases",ylim=c(0,800),bty="l",lwd=2,type="l")
  lines(xx_weeks_model,model_yy2,col="red",lwd=2)
  
  dev.copy(pdf,paste("figure1.pdf",sep=""),width=10,height=6)
  dev.off()
  
}



#' Load PDF data from figure
#'
#' This function simulates data
#' @export
#' @param file_name File to load
#' @examples
#' load_PDF_data()

load_PDF_data <- function( file_name = "figure1.pdf",integer_values=F ) {
  
  PostScriptTrace(file_name)
  figure_data <- readPicture(paste0(file_name,".xml"))
  
  # Extract and store co-ordinates
  npaths <- length(figure_data@paths)
  
  store_data <- list()
  
  for(ii in 1:npaths){
    
    data_store <- cbind(as.numeric(figure_data@paths[ii]$path@x),as.numeric(figure_data@paths[ii]$path@y)) %>% data.frame()
    names(data_store) <- c("x","y")
    store_data[[ii]] <- data_store
    
  }
  
  # Build calibration plot
  
  xxlim <- (figure_data@summary@xscale %>% as.numeric())
  yylim <- (figure_data@summary@yscale %>% as.numeric())
  
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


#' Extract data from PDF
#'
#' This function simulates data
#' @param file_name File to load
#' @param integer_values TRUE if the points are expected to be integer values
#' @export
#' @examples
#' extract_PDF_data()

extract_PDF_data <- function(file_name = "figure1.pdf") {
  
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
    
    xx <- x_actual[1]+(x_actual[2]-x_actual[1])*(store_data0[[ii]]$x - x_locations[1])/(x_locations[2]-x_locations[1])
    yy <- y_actual[1]+(y_actual[2]-y_actual[1])*(store_data0[[ii]]$y - y_locations[1])/(y_locations[2]-y_locations[1])
    
    # if(jj==1){
    #   par(mar=c(3,3,1,1))
    #   plot(xx,yy,type="l")
    # }else{
    #   lines(xx,yy)
    # }
    
    lines_store <- cbind(xx,yy) %>% data.frame()
    names(lines_store) <- c("x","y")
    
    write_csv(lines_store,paste0(file_name,jj,".csv"))
  }
  
  # dev.copy(pdf,paste0(file_name,"estimates.pdf",sep=""),width=10,height=6)
  # dev.off()
  
  
}




