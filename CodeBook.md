# codebook

by nocebo
19th of february 2015

this codebook is part of an assignment in coursera's "john hopkins university: getting and cleaning data", presented in nocebo's repository "getting an cleaning data".
this codebook describes the variables, the data, and any transformations or work that are performed by run_analysis.r to clean up the original data.

## created data by run_analysis.r

run_analysis.r creates the following data:

- *combined_data*: the full data = all the observations of the measured features assigned to the subjects and the activities.

- *tidy_wide*: this is a data frame in the wide format (tidy data) and contains the average of the observations of a specific subject and activity.

- ** _tidy_long_ **: *tidy_long* is my interpretation of tidy data. it's a table in the long format containing the same information as *tidy_wide* but displayed in another way. data analysis should be easier in a long format table. *tidy_long* is created by using melt(){reshape2}. i was inspired by hadley wickham (see credits in readme).

- *combine_data()*: a function including all the steps of cbinding and rbinding the raw data and renaming the variables. 

## variables in *tidy_long*

the final data frame *tidy_long* contains the following variables:

- **subjects**: the id of the subject performing the activities.
- **activity**: the descriptive activity performed during the measurements.
- **feature**: the feature being measured during the activity.
- **value**: the value of the measured feature, the mean of the means and standard deviations.

## transformations performed by run_analysis.r

run_analysis.r performs the following transformations of the original data (sorted chronologically):

- rbind() of training_set and test_set (-> *data*).

- assigning column names/the variables to data by using features.txt.

- rbind() of training_subjects and test_subjects (-> *subjects*).

- assigning the new column name "subjects" to the combined list of subjects.

- rbind() of activity_train and activity_test (-> *activity*).

- assigning the new column name "activity" to the combined list of activities.

- subsetting data by column names/the features containing "mean()" or "std()" (-> *data_of_interest*).

- altering the column names/the features by replacing "-" or "()" with "_".

- altering the column names/the features by replacing "__" (double underscore introduced in the step before) or "___" (triple underscore introduced in the step before) with "_" (single underscore).

- cbind() of subjects, activity, and data_of_interest (-> *full_data*).

- replacing the class numbers coding the activities by their corresponding descriptive name using activity_labels.txt.

- grouping of full_data by subjects and activities and summarising the observations of each feature with respect to subjects and activities (-> *tidy_wide*).

- melting the wide table format into a tidy long table format (-> *tidy_long*).

- assigning the new column name "feature" to column 3 of the data frame *tidy_long*.

## the function combine_data() creates the following data in the process

- *activity*: this is a data frame combining *activity_test* and *activity_train*. it is used to assign the performed activities to the observations. the activities are coded in class numbers.

- *activity_test*: this is a data frame containing the performed activities as class numbers in the test set.

- *activity_train*: this is a data frame containing the performed activities as class numbers in the training set.

- *data*: this is a data frame containing all the raw observations of the training set and the test set. it does not provide any variables.

- *data_of_interest*: this is a data frame containing only the calculated variables mean and standard deviation of each measured feature.

- *descriptive_activities*: this is a data frame used to assign descriptive variable names instead of the class numbers provided in activity.

- *features*: this is a data frame containing the measured features during the activities. it provides the variable names to the raw observations stored in data.

- *full_data*: this is a data frame containing *data_of_interest*, *activity*, and *subjects*. full_data includes all the observations of a feature during a activity of a subject.

- *subjects*: this is a data frame combining *test_subjects* and *training_subjects*. it is used to assign the subjects to the observations.

- *test_set*: this is a data frame containing the raw observations of the test set. it does not provide any variables.

- *test_subjects*: this is a data frame containing the subjects in the test set.

- *training_set*: this is a data frame containing the raw observations of the training set. it does not provide any variables.

- *training_subjects*: this is a data frame containing the subjects in the training set.