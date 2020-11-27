# reading files into R.
X_train <- read.table("X_train.txt")
X_test <- read.table("X_test.txt")
y_train <- read.table("y_train.txt")
y_test <-  read.table("y_test.txt")

# Merging the X and Y's.
train <- cbind(X_train, y_train)
test <- cbind(X_test, y_test)

# Renaming the added columns as "outcome"
colnames(train)[length(colnames(train))] <- "outcome"
colnames(test)[length(colnames(test))] <- "outcome"

# Merging the train and test datasets into one.
mergedSamsung <- rbind(train, test)

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

# Let's don't forget the outcome column.
mergedSamsungFiltered <- cbind(mergedSamsungFiltered, mergedSamsung$outcome)
colnames(mergedSamsungFiltered)[length(colnames(mergedSamsungFiltered))] <- "outcome"

# Factorizing the outcome column and change the observations to activity names.
factorized <- factor(mergedSamsungFiltered$outcome)
levels(factorized) <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")

# Replace the outcome column by the factorized observations.
mergedSamsungFiltered$outcome <- factorized

# Changing the entire dataset's column names to names in the features file.
colnames(mergedSamsungFiltered) <- features[meanandstdIndex ,]$V2

# Let's don't forget naming the outcome column as "activity"
colnames(mergedSamsungFiltered)[length(colnames(mergedSamsungFiltered))] <- "activity"

# Creating a second tidy dataset that grops the first dataset by the activity column and the means of the other columns.
groupedDF <- aggregate(mergedSamsungFiltered[, 1:length(colnames(mergedSamsungFiltered))-1], list(mergedSamsungFiltered$activity), mean)
colnames(groupedDF)[1] <- "activity"

# Exporting the second dataset.
write.table(groupedDF, file = "samsungTidied.txt", row.names = FALSE)