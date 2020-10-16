#找病程開始前一周是否有類流感診斷
#以流感病程歸戶代號找類流感診斷碼(疾病序號=1)，並判斷是否在病程的前一周內，如果是，將病程向前推一週
##類流感診斷碼
setwd("~/FluProjectForGithub/RMDforFluCases")
ILI_code<-readRDS('ILI_code.rds')
FluDiagnosisList_uniqueID<-unique(Flu_episode_start_end_last$uniqueID)
##急診
colnames_ER_diagnosis<-c("院區",	"資料年月",	"uniqueID",	"輸入日期",	"門診號",	"掛號科別",	"疾病序號",	
                         "疾病碼", "主診斷",	"重大傷病","資料年齡")
setwd("~/Flu_fromSQL/ER_diagnosis")
ER_diagnosis_pre<-data.table()
for (i in c(1:4)){
  a<-fread(paste0("ER_diagnosis_",i,".csv"),colClasses = 'character')
  print(i)
  colnames(a)<-colnames_ER_diagnosis
  ER_diagnosis_pre<-rbind(ER_diagnosis_pre,a[uniqueID%in%FluDiagnosisList_uniqueID][疾病碼%in%ILI_code][疾病序號=="1"])
  rm(a)
}

ER_diagnosis_pre$admissionDate<-ymd(ER_diagnosis_pre$輸入日期)
ER_diagnosis_pre$dischargeDate<-ymd(ER_diagnosis_pre$輸入日期)
ER_diagnosis_pre<-ER_diagnosis_pre[,c("uniqueID","門診號","院區",	"疾病序號","疾病碼","admissionDate","dischargeDate")]
ER_diagnosis_pre$Source<-""
ER_diagnosis_pre$dataSource<-"ER"

colnames(ER_diagnosis_pre)<-c("uniqueID","visitID","branch","diagnosis_sequence","diagnosis_code","admissionDate","dischargeDate","Source","dataSource")

##門診
setwd("~/Flu_fromSQL/OPD_diagnosis")
colnames_OPD_diagnosis<-c("院區",	"資料年月",	"uniqueID",	"輸入日期",	"門診號",	"疾病代號",	"疾病序號",	
                          "法定傳染病註記",	"重大傷病註記","資料年齡")
OPD_diagnosis_pre<-data.table()
for (i in c(1:56)){
  a<-fread(paste0("OPD_diagnosis_",i,".csv"),colClasses = 'character')
  print(i)
  colnames(a)<-colnames_OPD_diagnosis
  OPD_diagnosis_pre<-rbind(OPD_diagnosis_pre,a[uniqueID%in%FluDiagnosisList_uniqueID][疾病代號%in%ILI_code][疾病序號=="1"])
  rm(a)
}

OPD_diagnosis_pre$admissionDate<-ymd(OPD_diagnosis_pre$輸入日期)
OPD_diagnosis_pre$dischargeDate<-ymd(OPD_diagnosis_pre$輸入日期)
OPD_diagnosis_pre<-OPD_diagnosis_pre[,c("uniqueID","門診號","院區","疾病序號","疾病代號","admissionDate","dischargeDate")]
OPD_diagnosis_pre$Source<-''
OPD_diagnosis_pre$dataSource<-"OPD"
colnames(OPD_diagnosis_pre)<-c("uniqueID","visitID","branch","diagnosis_sequence","diagnosis_code","admissionDate","dischargeDate","Source","dataSource")

##住院
setwd("~/Flu_fromSQL")
IN_diagnosis<-readRDS('IN_diagnosis_RAW.rds')

IN_diagnosis<-subset(IN_diagnosis, select = c(院區,歸戶代號, 住院號, 住院日期, 出院日期, 來源別, 
                                                診斷類別1,診斷類別2,診斷類別3, 診斷類別4,診斷類別5,
                                                診斷類別6,診斷類別7,診斷類別8, 診斷類別9,診斷類別10))
IN_diagnosis_pre<-IN_diagnosis[歸戶代號%in%FluDiagnosisList_uniqueID][診斷類別1%in%ILI_code]
IN_diagnosis_pre<-melt(IN_diagnosis_pre, id.vars = c("歸戶代號","住院號","來源別","住院日期","出院日期","院區"),
                       variable.name = "診斷序號", 
                       value.name = "診斷代碼")
#rm(a)
IN_diagnosis_pre$診斷序號<-gsub("診斷類別", "", IN_diagnosis_pre$診斷序號)

IN_diagnosis_pre<-IN_diagnosis_pre[!診斷代碼==""][診斷代碼%in%ILI_code]


IN_diagnosis_pre$admissionDate<-ymd(IN_diagnosis_pre$住院日期)
IN_diagnosis_pre$dischargeDate<-ymd(IN_diagnosis_pre$出院日期)
IN_diagnosis_pre<-IN_diagnosis_pre[,c("歸戶代號","住院號","院區","診斷序號","診斷代碼","admissionDate","dischargeDate","來源別")]
IN_diagnosis_pre$dataSource<-"IN"

colnames(IN_diagnosis_pre)<-c("uniqueID","visitID","branch","diagnosis_sequence","diagnosis_code","admissionDate","dischargeDate","Source","dataSource")
#篩選類流感診斷在起始日前七天內
Diagnosis_pre<-rbind(ER_diagnosis_pre,OPD_diagnosis_pre,IN_diagnosis_pre)
Diagnosis_pre<-merge(Diagnosis_pre[order(uniqueID,admissionDate)],Flu_episode_start_end_last,by='uniqueID',all.x=T)
Diagnosis_pre<-Diagnosis_pre[admissionDate>=(startday-7)&admissionDate<=endday][,.SD[1],by=c('uniqueID','episodeno')]
newEpisodeStartDay<-Diagnosis_pre[,c("uniqueID","admissionDate","endday","no","episodeno")]

colnames(newEpisodeStartDay)[2]<-"startday"
Flu_episode_start_end_last<-rbind(Flu_episode_start_end_last,newEpisodeStartDay)
Flu_episode_start_end_last<-Flu_episode_start_end_last[,.SD[1],by=c('uniqueID','episodeno')]

#串CDC時間
library(lubridate)
CDC_Time$CDC_date<-ymd(CDC_Time$CDC_date)
Flu_episode_start_end_last$CDC_date<-Flu_episode_start_end_last$startday
Flu_episode_start_end_last<-merge(Flu_episode_start_end_last,CDC_Time,by='CDC_date',all.x=T)
nrow(Flu_episode_start_end_last[CDC_year%in%c(2010:2015)])
Flu_episode2010to2015<-Flu_episode_start_end_last[CDC_year%in%c(2010:2015)][,c("uniqueID","startday","endday","no","episodeno","CDC_year","CDC_week")]

