#install.packages("dplyr")
#install.packages("tidyr")
library(plyr)
library(tidyr)
library(dplyr)

#Change this to your current working directory and make sure the data is saved there
setwd("C:/Users/computer/Desktop/airquality/assignment3")
getwd()

## The Plan
## Seperate and consolidate respective x Train and Test data and y Train and Test data
##Assign all data into variables that will then be combined into a single data set later 


# Creating the variables that will eventually be combined into one data set
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# Combining the data based on type x, y, or subject_Train
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)




# Reads features data into variable
features <- read.table("features.txt")

#This selects and stores the indexes of all strings in the second column of features that
#match the words mean or std. This will be used to select the target data from X_data
mean_and_std_features <- grep("(mean|std)", features[, 2], ignore.case = TRUE)

# This selects all rows from the x_data df that have the words mean or std 
# and saves it to x_data (X training and test data)
x_data <- x_data[, mean_and_std_features]

#Rename the columns in x_data to give more descriptive titles 
names(x_data) <- features[mean_and_std_features, 2]

#read and store activity data in variable
activities <- read.table("activity_labels.txt")

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"


# correct column name
names(subject_data) <- "subject"

# combine all data into single data frame using rbind
all_data <- cbind(x_data, y_data, subject_data)

##Getting average of subject and activity
#all_data <- ColMeans(all_data(c(subject, activity)))
data1 <- gather(all_data,variable, value,1:86)
data1 %>% 
  group_by(subject,activity,variable) %>% 
  summarize(variable_mean=mean(value)) -> tidydataset
write.table(tidydataset,"tidydataset.txt", row.names = FALSE)
