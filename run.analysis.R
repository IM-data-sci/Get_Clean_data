
## Download file and unzip it

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./Data/UCI_HAR_Dataset.zip") 


unzip("./Data/UCI_HAR_Dataset.zip", files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = FALSE, exdir = ".", unzip = "internal",
      setTimes = FALSE)

## Read pertinent files to glean information from them

features <- read.table("./UCI HAR Dataset/features.txt")
features <- transform(features, V2 = as.character(V2))

s_t <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(s_t) <- "Subjects"

x_t <- read.table("./UCI HAR Dataset/test/X_test.txt", nrows=2960)
colnames(x_t) <- features[,2] # use features as column names  

y_t <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_t <- transform(y_t, V1 = as.character(V1))
names(y_t) <- "Activities"

s_tr <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(s_tr) <- "Subjects"

x_tr <- read.table("./UCI HAR Dataset/train/X_train.txt", nrows=7360)
colnames(x_tr) <- features[,2] # use features as column names 

y_tr <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_tr <- transform(y_tr, V1 = as.character(V1))
names(y_tr) <- "Activities"

## Select certain columns from dataset

features2 <- grep("mean()",features$V2) # select all mean() values from features 
features3 <- grep("std()",features$V2) # select all std() values from features 
mean_sd <- sort(c(features2,features3)) # make an ordered vector from features subsets

x_t <- x_t[,mean_sd] # subset 561 entries by interested features 
x_tr <- x_tr[,mean_sd] # trim large file to 79 columns 

## Add columns for Activities and Subjects to x_test and x_train sets

library(gsubfn)
tmp <- list("1"="walking", "2"="walkupstairs", "3"="walkdownstairs", "4"="sitting", "5"="standing", "6"="lyingdown") 
# replace numbers in column 1 with descriptions from tmp
y_t[,1] <- gsubfn('.', tmp, y_t[,1]) 
y_tr[,1] <- gsubfn('.', tmp, y_tr[,1])
# Add columns to test and train data
x_t <- cbind(s_t,y_t,x_t)
x_tr <- cbind(s_tr,y_tr,x_tr)

## Merge data from test and train into one set using rbind

data <- rbind(x_t,x_tr)

## Save data at this point as backup

write.table(data, file = "./Data/uci_data.txt", append = FALSE, quote = FALSE, sep = ",",eol = "\n", na = "NA", 
            dec = ".", row.names = FALSE,col.names = TRUE, qmethod = c("escape", "double"),fileEncoding = "")

## Change column names to make tidier

data <- transform(data, Subjects = as.factor(Subjects)) # factor w 30 levels after transform
name <- names(data) # extract out column names for processing
name <- tolower(name) # all lower case names
name <- gsub("\\.","",name,) # remove dots(.)
name <- gsub("body","",name,) # remove body, as most data is measured on it
names(data) <- name # re-insert column names post processing

## Save data at this point as backup

write.table(data, file = "./Data/uci_data_2.txt", append = FALSE, quote = FALSE, sep = ",",eol = "\n", na = "NA", 
            dec = ".", row.names = FALSE,col.names = TRUE, qmethod = c("escape", "double"),fileEncoding = "")

## Create new dataset with average for each activity and each subject

a <- split(data,data$activities, drop=FALSE) # split data set by activities
t <- sapply(a, function(x) colMeans(x[,name[3:81]])) # make matrix with variable column means and activities  
s <- split(data,data$subjects, drop=FALSE) # split data set by subjects
u <- sapply(s, function(x) colMeans(x[,name[3:81]])) # make matrix with variable column means and subjects 

c <- cbind(t,u) # combined results for activities and subjects (79 rows and 36 columns)

b <- split(data, list(data$activities,data$subjects), drop=TRUE) # split by activity for each subject
b <- sapply(b, function(x) colMeans(x[,name[3:81]])) # make matrix with 180 columns and 79 rows

## Save either b or c as text files for submission

write.table(c, file = "./Data/c.txt", append = FALSE, quote = FALSE, sep = ",",eol = "\n", na = "NA", 
            dec = ".", row.names = FALSE,col.names = TRUE, qmethod = c("escape", "double"),fileEncoding = "")



