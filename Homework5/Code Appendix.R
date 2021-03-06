# Load packages
install.packages("DataExplorer")
install.packages("corrplot")
install.packages("leaps")
install.packages("mlogit")
install.packages("lattice")

# Load libraries
library(ggplot2)
library(stringr)
library(tidyr)
library(dplyr)
library(corrplot)
library(DataExplorer)
library(leaps)
library(mlogit)
library(reshape2)

# Introduction
# In this homework, I will explore, analyze and model a data set containing approximately 12,000 commercially available wines.The variable are mostly related to the chemical properties of the wine being sold. The response variable is the number of sample cases of wine that were purchased by wine distribution companies after sampling a wine. These cases would be used to provide tasting samples to restaurants and wine stores around United States. The more sample cases purchased, the more likely is a wine to be sold at a high end restaurant. A large wine manufacturer is studying the data in order to predict the number of wine cases ordered based upon the wine characteristics. If the wine manufacturer can predict the number of cases, then that manufacturer will be able to adjust their wine offering to maximize sales.

# My objective is to build a count regression model to predict the number of cases of wine that will be sold given certain properties of the wine. 

# Read the data set

train_data <- read.csv("https://raw.githubusercontent.com/JennierJ/DATA621/master/Homework5/wine-training-data.csv", header = TRUE)
eval_data <- read.csv("https://raw.githubusercontent.com/JennierJ/DATA621/master/Homework5/wine-evaluation-data.csv", header = TRUE)

head(train_data)
summary(train_data)
nrow(train_data)

eval_data <- eval_data[, -1]
summary(eval_data)


# Data Exploration

# Histogram
hist(train_data$TARGET, col = "orange", xlab = " Target ", main = "Wine Counts")

# Correlation
corrplot(as.matrix(cor(train_data, use = "pairwise.complete")),method = "circle")

# Boxplot
ggplot(melt(train_data), aes(x=factor(variable), y=value)) + facet_wrap(~variable, scale="free") + geom_boxplot()


# Data Preparation 

# Replacing N/A with mean for calculation
train_data$ResidualSugar[is.na(train_data$ResidualSugar)] <- mean(train_data$ResidualSugar, na.rm=TRUE)
train_data$Chlorides[is.na(train_data$Chlorides)] <- mean(train_data$Chlorides, na.rm=TRUE)
train_data$FreeSulfurDioxide[is.na(train_data$FreeSulfurDioxide)] <- mean(train_data$FreeSulfurDioxide, na.rm=TRUE)
train_data$TotalSulfurDioxide[is.na(train_data$TotalSulfurDioxide)] <- mean(train_data$TotalSulfurDioxide, na.rm=TRUE)
train_data$pH[is.na(train_data$pH)] <- mean(train_data$pH, na.rm=TRUE)
train_data$Sulphates[is.na(train_data$Sulphates)] <- mean(train_data$Sulphates, na.rm=TRUE)
train_data$Sulphates[is.na(train_data$Sulphates)] <- mean(train_data$Sulphates, na.rm=TRUE)
train_data$Alcohol[is.na(train_data$Alcohol)] <- mean(train_data$Alcohol, na.rm=TRUE)
train_data$STARS[is.na(train_data$STARS)] <- mean(train_data$STARS, na.rm=TRUE)


eval_data$ResidualSugar[is.na(eval_data$ResidualSugar)] <- mean(eval_data$ResidualSugar, na.rm=TRUE)
eval_data$Chlorides[is.na(eval_data$Chlorides)] <- mean(eval_data$Chlorides, na.rm=TRUE)
eval_data$FreeSulfurDioxide[is.na(eval_data$FreeSulfurDioxide)] <- mean(eval_data$FreeSulfurDioxide, na.rm=TRUE)
eval_data$TotalSulfurDioxide[is.na(eval_data$TotalSulfurDioxide)] <- mean(eval_data$TotalSulfurDioxide, na.rm=TRUE)
eval_data$pH[is.na(eval_data$pH)] <- mean(eval_data$pH, na.rm=TRUE)
eval_data$Sulphates[is.na(eval_data$Sulphates)] <- mean(eval_data$Sulphates, na.rm=TRUE)
eval_data$Alcohol[is.na(eval_data$Alcohol)] <- mean(eval_data$Alcohol, na.rm=TRUE)
eval_data$STARS[is.na(eval_data$STARS)] <- mean(eval_data$STARS, na.rm=TRUE)

# Build Models

# Possion Distribution
model1 = glm(TARGET ~., data = train_data, family = poisson)
summary(model1)
# Exclude the predictor that are not significant
model2 = glm(TARGET ~ VolatileAcidity + CitricAcid + Chlorides + FreeSulfurDioxide
                        + TotalSulfurDioxide + Density + pH + Sulphates + Alcohol + LabelAppeal
             + AcidIndex + STARS, data = train_data,
             family = poisson)
summary(model2)

# Linera Model
model3 = lm(TARGET ~., data = train_data)
summary(model3)

# Model Selection
predict1 <- predict(model2, newdata=eval_data, type="response")
summary(predict1)
predict1


predict2 <- predict(model3, newdata=eval_data, type="response")
summary(predict2)
predict2


