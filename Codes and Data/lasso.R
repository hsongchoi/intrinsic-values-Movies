setwd("C:\\Users\\akrishna39\\Desktop\\office desktop\\Courses\\Spring 2017\\ISyE 6416\\Project\\Movie project")
rm(list = ls())
library(glmnet)
data<-read.csv("Data_for_lasso.csv")

x<-as.matrix(data[,2:23])
x2<-as.numeric(x)
x3<-matrix(x2,30,22)
y<-as.matrix(data$true_value)
fit = glmnet(x3, y)

plot(fit,label = T)
print(fit)
coef(fit,s=0.1)
cvfit = cv.glmnet(x3, y)
plot(cvfit)
lambda_min<-cvfit$lambda.min
coef(cvfit, s = "lambda.min")


#Testing
xtrain<-x3[1:20,]
ytrain<-y[1:20]
fit = glmnet(xtrain, ytrain)

plot(fit,label = T)
print(fit)
coef(fit,s=0.1)
cvfit = cv.glmnet(x3, y)
plot(cvfit)
lambda_min<-cvfit$lambda.min
coef(cvfit, s = "lambda.min")

predict(cvfit, newx = x3[21:30,], s = "lambda.min")


