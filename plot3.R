# Analysis to determine of the four types of Emissions types (point, nonpoint, onroad, nonroad)
# which ones saw a decreases in emissions from 1999-2008 for the city of Baltimore.
# The script user has ensure that both the base data R files are in thier working directory.   
 library(dplyr)
 library(ggplot2)

#Load all the base data required for the analyis.
 source('Data_Loader.R')

# Create analytical data set for the City of Baltimore
  bmore <- filter(NEI, fips == "24510")
  bmore_years_points <- group_by(bmore,year,type)
  bmore_yr_type_totals <- summarize(bmore_years_points, Total_Emissions = sum(Emissions))
# Bar graph of the diffrent types
#ggplot(data=bmore_yr_type_totals,aes(x=year, y=Total_Emissions)) + geom_bar(stat="identity", position=position_dodge()) + facet_wrap(~type)
  a2 <- ggplot(data=bmore_yr_type_totals, aes(x=year, y=Total_Emissions, color = type))
  a2 <- a2 + geom_line(lwd=2.5) + stat_smooth(method = "lm",col="red")
  a2 <- a2 + geom_point(size=4, shape=21, fill="white")
  a2 <- a2 + ggtitle(expression("Baltiomre City - Total PM"[2.5]*" Emissions"))
  a2 <- a2 + xlab("Year") + ylab("Total Emissions (Tons)")
  a2 <- a2 + facet_wrap(~type)
  print(a2)
#Copy the graph to graph vector for display
  dev.copy(png, file = "plot3.png", height = 680, width = 880)
  dev.off()
