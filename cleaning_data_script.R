library(reshape2)

#Download and unzip the data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data.zip")
unzip("./data.zip")
# Read feature:
features <- read.table('./UCI HAR Dataset/features.txt')
features[,2] <- as.character(features[,2])
# Read activity:
activityLabels = read.table('./UCI HAR Dataset/activity_labels.txt')
activityLabels[,2] <- as.character(activityLabels[,2])

# mean and standard deviation data extraction
features_1 <- grep(".*mean.*|.*std.*", features[,2])
features_1.names <- features[features_1,2]
features_1.names = gsub('-mean', 'Mean', features_1.names)
features_1.names = gsub('-std', 'Std', features_1.names)
features_1.names <- gsub('[-()]', '', features_1.names)


x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")[features_1]
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
s_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train <- cbind(s_train, y_train, x_train)

x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")[features_1]
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
s_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test <- cbind(s_test, y_test, x_test)

# merge datasets
combined_data <- rbind(train, test)
colnames(combined_data) <- c("subject", "activity", features_1.names)

# turn activities & subjects into factors
combined_data$activity <- factor(combined_data$activity, levels = activityLabels[,1], labels = activityLabels[,2])
combined_data$subject <- as.factor(combined_data$subject)

combined_data.melted <- melt(combined_data, id = c("subject", "activity"))
combined_data.mean <- dcast(combined_data.melted, subject + activity ~ variable, mean)

#Create tidy dataset
write.table(combined_data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
