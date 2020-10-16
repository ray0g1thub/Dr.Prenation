#ER_diagnosis_i.csv檔案來自11116_急診診斷檔_i.csv，共4個檔案
ER_diagnosis<-NULL
for (i in c(1:4)){
  a<-fread(paste0('ER_diagnosis_',i,'.csv'),colClasses = "character")
  colnames(a)<-c('院區',	'資料年月',	'歸戶代號',	'輸入日期',	'門診號',	'掛號科別',	'疾病序號',	'疾病碼',	'主診斷',	'重大傷病',	'資料年齡')
  
  ER_diagnosis<-rbind(ER_diagnosis,a[歸戶代號%in%unique(FluUniqueID_2010to2015)])
  print(i)
}
rm(a)


#敗血症(Sepsis)、毒性休克症候群(TSS)診斷碼
sepsis_code<-c("7907","78552","9959","99590","99591","99592","99593","99594","R7881","R651","R652","R6510","R6511","R6520","R6521")
TSS_code<-c("04082","04089","A483")

##毒性休克症候群(TSS) 急診診斷
ER_diagnosis_TSS<-ER_diagnosis[疾病碼%in%TSS_code]
colnames(ER_diagnosis_TSS)[3]<-'uniqueID'
ER_diagnosis_TSS<-merge(ER_diagnosis_TSS,Flu_episode2010to2015, by = "uniqueID")
ER_diagnosis_TSS$輸入日期<-ymd(ER_diagnosis_TSS$輸入日期)
ER_diagnosis_TSS<-ER_diagnosis_TSS[輸入日期>=startday&輸入日期<=endday]
ER_diagnosis_TSS_episodenum<-ER_diagnosis_TSS$episodeno


#敗血症(Sepsis) 急診診斷
ER_diagnosis_sepsis<-ER_diagnosis[疾病碼%in%sepsis_code]
colnames(ER_diagnosis_sepsis)[3]<-'uniqueID'
ER_diagnosis_sepsis<-merge(ER_diagnosis_sepsis,Flu_episode2010to2015, by = "uniqueID")
ER_diagnosis_sepsis$輸入日期<-ymd(ER_diagnosis_sepsis$輸入日期)
ER_diagnosis_sepsis<-ER_diagnosis_sepsis[輸入日期>=startday&輸入日期<=endday]
ER_diagnosis_sepsis_episodenum<-ER_diagnosis_sepsis$episodeno

##匯入門診診斷檔，OPD_diagnosis_i.csv，共56個檔案

OPD_diagnosis<-NULL
for (i in c(1:56)){
  a<-fread(paste0('OPD_diagnosis_',i,'.csv'),colClasses = "character")
  colnames(a)<-c('院區',	'資料年月',	'uniqueID',	'輸入日期',	'門診號',	'疾病代號',	'疾病序號',	'法定傳染病註記',	'重大傷病註記',	'資料年齡')
  
  OPD_diagnosis<-rbind(OPD_diagnosis,a[uniqueID%in%unique(FluUniqueID_2010to2015)])
  print(i)
}
rm(a)

#毒性休克症候群(TSS) 門診診斷
OPD_diagnosis_TSS<-OPD_diagnosis[疾病代號%in%TSS_code]
colnames(OPD_diagnosis_TSS)[3]<-'uniqueID'
OPD_diagnosis_TSS<-merge(OPD_diagnosis_TSS,Flu_episode2010to2015, by = "uniqueID")
OPD_diagnosis_TSS$輸入日期<-ymd(OPD_diagnosis_TSS$輸入日期)
OPD_diagnosis_TSS<-OPD_diagnosis_TSS[輸入日期>=startday&輸入日期<=endday]
OPD_diagnosis_TSS_episodenum<-OPD_diagnosis_TSS$episodeno

#敗血症(Sepsis) 門診診斷
OPD_diagnosis_sepsis<-OPD_diagnosis[疾病代號%in%sepsis_code]
colnames(OPD_diagnosis_sepsis)[3]<-'uniqueID'
OPD_diagnosis_sepsis<-merge(OPD_diagnosis_sepsis,Flu_episode2010to2015, by = "uniqueID")
OPD_diagnosis_sepsis$輸入日期<-ymd(OPD_diagnosis_sepsis$輸入日期)
OPD_diagnosis_sepsis<-OPD_diagnosis_sepsis[輸入日期>=startday&輸入日期<=endday]
OPD_diagnosis_sepsis_episodenum<-OPD_diagnosis_sepsis$episodeno


#匯入住院診斷
IN_diagnosis<-readRDS('IN_diagnosis_RAW.rds')

IN_diagnosis<-subset(IN_diagnosis, select = c(院區,歸戶代號, 住院號, 住院日期, 出院日期, 來源別, 
                                                診斷類別1,診斷類別2,診斷類別3, 診斷類別4,診斷類別5,
                                                診斷類別6,診斷類別7,診斷類別8, 診斷類別9,診斷類別10))
IN_diagnosis<-IN_diagnosis[歸戶代號%in%unique(FluUniqueID_2010to2015)]
IN_diagnosis<-melt(IN_diagnosis, id.vars = c("歸戶代號","住院號","來源別","住院日期","出院日期","院區"),
                   variable.name = "診斷序號", 
                   value.name = "診斷代碼")

IN_diagnosis$診斷序號<-gsub("診斷類別", "", IN_diagnosis$診斷序號)

IN_diagnosis<-IN_diagnosis[!診斷代碼==""]
IN_diagnosis$住院日期<-ymd(IN_diagnosis$住院日期)
IN_diagnosis$出院日期<-ymd(IN_diagnosis$出院日期)

#毒性休克症候群(TSS) 住診診斷
IN_diagnosis_TSS<-IN_diagnosis[診斷代碼%in%TSS_code]
colnames(IN_diagnosis_TSS)[1]<-"uniqueID"
IN_diagnosis_TSS<-merge(IN_diagnosis_TSS,Flu_episode2010to2015, by = "uniqueID")
IN_diagnosis_TSS<-IN_diagnosis_TSS[住院日期>=startday&出院日期<=endday]
IN_diagnosis_TSS_episodenum<-IN_diagnosis_TSS$episodeno

#敗血症(Sepsis) 住診診斷
IN_diagnosis_sepsis<-IN_diagnosis[診斷代碼%in%sepsis_code]
colnames(IN_diagnosis_sepsis)[1]<-"uniqueID"
IN_diagnosis_sepsis<-merge(IN_diagnosis_sepsis,Flu_episode2010to2015, by = "uniqueID")
IN_diagnosis_sepsis<-IN_diagnosis_sepsis[住院日期>=startday&出院日期<=endday]
IN_diagnosis_sepsis_episodenum<-IN_diagnosis_sepsis$episodeno

Total_sepsis_episode<-unique(c(ER_diagnosis_sepsis$episodeno,OPD_diagnosis_sepsis$episodeno,IN_diagnosis_sepsis$episodeno))
Total_TSS_episode<-unique(c(ER_diagnosis_TSS$episodeno,OPD_diagnosis_TSS$episodeno,IN_diagnosis_TSS$episodeno))
