## This script assumes that the following files from the UCI HAR
## dataset have already been loaded into R with the specified 
## variable names.

## activity_labels.txt: activity_labels
## features.txt: features
## /test/subject_test.txt: subject_test
## /test/X_test.txt: x_test
## /test/y_test.txt: y_test
## /train/subject_train.txt: subject_train
## /train/X_train.txt: x_train
## /train/y_train.txt: y_train

library(dplyr)
library(reshape2)

## Part 1
## Merge the training and the test sets to create one data set.

# Combine the x, y, and subject sets from testing and training groups
x <- rbind(x_test, x_train)
y <- rbind(y_test, y_train)
subject <- rbind(subject_test, subject_train)

# Add column names to x as specified in features.txt
colnames(x) <- features$V2

# Put the subject, y, and x data frames into a single data frame
data <- cbind(subject, y, x)

# Update the header names of subject and y columns
names(data)[1] <- "subject"
names(data)[2] <- "activityCode"

# Clean up column names
names(data) <- gsub("BodyBody", "Body", names(data), fixed=FALSE)
names(data) <- gsub("mean", "Mean", names(data), fixed=FALSE)
names(data) <- gsub("std", "Std", names(data), fixed=FALSE)
names(data) <- gsub(",gravity", "Gravity", names(data), fixed=FALSE)
names(data) <- gsub("\\(", "", names(data), fixed=FALSE)
names(data) <- gsub("\\)", "", names(data), fixed=FALSE)
names(data) <- gsub("-", "", names(data), fixed=FALSE)

## Part 2
## Extract only the measurements on the mean and standard deviation 
## for each measurement.

data <- data[,grepl("subject|activityCode|mean|std", colnames(data), ignore.case=TRUE)]

## Part 3
## Use descriptive activity names to name the activities in the 
## data set

data <- merge(activity_labels, data, by.x="V1", by.y="activityCode")
names(data)[1] <- "activityCode"
names(data)[2] <- "activityName"

## Part 4
## Appropriately label the data set with descriptive variable names. 

# Part 4 was already done in Part 1, which used the features variable as the 
# column headers for the x data frame

## Part 5
## From the data set in step 4, create a second, independent tidy data
## set with the average of each variable for each activity and each subject.

meltData <- melt(data, id=c("subject", "activityName"), measure.vars=4:89)
summaryData <- dcast(meltData, subject + activityName ~ variable, mean)