# Getting and Cleaning Data - Data Science - Coursera
# Peer assessment project
# Author: Ilias Biris
# Email: ibiris@gmail.com
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
user desires to work with as "pristine" data as possible. *It should
clear* that if you run the script "as is" then it will work in the
default mode exactly prescribed by the assessment project instructions.


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

## Global variables - basic assumptions
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

## Functions to break down the processing
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

## Default execution

If the top variable execute.data.processing is set to TRUE then this
last part of the script simply executes all the functions defined above
in sequence to get the resulting CSV file with the tidy data set. If
none of the global variables were changed, then the execution is
expected to fully comply with the requirements set by the project
definition.

## What else to note
### Performance

This script is not very fast. Taking a basic timing via system.time the
whole script as executed by default shows the following times:

```
   user  system elapsed
 39.578   1.182  42.537
```

In fact this script just goes "by the book" in terms of how the data
frames are assembled and joined together and how the aggregation is
done. As such it takes some 39+ seconds to complete. Possible
optimisations to try out as next step would be

* The aggregate function could be 



