# #######################################################################################
# This script download the required file and process it, if it is not done yet 
#  and plot the first figure in file plot1.png
# The URL of the file is 
#  https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
# original file is read using fread function for faster operation
# The original zipped file is unzipped and desired subsets are retrieved using temporary 
# file and saved in a file 'desirdedData.txt' - temporary files and data are removed as
# well. Once processed, the script will look for the processed file and will not repeat 
# the process 
# #####################################################################################

################
# Load Data    # 
################

library(data.table) # for fread
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if(file.exists("desiredData.txt")){ #processed file exists
        print("file already downloaded and processed...")
        
} else # download the file and process it 
{
        tempFile <- tempfile() # download as a temporary file
        download.file(fileUrl, tempFile)
        
        # read and load the whole file - as my computer permits (alternate is to use readLines) 
        dataAll <- fread(unzip(tempFile, "household_power_consumption.txt"), na.strings = "?") #missing values are coded as "?"
        unlink(tempFile) # unlink tempFile
        
        #find the index of desired data
        dIndex <- grep("^[1,2]/2/2007", dataAll$Date)
        requiredData <- dataAll[dIndex,] #keep the data that only of our interest
        
        # write the data.table to an equivalent text file in the working directory - to be used by project assignments
        write.table(requiredData,"desiredData.txt", row.names = FALSE )
        # clean up  temp vars used by this script
        rm("dataAll", "fileUrl", "dIndex", "requiredData", "tempFile")  
        
}

### clean data ready to load - using fread to cover both cases
powerData <- fread("desiredData.txt")

# get globalActivePower for plot 1
globalActivePower <- as.numeric(powerData$Global_active_power)

# set png device for ploting
png("plot1.png", width = 480, height = 480)

# plot a histogram to the png device
hist(globalActivePower, main = "Global Active Power",   # title
     xlab = "Global Active Power (kilowatts)",          # label of x-axix
     ylab = "Frequency",                                # y-axis label
     col = "red"                                        # color for the bar
     )

# device should be off

dev.off()


