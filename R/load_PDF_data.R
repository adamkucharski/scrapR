#' Load PDF data from figure
#'
#' This function extracts PDF data and creates a guide figure to align extraction
#' @export
#' @param file_name File to load
#' @examples
#' load_PDF_data()

load_PDF_data <- function( file_name = "figure1.pdf" ) {
  
  # Generate vector data
  grImport::PostScriptTrace(file_name) # Trace vector and store as xml
  figure_data <- readPicture(paste0(file_name,".xml")) # Import xml
  unlink(paste0(file_name,".xml")) # Remove xml file
  
  # Extract and store co-ordinates
  npaths <- length(figure_data@paths)
  
  store_data <- list()
  
  for(ii in 1:npaths){
    
    data_store <- cbind(as.numeric(figure_data@paths[ii]$path@x),as.numeric(figure_data@paths[ii]$path@y)) |> data.frame()
    names(data_store) <- c("x","y")
    store_data[[ii]] <- data_store
    
  }
  
  # Define plot range
  
  xxlim <- (figure_data@summary@xscale |> as.numeric())
  yylim <- (figure_data@summary@yscale |> as.numeric())
  
  # XX Extract plot elements here? XX
  
  store_string <- NULL
  
  for(ii in 1:npaths){
    store_string <- paste0(store_string,
                      paste0("id:", ii,
                             "; x:",paste(figure_data@paths[ii]$path@x,collapse=" "),
                             "; x:",paste(figure_data@paths[ii]$path@y,collapse=" "),
                             "; col:",figure_data@paths[ii]$path@rgb,
                             "\n")
    )
  }
  
  system_prompt <- "You are an expert at interpreting vector graphic data in R"
  user_prompt <- "The following string gives the x and y locations of multiple points in a vector graphic.
                Identify the contents of the plot (i.e. the vectors that are not axes or tick marks),
                and return their x and y co-ordinates in a clearly labelled csv format. 
                Only return the csv format, so it can be input directly into write_csv in R"
  
  llm_completion <- create_chat_completion(
    model = "gpt-3.5-turbo", 
    messages = list(list("role"="system","content" = system_prompt),
                    list("role"="user","content" = paste0(user_prompt,"\n",store_string))
    ),
    temperature = 0.2, # level of randomness in response
    openai_api_key = openai_api_key,
    max_tokens = 2000 # number of tokens (and hence $) used
  )
  
  llm_completion_content <- llm_completion$choices$message.content
  
  string_to_csv <- read_csv(llm_completion_content)
  write_csv(string_to_csv,"test.csv")
  
  # store_string <- data.frame(id=rep(NA,npaths),
  #                            x=rep(NA,npaths),
  #                            y=rep(NA,npaths),
  #                            rgb=rep(NA,npaths))
  # for(ii in 1:npaths){
  #   store_string[ii,"id"] <- ii
  #   store_string[ii,"x"] <- paste(figure_data@paths[ii]$path@x,collapse=" ")
  #   store_string[ii,"y"] <- paste(figure_data@paths[ii]$path@y,collapse=" ")
  #   store_string[ii,"rgb"] <- figure_data@paths[ii]$path@rgb
  # }
  
  # Build calibration plot
  
  par(mar=c(0,0,0,0))
  plot(0,xlim=xxlim,ylim=yylim,bty="l",col="white",xaxt="n",yaxt="n",ylab="",xlab="")
  
  for(ii in 1:npaths){
    
    plotval <- round(length(store_data[[ii]]$x)/2)
    
    lines(store_data[[ii]]$x,store_data[[ii]]$y )
    text(ii,x=store_data[[ii]]$x[plotval],y=store_data[[ii]]$y[plotval],col="red",cex=1.2)
    
  }
  
  dev.copy(pdf,paste0(file_name,"guide.pdf",sep=""),width=10,height=6)
  dev.off()
  
  write_rds(store_data,paste0(file_name,".RDS"))
  
}
