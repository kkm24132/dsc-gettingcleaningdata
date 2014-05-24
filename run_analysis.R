## run_analysis.R
## Code submitted as part of the required deliverables for the peer
## assessment project of the Getting and Cleaning Data class within the
## Data Science Coursera course

## AUTHOR: Ilias Biris <ibiris@gmail.com>

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation
##    for each measurement.
## 3. Uses descriptive activity names to name the activities in the
##    data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of
##    each variable for each activity and each subject.

## Initial assumptions

## Even though there is a requirement for the script to assume that the
## data is in place, I found it interesting to experiment with enabling
## also dealing with the lack of data files - this is tackled by
## downloading the original zipfile again, if the user desires to work
## with as "pristine" data as possible. If the script is run "as is"
## then it will work in the default mode which is exactly what the peer
## assessment project instructions request.

###############################################################
## Global variables definition area 
###############################################################

## The processing of the data and preparation of a tidy data set can be
# executed in a sequence of function calls below. If the execution of
# those functions is not desired, this flag can be set to FALSE. Then
# the function and global variable definitions remain to be perused by
# the user as s/he sees fit
execute.data.processing <- TRUE

## If the user desires to start from scratch - downloading the zip file
# and working with it directly then the next flag should be set to
# true. Otherwise the assumption is that the input (dirty) data is
# already deployed under top.data.dir directory
work.with.zipped.datafile <- FALSE

## URL where to find the original zipfile
web.data.source <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Top working directory to contain the zip file and the unzipped
# contents
WD <- getwd()
top.data.dir  <- paste(ifelse(is.null(WD),".",WD), "/UCI\ HAR\ Dataset", sep="")

## Local filename with the zipped data
data.file.zipped <- "./UCI_HAR_Dataset.zip"

## Local filename for the final "tidy" data set
data.file.tidy <- "UCI_HAR_Dataset_Tidy.csv"

###############################################################
## Functions definition area 
###############################################################
## Process steps below - each step is expressed as a new function
# that takes the given input and returns some output. The functions can
# also be used separately for debugging as well as to determine the
# outputs at different stages of this implementation

## FUNCTION determine.data.files
##
## Inputs: source.data: source data URL, result.top.dir: the top data
##         directory, where the data should be deployed,
##         local.data.zipped: the local copy of the zipfile,
##         work.with.zipped.data: a flag to indicate whether or not we
##         should work with the zipfile or with already deployed data
## Output: The function returns a list of all the data filenames needed
## for the next step
## Functionality: Some basic checks and preparation of the data for
## further processing. First ensure that the top data directory is a
## directory (if it exists). If the process should go on working with
## zipped data then check if the zip file exists, if not download in the
## data directory, and unzip it. The bottom part after the conditionals
## just deals with the collection of the filenames which should be used
## further on, as well as checking that each of the needed files is in
## place. 

determine.data.files <- function (source.data=web.data.source,
                                  result.top.dir=top.data.dir,
                                  local.data.zipped=data.file.zipped,
                                  work.with.zipped.data=work.with.zipped.datafile) {
    if( work.with.zipped.data ) {

        #first make sure that there is no ordinary file with the same
        #name as the target data directory
        if(file.exists(result.top.dir) && !file_test("-d", result.top.dir)) {
            stop("Top data directory location: \"", result.top.dir, "\" meant for data processing, exists as ordinary file!\n")
        }
        
        # To unzip the data into the result.top.dir, we need that
        # directory to be in place. So, create it if it's not there
        # already
        if(!file.exists(result.top.dir)) {
            dir.create(result.top.dir)
        }

        cat("Working with the zip file \"", local.data.zipped, "\"\n")

        # if we are working with zipped data, we need to download the
        # file if it's not there and create the directory for the data
        # to expand in
        if(!file.exists(local.data.zipped)) {
            cat("Downloading zip file from \"", source.data, "\"\n")
            download.file(source.data, local.data.zipped, method="curl")
        }


        # ok all is ready now -  unzip the data
        cat("Unzipping zip file \"", local.data.zipped, "\"\n")
        unzip(local.data.zipped, overwrite=TRUE, exdir=result.top.dir)
    } else {
        # Not working with the zipfile directly. Do some basic checks
        # because in this case the data should already be in the current
        # working directory

        cat("Assuming the data is available in  directory \"", result.top.dir, "\"\n")
        
        # if the top data directory is not a directory (either it is a
        # "normal" file or is not there at all) then stop
        if(file.exists(result.top.dir) && !file_test("-d", result.top.dir)) {
            stop("Top data directory location: \"", result.top.dir, "\" used for data processing, is not a directory!\n")
        } else if(!file.exists(result.top.dir)) {
            stop("Top data directory location: \"", result.top.dir, "\" used during data processing, does not exist!\n")
        }
    }

    # this is a common check for either when we are working with zipfile
    # or not: check that the expected data files are in place. If not,
    # then perhaps the zipfile was corrupt/wrong.
    data.files <- list(activities=paste(result.top.dir,"activity_labels.txt", sep="/"),
                       features  =paste(result.top.dir,"features.txt",sep="/"),
                       subject.test   =paste(result.top.dir,"test", "subject_test.txt", sep="/"),
                       subject.train  =paste(result.top.dir,"train", "subject_train.txt", sep="/"),
                       xtest     =paste(result.top.dir,"test", "X_test.txt", sep="/"),
                       xtrain    =paste(result.top.dir,"train", "X_train.txt", sep="/"),
                       ytest     =paste(result.top.dir,"test", "y_test.txt", sep="/"),
                       ytrain    =paste(result.top.dir,"train", "y_train.txt", sep="/"))
    sapply(data.files,
           function(x) {
               if(!file.exists(x)) {
                   stop("File: \"", x, "\" doesn't exist. Stopping!\n")
               }})
    
    return(data.files)
}

## FUNCTION process.and.merge.data
##
## Inputs: list.data.files: a list of strings indicating the filenames
##         for the files that should be processed.
## Output: The data frame with the "tidy data"
##
## Functionality: Tidy up the data according to the following principles
## (1) Account for all the training and all the test data. Merge the
## training and the test sets to create one data set. (2) Then extract
## only the measurements on the mean and standard deviation for each
## measurement. (3) Use descriptive activity names to name the
## activities in the data set. (4) Label the data set with descriptive
## activity names.  The function also orders the data according to the
## subject column. (5) Finally, create a second, independent tidy data
## set with the average of each variable for each activity and each
## subject.
process.and.merge.data <- function(list.data.files) {
    # if the list is NULL or empty then stop. 
    if(is.null(list.data.files) || length(list.data.files) == 0) {
        stop("The list of data files to use for data processing is null/empty!\n")
    }
    
    # get all the activities - as a data frame with 2 columns (ID and NAME)
    activities <- read.table(list.data.files$activities, header=FALSE, col.names=c("ID","NAME"))
    cat("Processing ... Got all the activities\n")

    # get all the feature names - time and frequency based variables
    # (values are in X dataset below) - as a data frame of 2 columns
    # (ID and NAME)
    features   <- read.table(list.data.files$features, header=FALSE,col.names=c("ID","NAME"))
    cat("Processing ... Got all the feature names\n")
    
    # get all test and train subjects and combine them in a single
    # 1-column data frame
    subject.test  <- read.table(list.data.files$subject.test, header=FALSE, col.names=c("ID"))
    subject.train <- read.table(list.data.files$subject.train, header=FALSE, col.names=c("ID"))
    subjects <- rbind(subject.train, subject.test)
    cat("Processing ... Got all the subjects (train/test)\n")

    
    # get the features actual data per subject(test and training), use
    # the feature labels for column names
    data.test.X  <- read.table(list.data.files$xtest, header=FALSE, col.names=features$NAME)
    data.train.X <- read.table(list.data.files$xtrain, header=FALSE, col.names=features$NAME)
    data.X <- rbind(data.test.X, data.train.X)
    cat("Processing ... Got all the feature values (train/test)\n")
    
    # extract only the mean and stddev for each of the measurements
    data.X <- data.X[,grep("mean|std",features$NAME)]

    # get the activities results per subject (test and train)
    data.test.Y  <- read.table(list.data.files$ytest, header=FALSE, col.names=c("ACTIVITY"))
    data.train.Y <- read.table(list.data.files$ytrain, header=FALSE, col.names=c("ACTIVITY"))
    data.Y <- rbind(data.test.Y, data.train.Y)
    cat("Processing ... Got all the activities results (train/test)\n")
    
    # replace the activities values with meaningful names using the
    # activity labels instead
    data.Y$ACTIVITY <- activities[data.Y$ACTIVITY,]$NAME
    
    # combine the subjects, data readings and activity labels in 1 data
    # frame
    interm.dfrm <- cbind(subjects, data.X, data.Y)
    
    # calculate the averages of the data values per subject and activity
    result.dfrm <- aggregate(interm.dfrm[,grep("mean|std",names(interm.dfrm))],
                             by=list(ID=interm.dfrm$ID,
                                 ACTIVITY=interm.dfrm$ACTIVITY),
                             FUN ="mean")
    
    # order the rows per subject
    result.dfrm <- result.dfrm[order(result.dfrm$ID),]
    cat("Finished aggregating and ordering the data into a data frame\n")
    return(result.dfrm)
    
}


## FUNCTION write.tidy.dataset.csv
##
## Inputs: in.dfrm: a data frame which contains the list of values to be
## written out, out.csv.file: the filename for the CSV file to be
## produced, appendl: TRUE/FALSE logical value whether or not to append
## the data in the CSV file if it pre-exists.
##
## Output: No output. Collateral: create the CSV file (if not there) and
## write out the values from the input data frame
##

write.tidy.dataset.csv <- function (in.dfrm,
                                    out.csv.file=data.file.tidy,
                                    appendl=FALSE) {
    if(is.null(in.dfrm)) {
        stop("The input data frame to function 'create.tidy.dataset' cannot be NULL!\n")
    }
    cat("Writing out the \"tidy\" data into a csv file \n")
    write.table(in.dfrm,
                out.csv.file,
                append=appendl,
                sep=",", row.names=FALSE, col.names=names(in.dfrm))
}


###############################################################
## Default execution of the functions area 
###############################################################
# Overall processing, if the top variable execute.data.processing is
# TRUE then simply execute all functions in sequence to get the
# resulting CSV file. If nothing is changed with the Global variables at
# the top, then the following lines execute the functions precisely in
# the way expected by the peer assessment project prescription.

if(execute.data.processing) {
    write.tidy.dataset.csv(in.dfrm=process.and.merge.data(list.data.files=determine.data.files()))
    
}

