#download the file and set up the working directory
setwd('C:/Users/Lenovo/Documents/Online-Courses/Getting and Cleaning Data/Project')
urlfile="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(urlfile,"cleaningdata_project.zip",method="curl")
unzip(zipfile="cleaningdata_project.zip",exdir ="cleaningdata_project")
setwd("cleaningdata_project/UCI HAR Dataset")


#Read training files

x_train = read.table("train/X_train.txt")
y_train = read.table("train/y_train.txt")
subject_train = read.table("train/subject_train.txt")

#Read test files
x_test = read.table("test/X_test.txt")
y_test = read.table("test/y_test.txt")
subject_test = read.table("test/subject_test.txt")

#Read feature files
features = read.table("features.txt")

#Read activity labels
activity_labels = read.table("activity_labels.txt")



#Labelize the features (columns) in the training set and testing set
colnames(x_train)=features[,2]
colnames(x_test)=features[,2]

#labelize the y_train and y_test columns
colnames(y_train)=c("activity_ID")
colnames(y_test)=c("activity_ID")

#labelize the subject's column in the training and testing set
colnames(subject_train)=c("subject_ID")
colnames(subject_test)=c("subject_ID")

#Labelize the features' columns
colnames(features)=c("variable_ID","variable_name")

#Labelized the activity_labels' columns
colnames(activity_labels)=c("activity_ID","activity_name")


#combine the training datasets
train_data = cbind(x_train,y_train,subject_train)
colnames(train_data)

#combine the test datasets
test_data = cbind(x_test,y_test,subject_test)
colnames(test_data)

#Merges the training and the test sets to create one data set
data_allset = rbind(train_data,test_data)

#Extracts only the measurements on the mean and standard deviation for each measurement
data_mean_std = data_allset[,grep("mean|std|activity_ID|subject_ID",names(data_allset)) ]

#Appropriately labels the data set with descriptive variable names.
data_activity_label=merge(data_mean_std,activity_labels,by ="activity_ID",all.x = TRUE)

#independent tidy data set with the average of each variable for each activity and each subject

data_step5=aggregate(data_activity_label[,!grepl("^activity_name|^activity_ID|^subject_ID",names(data_activity_label))],list(data_activity_label$activity_name,data_activity_label$subject_ID),mean,na.rm=TRUE,na.action=NULL)

write.table(data_step5,"tidyset.txt")

