### Coursera Project

#Author : Valcin Pierry 
##############################


##Download the dataset from th url provided if it does not already exist in the working directory.
DataDir <- "./Data"
DataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
DataFilename <- "Data.zip"

DataDFn <- paste(DataDir, "/", "Data.zip", sep = "")
dataDir <- "./data"
##hyug
if (!file.exists(DataDir)) {
  dir.create(DataDir)
  download.file(url = DataUrl, destfile = DataDFn)
}
if (!file.exists(dataDir)) {
  dir.create(dataDir)
  unzip(zipfile = DataDFn, exdir = dataDir)
}

## Read both the train and test datasets and merge them into x(measurements), y(activity) and subject.
library(reshape2)
x_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/Y_train.txt"))
s_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/subject_train.txt"))


x_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/X_test.txt"))
y_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/Y_test.txt"))
s_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/subject_test.txt"))


x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)

###Load the data for feature, activity info and extract columns named 'mean'(`-mean`) and 'standard'(`-std`).
feature <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/features.txt"))


a_label <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/activity_labels.txt"))
a_label[,2] <- as.character(a_label[,2])


selectedCols <- grep("-(mean|std).*", as.character(feature[,2]))
selectedColNames <- feature[selectedCols, 2]
selectedColNames <- gsub("-mean", "Mean", selectedColNames)
selectedColNames <- gsub("-std", "Std", selectedColNames)
selectedColNames <- gsub("[-()]", "", selectedColNames)

##Extract data by selected columns(, and merge x, y(activity) and subject data..

x_data <- x_data[selectedCols]
allData <- cbind(s_data, y_data, x_data)
colnames(allData) <- c("Subject", "Activity", selectedColNames)

allData$Subject <- as.factor(allData$Subject)
allData$Activity <- factor(allData$Activity, levels = a_label[,1], labels = a_label[,2])




Data <- melt(setDT(allData), id = c("Subject", "Activity"))
tidyData <- dcast(Data, Subject + Activity ~ variable, mean)

## Generate 'Tidy Dataset' with write.table() as .txt file in the directory.

write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)

