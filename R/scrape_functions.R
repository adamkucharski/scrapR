#' Extract PDF data
#'
#' This function extracts PDF data
#' @keywords extra
#' @export
#' @examples
#' function_1()



# - - - 
# Simulate some cartoon data

simulate_data <- function() {
  
  set.seed(1)
  xx_weeks_model = seq(1,30,1)
  model_yy = round((1+0.5*runif(length(xx_weeks_model)))*5000*dnorm(xx_weeks_model,mean=10,sd=5))
  model_yy2 = round((1+0.9*runif(length(xx_weeks_model)))*5000*dnorm(xx_weeks_model,mean=15,sd=5))
  
  # Plot simulations
  par(mar=c(4,5,1,1),las=1)
  plot(xx_weeks_model,model_yy,pch=19,xlim=c(0,30.5),xaxs="i",yaxs="i",col='black',xlab="Weeks",ylab="Cases",ylim=c(0,800),bty="l",lwd=2,type="l")
  lines(xx_weeks_model,model_yy2,col="red",lwd=2)
  
  dev.copy(pdf,paste("data/figure0.pdf",sep=""),width=10,height=6)
  dev.off()
  
}



# - - - 
# Load PDF data from figure

load_data <- function(file_name = "figure1.pdf", file_path='data/figure1.pdf') {
  

  setwd("data/")
  PostScriptTrace(file_name)
  figure_data <- readPicture(paste0(file_name,".xml"))
  setwd("..")
  
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
  
  plot(0,xlim=xxlim,ylim=yylim)
  
  for(ii in 1:npaths){
    
    lines(store_data[[ii]]$x,store_data[[ii]]$y )
    text(LETTERS[ii],x=min(store_data[[ii]]$x),y=min(store_data[[ii]]$y),col="red")
    
  }
  
  dev.copy(pdf,paste0("outputs/",file_name,"guide.pdf",sep=""),width=10,height=6)
  dev.off()
  
  write_rds(store_data,paste0("outputs/",file_name,".RDS"))
  
}

# - - - - 
# Extract data from PDF

extract_data <- function(file_name = "figure1.pdf") {
  
  figure_guide <- read_csv(paste0("data/",file_name,".guide.csv"))
  
  # Transform co-ordinate system
  xxbase <- figure_guide[figure_guide$axis=="x",]
  yybase <- figure_guide[figure_guide$axis=="y",]
  
  # Load PDF data
  store_data0 <- read_rds(paste0("outputs/",file_name,".RDS"))
  
  ntotal <- length(store_data0)
  
  # Match up and extract
  x_labels <- match(xxbase$point,LETTERS[1:ntotal]); 
  x_locations <- sapply(x_labels,function(i){store_data0[[i]]$x[1]}) # Extract tick locations
  x_locations <- x_locations[order(xxbase$value)] # Put in ascending order based on extracted values
  x_actual <- sort(xxbase$value)
  
  y_labels <- match(yybase$point,LETTERS[1:ntotal]); 
  y_locations <- sapply(y_labels,function(i){store_data0[[i]]$y[1]})
  y_locations <- y_locations[order(yybase$value)] # Put in ascending order based on extracted values
  y_actual <- sort(yybase$value)
  
  # - - - 
  # Plot and output data
  
  entries_data <- (1:ntotal)[-match(figure_guide$point,LETTERS[1:ntotal])] # Non-guide entries

  
  for(ii in entries_data){
    
    xx = x_actual[1]+(x_actual[2]-x_actual[1])*(store_data0[[ii]]$x - x_locations[1])/(x_locations[2]-x_locations[1])
    yy = y_actual[1]+(y_actual[2]-y_actual[1])*(store_data0[[ii]]$y - y_locations[1])/(y_locations[2]-y_locations[1])
    
    if(ii==entries_data[1]){
      plot(xx,yy,type="l")
    }else{
      lines(xx,yy)
    }
    
    lines_store <- cbind(xx,yy) %>% data.frame()
    names(lines_store) <- c("x","y")
    
    write_csv(lines_store,paste0("outputs/",file_name,ii,".csv"))
  }
  
  dev.copy(pdf,paste0("outputs/",file_name,"estimates.pdf",sep=""),width=10,height=6)
  dev.off()
  
  
}




