##Script to Compare emissions motor vehicle sources between Baltimore City and Los Angeles County
## The idea is to determine Which city has seen greater changes over time in motor vehicle emissions
 library(dplyr)
 library(ggplot2)
 library(grid)

#Load all the base data required for the analyis.
 source('Data_Loader.R')
 source('multiplot.R')

# Filter base data, filter and summarize for Baltimore City and Los Angeles County for comparison 
 Bmore_LA_veh <- NEI_SCC %>% 
   filter(grepl('Vehicle', Short.Name, ignore.case = TRUE)) %>% # filter Vehicel emssions
   filter(fips == "24510" | fips == "06037")        %>% # filter Baltiomer and LA data
   group_by (year,fips)                             %>% # Group year
   summarize (Total_Emissions = sum(Emissions))     %>% # Total Emmisions for each region/year
   mutate(Start_Level = 0)                          %>% # Add column to hold initial Emmison level
   mutate(City = "")                                    #create field to hold the city name

# Get the initial level of Emmisions for both Baltimore City and Los Angeles County
 start_levels <- Bmore_LA_veh                       %>% #Select data from Master data set
   filter(min_rank(Total_Emissions) & year=="1999") %>% #get the initial level for earliest year
   rename(init_level = Total_Emissions)                 #rename the columns to reflect approproiate value

# Assign the starting level of Emmisions and City Names 
 Bmore_LA_veh$Start_Level = start_levels$init_level[match(Bmore_LA_veh$fips,start_levels$fips)]
 df <- data.frame(fips = c("06037","24510"), City = c("Los Angeles County","Baltimore City"))
 Bmore_LA_veh$City = df$City[match(Bmore_LA_veh$fips,df$fips)]
 

# Calculate the real actual change in emmsions levels
 Bmore_LA_veh <- mutate(Bmore_LA_veh,Emissions_change = Total_Emissions - Start_Level)
# Calculate the relative change in emmsions levels
 Bmore_LA_veh <- mutate(Bmore_LA_veh,Emissions_pct_change = ((Emissions_change/Total_Emissions)*100))

#Plot the data in a line Graph to compare Total Change in Emssions
 a6 <- ggplot(data=Bmore_LA_veh, aes(x=year, y=Emissions_change,group=City,shape=City, color=City))
 a6 <- a6 + geom_line()
 a6 <- a6 + geom_point(size=4, shape=21, fill="white")
 a6 <- a6 + ggtitle(expression(atop("Baltimore City and Los Angeles County", atop(italic("Total Vehicle Emissions Volume Change since 1999"), ""))))
 a6 <- a6 + labs(x="year", y=expression("Total Change in PM"[2.5]*" Emission (Tons)")) 
 a6 <- a6 + theme(legend.position="bottom",legend.text = element_text(size = 14, face = "bold"))
 
#Plot the data in a line Graph to compare Total Percentage in Vehicle Emssions
 b6 <- ggplot(data=Bmore_LA_veh, aes(x=year, y=Emissions_pct_change,group=City,shape=City, color=City))
 b6 <- b6 + geom_line()
 b6 <- b6 + geom_point(size=4, shape=21, fill="white")
 b6 <- b6 + ggtitle(expression(atop("Baltimore City and Los Angeles County", atop(italic("Vehicle Emissions Rate Change (%) since 1999"), ""))))
 b6 <- b6 + labs(x="year", y=expression("Total PM"[2.5]*" Percentage(%) Rate Change"))
 b6 <- b6 + theme(legend.position="bottom",legend.text = element_text(size = 14, face = "bold"))
 
 # Make Bar Graph of Actual Volume Change since 1999
 c6 <- ggplot(data=Bmore_LA_veh, aes(x=factor(year), y=Emissions_change,fill=City))
 c6 <- c6 + geom_bar(stat="identity",position=position_dodge()) +  coord_flip()
 c6 <- c6 + theme_bw() + guides(fill=FALSE) 
 c6 <- c6 + facet_grid(.~City,scales = "free",space="free")
 c6 <- c6 + labs(x="year", y=expression("Total PM"[2.5]*" Emission Change (Tons)")) 
 c6 <- c6 + labs(title=expression("Vehicle PM"[2.5]*" Emission Volume Change"))
 
 # Make Bar Graph of Actual rate Change since 1999
 d6 <- ggplot(data=Bmore_LA_veh, aes(x=factor(year), y=Emissions_pct_change,fill=City))
 d6 <- d6 + geom_bar(stat="identity",position=position_dodge()) +  coord_flip()
 d6 <- d6 + theme_bw() + guides(fill=FALSE) 
 d6 <- d6 + facet_grid(.~City,scales = "free",space="free")
 d6 <- d6 + labs(x="year", y=expression("Total PM"[2.5]*" Emissions Rate Change (%)")) 
 d6 <- d6 + labs(title=expression("Vehicle PM"[2.5]*" Emissions Rate Change (%)"))

#plot the graphs to an output file 
 multiplot(a6, c6, b6, d6, cols=2)
 dev.copy(png, file = "plot6.png", height = 880, width = 880)
 dev.off()