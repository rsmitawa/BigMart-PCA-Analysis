# Setting data directory to read/write files
setwd("/home/ramesh/Documents/Data_Science/AV_Projts/Big Mart Sales III")

# Loading all the required libraries
library(data.table)
library(tidyverse) #NOTE:Loading data.table first to use tidyverse functions for default
library(fastDummies)
library(rpart)
library(rattle)

# Reading data files -----------------------------------------------------------

train_df <- fread("train_kOBLwZA.csv", stringsAsFactors = TRUE)
test_df <- fread("test_t02dQwI.csv", stringsAsFactors = TRUE)
submis_df <- fread("SampleSubmission_TmnO39y_Jw0L2VF.csv", stringsAsFactors = TRUE)

# Merging train and test for analysis, will separate later to avoid data leakage
main_df <- rbindlist(l = list(train_df, test_df), idcol = TRUE, fill = TRUE)

# Replacing NA's with median
main_df$Item_Weight[is.na(main_df$Item_Weight)] <- median(main_df$Item_Weight, na.rm = TRUE)
main_df$Item_Visibility <- ifelse(main_df$Item_Visibility == 0, 
                                  median(main_df$Item_Visibility, na.rm = TRUE), 
                                  main_df$Item_Visibility)
levels(main_df$Outlet_Size)[1] <- "Other"

# Removing Non-informative columns and independent variable 
final_df <- main_df[,-c(1, 2, 7, 13)]

# Making dummy cols of categorical data
new_dummy_df <- fastDummies::dummy_cols(.data = final_df, 
                                        select_columns = colnames(select_if(final_df, is.factor)),
                                        remove_most_frequent_dummy = TRUE, 
                                        remove_selected_columns = TRUE)

# Splitting data into train and test, No data leakage
pca_train_df <- new_dummy_df[1:nrow(train_df)]
pca_test_df <- new_dummy_df[-(1:nrow(train_df))]

# Applying PCA on the training set
princ_comp <- prcomp(x = pca_train_df, scale. = TRUE)
pr_std_dev <- princ_comp$sdev
pr_var <- pr_std_dev ^ 2
pr_varex <- pr_var / sum(pr_var) 

# plotting PCA for each column, and for cumsum
plot(pr_varex, type = "b")
plot(cumsum(pr_varex), type = "b")

# Adding Principal components
train_data <- data.frame(Sales = train_df$Item_Outlet_Sales, princ_comp$x)
train_data <- train_data[, 1:31]
rpart_model <- rpart::rpart(formula = Sales ~ . , data = train_data, method = "anova")
fancyRpartPlot(rpart_model)


test_data <- as.data.frame(predict(princ_comp, newdata = pca_test_df))
test_data <- test_data[,1:30]
rpart_pred <- predict(rpart_model, newdata = test_data)

final_output <- data.frame(Item_Identifier = test_df$Item_Identifier, 
                           Outlet_Identifier = test_df$Outlet_Identifier, 
                           Item_Outlet_Sales = rpart_pred)

head(final_output)

# My code is like my room, Clean and Neat