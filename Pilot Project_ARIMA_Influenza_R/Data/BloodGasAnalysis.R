#血液氣體分析
#使用lab_i.csv檔案為"11116_檢驗結果歷史檔"共112個檔案

BloodGasAnalysis<-NULL
for (i in c(1:50)){
  a<-fread(paste0('lab_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",'資料年月','歸戶代號','檢驗編號','檢驗項目','序號','檢體','檢驗單一項目','檢驗名稱縮寫',
                 '輸入日期','輸入時間','檢驗結果值','驗證日期','驗證時間','驗證註記','免驗證註記','報告完成註記','結果異動註記','檢驗值異常註記',
                 '檢驗值危機註記','檢驗值單位','檢驗參考值','危險值通知註記','資料年齡')
  BloodGasAnalysis<-rbind(BloodGasAnalysis,a[歸戶代號%in%unique(FluUniqueID_2010to2015)][檢驗項目%in%c('72-530')])
  print(i)
}

for (i in c(51:112)){
  a<-fread(paste0('lab_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",'資料年月','歸戶代號','檢驗編號','檢驗項目','序號','檢體','檢驗單一項目','檢驗名稱縮寫',
                 '輸入日期','輸入時間','檢驗結果值','驗證日期','驗證時間','驗證註記','免驗證註記','報告完成註記','結果異動註記','檢驗值異常註記',
                 '檢驗值危機註記','檢驗值單位','檢驗參考值','危險值通知註記','資料年齡')
  BloodGasAnalysis<-rbind(BloodGasAnalysis,a[歸戶代號%in%unique(FluUniqueID_2010to2015)][檢驗項目%in%c('72-530')])
  print(i)
}
rm(a)

BloodGasAnalysisTable<-BloodGasAnalysis
BloodGasAnalysisTable$檢驗結果值<-iconv(BloodGasAnalysisTable$檢驗結果值,"big5","utf8")
BloodGasAnalysisTable$驗證日期<-ymd(BloodGasAnalysisTable$驗證日期)

colnames(BloodGasAnalysisTable)[3]<-"uniqueID"
BloodGasAnalysisTable<-merge(BloodGasAnalysisTable,Flu_episode2010to2015,by = "uniqueID",allow.cartesian=TRUE)
BloodGasAnalysisTable_episode_tidy<-BloodGasAnalysisTable[驗證日期>=startday &驗證日期<=endday]
BloodGasAnalysisTable_episode_tidy$BloodGas<-"T"

#是否有進行血氧氣體分析-各病程標籤
BloodGasAnalysis_episodeno<-unique(BloodGasAnalysisTable_episode_tidy[BloodGas=='T']$episodeno)
BloodGasAnalysis_nolab<-Flu_episode2010to2015[!episodeno%in%c(BloodGasAnalysis_episodeno)]$episodeno

rm(BloodGasAnalysis,BloodGasAnalysisTable)
