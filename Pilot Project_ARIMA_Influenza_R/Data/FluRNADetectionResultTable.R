#A/B 型流感病毒RNA檢驗(Influenza A, B RNA detection)篩選
#使用lab_i.csv檔案為"11116_檢驗結果歷史檔"共112個檔案

checkedRNA<-NULL
for (i in c(1:50)){
  a<-fread(paste0('lab_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",'資料年月','歸戶代號','檢驗編號','檢驗項目','序號','檢體','檢驗單一項目','檢驗名稱縮寫',
                 '輸入日期','輸入時間','檢驗結果值','驗證日期','驗證時間','驗證註記','免驗證註記','報告完成註記','結果異動註記','檢驗值異常註記',
                 '檢驗值危機註記','檢驗值單位','檢驗參考值','危險值通知註記','資料年齡')
  checkedRNA<-rbind(checkedRNA,a[歸戶代號%in%unique(FluUniqueID_2010to2015)][檢驗項目%in%c('72-906')])
  print(i)
}

for (i in c(51:112)){
  a<-fread(paste0('lab_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",'資料年月','歸戶代號','檢驗編號','檢驗項目','序號','檢體','檢驗單一項目','檢驗名稱縮寫',
                 '輸入日期','輸入時間','檢驗結果值','驗證日期','驗證時間','驗證註記','免驗證註記','報告完成註記','結果異動註記','檢驗值異常註記',
                 '檢驗值危機註記','檢驗值單位','檢驗參考值','危險值通知註記','資料年齡')
  checkedRNA<-rbind(checkedRNA,a[歸戶代號%in%unique(FluUniqueID_2010to2015)][檢驗項目%in%c('72-906')])
  print(i)
}

lab_RNAdetectionfromSQL<-checkedRNA
colnames(lab_RNAdetectionfromSQL)[3]<-"uniqueID"
lab_RNAdetectionfromSQL$RNADetectionResult<-""
lab_RNAdetectionfromSQL$檢驗結果值<-iconv(lab_RNAdetectionfromSQL$檢驗結果值,"big5","utf8")
lab_RNAdetectionfromSQL[grep("positive",tolower(檢驗結果值))]$RNADetectionResult<-"positive"
lab_RNAdetectionfromSQL[RNADetectionResult==""][grep("negative",tolower(檢驗結果值))]$RNADetectionResult<-"negative"
lab_RNAdetectionfromSQL[RNADetectionResult==""][grep("undetectable",tolower(檢驗結果值))]$RNADetectionResult<-"negative"
lab_RNAdetectionfromSQL[RNADetectionResult==""][grepl("[-]",檢驗結果值)]$RNADetectionResult<-"negative"

lab_RNAdetectionfromSQL$檢驗結果值<-as.character(lab_RNAdetectionfromSQL$檢驗結果值)
lab_RNAdetectionfromSQL[RNADetectionResult==""][grep("陰性",檢驗結果值)]$RNADetectionResult<-"negative"
lab_RNAdetectionfromSQL[RNADetectionResult==""][grepl("陽性",檢驗結果值)]$RNADetectionResult<-"positive"
lab_RNAdetectionfromSQL[RNADetectionResult==""][grepl("H7N9",檢驗結果值)]$RNADetectionResult<-"positive"
lab_RNAdetectionfromSQL[RNADetectionResult==""][is.na(檢驗結果值)]$RNADetectionResult<-"negative"


lab_RNAdetectionfromSQL_episode<-merge(lab_RNAdetectionfromSQL[,c(1,3:13,25),with =F],Flu_episode2010to2015,by ="uniqueID")
lab_RNAdetectionfromSQL_episode$驗證日期<-ymd(lab_RNAdetectionfromSQL_episode$驗證日期)
lab_RNAdetectionfromSQL_tidy<-lab_RNAdetectionfromSQL_episode[驗證日期>=startday & 驗證日期<=endday]

#RNAdetection檢驗-各病程標籤
Flu_RNAdetection_positive<-unique(lab_RNAdetectionfromSQL_tidy[RNADetectionResult=='positive']$episodeno)
Flu_RNAdetection_negative<-unique(lab_RNAdetectionfromSQL_tidy[RNADetectionResult=='negative'][!episodeno%in%Flu_RNAdetection_positive]$episodeno)
Flu_RNAdetection_nolab<-Flu_episode2010to2015[!episodeno%in%c(Flu_RNAdetection_positive,Flu_RNAdetection_negative)]$episodeno

#RNA Detection為陽性的檢驗結果表，排序後取最後一筆檢驗資料(因positive會排序在negative後面)
lab_RNAdetectionfromSQL_tidy<-lab_RNAdetectionfromSQL_tidy[order(episodeno,RNADetectionResult)]
lab_RNAdetectionfromSQL_tidy<-lab_RNAdetectionfromSQL_tidy[,.SD[c(.N)],by = "episodeno"]

#整理後的表格

rm(lab_RNAdetectionfromSQL_episode,lab_RNAdetectionfromSQL,checkedRNA)

#流感病毒類型
lab_RNAdetectionfromSQL_tidy$VirusType<-''
lab_RNAdetectionfromSQL_tidy[RNADetectionResult=='positive']$VirusType<-substring(lab_RNAdetectionfromSQL_tidy[RNADetectionResult=='positive']$檢驗名稱縮寫,6,6)

