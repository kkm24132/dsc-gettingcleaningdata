# Getting and Cleaning Data - Data Science - Coursera
## Peer assessment project
### Author: Ilias Biris
### Email: ibiris@gmail.com
=====================================================================

# General description of the files and variables involved

This is the repository containing code, resulting tidy dataset and data
cookbook for the submission by Ilias Biris of the peer assessment
project for the Getting and Cleaning Data class.

There are 4 files in the repo:
* README.md: this file you are reading now.
* run\_analysis.R: A R script which contains the main functionality of
working with the specific data set linked to from the course website -
it contains functions and variable definitions which help process the
data and shape it into a new data set that could be considered "tidy"
when seen under the assumptions set by the course project definition.
* Codebook.md: a data "codebook" file; it describes each variable and
  its values in the tidy data set.
* UCI\_HAR\_Dataset\_Tidy.csv: this is the tidy data set which is
  produced by the R script, based on the input data which is made
  available by the course website.

The next few subsections will look at the script and the output tidy
dataset in more detail. Further down there is another section describing
in more detail the script itself and what it does.

## run_analysis.R script
The basic requirement of the project was to assume the data is in place,
at the current working directory. However, I found it interesting to
experiment also with dealing with the lack of data files or with the
situation when a user desires to start directly from the zipfile. This
is tackled by allowing to download the original zipfile again, if the
user desires to work with as "pristine" data as possible. *It should be
clear* that if you run the script "as is" then it will work in the
default mode exactly prescribed by the assessment project instructions.

### How to run the script

The default execution of this script assumes working with the command
line. By default, just open up a terminal, then assuming 

1. you can start R from the commandline
2. you are at the directory where you've deployed the data (so by
default you should have a subdirectory "UCI HAR Dataset" at the working
directory)

you should be able to just start R and then

```
source("run_analysis.R")
```

This will execute the R script with the default options and
assumptions. At the end of the execution you should have a file called
"UCI\_HAR\_Dataset\_Tidy.csv" which contains the tidy data. During the
execution the script prints out some information regarding the actions
it managed to execute and some assumptions it makes - eg where is the
data.

## Output dataset file description

The run\_analysis.R script, if run in the default manner, produces an
output file "UCI\_HAR\_Dataset\_Tidy.csv" which contains the tidy
data. The file contains exactly 181 lines: the top header with the
variable names, followed by a series of 6 observatio rows (1 per
activity) for each of the 30 subjects involved in the original data.

Each row contains values for 68 variables. Here's a short account of
each of these variables:
* id: (Integer) The id of the subject involved in the measurements
* activity: (Factor) the label of the activity involved. Could be one of
  * 1 WALKING
  * 2 WALKING\_UPSTAIRS
  * 3 WALKING\_DOWNSTAIRS
  * 4 SITTING
  * 5 STANDING
  * 6 LAYING
* The remaining columns are numeric. They contain the average (per
  subject and activity) values of the mean or standard deviation of the
  measurements for a total of 66 feature variables which represent the
  following:

  Note: in the names below the prefix 't.' denotes a time domain
  variable, the prefix 'f.' denotes a frequency domain variable. 'xyz'
  denotes 3-axial signals in any one of the X, or Y, or Z
  directions. 'acc' denotes data coming from the accelerometer, 'gyro'
  is for data coming from the gyroscope sensor.
  * **Time domain variables**
	* The acceleration signal is split into body and gravity
      acceleration signals - the mean values of which are indicated as
      t.bodyacc.mean.xyz, t.gravityacc.xyz. The standard deviations are
      indicated as t.bodyacc.std.xyz, t.gravityacc.std.xyz.
    * The magnitude of these signals is indicated by t.bodyaccmag.mean,
      t.bodyaccmag.std, t.gravityaccmag.mean, t.gravityaccmag.std (the
      meaning of 'mean' and 'std' should be obvious by now)
    * The gyroscope signal is just referring to the body itself, the
      signals are under t.bodygyro.mean.xyz, t.bodygyro.std.xyz. The
      magnitude of the signal is under t.bodygyromag.mean and
      t.bodygyromag.std
    * Body linear acceleration and angular velocity have been derived to
      obtain jerk signals - again mean values (t.bodyaccjerk.mean.xyz,
      t.bodygyrojerk.mean.xyz) and standard deviations
      (t.bodyaccjerk.std.xyz, t.bodygyrojerk.std.xyz) are indicated.
    * The magnitude of these signals is under t.bodyaccjerkmag.mean,
      t.bodyaccjerkmag.std, t.bodygyrojerkmag.mean,
      t.bodygyrojerkmag.std.
  * **Frequency domain variables**
    * Then the Fast Fourier Transformation results (FFT) for these
      signals are contained by variables whose name starts with "f."
      indicating the frequency domain. So we have the FFT versions of
      the variables in the time domain: f.bodyacc.mean.xyz,
      f.bodyacc.std.xyz, f.bodyaccjerk.mean.xyz, f.bodyaccjerk.std.xyz,
      f.bodygyro.mean.xyz, f.bodygyro.std.xyz, f.bodyaccmag.mean,
      f.bodyaccmag.std.

# More details about the script

Let's now look at more details about the script itself and how it works.

## Structure of the script

The script contains three clearly outlined areas surrounded by comments:
* the top area contains the defininion of some global constants to use
  for convenience
* the middle area is where the functions which carry out the required
  actions are defined
* the bottom area is where the functions are executed in a way to comply
  with the expectations set out in the peer assessment
  prescriptions. The assumption here is that the global costants are
  not changed in any way for the bottom of the script to execute
  successfuly.


## SECTION 1: Global constants - basic assumptions
The script global constants define
* workWithZippedDatafile: is TRUE if the user wants to use the zipfile
  with the data instead of assuming that the data is unpacked at a local
  directory
* executeDataProcessing: TRUE if the script should actually run the
  functions defined in it. If FALSE then the functions are defined but
  not executed, the user can decide to run these functions as needed.
* webDataSource: a string with the URL where to find the original
  zipfile at. This is expected to be used if work.with.zipped.datafile
  is set to TRUE.
* dataFileZipped: Local filename with the zipped data.
* topDataDir: the top level directory where to expect that the data set
  will be deployed. By default it uses the current working directory as
  a reference.
* dataFileTidy: Local filename for the final "tidy" data set.

## SECTION 2: Functions to break down the processing
There are 3 functions to handle the processing of the data:

* DetermineDataFiles: this is a function which determines which data
  files to use for the processing. It just makes life easier to define
  those filenames once and put them in a list which can be reused
  instead of bulding those filename strings again and again.

  As inputs it has - note that all these inputs have defaults:
  * source.data: source data URL, 
  * result.top.dir: the top data directory, where the data should be
    deployed,
  * local.data.zipped: the local copy of the zipfile,
  * work.with.zipped.data: a flag to indicate whether or not we should
    work with the zipfile or with already deployed data

   The files listed by this function are the following ones (assuming
   the data is in ./data for simplicity) - a description of the files is
   given further below. Each of these files are also checked that they
   exist - the script stops if any of these files are missing :
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

* ProcessAndMergeData: This is the main data processing function in this
  script. It tidies up the data according to the following principles
  (1) Account for all the training and all the test data. Merge the
  training and the test sets to create one data set. (2) Extract only
  the measurements on the mean and standard deviation for each
  measurement. (3) Use descriptive activity names to name the activities
  in the data set. (4) Label the data set with descriptive activity
  names.  The function also orders the data according to the subject
  column. (5) Finally, create a second, independent tidy data set with
  the average of each variable for each activity and each subject.

  As input it expects a list of strings which indicate the names of the
  files containing the data to process.

  In more detail for the functionality this function
  * gets all the activities from the activities, as a data frame with
    columns ID/NAME
  * gets all the feature labels again with columns being
    ID/NAME. Importantly, it attempts to replace any R "significant"
    characters such as parentheses, "-" or "," from the feature name
    values. The feature name values are also turned lower case
	* "t" or "f" at the start of feature names are turned to "t." or
      "f." to make those differing names stand out. Note that this
      should only happen with the starting letter, so there is no need
      to use gsub for this. Calling sub is enough
     * Any "-" or "," are replaced with ".".
     * Any "()" are completely removed - if left around then cases like
       "()-X" will result to something other than just ".X"
     * Any remaining "(" is turned into ".".
     * Any remaining ')' is dropped completely. 
     * The labels of some features in the frequency have duplicate
     "bodybody" strings. Those are replaced with single ones "body" -
     there seems to be no practical reason for the repetition 

  * gets all the test and training subjects as single column data
    frames - it then combines them into 1 single-column data frame using
    rbind
  * gets all the features actual data values per subject - for both test
    and training - as a data frame. It uses the feature labels as column
    names - so it refers to the feature labels data frame from the step
    described above. It combines both test and train data frames into 1
    data frame. Having done that, it proceeds to maintain only the
    feature data which contain the labels ".mean" or ".std" in the
    corresponding feature column names - that in turn leaves only those
    feature columns which express the mean or standard deviation of an
    observation variable. Note that the script takes care not to pick
    those variables which contain the string "meanfreq" - a mean
    frequency is a different function applied to the sensor signals.
    Details about these variables are given in the file Cookbook.md
  * it extracts the activities results per subject (test and train). It
    binds the two data frames into 1. Then it replaces the activities
    values with meaningful names using the activity labels instead.
  * it combines the subjects, data readings and activity labels from the
    previous steps into 1 data frame, then it proceeds to calculate the
    average of each of the columns, per subject and activity (uses
    aggregate to do that)
  * finally it orders the data frame per subject, and returns it.

* WriteTidyDatasetCsv: this function expects
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
   user  system  elapsed 
 33.283   0.946   34.358

```

In fact this script just goes "by the book" in terms of how the data
frames are assembled and joined together and how the aggregation is done
(even though 'aggregate' is not too bad performance-wise). A quick pry
through the execution stack reveals most of the time is actually spent
reading files, so more investigation is needed to determine ways to
improve the performance of this script.





