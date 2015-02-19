## This script is in need of the following packages: dplyr, reshape2. Please install the packages before
## running this script (install.packages("dplyr"), install.packages("reshape2").

## This script is in need of the full dataset (see credits) in a folder called "UCI HAR Dataset"
## within the current working directory.

## Credits
## dplyr: Hadley Wickham [aut, cre], Romain Francois [aut], RStudio [cph]
## reshape2: Hadley Wickham
## dataset: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz.
  ## Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine.
  ## International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
## ideas of tidy data: Hadley Wickham. Tidy Data. Journal of Statistical Software, Vol. 59, Issue 10,
  ## Sep 2014.

## Please consider reading the ReadMe.md file in the repository "Getting and Cleaning Data" for a detailed
## description of each step performed by this script.

## load dyplr
library(dplyr)
## load reshape2
library(reshape2)

## let's call a function including all the steps of cbinding and rbinding the raw data and renaming the variables
## to keep our environment clean.

combine_data <- function(){
  
## read in the data
training_set <- read.table("UCI HAR Dataset/train/X_train.txt")
test_set <- read.table("UCI HAR Dataset/test/X_test.txt")

  ## put the two together
  data <- rbind(training_set, test_set)

## read in the features
features <- read.table("UCI HAR Dataset/features.txt")

## assign the features as column names to the new big data set
colnames(data) <- features[, 2]

## read in the subject data
training_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

  ## put the two together
  subjects <- rbind(training_subjects, test_subjects)
  ## rename
  colnames(subjects) <- "subjects"

## read in the activities
activity_train <- read.table("UCI HAR Dataset/train/y_train.txt")
activity_test <- read.table("UCI HAR Dataset/test/y_test.txt")

  ## put the two together
  activity <- rbind(activity_train, activity_test)
  ## rename
  colnames(activity) <- "activity"

## we are only interested in the mean and standard-deviation of all activities
data_of_interest <- data[grepl("mean[()]|std[()]", colnames(data))]

## now we rename the columns of data_of_interest with names wihtout operators
colnames(data_of_interest) <- gsub("-|[()]|,", "_",  colnames(data_of_interest))
colnames(data_of_interest) <- gsub("__|___", "_",  colnames(data_of_interest))

## put data_of_interest, subjects, and activity together
full_data <- cbind(subjects, activity, data_of_interest)

## assign descriptive activity names to the class labels. the arguments are levels 1 to 6 (as described
## in the readme file) and their acording labels "walking", "standing", etc. levels are in the first
## column of the descriptive_activity vector, labels in the second.
descriptive_activity <- read.table("UCI HAR Dataset/activity_labels.txt")

full_data$activity <- factor(full_data$activity, levels = descriptive_activity[, 1], 
                             labels = descriptive_activity[, 2])
full_data
}

combined_data <- combine_data()

## now we want the average of each activity for each subject
## first we group the data according to two values: subjects and activities
tidy_wide <-
  combined_data %>%
  group_by(subjects, activity) %>%
  summarise_each(funs(mean))

## tidy_wide is the solution to question 5 in the assignment. it's a table in the wide format. as stated in
## hadley wickhams "tidy data" (see credits), the long format should be prefered.

## melt(){reshape2} is able to transform a wide table into a long table, needing the distinction between
## ids and measurements.
tidy_long <- melt(tidy_wide, id = c("subjects", "activity"), measure.vars = colnames(tidy_wide)[3:68])
## assign appropriate columnnames
colnames(tidy_long)[3] <- "feature"

## pop the final table up for inspection
View(tidy_long)