#The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.
#The goal is to prepare tidy data that can be used for later analysis. 
#You will be graded by your peers on a series of yes/no questions related to the project. 
#You will be required to submit: 
#1) a tidy data set as described below, 
#2) a link to a Github repository with your script for performing the analysis, and 
#3) a code book that describes the variables, the data, and any transformations or work that you performed 
#to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. 
#This repo explains how all of the scripts work and how they are connected. 

#One of the most exciting areas in all of data science right now is wearable computing - see for example this article . 
#Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#Here are the data for the project:
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#You should create one R script called run_analysis.R that does the following. 
#1) Merges the training and the test sets to create one data set.
#2) Extracts only the measurements on the mean and standard deviation for each measurement. 
#3) Uses descriptive activity names to name the activities in the data set
#4) Appropriately labels the data set with descriptive variable names. 
#5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

#loading Libraries
library(plyr)


#Extract the features
features <- read.table("features.txt",sep="",stringsAsFactors=F)

#Extract Test
test_subject <- read.table("test/subject_test.txt", sep="", stringsAsFactor=F, col.names="id")
test_x <- read.table("test/X_test.txt", sep="", stringsAsFactor=F, col.names=features$V2)
test_y <- read.table("test/y_test.txt", sep="", stringsAsFactor=F, col.names="activity")
test<- cbind(test_subject, test_x, test_y)

#Extract Train
train_subject <- read.table("train/subject_train.txt", sep="", stringsAsFactor=F, col.names="id")
train_x <- read.table("train/X_train.txt", sep="", stringsAsFactor=F, col.names=features$V2)
train_y <- read.table("train/y_train.txt", sep="", stringsAsFactor=F, col.names="activity")
train<- cbind(train_subject, train_x, train_y)

#Merge Test and Train
data <- rbind(train, test)
data <- arrange(data, id)

#Extracts only the measurements on the mean and standard deviation for each measurement.
mean_and_std <- data[,c(1,2,grep("std", colnames(data)), grep("mean", colnames(data)))]

#Appropriately labels the data set with descriptive variable names
activity_lbl <- read.table("activity_labels.txt", sep="", stringsAsFactors = F)
data$activity <- factor(data$activity, levels=activity_lbl$V1, labels=activity_lbl$V2)

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_dataset <- ddply(mean_and_std, .(id), .fun=function(x){ colMeans(x[,-c(1:2)]) })
colnames(tidy_dataset)[-c(1:2)] <- paste(colnames(tidy_dataset)[-c(1:2)], "_mean", sep="")

file <- paste("tidy_dataset.csv" ,sep="")
write.csv(tidy_dataset,file)