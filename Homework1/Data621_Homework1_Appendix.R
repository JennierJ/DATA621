

library(MASS)
library(knitr)
library(ggplot2)
library(grid)

data_train <- read.csv("https://raw.githubusercontent.com/JennierJ/DATA621/master/Homework1/moneyball-training-data.csv", header = TRUE)
nrow(data_train)
# 1. Introduction
# The dataset contains 2276 professional baseball team's performance statistics from the year 1871 to 2006. 

# 2. Data Exploration

# Data Summary 
summary(data_train)

# From the dataset summary, we can get a quick look at the training dataset. 

hist(data_train$TARGET_WINS)


# Missing Values
# To test how many missing values in the dataset, I would like to find out the numbers of missing values in the variables.
boxplot(data_train, horizontal = TRUE, las=1)

sum(is.na(data_train$TARGET_WINS))
sum(is.na(data_train$TEAM_BATTING_H))
sum(is.na(data_train$TEAM_BATTING_2B))
sum(is.na(data_train$TEAM_BATTING_3B))
sum(is.na(data_train$TEAM_BATTING_HR))
sum(is.na(data_train$TEAM_BATTING_BB))
sum(is.na(data_train$TEAM_BATTING_SO))
sum(is.na(data_train$TEAM_BASERUN_SB))
sum(is.na(data_train$TEAM_BASERUN_CS))
sum(is.na(data_train$TEAM_BATTING_HBP))
sum(is.na(data_train$TEAM_PITCHING_H))
sum(is.na(data_train$TEAM_PITCHING_HR))
sum(is.na(data_train$TEAM_PITCHING_BB))
sum(is.na(data_train$TEAM_PITCHING_SO))
sum(is.na(data_train$TEAM_FIELDING_E))
sum(is.na(data_train$TEAM_FIELDING_DP))


# There are 102 missing values in Strikeouts by batters, 131 missing values in Stolen bases, 772 missing values in Caught stealings, 2085 missing values in Batters hit by pitch, and 286 missing values in double players.


# 3. Data Preparation
# Missing Values
# Some variables have the NA's. There are too many missing values in the field of batters hit by pitch, which rarely happends in the game. So I decided to remove this variable from the dataset, along with index.
data_train1 <- subset(data_train, select = -c(TEAM_BATTING_HBP, INDEX))
summary(data_train1)

#box_plot_TEAM_BATTING_SO <- ggplot(data_train1, aes(x = data_train1$TEAM_BATTING_SO, y = data_train1$TARGET_WINS)) + geom_boxplot()
#box_plot_TEAM_BATTING_SO
#box_plot_TEAM_BASERUN_SB <- ggplot(data_train1, aes(x = data_train1$TEAM_BASERUN_SB, y = data_train1$TARGET_WINS)) + geom_boxplot()
#box_plot_TEAM_BASERUN_SB
#box_plot_TEAM_BASERUN_CS <- ggplot(data_train1, aes(x = data_train1$TEAM_BASERUN_CS, y = data_train1$TARGET_WINS)) + geom_boxplot()
#box_plot_TEAM_BASERUN_CS
#box_plot_TEAM_PITCHING_SO <- ggplot(data_train1, aes(x = data_train1$TEAM_PITCHING_SO, y = data_train1$TARGET_WINS)) + geom_boxplot()
#box_plot_TEAM_BATTING_SO
#box_plot_TEAM_FIELDING_DP <- ggplot(data_train1, aes(x = data_train1$TEAM_FIELDING_DP, y = data_train1$TARGET_WINS)) + geom_boxplot()
#box_plot_TEAM_FIELDING_DP

# For the rest variables wiht NAs, I decided to replace NAs with mean values of the variabls.
data_train1$TEAM_BATTING_SO[which(is.na(data_train1$TEAM_BATTING_SO))] <- mean(data_train1$TEAM_BATTING_SO, na.rm = TRUE)
data_train1$TEAM_BASERUN_SB[which(is.na(data_train1$TEAM_BASERUN_SB))] <- mean(data_train1$TEAM_BASERUN_SB, na.rm = TRUE)
data_train1$TEAM_BASERUN_CS[which(is.na(data_train1$TEAM_BASERUN_CS))] <- mean(data_train1$TEAM_BASERUN_CS, na.rm = TRUE)
data_train1$TEAM_PITCHING_SO[which(is.na(data_train1$TEAM_PITCHING_SO))] <- mean(data_train1$TEAM_PITCHING_SO, na.rm = TRUE)
data_train1$TEAM_FIELDING_DP[which(is.na(data_train1$TEAM_FIELDING_DP))] <- mean(data_train1$TEAM_FIELDING_DP, na.rm = TRUE)
# No Nas in the training dataset
sum(is.na(data_train1))

# 4. Build Models
# Before beginning model development, it is useful to get a visual sense of the relationship within the data.
pairs(data_train1, gap = 0.5)

# Let's try out the models by backward elimination. I am using all the variables left to build the full multiple regression model.
full.model <- lm(TARGET_WINS ~., data = data_train1 )
summary(full.model)
# From the summary of the full.model, we can see that the R-squre is 0.3147. To continue developing the model, I applly the backward elimination procedure by identifying the predictor with the largest p-value that exceeds our predetermined threshold p = 0.05.
full.model <- update(full.model, .~. - TEAM_PITCHING_BB)
summary(full.model)
# Remove TEAM_PITCHING_HR
full.model <- update(full.model, .~. -TEAM_PITCHING_HR)
summary(full.model)
# Remove TEAM_BASERUN_CS
full.model <- update(full.model, .~. -TEAM_BASERUN_CS)
summary(full.model)
# Residual Analysis
plot(fitted(full.model), resid(full.model))
qqnorm(resid(full.model))
qqline(resid(full.model))


# 5. Select Models
# We are to use the model to predict the number of wins with evaluation data.
data_pre <- read.csv("https://raw.githubusercontent.com/JennierJ/DATA621/master/Homework1/moneyball-evaluation-data.csv", header = TRUE)
head(data_pre)

predicted.win <- predict(full.model, newdata = data_pre)
predicted <- data.frame(predicted.win)
summary(predicted)
View(predicted)
