# reading files into R.
X_train <- read.table("X_train.txt")
X_test <- read.table("X_test.txt")
y_train <- read.table("y_train.txt")
y_test <-  read.table("y_test.txt")
subject_train <- read.table("subject_train.txt")
subject_test <- read.table("subject_test.txt")

# Merging the X and Y's.
train <- cbind(X_train, subject_train, y_train)
test <- cbind(X_test, subject_test, y_test)

# Merging the train and test datasets into one.
mergedSamsung <- rbind(train, test)

# Renaming the added y column as "outcome"
colnames(mergedSamsung)[length(colnames(mergedSamsung))] <- "outcome"

# Renaming the added subject column as "subject"
colnames(mergedSamsung)[length(colnames(mergedSamsung))-1] <- "subject"

# reading the features file into R.
features <- read.table("features.txt")

# finding the features that include the word "mean" and "std", then save their indexes.
means <- grepl("mean", features$V2, ignore.case = TRUE)
meanIndex <- features[means,]$V1
stds <- grepl("std", features$V2, ignore.case = TRUE)
stdIndex <- features[stds,]$V1

# sorted and combined the indexes. Sorting was just for fun I guess.
meanandstdIndex <- sort(c(meanIndex, stdIndex))

# filter the columns of the merged dataset by the wanted features.
mergedSamsungFiltered <- mergedSamsung[, meanandstdIndex]

# Let's don't forget the outcome and subject columns.
mergedSamsungFiltered <- cbind(mergedSamsungFiltered, mergedSamsung$subject, mergedSamsung$outcome)
colnames(mergedSamsungFiltered)[length(colnames(mergedSamsungFiltered))] <- "outcome"
colnames(mergedSamsungFiltered)[length(colnames(mergedSamsungFiltered))-1] <- "subject"

# Factorizing the outcome column and change the observations to activity names.
factorized <- factor(mergedSamsungFiltered$outcome)
levels(factorized) <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")

# Replace the outcome column by the factorized observations.
mergedSamsungFiltered$outcome <- factorized

# Changing the entire dataset's column names to names in the features file.
colnames(mergedSamsungFiltered) <- features[meanandstdIndex ,]$V2

# Let's not forget naming the outcome column as "activity" and subject column as "subject".
colnames(mergedSamsungFiltered)[length(colnames(mergedSamsungFiltered))] <- "activity"
colnames(mergedSamsungFiltered)[length(colnames(mergedSamsungFiltered))-1] <- "subject"

# We will import the library dplyr for using group_by.
library(dplyr)

# codeblock below groups the mergedSamsungFiltered by two columns (subject and activity) and takes the mean of the rest.
groupedDF <- mergedSamsungFiltered %>% group_by(subject, activity) %>% 
  summarise(across(everything(), mean))

# Exporting the second dataset.
write.table(groupedDF, file = "samsungTidied.txt", row.names = FALSE)