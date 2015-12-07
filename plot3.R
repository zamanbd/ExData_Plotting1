# #######################################################################################
# This script download the required file and process it, if it is not done yet 
#  and plot the 3rd figure in file plot3.png
# The URL of the file is 
#  https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
# original file is read using fread function for faster operation
# The original zipped file is unzipped and desired subsets are retrieved using temporary 
# file and saved in a file 'desirdedData.txt' - temporary files and data are removed as
# well. Once processed, the script will look for the processed file and will not repeat 
# the process 
# #####################################################################################

##########################################################################
# Load Data - this part is same as plot1.R but utilized processed file   # 
##########################################################################

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

# retrieve date & time in required format
dateAndTime <- strptime(paste(powerData$Date, powerData$Time), format = "%d/%m/%Y %H:%M:%S")

# retrieve subMetering data sets
subMet1 <- as.numeric(powerData$Sub_metering_1)
subMet2 <- as.numeric(powerData$Sub_metering_2)
subMet3 <- as.numeric(powerData$Sub_metering_3)

# set png device for ploting
png("plot3.png", width = 480, height = 480)

# plot

plot(dateAndTime, subMet1, type = "l", # line type, subMet1 plotted
     xlab = "",                        # to avoid var name as xlbael
     ylab = "Energy sub metering")     # no title
# add subMet2
lines(dateAndTime, subMet2, col="red", type = "l")
# add subMet 3
lines(dateAndTime, subMet3, col="blue", type = "l")

# add legend

legend("topright",
       legend = c("Sub_metering_1",   #legend captions
                  "Sub_metering_2",
                  "Sub_metering_3"
                  ),
       col = c("black",               # legend color, legend border is default
               "red",
               "blue"
               ),
       lty = 1
       
       )

# done, now off the device
dev.off()


