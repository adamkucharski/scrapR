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
  xx_weeks_model <- seq(1,30,1)
  model_yy <- round((1+0.5*runif(length(xx_weeks_model)))*5000*dnorm(xx_weeks_model,mean=10,sd=5))
  model_yy2 <- round((1+0.9*runif(length(xx_weeks_model)))*5000*dnorm(xx_weeks_model,mean=15,sd=5))
  
  # Plot simulations
  par(mar=c(4,5,1,1),las=1)
  plot(xx_weeks_model,model_yy,pch=19,xlim=c(0,30.5),xaxs="i",yaxs="i",col='black',xlab="Weeks",ylab="Cases",ylim=c(0,800),bty="l",lwd=2,type="l")
  lines(xx_weeks_model,model_yy2,col="red",lwd=2)
  
  dev.copy(pdf,paste("figure1.pdf",sep=""),width=10,height=6)
  dev.off()
  
  # generate guide functions
  guide_data <- cbind(c(5,10,13,16,2,18),c(5,30,200,800,NA,NA),c("x","x","y","y","data","data")) %>% data.frame()
  names(guide_data) <- c("point","value","axis")
  write_csv(guide_data,paste0("figure1.pdf",".guide.csv"))
  
}
