# The sript will answer if USA PM2.5 Emisosns have decreased/increased from 1999 to 2008
# The Loigic used for the assement is if there was a down ward trend over the years
# The script user has ensure that both the base data R files are in thier working directory. 
library(dplyr)

#Load all the base data required for the analyis.
source('Data_Loader.R')

# Break down emmisions data by stratum,Calculate total emmsions for each year
  years <- group_by(NEI,year)
  year_totals <- summarize(years, Total_Emissions = sum(Emissions))
# Graph the data
  with(year_totals,plot(year,log(Total_Emissions),
                        type = "o",
                        main = "Total US Emissions by Year",
                        xlab= " Year of Emission",
                        ylab = "Total Emmisions in Tons (Log)",
                        pch=20,col="blue",lwd=2.5)
       )
# Evaluate the tread over the year using liner reg
  model <- lm(log(Total_Emissions) ~ year, year_totals)
# Plot the trend
  abline(model, lwd = 2, col="red")
# Add a legend to the graph
  legend("topright",cex=0.75,c("Emissions","Trend Line"), lty=c(1,1), lwd=c(2.5,2.5),col=c("blue","red"))
#Copy the graph to graph vector for display
  dev.copy(png, file = "plot1.png", height = 480, width = 680)
  dev.off()