# The sript will answer if Baltimore PM2.5 Emisosns have decreased/increased from 1999 to 2008
# The script user has ensure that both the base data R files are in thier working directory.
  (library(dplyr))
# Filter the data ti get only the Data for Baltiomer City
  bmore <- filter(NEI, fips == "24510")
  bmore_years <- group_by(bmore,year)
#summarize data by years
  bmore_totals <- summarize(bmore_years, Total_Emissions = sum(Emissions))
# Graph the Baltiomer data
  with(bmore_totals,plot(year, Total_Emissions,
                       type = "o",
                       main = "Baltimore Emissions by Year",
                       xlab= " Year of Emission",
                       ylab = "Total PM2.5 - Emissions(Tons)",
                       pch=20,col="blue",lwd=2.5)
  )
# Evaluate the tread over the year using liner reg
  model <- lm(Total_Emissions ~ year, bmore_totals)
# Plot the trend
  abline(model, lwd = 2, col="red")
# Add a legend to the graph
  legend("topright",cex=0.75,c("Emissions","Trend Line"), lty=c(1,1), lwd=c(2.5,2.5),col=c("blue","red"))
  dev.copy(png, file = "plot2.png", height = 480, width = 680)
  dev.off()