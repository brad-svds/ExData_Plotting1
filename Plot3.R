#thanks for looking at my work - any advice would be much appreciated
#since I didn't know where my charts would end up on your computer, I set the working directory to home.

as.numeric.factor <- function(x) {as.numeric(levels(x))[x]}

setwd("~")
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
power <- read.table(unz(temp, "household_power_consumption.txt"), header = TRUE, sep = ";", stringsAsFactors = FALSE)
unlink(temp)

#once the .txt file has been extracted, I go through changing the values from char to numeric
#"Time" doesn't matter until the 2nd chart, so you'll find the "DateTime" transform is only in the 3 final files
#this takes a fair bit of time and is computationally heavy - any advice you have on how to pull only the files I
#need (or for exploring the data without having to store it in memory) would be very helpful.

power$Date <- strptime(power$Date, format = "%d/%m/%Y", tz = "")
#power$Time <- as.POSIXlt(power$Time, format = "%H:%M:%S")
power$Global_active_power<-as.numeric(power$Global_active_power) 
power$Global_reactive_power<-as.numeric(power$Global_reactive_power) 
power$Voltage<-as.numeric(power$Voltage) 
power$Global_intensity<-as.numeric(power$Global_intensity) 
power$Sub_metering_1<-as.numeric(power$Sub_metering_1)
power$Sub_metering_2<-as.numeric(power$Sub_metering_2)
power$Sub_metering_3<-as.numeric(power$Sub_metering_3)

#I now clean the transformed data down to a "specific_power" dataframe that I use to create the plots
specific_power1 <- power[power$Date == "2007-02-01", ]
specific_power2 <- power[power$Date == "2007-02-02", ]
specific_power <- rbind(specific_power1, specific_power2)
specific_power$DateTime <- paste(specific_power$Date, specific_power$Time, sep=' ')
specific_power$DateTime <- strptime(specific_power$DateTime, format = "%Y-%m-%d %H:%M:%S", tz = "")

#Plot 3

plot(specific_power$DateTime, specific_power$Sub_metering_1, ylim=range(c(specific_power$Sub_metering_1,
     specific_power$Sub_metering_2, specific_power$Sub_metering_3)), type="l", xlab="", ylab = "Energy Sub Meeting")
legend("topright", lty=c(1,1,1), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd=c(2.5,2.5,2.5), col=c("black","red", "blue")) 

par(new = TRUE)
plot(specific_power$DateTime, specific_power$Sub_metering_2, ylim=range(c(specific_power$Sub_metering_1,
     specific_power$Sub_metering_2, specific_power$Sub_metering_3)), axes = FALSE, type="l", xlab="", 
     ylab = "", col = "red")

par(new = TRUE)
plot(specific_power$DateTime, specific_power$Sub_metering_3, ylim=range(c(specific_power$Sub_metering_1,
     specific_power$Sub_metering_2, specific_power$Sub_metering_3)), axes = FALSE, type="l", xlab="", 
     ylab = "", col = "blue")

#I noticed my legend shows differently in the .png as compared to graphically in RStudio.
dev.print(png, width = 480, height = 480, file = "plot3.png")
dev.off()
