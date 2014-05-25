# Getting and Cleaning Data - Data Science - Coursera
## Peer assessment project - cookbook for the data
### Author: Ilias Biris
### Email: ibiris@gmail.com
=====================================================================

The UCI\_HAR\_Dataset\_Tidy.csv table contains eighty eight (88)
fields. Excluding the first two fields, the remaining 86 provide the
averages of the mean and standard deviation of a number of observations
coming from data originally obtained by mobile device sensors,
accelerometer (acc) and gyroscope (gyro).

## Variables involved

* id: integer - an id for the subject (person) from where the data came. Valued between 1 and 30 (inclusive)
* activity: factor - a set of label to identify the activity for which
  the data is provided. Values are:
  * LAYING
  * SITTING
  * STANDING
  * WALKING
  * WALKING\_DOWNSTAIRS
  * WALKING\_UPSTAIRS
* time domain variables
    * t.bodyacc.mean.x: numeric - time domain - the mean of the body
      acceleration signal in the X dimension
    * t.bodyacc.mean.y: numeric - time domain - the mean of the body
      acceleration signal in the Y dimension
    * t.bodyacc.mean.z: numeric - time domain - the mean of the body
      acceleration signal in the Z dimension
    * t.bodyacc.std.x: numeric - time domain - the standard deviation of
      the body acceleration signal in the X dimension
    * t.bodyacc.std.y: numeric - time domain - the standard deviation of
      the body acceleration signal in the Y dimension
    * t.bodyacc.std.z: numeric - time domain - the standard deviation of
      the body acceleration signal in the Z dimension
    * t.gravityacc.mean.x: numeric - time domain - the mean of the
      gravity acceleration signal in the X dimension
    * t.gravityacc.mean.y: numeric - time domain - the mean of the
      gravity acceleration signal in the X dimension
    * t.gravityacc.mean.z: numeric - time domain - the mean of the
      gravity acceleration signal in the Z dimension
    * t.gravityacc.std.x: numeric - time domain - the standard deviation
      of the gravity acceleration signal in the X dimension
    * t.gravityacc.std.y: numeric - time domain - the standard deviation
      of the gravity acceleration signal in the Y dimension
    * t.gravityacc.std.z: numeric - time domain - the standard deviation
      of the gravity acceleration signal in the Z dimension
    * t.bodyaccjerk.mean.x: numeric - time domain - the mean of the jerk
      signal in the X dimension (derived from the body acceleration mean
      signal)
    * t.bodyaccjerk.mean.y: numeric - time domain - the mean of the jerk
      signal in the Y dimension (derived from the body acceleration mean
      signal)
    * t.bodyaccjerk.mean.z: numeric - time domain - the mean of the jerk
      signal in the Z dimension (derived from the body acceleration mean
      signal)
    * t.bodyaccjerk.std.x: numeric - time domain - the standard
      deviation of the jerk signal in the X dimension (derived from the
      body acceleration standard deviation signal in the X dimension)
    * t.bodyaccjerk.std.y: numeric - time domain - the standard
      deviation of the jerk signal in the Y dimension (derived from the
      body acceleration standard deviation signal in the Y dimension)
    * t.bodyaccjerk.std.z: numeric - time domain - the standard
      deviation of the jerk signal in the Z dimension (derived from the
      body acceleration standard deviation signal in the Z dimension)
    * t.bodygyro.mean.x: numeric - time domain - the mean of the body
      angular speed signal in the X dimension signal)
    * t.bodygyro.mean.y: numeric - time domain - the mean of the body
      angular speed signal in the Y dimension
    * t.bodygyro.mean.z: numeric - time domain - the mean of the body
      angular speed signal in the Z dimension
    * t.bodygyro.std.x: numeric - time domain - the standard deviation
      of the body angular speed signal in the X dimension
    * t.bodygyro.std.y: numeric - time domain - the standard deviation
      of the body angular speed signal in the Y dimension
    * t.bodygyro.std.z: numeric - time domain - the standard deviation
      of the body angular speed signal in the Z dimension
    * t.bodygyrojerk.mean.x: numeric - time domain - the mean of the
      body angular acceleration signal in the X dimension
    * t.bodygyrojerk.mean.y: numeric - time domain - the mean of the
      body angular acceleration signal in the Y dimension
    * t.bodygyrojerk.mean.z: numeric - time domain - the mean of the
      body angular acceleration signal in the Z dimension
    * t.bodygyrojerk.std.x: numeric - time domain - the standard
      deviation of the body angular acceleration signal in the X
      dimension
    * t.bodygyrojerk.std.y:numeric - time domain - the standard
      deviation of the body angular acceleration signal in the Y
      dimension
    * t.bodygyrojerk.std.z: numeric - time domain - the standard
      deviation of the body angular acceleration signal in the Z
      dimension
    * t.bodyaccmag.mean: numeric - time domain - the mean of the body
       acceleration signal magnitude
    * t.bodyaccmag.std: numeric - time domain - the standard deviation
       of the body acceleration signal magnitude
    * t.gravityaccmag.mean: numeric - time domain - the mean of the
       gravity acceleration signal magnitude
    * t.gravityaccmag.std: numeric - time domain - the standard
       deviation of the gravity acceleration signal magnitude
    * t.bodyaccjerkmag.mean: numeric - time domain - the mean of the
       body acceleration jerk signal magnitude
    * t.bodyaccjerkmag.std: numeric - time domain - the standard
       deviation of the body acceleration jerk signal magnitude
    * t.bodygyromag.mean: numeric - time domain - the mean of the
       angular speed signal magnitude
    * t.bodygyromag.std: numeric - time domain - the standard deviation
       of the angular speed signal magnitude
    * t.bodygyrojerkmag.mean: numeric - time domain - the mean of the
       angular acceleration signal magnitude
    * t.bodygyrojerkmag.std: numeric - time domain - the standard
       deviation of the angular acceleration signal magnitude
* frequency domain variables : obtained from the time domain, via a fast
  fourier transform. 
    * f.bodyacc.mean.x: numeric - frequency domain - the mean of the
      body acceleration signal in the X dimension
    * f.bodyacc.mean.y: numeric - frequency domain - the mean of the
      body acceleration signal in the Y dimension
    * f.bodyacc.mean.z: numeric - frequency domain - the mean of the
      body acceleration signal in the Z dimension
    * f.bodyacc.std.x: numeric - frequency domain - the standard
      deviation of the body acceleration signal in the X dimension
    * f.bodyacc.std.y: numeric - frequency domain - the standard
      deviation of the body acceleration signal in the Y dimension
    * f.bodyacc.std.z: numeric - frequency domain - the standard
      deviation of the body acceleration signal in the Z dimension
    * f.bodyaccjerk.mean.x: numeric - frequency domain - the mean of the
      jerk signal in the X dimension (derived from the body acceleration
      mean signal in the frequency domain)
    * f.bodyaccjerk.mean.y: numeric - frequency domain - the mean of the
      jerk signal in the Y dimension (derived from the body acceleration
      mean signal in the frequency domain)
    * f.bodyaccjerk.mean.z: numeric - frequency domain - the mean of the
      jerk signal in the Z dimension (derived from the body acceleration
      mean signal in the frequency domain)
    * f.bodyaccjerk.std.x: numeric - frequency domain - the standard
      deviation of the jerk signal in the X dimension (derived from the
      body acceleration mean signal in the frequency domain)
    * f.bodyaccjerk.std.y: numeric - frequency domain - the standard
      deviation of the jerk signal in the Y dimension (derived from the
      body acceleration mean signal in the frequency domain)
    * f.bodyaccjerk.std.z: numeric - frequency domain - the standard
      deviation of the jerk signal in the Z dimension (derived from the
      body acceleration mean signal in the frequency domain)
    * f.bodygyro.mean.x: numeric - frequency domain - the mean of the
      body angular speed signal in the X dimension signal)
    * f.bodygyro.mean.y: numeric - frequency domain - the mean of the
      body angular speed signal in the Y dimension signal)
    * f.bodygyro.mean.z: numeric - frequency domain - the mean of the
      body angular speed signal in the Z dimension signal)
    * f.bodygyro.std.x: numeric - frequency domain - the standard
      deviation of the body angular speed signal in the X dimension
      signal)
    * f.bodygyro.std.y: numeric - frequency domain - the standard
      deviation of the body angular speed signal in the Y dimension
      signal)
    * f.bodygyro.std.z: numeric - frequency domain - the standard
      deviation of the body angular speed signal in the Z dimension
      signal)
    * f.bodyaccmag.mean: numeric - frequency domain - the mean of the
       body acceleration signal magnitude
    * f.bodyaccmag.std: numeric - frequency domain - the standard
       deviation of the body acceleration signal magnitude
    * f.bodyaccjerkmag.mean: numeric - frequency domain - the mean of
       the body acceleration jerk signal magnitude
    * f.bodyaccjerkmag.std: numeric - frequency domain - the standard
       deviation of the body acceleration jerk signal magnitude
    * f.bodygyromag.mean: numeric - frequency domain - the mean of
       the body angular velocity signal magnitude
    * f.bodygyromag.std: numeric - frequency domain - the standard
       deviation of the body angular velocity signal magnitude
    * f.bodygyrojerkmag.mean: numeric - frequency domain - the mean of
       the body angular acceleration signal magnitude
    * f.bodygyrojerkmag.std: numeric - frequency domain - the standard
       deviation of the body angular acceleration signal magnitude
