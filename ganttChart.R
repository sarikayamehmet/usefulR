#read excel
require(readxl)
etl_jobs <- readxl::read_excel("ETL_jobs.xlsx", sheet = "Sheet1")
colnames(etl_jobs) <- c("jobs","start","end","duration")
etl_jobs$start <- as.POSIXct(as.character(etl_jobs$start), format="%Y-%d-%m %H:%M:%S")
etl_jobs$end <- as.POSIXct(as.character(etl_jobs$end), format="%Y-%d-%m %H:%M:%S")

### Method 1  ###
library(timevis)
dataTimevis <- data.frame(
  id      = etl_jobs$jobs,
  className = etl_jobs$jobs,
  content = etl_jobs$duration,
  start   = etl_jobs$start,
  end     = etl_jobs$end
)
timevis(dataTimevis)

### Method 2 (Best one)  ###
df <- etl_jobs
library(plotly)
# Choose colors based on number of resources
colourCount = length(unique(df$jobs))
getPalette = colorRampPalette(RColorBrewer::brewer.pal(9, "Set3"))
cols <- getPalette(colourCount)
df$color <- factor(df$jobs, labels = cols)

# Initialize empty plot
p <- plot_ly()

# Each task is a separate trace
# Each trace is essentially a thick line plot
# x-axis ticks are dates and handled automatically

for(i in 1:(nrow(df) - 1)){
  p <- add_trace(p,
                 x = c(df$start[i], df$end[i]),  # x0, x1
                 y = c(i, i),  # y0, y1
                 mode = "lines",
                 line = list(color = df$color[i], width = 20),
                 showlegend = F,
                 hoverinfo = "text",
                 
                 # Create custom hover text
                 
                 text = paste("Task: ", df$jobs[i], "<br>",
                              "Duration: ", df$duration[i], "minutes<br>",
                              "Module: ", df$jobs[i]),
                 
                 evaluate = T  # needed to avoid lazy loading
  )
}

p

### Method 3  ###
library(ggplot2)
ggplot(data=etl_jobs) +
  geom_linerange(aes(x = jobs, ymin = start, ymax = end)) +
  coord_flip()+
  theme_bw()
