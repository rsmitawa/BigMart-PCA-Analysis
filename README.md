---

# BigMart Sales Prediction using PCA and Decision Trees

This project applies Principal Component Analysis (PCA) to the BigMart dataset, followed by a decision tree model to predict sales.

## Overview

The analysis uses PCA for dimensionality reduction on the BigMart dataset, then builds a decision tree model to predict Item_Outlet_Sales. This approach helps in understanding the underlying structure of the data and potentially improves prediction accuracy.

## Key Features

- Data preprocessing and handling of missing values
- PCA for dimensionality reduction
- Decision tree model for sales prediction
- Visualization of PCA results and decision tree

## Requirements

- R (version used in your environment)
- Required packages: data.table, tidyverse, fastDummies, rpart, rattle

## Usage

1. Set your working directory in the script
2. Ensure all required CSV files are in the working directory
3. Run the R script

## Data Preprocessing

- Handling of missing values in Item_Weight and Item_Visibility
- Creation of dummy variables for categorical features
- Merging of train and test datasets for consistent preprocessing

## PCA Analysis

- PCA applied to the preprocessed dataset
- Scree plot and cumulative variance plot generated for PC selection

## Machine Learning

- Decision tree model built using the rpart package
- Prediction on test data using the trained model

## Results

The final predictions are saved in "Predictions.csv".

---
