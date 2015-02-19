# readme

by nocebo
19th of february 2015

this readme is part of an assignment in coursera's "john hopkins university: getting and cleaning data", presented in nocebo's repository "getting an cleaning data"

## content of the nocebo's repository "gettingandcleaningdata"

- readme: explains how all of the scripts work and how they are connected.

- run_analysis.R: runs a script to tidy up the data of [1].

- codebook: describes the variables, the data, and any transformations or work that are performed by run_analysis.r to clean up the original data.

## requirements

the script run_analysis.r is in need of the following **packages**:

- dplyr

- reshape2

please install the packages before running this script (install.packages("dplyr"), install.packages("reshape2").

the script run_analysis.r needs the **data** [1] in a folder "UCI HAR Dataset" within the current working directory. the data can be obtained [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

## credits and references

- **dplyr**: hadley wickham [aut, cre], romain francois [aut], rstudio [cph]

- **reshape2**: hadley wickham

- **dataset** [1]: davide anguita, alessandro ghio, luca oneto, xavier parra and jorge l. reyes-ortiz. human activity recognition on smartphones using a multiclass hardware-friendly support vector machine. international workshop of ambient assisted living (iwaal 2012). vitoria-gasteiz, spain. dec 2012

- my **ideas of tidy data**: hadley wickham. tidy data. journal of statistical software, vol. 59, issue 10, sep 2014.

## what does run_analysis.r do?

run_analysis.r is a script of multiple functions. the first few steps are performed within a function called *combine_data()*

combine_data():

- reads in the data [1], stored in a folder "UCI HAR Dataset". this data consists of measurements of features during a certain activity performed by subjects divided in a training set and a test set.

- combines the different sets of data together

- combines the measured observations with their activity and subject

- extracts only calculated means and standard deviations from the data

- alters the names of the features

- assigns descriptive activity names

run_analysis then calls other functions, which:

- group the data in respect to subjects and activities and summarise (mean) each measured feature in respect to the grouping

- melt the tidy data in wide table format into a long table format for easy read-outs

- display the final version of the data *tidy_long*


## detailed description of each step performed by run_analysis.r

(you can find a short description within run_analysis.r as well)

load dyplr 
> library(dplyr)
load reshape2
> library(reshape2)

let's call a function including all the steps of cbinding and rbinding the raw data and renaming the variables to keep our environment clean.
> combine_data <- function(){

read in the data. there are two datasets we are interested in: a training set (X_train.txt) and a test set (X_test.txt).
> training_set <- read.table("UCI HAR Dataset/train/X_train.txt")
> test_set <- read.table("UCI HAR Dataset/test/X_test.txt")

 put the two together, because we want one large file of all the observations, whether it is from the training set or the test set.
 > rbind() combines the rows of the tables training_set and test_set and creates one large data frame "data".
 > data <- rbind(training_set, test_set)

read in the features. as stated in the readme.txt file of the dataset, features.txt provides the variables to the measurements now stored in the data frame data.
> features <- read.table("UCI HAR Dataset/features.txt")

assign the features as column names to the data frame, but we only need the second column of the table features.
> colnames(data) <- features[, 2]

read in the subject data. at the moment data only consists of variables with the appropriate observations. but we would like to know to which subject each measurement belongs. as stated in the readme.txt file of the dataset, this information is stored in subject_train.txt and subject_test.txt.
> training_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
> test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

put the two together, because we want one large file of all the observations, whether it is from the training set or the test set.
> subjects <- rbind(training_subjects, test_subjects)
rename the columnname for future use.
> colnames(subjects) <- "subjects"

read in the activities. up to this moment we don't know, which activities had been performed during the measurements providing the observations. but we would like to know to which activity each measurement belongs. as stated in the readme.txt file of the dataset, this information is stored in y_train.txt and y_test.txt.
> activity_train <- read.table("UCI HAR Dataset/train/y_train.txt")
> activity_test <- read.table("UCI HAR Dataset/test/y_test.txt")

put the two together, because we want one large file of all the observations, whether it is from the training set or the test set.
> activity <- rbind(activity_train, activity_test)
rename the columnname for future use.
> colnames(activity) <- "activity"

we are only interested in the mean and standard-deviation (std) of all activities. if we take a look at the columnnames in data (provided by features), we see a naming pattern for mean and std, which we can use to subset our data. the function grepl() searches for matches to the pattern we provide within the columnnames and passes them to the subset. we now create a data frame *data_of_interest*, which only contains the values to the variables mean and std.
> data_of_interest <- data[grepl("mean[()]|std[()]", colnames(data))]

after we specifically used some specialities in the naming of the variables, it's time to clean them up: we don't want any operators within the column names of *data_of_interest*, which might confuse r. let's get rid of minuses and brackets. we can replace them with underscores. because sometimes a minus comes after a bracket in the original naming, we create long underscores, which we replace with a single underscore in the next step. this looks better.
> colnames(data_of_interest) <- gsub("-|[()]|,", "_",  colnames(data_of_interest))
> colnames(data_of_interest) <- gsub("__|___", "_",  colnames(data_of_interest))

finally we are ready to put *data_of_interest*, *subjects*, and *activity* together. *full_data* now contains the measurements to each variable we are interested in (mean and std), linked with the subjects and their activity.
> full_data <- cbind(subjects, activity, data_of_interest)

at the moment, the activities are still coded by numbers (class labels), but we would like descriptive activity names. assign descriptive activity names to the class labels. the arguments are levels 1 to 6 (as described in the readme.txt file in the dataset) and their acording labels "walking", "standing", etc. levels are in the first column of the descriptive_activity vector, labels in the second.
> descriptive_activity <- read.table("UCI HAR Dataset/activity_labels.txt")
> full_data$activity <- factor(full_data$activity, levels = descriptive_activity[, 1], labels = descriptive_activity[, 2])

write *full_data* into the output of the function *combine_data()*
> full_data
> }

we want the output of *combine_data()* in a variable, so we can use it in our last steps.
> combined_data <- combine_data()

now we want the average of each activity for each subject. first we group the data according to two values: subjects and activities
> tidy_wide <-
>  combined_data %>%
>  group_by(subjects, activity) %>%
>  summarise_each(funs(mean))

tidy_wide is the solution to question 5 in the assignment. it's a table in the wide format. as i've been reading hadley wickham's "tidy data" (see credtis) i realized that tidy data is better presented in a long format. this is mostly personal preference, wide and long format may be used - i would like to follow hadley wickham here and present my tidy data in the long format table.

for the transformation of a wide table into a long table we can use the function melt(){reshape2}. melt() needs to know the ids and the measurements. that's why we create the vector melt_id first, which contains the columnnames of the measurements of *tidy_wide*.
> tidy_long <- melt(tidy_wide, id = c("subjects", "activity"), measure.vars = colnames(tidy_wide)[3:68])
assign appropriate columnnames
> colnames(tidy_long)[3] <- "feature"

pop the final table up for inspection
> View(tidy_long)

tidy_long is my final version of this dataset. i hope that the reviewers agree with me.