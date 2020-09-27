#Read the feature names from features.txt
features<-read.csv('features.txt',sep='\n',header=F)
features<-gsub('[0-9]+ ','',features[,1])


#--=== Gathering the training data
trainRaw<-readLines(file('./train/X_train.txt')) #Raw data (to be
#formatted for easy processing)
trainNew<-file('trainNew.txt') #New handle for formatted version
trainRaw<-gsub(' +',',',trainRaw) #Substituting all occurrences of
#one or more contiguous whitespaces with a comma
writeLines(text=trainRaw,con=trainNew)
close(trainNew)
#Read the new data as csv
trainData<-read.csv('trainNew.txt',header=F)
trainData<-as_tibble(trainData[,-1]) #Tidy it up as a tibble
#Adding the feature names as columns
names(trainData)<-features
#Keeping only means and SD's
trainData<-trainData%>%select(matches('(.*mean.*|.*std.*)'))

#---=== Gathering the test data
testRaw<-readLines(file('./test/X_test.txt'))
testRaw<-gsub(' +',',',testRaw)
testNew<-file('testNew.txt')
writeLines(text=testRaw,con=testNew)
close(testNew)
testData<-read.csv('testNew.txt',sep=',',header=F)
testData<-as_tibble(testData[,-1])
names(testData)<-features
testData<-testData%>%select(matches('(.*mean.*|.*std.*)'))

#---=== Stack them on top of each other
biometricData<-rbind(trainData,testData)

#---=== Adding subject ID's
trainSubs<-read.csv('./train/subject_train.txt',header=F,sep='\n')
testSubs<-read.csv('./test/subject_test.txt',header=F,sep='\n')
subjects<-rbind(trainSubs,testSubs)
subjects<-subjects$V1
biometricData<-cbind(biometricData,SubjectID=subjects)


#---=== Add activity labels to the mix
trainAcLabs<-read.csv('./train/y_train.txt',sep='\n',header=F)
testAcLabs<-read.csv('./test/y_test.txt',sep='\n',header=F)
acLabs<-rbind(trainAcLabs,testAcLabs)
acLabs<-as.character(acLabs$V1)
acLabs<-gsub('1','walking',acLabs)
acLabs<-gsub('2','walking_upstairs',acLabs)
acLabs<-gsub('3','walking_downstairs',acLabs)
acLabs<-gsub('4','sitting',acLabs)
acLabs<-gsub('5','standing',acLabs)
acLabs<-gsub('6','lying',acLabs)

biometricData$Activity<-acLabs


#---=== Grouping by subject and activity and taking the mean of each variable
bio<-biometricData
bioMeans<-bio%>%group_by(SubjectID,Activity)%>%summarise(across(where(is.numeric),mean))


#---=== Finally, saving as a text file
write.table(bioMeans,'samsung_tidy.txt',row.names=F)