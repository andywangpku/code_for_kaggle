train_v2 <- read.csv("~/Downloads/Kaggle/morgage/train_v2.csv")
cor_train<-train_v2[,2:770]
std.dev <- apply(cor_train,2,sd,na.rm=TRUE)
constant.columns <- names(std.dev[std.dev ==0])
columns.of.interest <- names(cor_train)[!names(cor_train) %in% constant.columns]
cor_train<-cor_train[,columns.of.interest]
cor_t<-cor(cor_train,use="pairwise.complete.obs")
library(caret)
corres<-findCorrelation(cor_t, cutoff = .95, verbose = FALSE)
drop.correlation<-names(cor_train[,corres])
columns.of.interest <- names(cor_train)[!names(cor_train) %in% drop.correlation]
data<-cor_train[,columns.of.interest]
data$f2<-as.factor(data$f2)
data$f5<-as.factor(data$f5)
data$f776<-as.factor(data$f776)

X<-data
Y<-train_v2[,771]

#library(DMwR)
new_X<-X
new_X$label<-0
new_X$label[which(Y>0)]<-1
new_X$label<-as.factor(new_X$label)
#newData <- SMOTE(label ~ ., new_X, perc.over = 300,perc.under=50)

library(rpart)
#newXX<-new_X[1:1000,]
bad<-subset(new_X,label==1)
good<-subset(new_X,label==0)

sp<-sample(95688,9783)
goodsp<-good[sp,]
newXX<-rbind(goodsp,bad)
fit<-rpart(label ~ ., data=newXX,method="class",control=rpart.control(minsplit=30, cp=0.001,xval=10))
plotcp(fit)


sp2<-sample(95688,18000)
goodsp<-good[sp2,]
newXX<-rbind(goodsp,bad)
fit2<-rpart(label ~ ., data=newXX,method="class",control=rpart.control(minsplit=30, cp=0.001,xval=10))
plotcp(fit2)


#--regression on loss
loss<-Y[which(Y>0)]

Xloss<-X[which(Y>0),]

Xloss$loss<-loss
lmfit<-glm(loss~ . , data=Xloss)
summary(lmfit)





# Xloss2<-subset(Xloss,select= -c(id,f2,f5,f776))
# Xloss2<-scale(Xloss2)
# Xloss2<-data.frame(Xloss2)
# f2_d<-Xloss$f2
# dummies<-model.matrix(~f2_d)
# Xloss2<-cbind(Xloss2,dummies)
# f5_d<-Xloss$f5
# dummies<-model.matrix(~f5_d)
# Xloss2<-cbind(Xloss2,dummies)
# f776_d<-Xloss$f776
# dummies<-model.matrix(~f776_d)
# Xloss2<-cbind(Xloss2,dummies)
# Xloss2<-as.matrix(Xloss2)
# tmp<-complete.cases(Xloss2)
# Xloss2<- Xloss2[tmp,]
# loss<-loss[tmp]
# 
# library(glmnet)
# fitloss<-glmnet(Xloss2,loss,family="poisson",standardize=FALSE)
# cvfit<-cv.glmnet(Xloss2,loss,family="poisson",type.measure="mae")
# model<-cvfit$glmnet.fit
# pfit = predict(model,Xloss2,s=0.001,type="response")
# plot(pfit,loss)

test_v2 <- read.csv("~/Downloads/Kaggle/morgage/test_v2.csv")
test_id<-test_v2$id
test_v2<-subset(test_v2,select=-c(id))
testdata<-test_v2
columns.of.interest <- names(testdata)[!names(testdata) %in% constant.columns]
testdata<-testdata[,columns.of.interest]
columns.of.interest <- names(testdata)[!names(testdata) %in% drop.correlation]
testdata<-testdata[,columns.of.interest]
testdata$f2<-as.factor(testdata$f2)
testdata$f5<-as.factor(testdata$f5)
testdata$f776<-as.factor(testdata$f776)
tmp<-which(testdata$f2==5)
test2<-testdata[!row.names(testdata)%in%tmp,]
res<-predict(fit,test2)
