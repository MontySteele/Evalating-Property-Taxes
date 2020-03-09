# Evalating-Property-Taxes

This repo contains my code for running a multivariate linear regression on Nevada housing data to detwrmine errors in tax assessments.

'house_data.R' contains my code in R for examining and cleaning the data.
'house_data_rmd.htm' is a copy of this code.

'MSteele_cleaned_full_data.csv' contains the cleaned data.

'estimating_tax_error.ipynb' contains my Python code for running the linear regression model.
'estimating_tax_error.ipynb - Colaboratory.pdf' is a PDF copy of this code.

Summary:

Nevada Housing Dataset – Linear Regression

Business problem: Save taxpayers time and money by evaulating the likelihood that the government has mis-appraised your house's taxable value. We want to estimate the error between your house's true value and the government's appraisal and whether it is worth hiring a private appraiser to get the tax assessment changed.

For this problem, I used a Linear Regression model trained on a data set of 52k houses (42k training examples, 10k test examples). Using an R script, I cleaned the data and performed some onehot encoding of categorical features.

The model was coded in Python in a Jupyter notebook. I found that after simplifying my model, I achieved r^2 of 0.88 and RMSE of 0.037 on the test dataset using 19 features. The mean normalized difference between sales price and tax assessment is 0.045, which is close, meaning that my error is close to the magnitude of the value I am trying to predict.
