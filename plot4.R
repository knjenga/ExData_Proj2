## Script to determine if Coal based Emssions descressed in the United States between 1999-2008
## The script user has ensure that both the base data R files are in thier working directory.   
  library(dplyr)
  library(ggplot2)

#Load all the base data required for the analyis.
  source('Data_Loader.R')
  source('multiplot.R')

# Get the Emmisons for Coal for the whole USA
  usa_coal <- subset(NEI_SCC, grepl('Coal',NEI_SCC$Short.Name, fixed=TRUE), c("Emissions", "year","type"))
# Get Total Coal Emmisions by year
  emm_years <- group_by(usa_coal,year)
  usa_coal_year_totals <- summarize(emm_years, Total_Emissions = sum(Emissions),na.rm=TRUE)
# Build Graph
  a4 <- ggplot(data=usa_coal_year_totals, aes(x=year, y=Total_Emissions))
  a4 <- a4 + geom_line(col ="blue") 
  a4 <- a4 + geom_point(size=4, shape=21, fill="white")
  a4 <- a4 + stat_smooth(method = "lm",col="red")
  a4 <- a4 + ggtitle(expression("USA - Total PM"[2.5]*" Coal Emissions"))
  a4 <- a4 + labs(x="Year", y=expression("Total PM"[2.5]*" Emission (Tons)")) 
  print(a4)
#Copy the graph to graph vector for display
  dev.copy(png, file = "plot4.png", height = 480, width = 480)
  dev.off()
