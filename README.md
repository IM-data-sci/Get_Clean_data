
Downloaded the zip file to the working directory using download.file.
Unzipped the file to begin analysis
read.table for the small files to get an idea of their dimensions. 

Found that the x_train.txt and X_test files have 7352 and 2947 rows respectively. 
They have 561 columns. 
Column labels are features.txt for both files.
Row labels are y_test(or train).txt and subject_test(or train).txt


Step 1: Merges the training and the test sets to create one data set.
  Added column labels (features.txt, factor) to x_test(or train).txt to describe data better. Changed column type in features.txt to character from factor.  
  Added columns (for Subjects and Activities) to the left of x_test(or train).txt; used cbind.
  Merged x_test.txt and X_train.txt data by rows (as they have the same number of columns); used rbind. Alternatively, these could have been done after step 2. 


Step 2: Extracted only measurements on mean and standard deviation for each measurement. 
  Used grep on features.txt to isolate column numbers for mean and std. Made an ordered list containing both sets (mean and std). 
  Trimmed x_test.txt and X_train.txt using the list to reduce file size. New columns (for Subjects and Activities) could be added and a more efficient (faster) rbind process resulted in the merged data set.


Step 3: Uses descriptive activity names to name the activities in the data set
  Changed the numerical codes for y_test(and train).txt to the descriptions in activity_labels.txt. This was done prior to cbind. Cleanup of data included lower case descriptions.


Step 4: Appropriately labeled the data set with descriptive variable names. 
  Changed column labels by removing brackets, dots, extraneous names (body), and making all letters lower case.


Step 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
  Split the data set by activities and by subject. The resulting matrices (79 rows, and 6 columns for activity and 30 columns for subjects) were merged using cbind to obtain a 79(rows) x 36(columns) matrix (c.txt). 

  I also split the data by both factors simultaneously,as I was not sure how to present the data. This resulted in a 79 (rows) x 180(column) matrix (b.txt).

