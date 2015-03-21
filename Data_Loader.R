# Load the National Emissions Inventory database data
# the data will be analyzed to study fine particulate matter pollution in the United states
# the script assumes that the user has manually loaded the base data files from link bellow
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
# The script design also assumes unzipped are in the working directory

# This script will be called by a total of 6 other scripts
# if the main data already exists in the computer memory then no need to re-run the lengthy load process  
#  

if (!exists("NEI")) NEI <- readRDS("summarySCC_PM25.rds")
if (!exists("SCC")) SCC <- readRDS("Source_Classification_Code.rds")
   # Get a list of SCC Descriptions
if (!exists("SCC_Desc")) SCC_Desc <- subset(SCC, select = c("SCC", "Short.Name"))
   # Assign the Summary Data set the SCC Descriptions by merging the two data sets
if (!exists("NEI_SCC")) NEI_SCC <- merge(NEI,SCC_Desc,by.x="SCC",by.y="SCC",all=TRUE)

