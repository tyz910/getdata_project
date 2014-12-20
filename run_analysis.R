# download and extract data
if (!file.exists("./data")) {
  dir.create("./data")
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, destfile = "./data/dataset.zip", method = "curl")
  unzip("./data/dataset.zip", exdir = "./data")
}

# reading data
train_subject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
train_x <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("./data/UCI HAR Dataset/train/y_train.txt")

test_subject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
test_x <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("./data/UCI HAR Dataset/test/y_test.txt")

activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./data/UCI HAR Dataset/features.txt")

# merge data  
train <- cbind(train_y, train_subject, train_x)
test <- cbind(test_y, test_subject, test_x)
data <- rbind(train, test)

# set names
feature_names <- as.vector(features[[2]])
names(data) <- c('activity', 'subject', feature_names)

# extract mean and std data
ms_data <- data[, c('activity', 'subject', feature_names[grep('mean|std', feature_names)])]

# set activity names
activity_names <- activity_labels[[2]]
ms_data$activity <- activity_names[ms_data$activity]

# aggregate to tidy data
tidy_data <- aggregate(. ~ activity + subject, ms_data, FUN = mean)
write.table(tidy_data, file="./tidy_data.txt", row.name = FALSE)
