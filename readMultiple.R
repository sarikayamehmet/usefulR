# Make a function to process each file
processFile <- function(f) {
  df <- read.csv(f, colClasses=c("status_id"="character"))
  # ...and do stuff...
  return(df)
}

# Find all .csv files
files <- dir("user_labels/", recursive=TRUE, full.names=TRUE, pattern="\\.csv$")

# Apply the function to all files.
library(dplyr)
df <- files %>% 
  lapply(processFile) %>% 
  bind_rows
  
  
