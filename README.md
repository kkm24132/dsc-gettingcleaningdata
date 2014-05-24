# Getting and Cleaning Data - Data Science - Coursera
## Peer assessment project
### Author: Ilias Biris
### Email: ibiris@gmail.com
=====================================================================

This is the repository containing code, resulting tidy dataset and data
cookbook for the submission by Ilias Biris of the peer assessment
project for the Getting and Cleaning Data class.

The script is run_analysis.R. The script contains numerous comments to
explain its function but here are some basic instructions on its
structure, how to run it and what to expect as result.

The basic requirement of the project was to assume the data is in place,
at the current working directory. However, I found it interesting to
experiment also with dealing with the lack of data files or with the
situation when a user desires to start directly from the zipfile. This
is tackled by allowing to download the original zipfile again, if the
user desires to work with as "pristine" data as possible. *It should be
clear* that if you run the script "as is" then it will work in the
default mode exactly prescribed by the assessment project instructions.

## How to run the script

By default just open up a terminal and assuming you are at the location
where you've cloned this repository you should be able to just run R and then

```
source("run_analysis.R")
```

This will execute the R script with the default options and
assumptions. At the end of the execution you should have a file called
"UCI\_HAR\_Dataset\_Tidy.csv" which contains the tidy data. During the
execution the script prints out some information regarding the
assumptions it makes and the actions it takes. 

## Output file description

The run\_analysis.R script, if run in the default manner, produces an
output file "UCI\_HAR\_Dataset\_Tidy.csv" which contains the tidy
data. The file contains exactly 181 lines: the top header with the
variable names, followed by a series of 6 observatio rows (1 per
activity) for each of the 30 subjects involved in the original data.

Each row contains values for 81 variables. Here's a short account of each of these variables:
* ID: (Integer) The id of the subject involved in the measurements
* ACTIVITY: (Factor) the label of the activity involved. Could be one of
  * 1 WALKING
  * 2 WALKING\_UPSTAIRS
  * 3 WALKING\_DOWNSTAIRS
  * 4 SITTING
  * 5 STANDING
  * 6 LAYING
* The remaining columns are numeric and contain the mean or standard deviation of the measurements for a total of 79 feature variables which represent the following. Note: in the names below the prefix 't' denotes time, the prefix 'f' denotes frequency; 'XYZ' denotes 3-axial signals in any one of the X, or Y, or Z directions:
  * the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ - 
    * The acceleration signal is split into body and gravity acceleration signals (tBodyAcc-XYZ, tGravityAcc-XYZ)
    * Body linear acceleration and angular velocity have been derived to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ)
    * The magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).
  * The result of a Fast Fourier Transform (FFT) applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

Additionally, each variable may have the qualifier 'mean' in its name which indicates the measure is the mean value, or 'std' which indicates the value is the standard deviation, or 'meanFreq' which indicates the value is the weighted average of the frequency components to obtain a mean frequency.




## Structure of the script
The script contains three areas outlined by clear comments:
* the top area contains the defininion of some global variables to use
  for convenience
* the middle area is where the functions which carry out the required
  actions are defined
* the bottom area is where the functions are executed in a way to comply
  with the expectations set out in the peer assessment
  prescriptions. The assumption here is that the global variables are
  not changed in any way for the bottom of the script to execute
  successfuly.


## SECTION 1: Global variables - basic assumptions
The script global variables define
* work.with.zipped.datafile: is TRUE if the user wants to use the
  zipfile with the data instead of assuming that the data is unpacked at
  a local directory
* execute.data.processing: TRUE if the script should actually run the
  functions defined in it. If FALSE then the functions are defined but
  not executed, the user can decide to run these functions as needed.
* web.data.source: a string with the URL where to find the original
  zipfile at. This is expected to be used if work.with.zipped.datafile
  is set to TRUE.
* data.file.zipped: Local filename with the zipped data. 
* top.data.dir: the top level directory where to expect that the data
  set will be deployed. By default it uses the current working directory
  as a reference.
* data.file.tidy: Local filename for the final "tidy" data set. 

## SECTION 2: Functions to break down the processing
There are 3 functions to handle the processing of the data:

* determine.data.files: this is a function which determines which data
  files to use for the processing. It just makes life easier to define
  those filenames once and put them in a list which can be reused
  instead of bulding those filename strings again and again.

  As inputs it has - note that all these inputs have defaults:
  * source.data: source data URL, 
  * result.top.dir: the top data directory, where the data should be deployed, 
  * local.data.zipped: the local copy of the zipfile, 
  * work.with.zipped.data: a flag to indicate whether or not we should
    work with the zipfile or with already deployed data

   The files listed by this function are the following ones (assuming
   the data is in ./data for simplicity) - a description of the files is
   given further below. Each of these files are also checked that they
   exist - the scripts stops if any of these files are missing :
  * ./data/activity_labels.txt
  * ./data/features.txt
  * ./data/test/subject_test.txt
  * ./data/train/subject_train.txt
  * ./data/test/X_test.txt
  * ./data/train/X_train.txt
  * ./data/test/y_test.txt
  * ./data/train/y_train.txt

  All these entries to the output list are labelled properly so that
  subsequent processing functions can use the labels to extract
  filenames.

* process.and.merge.data: This is he main data processing function in
  this script.It tidies up the data according to the following
  principles (1) Account for all the training and all the test
  data. Merge the training and the test sets to create one data set. (2)
  Extract only the measurements on the mean and standard deviation for
  each measurement. (3) Use descriptive activity names to name the
  activities in the data set. (4) Label the data set with descriptive
  activity names.  The function also orders the data according to the
  subject column. (5) Finally, create a second, independent tidy data
  set with the average of each variable for each activity and each
  subject.

  As input it expects a list of strings which indicate the names of the
  files containing the data to process.

  In more detail for the functionality this function
  * gets all the activities from the activities, as a data frame with
    columns ID/NAME
  * gets all the feature labels again with columns being ID/NAME
  * gets all the test and training subjects as single column data
    frames - it then combines them into 1 single-column data frame using
    rbind
  * gets all the features actual data per subject - for both test and
    training. It uses the feature labels as column names - so it refers
    to the feature labels data frame from the step described above. It
    combines both test and train dta into 1 data frame. Having done
    that, it proceeds to maintain only the feature data which contain
    the labels "mean" or "std" in the column names
  * it extracts the activities results per subject (test and train). It
    binds the two data frames into 1. Then it replaces the activities
    values with meaningful names using the activity labels instead.
  * it combines the subjects, data readings and activity labels from the
    previous steps into 1 data frame, then it proceeds to calculate the
    averages of the data values, per subject and activity (uses
    aggregate to do that)
  * finally it orders the data frame per subject, and returns it.

* write.tidy.dataset.csv: this function expects
  * in.dfrm: a data frame which contains the list of values to be
    written out
  * out.csv.file: the filename for the CSV file to be produced
  * appendl: TRUE/FALSE logical value whether or not to append the data
    in the CSV file if that file already exists
	
	After it checks that the input data frame is not null it uses
    write.table to write the data frame into the output file.

## SECTION 3: "Default" execution

If the top variable execute.data.processing is set to TRUE, then will
the last section of the script executes all the functions defined above
in a sequence. The result is a CSV file with the tidy data set. The
default execution is expected to fully comply with the requirements set
by the project definition.

## What else to note
### Performance

Taking a basic timing via system.time the whole script as executed by
default shows the following times (system used: Lenovo Thinkpad T510i i5
processor, 8GB RAM):

```
   user  system elapsed
 39.578   1.182  42.537
```

In fact this script just goes "by the book" in terms of how the data
frames are assembled and joined together and how the aggregation is done
(even though 'aggregate' is not too bad performance-wise). A quick pry
through the execution stack reveals most of the time is actually spent
reading files, so perhaps there is not much one can do to improve the
performance of this script.





