#匯入細菌培養資料
cultureData_grouping<-fread('BacterialCultureData_Grouping_new.csv')
cultureData_grouping<-merge(cultureData[檢體%in%includeCultureType2][,c('episodeno','cultureResult')],cultureData_grouping,by=c('episodeno','cultureResult'))

###革蘭氏陽性菌的分析Gram Positive 
GramPositiveEpisodeno<-unique(cultureData_grouping[Grouping2=='Gram positive'])$episodeno
##將培養資料與病程資料結合
cultureData_GramPositive<-merge(unique(cultureData_grouping[Grouping2=='Gram positive']),
                                Flu_episode2010to2015_Summarize[episodeno%in%GramPositiveEpisodeno][,c('episodeno','FluDrugUse','SevereComplicatedInfluenza','agegroup')],by=c('episodeno'),all.x=T)

##會使用到的變數
myVarsGramPositiveCoinfection <- c("FluDrugUse",'agegroup','Grouping1')
##需轉換成類別變項的變數
catVarsGramPositiveCoinfection <- c('agegroup','Grouping1','FluDrugUse')
## 產生tableone比較表
CreateTableOne(vars = myVarsGramPositiveCoinfection, data =cultureData_GramPositive, factorVars = catVarsGramPositiveCoinfection,strata = "SevereComplicatedInfluenza")

###革蘭氏陰性菌的分析Gram Negative
GramNegativeEpisodeno<-unique(cultureData_grouping[Grouping2=='Gram negative'][,c('episodeno','Grouping1','Grouping2'),with=F])$episodeno
##將培養資料與病程資料結合
cultureData_GramNegative<-merge(unique(cultureData_grouping[Grouping2=='Gram negative'][,c('episodeno','Grouping1','Grouping2'),with=F]),
                                Flu_episode2010to2015_Summarize[episodeno%in%GramNegativeEpisodeno][,c('episodeno','FluDrugUse','SevereComplicatedInfluenza','agegroup')],by='episodeno',all.x=T)

##會使用到的變數
myVarsGramNegativeCoinfection <- c("FluDrugUse",'agegroup','Grouping1')
##需轉換成類別變項的變數
catVarsGramNegativeCoinfection <- c('agegroup','Grouping1','FluDrugUse')
## 產生tableone比較表
CreateTableOne(vars = myVarsGramNegativeCoinfection, data =cultureData_GramNegative, factorVars = catVarsGramNegativeCoinfection,strata = "SevereComplicatedInfluenza")


### 黴菌培養資料分析Fungus
FungusEpisodeno<-unique(cultureData_grouping[Grouping2=='Fungus'][,c('episodeno','Grouping1','Grouping2'),with=F])$episodeno
##將培養資料與病程資料結合
cultureData_Fungus<-merge(unique(cultureData_grouping[Grouping2=='Fungus'][,c('episodeno','Grouping1','Grouping2'),with=F]),
                          Flu_episode2010to2015_Summarize[episodeno%in%FungusEpisodeno][,c('episodeno','FluDrugUse','SevereComplicatedInfluenza','agegroup')],by='episodeno',all.x=T)

## 會使用到的變數
myVarsFungusCoinfection <- c("FluDrugUse",'agegroup','Grouping1')
## 需轉換成類別變項的變數
catVarsFungusCoinfection <- c('agegroup','Grouping1','FluDrugUse')
## 產生tableone比較表
CreateTableOne(vars = myVarsFungusCoinfection, data =cultureData_Fungus, factorVars = catVarsFungusCoinfection,strata = "SevereComplicatedInfluenza")

### 分枝桿菌培養資料分析
MycobacteriumEpisodeno<-unique(cultureData_grouping[Grouping2=='Mycobacterium'][,c('episodeno','Grouping1','Grouping2'),with=F])$episodeno
## 將培養資料與病程資料結合
cultureData_Mycobacterium<-merge(unique(cultureData_grouping[Grouping2=='Mycobacterium'][,c('episodeno','Grouping1','Grouping2'),with=F]),
                                 Flu_episode2010to2015_Summarize[episodeno%in%MycobacteriumEpisodeno][,c('episodeno','FluDrugUse','SevereComplicatedInfluenza','agegroup')],by='episodeno',all.x=T)
## 會使用到的變數
myVarsMycobacteriumCoinfection <- c("FluDrugUse",'agegroup','Grouping1')
## 需轉換成類別變項的變數
catVarsMycobacteriumCoinfection <- c('agegroup','Grouping1','FluDrugUse')
## 產生tableone比較表
CreateTableOne(vars = myVarsMycobacteriumCoinfection, data =cultureData_Mycobacterium, factorVars = catVarsMycobacteriumCoinfection,strata = "SevereComplicatedInfluenza")


### 細菌培養結果結合病程資料
#cultureData_group2<-unique(cultureData_grouping[Grouping2!=''][,c('episodeno','Grouping1','Grouping2'),with=F]$episodeno)
#cultureData_group2<-merge(unique(cultureData_grouping[Grouping2!=''][,c('episodeno','Grouping1','Grouping2'),with=F]),
#                          Flu_episode2010to2015_Summarize[episodeno%in%cultureData_group2][,c('episodeno','FluDrugUse','SevereComplicatedInfluenza','agegroup')],by='episodeno',all.x=T)
## 會使用到的變數
#myVarscultureDataGroup2Coinfection <- c("FluDrugUse",'agegroup','Grouping2')
## 需轉換成類別變項的變數
#catVarscultureDataGroup2Coinfection <- c('agegroup','Grouping2','FluDrugUse')
## 產生tableone比較表
#CreateTableOne(vars = myVarscultureDataGroup2Coinfection, data =cultureData_group2, factorVars = catVarscultureDataGroup2Coinfection,strata = "SevereComplicatedInfluenza")


##VIRUS

#VirusCoinfection$Grouping2<-'Virus'
#colnames(VirusCoinfection)[2]<-'Grouping1'
#VirusCoinfection<-VirusCoinfection[,c('episodeno','Grouping1','Grouping2',"FluDrugUse","SevereComplicatedInfluenza","agegroup")]

#LabDataSummary<-rbind(VirusCoinfection,cultureData_group2)

#myVarsGroup2Coinfection <- c("FluDrugUse",'agegroup','Grouping2')
## Vector of categorical variables that need transformation
#catVarsGroup2Coinfection <- c('agegroup','Grouping2','FluDrugUse')
## Create a TableOne object
#CreateTableOne(vars = myVarsGroup2Coinfection, data =LabDataSummary, factorVars = catVarsGroup2Coinfection,strata = "SevereComplicatedInfluenza")
