#You should create one R script called run_analysis.R that does the following.

library(dplyr)
library(data.table)

#getting the data
if(!file.exists("./data")){
  dir.create("./data")
 fileUrl<-("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
 download.file(fileUrl,"./data")
}

setwd("./data")


#data cleaning
activitylabel<-read.table("UCI HAR Dataset/activity_labels.txt",col.names=c("activity", "activitydescription"))
features<-read.table("UCI HAR Dataset/features.txt")
testvariables<-data.table(read.table("UCI HAR Dataset/test/X_test.txt"))
names(testvariables)<-features$V2
testactivity<-read.table("UCI HAR Dataset/test/y_test.txt")
testsubject<-read.table("UCI HAR Dataset/test/subject_test.txt")
testdata<-testsubject %>% mutate(subject ="candidate",.before=NULL)%>% cbind(testvariables) %>% cbind(testactivity)    
trainvariables<-data.table(read.table("UCI HAR Dataset/train/X_train.txt"))
names(trainvariables)<-features$V2
trainactivity<-read.table("UCI HAR Dataset/train/y_train.txt")
trainsubject<-read.table("UCI HAR Dataset/train/subject_train.txt")
traindata<-trainsubject  %>% mutate(subject ="trainer",.before=NULL) %>% cbind(trainvariables) %>% cbind(trainactivity) 

#Merges the training and the test sets to create one data set.
mergedvariables<-rbind(testdata,traindata)

#Appropriately labels the data set with descriptive variable names.
meanstd1<-mergedvariables[,c(1,2,564)]
activitynames<-c("id","subject","activity")
names(meanstd1)<-(activitynames)

#Extracts only the measurements on the mean and standard deviation for each measurement.
meanstd2<-mergedvariables%>% select(contains(c("mean","std")))
meanstd<-cbind(meanstd1,meanstd2)
 

#Uses descriptive activity names to name the activities in the data set
for(i in 1:6){meanstd["activity"][meanstd["activity"]==i]<-activitylabel[i,]$activitydescription}


#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data.table(meanstd)
meanstd %>% group_by(subject,id,activity) %>% summarise(across(c(contains("mean","std")),mean)) 
