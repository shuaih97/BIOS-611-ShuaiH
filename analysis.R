# R Code
# install.packages("e1071")
# install.packages("caret")
# install.packages("randomForest")
library(e1071)
library(caret)
library(randomForest)
library('pROC')

# ObesityData <- read.table("./obesity.txt",
#                      sep="", header = T)
# # View(ObesityData)
# 
# ObesityData_noHW <- ObesityData[,!names(ObesityData) %in% c("Height","Weight")]
# 
# write.table(ObesityData_noHW, file = "./Derived_data/ObesityConvert.txt", 
#             quote = FALSE, row.names = F, col.names = T, sep = "\t")

ObesityData <- read.table("./Derived_data/ObesityConvert.txt", sep = "", header = T)

ObesityData$FCVCrF = as.factor(ObesityData$FCVCr)
ObesityData$NCPrF = as.factor(ObesityData$NCPr)
ObesityData$CH2OrF = as.factor(ObesityData$CH2Or)
ObesityData$FAFrF = as.factor(ObesityData$FAFr)
ObesityData$TUErF = as.factor(ObesityData$TUEr)
ObesityData$MTRANS[which(ObesityData$MTRANS=='Automobile' | 
                             ObesityData$MTRANS=='Motorbike')] = 'Automobile or Motorbike'
ObesityData$MTRANS[which(ObesityData$MTRANS=='Bike' | 
                             ObesityData$MTRANS=='Walking')] = 'Bike or Walking'

# View(ObesityData)

# No extreme values to delete

# Train and test data. Need to set seed every time you do the sampling.
set.seed(777)
# To index the samples. 1: train, 2: validation, 3: test.
ind<-sample(2, nrow(ObesityData), replace=T, prob=c(0.75,0.25))
train_data <- ObesityData[ind==1,] # training set
# write.table(train_data,file='D:/All_University/1_Graduate/UNC/Courses/S4-BIOS-992/Final Project/Data/obesityTrain.txt',
#             sep="\t",quote=F,row.names=F,col.names=T)
# valid_data <- obesity[ind==2,]
test_data <- ObesityData[ind==2,] # test set


# Record error 1: shuffle. first 160 record error (record to other patients)
# set.seed(123)
# newind <- sample(160, 160, replace = F)
# obesity_shuffle <- train_data$obesity[newind]
# obesity_shuffle <- c(obesity_shuffle,train_data$obesity[161:1614])
# sum(obesity_shuffle[161:1614]==train_data$obesity[161:1614])
# sum(obesity_shuffle[1:160]==train_data$obesity[1:160])
# train_data$obesity_shuffle <- obesity_shuffle

# Record error 2: randomly 160 records, and make it wrong
# newind2 <- sample(1614,160,replace = F)
# obesity_shuffle2 <- train_data$obesity
# obesity_shuffle2[newind2] <- 1-obesity_shuffle2[newind2]
# sum(obesity_shuffle2==train_data$obesity)
# train_data$obesity_shuffle2 <- obesity_shuffle2

png( 
    filename = "./Figures/corr.png", # 文件名称
    width = 960,           # 宽
    height = 960,          # 高
    units = "px",          # 单位
    bg = "white",          # 背景颜色
    res = 144)

plot(train_data[c("Age","BMI","obesity")])
dev.off()


# Random forest

# set the form of cross validation
set.seed(123)
fitControlrf <- trainControl(method = 'repeatedcv', 
                            number = 5, search = 'random',
                            repeats = 3, savePredictions = T)
# Cross validation to find the best parameter mtry
set.seed(123)
modelFitrf <- train(as.factor(obesity)~Gender+Age+family_history_with_overweight+
                        FAVC+CAEC+SMOKE+SCC+CALC+MTRANS+
                        FCVCrF+NCPrF+CH2OrF+
                        FAFrF+TUErF, 
                    data=train_data,
                    method = 'rf',
                    trControl = fitControlrf, tunelength = 10, ntree = 1000)

modelFitrf$bestTune
# mtry: 14

png( 
    filename = "./Figures/Variable_importance_base.png", # 文件名称
    width = 960,           # 宽
    height = 960,          # 高
    units = "px",          # 单位
    bg = "white",          # 背景颜色
    res = 144)

plot(varImp(modelFitrf,scale = F))
dev.off()

# use the mrty to fit the final model
set.seed(123)
rf.obesity=randomForest(as.factor(obesity)~Gender+Age+family_history_with_overweight+
                            FAVC+CAEC+SMOKE+SCC+CALC+MTRANS+
                            FCVCrF+NCPrF+CH2OrF+
                            FAFrF+TUErF,
                        data=train_data, mtry=14, importance=TRUE)
# Choose the best tree
png( 
    filename = "./Figures/Tree_number.png", # 文件名称
    width = 960,           # 宽
    height = 960,          # 高
    units = "px",          # 单位
    bg = "white",          # 背景颜色
    res = 144)

plot(rf.obesity)
dev.off()
# the best is around 300

set.seed(123)
rf.obesity300=randomForest(as.factor(obesity)~Gender+Age+family_history_with_overweight+
                            FAVC+CAEC+SMOKE+SCC+CALC+MTRANS+
                            FCVCrF+NCPrF+CH2OrF+
                            FAFrF+TUErF,
                        data=train_data, mtry=14, importance=TRUE, 
                        ntree=300)

png( 
    filename = "./Figures/Variable_importance_tree300.png", # 文件名称
    width = 960,           # 宽
    height = 960,          # 高
    units = "px",          # 单位
    bg = "white",          # 背景颜色
    res = 144)

varImpPlot(rf.obesity300,scale = F)
dev.off()


# subset the modelFitrf$pred dataset to those predicted using the best tuned mtry
sub_rf1=subset(modelFitrf$pred,modelFitrf$pred$mtry==modelFitrf$bestTune$mtry)
# epiR::epi.tests(table(sub_rf1$pred,sub_rf1$obs))
caret::confusionMatrix(table(sub_rf1$pred,sub_rf1$obs))

# rocrfcv <- roc(as.numeric(sub_rf1$obs),as.numeric(sub_rf1$pred),plot=T)

# View(rf.obesity300$predicted)
rf.obesity300$confusion
# epiR::epi.tests(table(as.numeric(rf.obesity300$y),as.numeric(rf.obesity300$predicted)))
# epiR::epi.tests(table(as.numeric(train_data$obesity),as.numeric(rf.obesity300$predicted)))
yhat.prob.rf.train=predict(rf.obesity300, newdata = train_data, type = c('prob'))[,1]
# View(yhat.prob.rf.train)
# rocrf.train <- roc(as.numeric(rf.obesity300$y),yhat.prob.rf.train,plot=T)
# rocrf.train
# ci.auc(rocrf.train)

# predict on the test data set
yhat.rf=predict(rf.obesity, newdata = test_data)
yhat.rf300=predict(rf.obesity300, newdata = test_data)
sum(yhat.rf==yhat.rf300) # 493. The # of observations is 497
# sensitivity, specificity, and CI
# epiR::epi.tests(table(as.numeric(test_data$obesity),as.numeric(yhat.rf300)))
# roc curve in the prediction on test data set
# rocrf <- roc(as.numeric(test_data$obesity),as.numeric(yhat.rf300),plot=T)
# rocrf
# ci.auc(rocrf)

# predict the probability on the test data set
yhat.prob.rf=predict(rf.obesity300, newdata = test_data, type = c("prob"))[,2]
# sensitivity, specificity, and CI
# epiR::epi.tests(table(as.numeric(test_data$obesity),as.numeric(yhat.prob.rf)))
# roc curve in the prediction on test data set
png( 
    filename = "./Figures/ROC.png", # 文件名称
    width = 960,           # 宽
    height = 960,          # 高
    units = "px",          # 单位
    bg = "white",          # 背景颜色
    res = 144)

rocrfprob <- roc(as.numeric(test_data$obesity),as.numeric(yhat.prob.rf),plot=T)
dev.off()

rocrfprob
ci.auc(rocrfprob)

test_data_pred <- cbind(test_data,yhat.prob.rf)
# length(yhat.prob.rf)
# dim(test_data_pred)
write.table(test_data_pred, file = "./Derived_data/Predited_value_test.csv", 
            quote = FALSE, row.names = F, col.names = T, sep = ",")

# run the RFE algorithm
# find the most important features
controlselect <- rfeControl(functions=rfFuncs, method="cv", number=5)
results <- rfe(train_data[,c('Gender','Age','family_history_with_overweight',
                                 'FAVC','CAEC','SMOKE','SCC','CALC','MTRANS',
                                 'FCVCrF','NCPrF','CH2OrF',
                                 'FAFrF','TUErF')], as.factor(train_data$obesity), 
               sizes=c(1:14), rfeControl=controlselect)
# summarize the results
print(results)
# list the chosen features
predictors(results)
# plot the results
# plot(results, type=c("g", "o"))
