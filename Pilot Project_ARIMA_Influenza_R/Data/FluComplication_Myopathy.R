#使用TroponinI篩選
#使用lab_i.csv檔案為"11116_檢驗結果歷史檔"共112個檔案

checkedtroponinI<-NULL
for (i in c(1:50)){
  a<-fread(paste0('lab_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",'資料年月','歸戶代號','檢驗編號','檢驗項目','序號','檢體','檢驗單一項目','檢驗名稱縮寫',
                 '輸入日期','輸入時間','檢驗結果值','驗證日期','驗證時間','驗證註記','免驗證註記','報告完成註記','結果異動註記','檢驗值異常註記',
                 '檢驗值危機註記','檢驗值單位','檢驗參考值','危險值通知註記','資料年齡')
  checkedtroponinI<-rbind(checkedtroponinI,a[歸戶代號%in%unique(FluUniqueID_2010to2015)][檢驗項目%in%c('72-566')][檢驗結果值<0.3][檢驗結果值>0.04])
  print(i)
}
rm(a)

for (i in c(51:112)){
  a<-fread(paste0('lab_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",'資料年月','歸戶代號','檢驗編號','檢驗項目','序號','檢體','檢驗單一項目','檢驗名稱縮寫',
                 '輸入日期','輸入時間','檢驗結果值','驗證日期','驗證時間','驗證註記','免驗證註記','報告完成註記','結果異動註記','檢驗值異常註記',
                 '檢驗值危機註記','檢驗值單位','檢驗參考值','危險值通知註記','資料年齡')
  checkedtroponinI<-rbind(checkedtroponinI,a[歸戶代號%in%unique(FluUniqueID_2010to2015)][檢驗項目%in%c('72-566')][檢驗結果值<0.3][檢驗結果值>0.04])
  print(i)
}
rm(a)

#確認檢驗值符合條件者的檢驗時間在病程內
lab_troponinI<-checkedtroponinI
colnames(lab_troponinI)[3]<-'uniqueID'
lab_troponinI<-merge(lab_troponinI,Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],by = 'uniqueID')
lab_troponinI$驗證日期<-ymd(lab_troponinI$驗證日期)
lab_troponinI<-lab_troponinI[驗證日期>=startday&驗證日期<=endday]
lab_troponinI$TroponinIResults<-"positive"
lab_troponinI_episodeno<-lab_troponinI$episodeno
#saveRDS(lab_troponinI_episodeno,'lab_troponinI_episodeno.rds')

#由於CK檢驗值的判斷需要用到性別資料(男女條件不同)
#把Flu_episode2010to2015大表加上性別、生日，匯入資料來源為"11116_歸戶主檔"

patient_Basic_Raw<-fread('11116_歸戶主檔_1.csv',encoding="UTF-8")
colnames(patient_Basic_Raw)<-c("branch","uniqueID","sex","birthdate")
patient_Basic_Raw<-patient_Basic_Raw[,c("uniqueID","sex","birthdate")]
patient_Basic_Raw$birthdate<-ymd(patient_Basic_Raw$birthdate)
patient_Basic_Raw<-patient_Basic_Raw[!duplicated(patient_Basic_Raw$uniqueID),]
Flu_episode2010to2015[uniqueID%in%patient_Basic_Raw$uniqueID]
Flu_episode2010to2015<-merge(Flu_episode2010to2015,patient_Basic_Raw,by="uniqueID")



##1. Creatinine kinase >200(male);female>180
##使用lab_i.csv檔案為"11116_檢驗結果歷史檔"共112個檔案

checkedCKMB_M<-NULL

for (i in c(1:50)){
  a<-fread(paste0('lab_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",'資料年月','歸戶代號','檢驗編號','檢驗項目','序號','檢體','檢驗單一項目','檢驗名稱縮寫',
                 '輸入日期','輸入時間','檢驗結果值','驗證日期','驗證時間','驗證註記','免驗證註記','報告完成註記','結果異動註記','檢驗值異常註記',
                 '檢驗值危機註記','檢驗值單位','檢驗參考值','危險值通知註記','資料年齡')
  checkedCKMB_M<-rbind(checkedCKMB_M,a[歸戶代號%in%unique(Flu_episode2010to2015[sex=='M']$uniqueID)][檢驗項目%in%c('72-555','72-374')][as.numeric(檢驗結果值)>200])
  print(i)
}
rm(a)

for (i in c(51:112)){
  a<-fread(paste0('lab_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",'資料年月','歸戶代號','檢驗編號','檢驗項目','序號','檢體','檢驗單一項目','檢驗名稱縮寫',
                 '輸入日期','輸入時間','檢驗結果值','驗證日期','驗證時間','驗證註記','免驗證註記','報告完成註記','結果異動註記','檢驗值異常註記',
                 '檢驗值危機註記','檢驗值單位','檢驗參考值','危險值通知註記','資料年齡')
  checkedCKMB_M<-rbind(checkedCKMB_M,a[歸戶代號%in%unique(Flu_episode2010to2015[sex=='M']$uniqueID)][檢驗項目%in%c('72-555','72-374')][as.numeric(檢驗結果值)>200])
  print(i)
}
rm(a)

#Female
checkedCKMB_F<-NULL

for (i in c(1:50)){
  a<-fread(paste0('lab_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",'資料年月','歸戶代號','檢驗編號','檢驗項目','序號','檢體','檢驗單一項目','檢驗名稱縮寫',
                 '輸入日期','輸入時間','檢驗結果值','驗證日期','驗證時間','驗證註記','免驗證註記','報告完成註記','結果異動註記','檢驗值異常註記',
                 '檢驗值危機註記','檢驗值單位','檢驗參考值','危險值通知註記','資料年齡')
  checkedCKMB_F<-rbind(checkedCKMB_F,a[歸戶代號%in%unique(Flu_episode2010to2015[sex=='F']$uniqueID)][檢驗項目%in%c('72-555','72-374')][as.numeric(檢驗結果值)>200])
  print(i)
}
rm(a)

for (i in c(51:112)){
  a<-fread(paste0('lab_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",'資料年月','歸戶代號','檢驗編號','檢驗項目','序號','檢體','檢驗單一項目','檢驗名稱縮寫',
                 '輸入日期','輸入時間','檢驗結果值','驗證日期','驗證時間','驗證註記','免驗證註記','報告完成註記','結果異動註記','檢驗值異常註記',
                 '檢驗值危機註記','檢驗值單位','檢驗參考值','危險值通知註記','資料年齡')
  checkedCKMB_F<-rbind(checkedCKMB_F,a[歸戶代號%in%unique(Flu_episode2010to2015[sex=='F']$uniqueID)][檢驗項目%in%c('72-555','72-374')][as.numeric(檢驗結果值)>180])
  print(i)
}
rm(a)

checkedCKMB<-rbind(checkedCKMB_F,checkedCKMB_M)
colnames(checkedCKMB)[3]<-'uniqueID'
checkedCKMB<-merge(checkedCKMB,Flu_episode2010to2015,by = 'uniqueID')
checkedCKMB$驗證日期<-ymd(checkedCKMB$驗證日期)
checkedCKMB<-checkedCKMB[驗證日期>=startday&驗證日期<=endday]
checkedCKMB$CKMBResults<-"positive"
checkedCKMB_episodeno<-checkedCKMB$episodeno

#saveRDS(checkedCKMB_episodeno,'checkedCKMB_episodeno_0514.rds')

#檢查這些檢驗值異常的案例是否有心臟病史

CHD_past<-unique(c(checkedCKMB$uniqueID,lab_troponinI$uniqueID))

#急診診斷資料：ER_diagnosis_i.csv 資料來自急診診斷檔，共4個檔案
CHDpast_diagnosis_ER<-NULL
for (i in c(1:4)){
  a<-fread(paste0('ER_diagnosis_',i,'.csv'),colClasses = "character")
  colnames(a)<-c('院區',	'資料年月',	'歸戶代號',	'輸入日期',	'門診號',	'掛號科別',	'疾病序號',	'疾病碼',	'主診斷',	'重大傷病',	'資料年齡')
  
  CHDpast_diagnosis_ER<-rbind(CHDpast_diagnosis_ER,a[歸戶代號%in%unique(CHD_past)][substring(疾病碼,1,3)%in%c('410','411','412','413','414','I20','I21','I22','I23','I24','I25')])
  print(i)
}
rm(a)

colnames(CHDpast_diagnosis_ER)[3]<-'uniqueID'
CHDpast_diagnosis_ER$輸入日期<-ymd(CHDpast_diagnosis_ER$輸入日期)
CHDpast_diagnosis_ER<-merge(CHDpast_diagnosis_ER,Flu_episode2010to2015,by = 'uniqueID')
CHDpast_diagnosis_ER<-CHDpast_diagnosis_ER[輸入日期>=startday&輸入日期<=endday]

#門診診斷資料：OPD_diagnosis_i.csv 資料來自門診診斷檔，共56個檔案
CHDpast_diagnosis_OPD<-NULL
for (i in c(1:56)){
  a<-fread(paste0('OPD_diagnosis_',i,'.csv'),colClasses = "character")
  colnames(a)<-c('院區',	'資料年月',	'uniqueID',	'輸入日期',	'門診號',	'疾病代號',	'疾病序號',	'法定傳染病註記',	'重大傷病註記',	'資料年齡')
  
  CHDpast_diagnosis_OPD<-rbind(CHDpast_diagnosis_OPD,a[uniqueID%in%unique(CHD_past)][substring(疾病代號,1,3)%in%c('410','411','412','413','414','I20','I21','I22','I23','I24','I25')])
  print(i)
}
rm(a)

CHDpast_diagnosis_OPD$輸入日期<-ymd(CHDpast_diagnosis_OPD$輸入日期)
CHDpast_diagnosis_OPD<-merge(CHDpast_diagnosis_OPD,Flu_episode2010to2015,by = 'uniqueID')
CHDpast_diagnosis_OPD<-CHDpast_diagnosis_OPD[輸入日期>=startday&輸入日期<=endday]

#住院診斷資料：IN_diagnosis_RAW.rds　資料來自＂疾病分類統計檔＂，共１個檔案
IN_diagnosis<-readRDS('IN_diagnosis_RAW.rds')

IN_diagnosis<-subset(IN_diagnosis, select = c(院區,歸戶代號, 住院號, 住院日期, 出院日期, 來源別, 
                                                診斷類別1,診斷類別2,診斷類別3, 診斷類別4,診斷類別5,
                                                診斷類別6,診斷類別7,診斷類別8, 診斷類別9,診斷類別10))
IN_diagnosis<-melt(IN_diagnosis, id.vars = c("歸戶代號","住院號","來源別","住院日期","出院日期","院區"),
                       variable.name = "診斷序號", 
                       value.name = "診斷代碼")
#rm(a)


CHDpast_diagnosis_IN<-IN_diagnosis[!診斷代碼==""][substring(診斷代碼,1,3)%in%c('410','411','412','413','414','I20','I21','I22','I23','I24','I25')]

colnames(CHDpast_diagnosis_IN)[1]<-'uniqueID'
CHDpast_diagnosis_IN<-merge(CHDpast_diagnosis_IN,Flu_episode2010to2015,by = 'uniqueID')
CHDpast_diagnosis_IN$住院日期<-ymd(CHDpast_diagnosis_IN$住院日期)
CHDpast_diagnosis_IN$出院日期<-ymd(CHDpast_diagnosis_IN$出院日期)
CHDpast_diagnosis_IN<-CHDpast_diagnosis_IN[住院日期>=startday&出院日期<=endday]

CHDpast_diagnosis<-unique(c(CHDpast_diagnosis_ER$episodeno,CHDpast_diagnosis_OPD$episodeno,CHDpast_diagnosis_IN$episodeno))

