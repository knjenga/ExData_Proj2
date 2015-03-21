##Script to determine if Motor vehicle Emssions descressed in the City of Baltimore between 1999-2008
  library(dplyr)
  library(ggplot2)
  library(grid)

#Load all the base data required for the analyis.
  source('Data_Loader.R')
  source('multiplot.R')

#Subset the data to get only Motor vehicle related Emmissions
#The assumption: Motor vehicle Emissions are those with the term "Vehicle" in the field  Short.Name
  bmore_veh <- subset(NEI_SCC, grepl('Vehicle', NEI_SCC$Short.Name, ignore.case = TRUE))
#Filter the data set to contain only data from the city of Baltimore
  bmore_veh <- filter(bmore_veh, fips == "24510")
#Orgainze the Baltimore data by emssion years (Create stratum by year)
  emmision_years <- group_by(bmore_veh,year)
#Get the Total Emssion for Baltiomre by Year
  bmore_veh_year_totals <- summarize(emmision_years, Total_Emissions = sum(Emissions),na.rm=TRUE)

#Build the graph for Balitmore
  a5 <- ggplot(data=bmore_veh_year_totals, aes(x=year, y=Total_Emissions))
  a5  <- a5  + geom_line() + stat_smooth(method = "lm",col="red")
  a5  <- a5 + geom_point(size=4, shape=21, fill="white")
  a5  <- a5 + ggtitle(expression("Baltimore City - Total PM"[2.5]*" Vehicle Emission"))
  a5  <- a5 + labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) 

# Make additonal Detalied Graph
  b5 <- ggplot(data=bmore_veh, aes(x=factor(year), y=Emissions,fill=type))
  b5 <- b5 + geom_bar(stat="identity")
  b5 <- b5 + theme_bw() + guides(fill=FALSE) 
  b5 <- b5 + facet_grid(.~type,scales = "free",space="free")
  b5 <- b5 + labs(x="year", y=(expression("Total PM"[2.5]*" Emission (Tons)"))) 
  b5 <- b5 + labs(title=expression("Baltimore City - PM"[2.5]*" Emissions, 1999-2008 by Source Type"))

# Plot the graphs and save the output to a file
  multiplot(a5, b5, cols=1)
  dev.copy(png, file = "plot5.png", height = 580, width = 680)
  dev.off()
