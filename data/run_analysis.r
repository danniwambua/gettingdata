library(dplyr)
library(data.table)

setwd("D:/R-4.0.0/R project assignment/Programming assignment 3/gettingdata/data")

actvitylabel<-read.table("UCI HAR Dataset/activity_labels.txt",col.names=c("activity", "activitydescription"))
features<-read.table("UCI HAR Dataset/features.txt")
testvariables<-data.table(read.table("UCI HAR Dataset/test/X_test.txt"))
testactivity<-read.table("UCI HAR Dataset/test/y_test.txt")
testsubject<-read.table("UCI HAR Dataset/test/subject_test.txt")
testdata<-testsubject %>% cbind(testvariables) %>% cbind(testactivity)  
trainvariables<-data.table(read.table("UCI HAR Dataset/train/X_train.txt"))
trainactivity<-read.table("UCI HAR Dataset/train/y_train.txt")
trainsubject<-read.table("UCI HAR Dataset/train/subject_train.txt")
traindata<-trainsubject  %>% cbind(trainvariables) %>% cbind(trainactivity)

mergedvariables<-rbind(testdata,traindata)
meanstd<-mergedvariables[,c(1,2,3:7,563)]
activitynames<-c("id","meanX","meanY","meanZ","stdX","stdY","stdZ","activity")
names(meanstd)<-(activitynames)
data.table(meanstd)
meanstd %>% group_by(id,activity) %>% summarise_all(mean)