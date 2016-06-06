# run_analysis.R
#Created By: Sreekanth Jonnalagadda
#Description: Submitted for Project Assignment
#
library(dplyr)
library(reshape2)

#Source File downloaded from the url
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

SRC_DATADIR <- "/home/sreekanth/Documents/quiz1_data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset"

# This will allow us to use activity names
activities   <- read.table(file= paste(SRC_DATADIR, "activity_labels.txt", sep = "/"), 
                           col.names = c("Activity.ID", "Activity.Name"))
ACT_test       <- read.table(paste(SRC_DATADIR, "test", "ACT_test.txt",        sep = "/"),
                           col.names = c("Activity.ID"))
actvty <- merge(ACT_test, activities, by.x="Activity.ID", by.y="Activity.ID")
Activity     <- actvty[,2]

# Create a vector of feature names
# This will allow us to apply the column names to the data
features     <- read.table(paste(SRC_DATADIR, "features.txt", sep ="/"), 
                           col.names = c("Feature.Number", "Feature.Name"))
features     <- features[,2]

# Create a data.frame of the subject
subject_test <- read.table(file = paste(SRC_DATADIR, "test", "subject_test.txt", sep = "/"),
                           col.names = c("Subject"))

# Read in the test data and apply the feature column names
x_test       <- read.table(file = paste(SRC_DATADIR, "test", "X_test.txt", sep = "/"),
                           col.names = features)

# Combine the subject, activity, and test data.frames into one data.frame
test_data    <- cbind(subject_test, Activity, x_test)

# Combine Training Data
# This is very similar to the above, but for the training data
y_train       <- read.table(paste(SRC_DATADIR, "train", "y_train.txt",        sep = "/"),
                            col.names = c("Activity.ID"))
actvty  <- merge(y_train, activities, by.x="Activity.ID", by.y="Activity.ID")
Activity      <- actvty[,2]

subject_train <- read.table(file = paste(SRC_DATADIR, "train", "subject_train.txt", sep = "/"),
                            col.names = c("Subject"))
x_train       <- read.table(file = paste(SRC_DATADIR, "train", "X_train.txt", sep = "/"),
                            col.names = features)

train_data    <- cbind(subject_train, Activity, x_train)
data          <- rbind(test_data, train_data)
data_mean_std <- data[,c("Subject",
                         "Activity",
                         grep("mean|std", colnames(data), value=TRUE))
                      ]

# melt the data by subject/activity
sub_act_data  <- melt(data_mean_std, id.vars=c("Subject","Activity"))

# cast the data by subject/activity and calculate the average of the variables
tidy_data     <- dcast(sub_act_data, Subject + Activity ~ variable, mean)

# write the tidy_data to a file
write.table(tidy_data, row.name=FALSE, file = "tidy_data.txt")

# Output just the column names of tidy_data for CodeBook.md
#cat(names(tidy_data), sep="\n")
