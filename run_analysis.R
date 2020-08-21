library(dplyr)

features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

colnames(x_test) <- features$V2; colnames(x_train) <- features$V2
colnames(subject_test) <- "subject"; colnames(subject_train) <- "subject"
colnames(activities) <- c("code_a", "activity")
colnames(features) <-c("code_f","func")
colnames(y_test) <- "code_a"; colnames(y_train) <- "code_a"

training_data <- cbind(subject_train, y_train, x_train)
testing_data <- cbind(subject_test, y_test, x_test)
all_subject_data <- rbind(training_data, testing_data)

mean_f <- features[grepl("mean",features$func, ignore.case = TRUE),]
std_f <- features[grepl("std",features$func, ignore.case = TRUE),]
measurements <- rbind(mean_f,std_f)

extracted <- select(all_subject_data, subject, code_a,measurements$func)

extracted$code_a <- activities[extracted$code_a , 2]

names(extracted)[2] = "activity"
names(extracted)<-gsub("Acc", "Accelerometer", names(extracted))
names(extracted)<-gsub("Gyro", "Gyroscope", names(extracted))
names(extracted)<-gsub("BodyBody", "Body", names(extracted))
names(extracted)<-gsub("Mag", "Magnitude", names(extracted))
names(extracted)<-gsub("^t", "Time", names(extracted))
names(extracted)<-gsub("^f", "Frequency", names(extracted))
names(extracted)<-gsub("tBody", "TimeBody", names(extracted))
names(extracted)<-gsub("-mean()", "Mean", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("-std()", "STD", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("-freq()", "Frequency", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("angle", "Angle", names(extracted))
names(extracted)<-gsub("gravity", "Gravity", names(extracted))

final<- extracted %>% group_by(subject, activity) %>% summarise_all(funs(mean))

