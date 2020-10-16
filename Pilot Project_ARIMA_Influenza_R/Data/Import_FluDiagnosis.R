library(data.table)
library(icd)
library(lubridate)
#Flu_code<-c(icd_expand_range("487","488"),icd_expand_range("J09","J11"))
Flu_code<-c("487","4870","4871","4878", "J09","J09X","J09X1","J09X2","J09X3","J09X9","J10","J100","J1000","J1001","J1008","J101","J102", 
            "J108","J1081","J1082","J1083","J1089","J11","J110","J1100","J1108","J111","J112","J118","J1181","J1182","J1183","J1189")
colnames_ER_diagnosis<-c("院區",	"資料年月",	"uniqueID",	"輸入日期",	"門診號",	"掛號科別",	"疾病序號",	
                         "疾病碼", "主診斷",	"重大傷病","資料年齡")

#ER_diagnosis_i.csv 為11116_急診診斷檔.csv，共4個檔案
ER_diagnosis<-data.table()
for (i in c(1:4)){
  a<-fread(paste0("ER_diagnosis_",i,".csv"),colClasses = 'character')
  print(i)
  colnames(a)<-colnames_ER_diagnosis
  ER_diagnosis<-rbind(ER_diagnosis,a[疾病碼%in%Flu_code])
  rm(a)
}

ER_diagnosis$admissionDate<-ymd(ER_diagnosis$輸入日期)
ER_diagnosis$dischargeDate<-ymd(ER_diagnosis$輸入日期)
ER_diagnosis<-ER_diagnosis[,c("uniqueID","門診號","院區",	"疾病序號","疾病碼","admissionDate","dischargeDate")]
ER_diagnosis$Source<-""
ER_diagnosis$dataSource<-"ER"

colnames(ER_diagnosis)<-c("uniqueID","visitID","branch","diagnosis_sequence","diagnosis_code","admissionDate","dischargeDate","Source","dataSource")

#匯入門診診斷
#OPD_diagnosis_i.csv 為11116_門診診斷檔.csv，共56個檔案

colnames_OPD_diagnosis<-c("院區",	"資料年月",	"uniqueID",	"輸入日期",	"門診號",	"疾病代號",	"疾病序號",	
                          "法定傳染病註記",	"重大傷病註記","資料年齡")
OPD_diagnosis<-data.table()
for (i in c(1:56)){
  a<-fread(paste0("OPD_diagnosis_",i,".csv"),colClasses = 'character')
  print(i)
  colnames(a)<-colnames_OPD_diagnosis
  OPD_diagnosis<-rbind(OPD_diagnosis,a[疾病代號%in%Flu_code])
  rm(a)
}

OPD_diagnosis$admissionDate<-ymd(OPD_diagnosis$輸入日期)
OPD_diagnosis$dischargeDate<-ymd(OPD_diagnosis$輸入日期)
OPD_diagnosis<-OPD_diagnosis[,c("uniqueID","門診號","院區","疾病序號","疾病代號","admissionDate","dischargeDate")]
OPD_diagnosis$Source<-''
OPD_diagnosis$dataSource<-"OPD"
colnames(OPD_diagnosis)<-c("uniqueID","visitID","branch","diagnosis_sequence","diagnosis_code","admissionDate","dischargeDate","Source","dataSource")

#住院
#IN_diagnosis_RAW.rds 為11116_住診診斷檔.csv，共1個檔案
IN_diagnosis<-readRDS('IN_diagnosis_RAW.rds')

IN_diagnosis<-subset(IN_diagnosis, select = c(院區,歸戶代號, 住院號, 住院日期, 出院日期, 來源別, 
                                                    診斷類別1,診斷類別2,診斷類別3, 診斷類別4,診斷類別5,
                                                    診斷類別6,診斷類別7,診斷類別8, 診斷類別9,診斷類別10))
IN_diagnosis_Flu<-IN_diagnosis[診斷類別1%in%Flu_code|診斷類別2%in%Flu_code|診斷類別3%in%Flu_code|診斷類別4%in%Flu_code|診斷類別5%in%Flu_code|診斷類別6%in%Flu_code|診斷類別7%in%Flu_code|診斷類別8%in%Flu_code|診斷類別9%in%Flu_code|診斷類別10%in%Flu_code]
IN_diagnosis_Flu<-melt(IN_diagnosis_Flu, id.vars = c("歸戶代號","住院號","來源別","住院日期","出院日期","院區"),
                       variable.name = "診斷序號", 
                       value.name = "診斷代碼")
#rm(a)
IN_diagnosis_Flu$診斷序號<-gsub("診斷類別", "", IN_diagnosis_Flu$診斷序號)

IN_diagnosis_Flu<-IN_diagnosis_Flu[!診斷代碼==""][診斷代碼%in%Flu_code]


IN_diagnosis_Flu$admissionDate<-ymd(IN_diagnosis_Flu$住院日期)
IN_diagnosis_Flu$dischargeDate<-ymd(IN_diagnosis_Flu$出院日期)
IN_diagnosis_Flu<-IN_diagnosis_Flu[,c("歸戶代號","住院號","院區","診斷序號","診斷代碼","admissionDate","dischargeDate","來源別")]
IN_diagnosis_Flu$dataSource<-"IN"

colnames(IN_diagnosis_Flu)<-c("uniqueID","visitID","branch","diagnosis_sequence","diagnosis_code","admissionDate","dischargeDate","Source","dataSource")

#三個來源串聯
Flu_total_list<-rbind(ER_diagnosis,OPD_diagnosis,IN_diagnosis_Flu)
rm(ER_diagnosis,IN_diagnosis,IN_diagnosis_Flu,OPD_diagnosis)
#流感診斷的資料(急診+門診+住院))
Flu_total_list[order(Flu_total_list$uniqueID,Flu_total_list$admissionDate,Flu_total_list$dischargeDate,decreasing = F)]

length(unique(Flu_total_list$visitID))
length(unique(Flu_total_list$uniqueID))

#基本資料
setwd("~/Flu_fromSQL")
patient_Basic_Raw<-fread('11116_歸戶主檔_1.csv',encoding="UTF-8")
colnames(patient_Basic_Raw)<-c("branch","uniqueID","sex","birthdate")
patient_Basic_Raw<-patient_Basic_Raw[,c("uniqueID","sex","birthdate")]
patient_Basic_Raw$birthdate<-ymd(patient_Basic_Raw$birthdate)
patient_Basic_Raw<-patient_Basic_Raw[!duplicated(patient_Basic_Raw$uniqueID),]
Flu_total_list[uniqueID%in%patient_Basic_Raw$uniqueID]
Flu_total_list<-merge(Flu_total_list,patient_Basic_Raw,by="uniqueID")
Flu_total_list[order(Flu_total_list$uniqueID,Flu_total_list$admissionDate,Flu_total_list$dischargeDate,decreasing = F)]
Flu_total_list$year<-as.numeric(substring(Flu_total_list$admissionDate,1,4))
yr = duration(num = 1, units = "years")
Flu_total_list[, age := interval(Flu_total_list$birthdate, Flu_total_list$admissionDate)/yr]

#排除性別=U、年齡小於等於0的資料
ProblemID<-Flu_total_list[sex=="U"|age<=0]$uniqueID
Flu_total_list_last<-Flu_total_list[!uniqueID%in%ProblemID]

#合併疾管署年月
#CDC_Time.csv 檔案來自 https://nidss.cdc.gov.tw/docs/WEEKDATE.xls
#下載後將欄位名稱改為CDC_date, CDC_year, CDC_week
#將xls另存成csv檔

Flu_total_list_last$CDC_date<-Flu_total_list_last$admissionDate
CDC_Time<-fread('CDC_Time.csv',colClasses = 'character')
CDC_Time$CDC_date<-ymd(CDC_Time$CDC_date)
Flu_total_list_last<-merge(Flu_total_list_last,CDC_Time,by='CDC_date',all.x=T)
Flu_total_list_last$no<-1:nrow(Flu_total_list_last)
#CDC年月－2010年至2015年流感診斷碼資料
##Flu_TotalList_2010to2015<-Flu_total_list_last[CDC_year%in%c(2010:2015)]
##Flu_TotalList_2010to2015<-Flu_TotalList_2010to2015[, .SD[c(1)],by = c('uniqueID','visitID','admissionDate')]

#具有流感診斷碼的歸戶代號、門診號
FluDiagnosisList_uniqueID<-unique(Flu_total_list_last$uniqueID)
FluDiagnosisList_visitID<-unique(Flu_total_list_last$visitID)
length(unique(FluDiagnosisList_uniqueID))
length(unique(FluDiagnosisList_visitID))

