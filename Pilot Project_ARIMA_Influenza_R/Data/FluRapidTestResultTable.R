#流感快速篩檢(RapidTest)篩選
#使用lab_i.csv檔案為"11116_檢驗結果歷史檔"共112個檔案

checkedrapidtest<-NULL
for (i in c(1:50)){
  a<-fread(paste0('lab_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",'資料年月','歸戶代號','檢驗編號','檢驗項目','序號','檢體','檢驗單一項目','檢驗名稱縮寫',
                 '輸入日期','輸入時間','檢驗結果值','驗證日期','驗證時間','驗證註記','免驗證註記','報告完成註記','結果異動註記','檢驗值異常註記',
                 '檢驗值危機註記','檢驗值單位','檢驗參考值','危險值通知註記','資料年齡')
  checkedrapidtest<-rbind(checkedrapidtest,a[歸戶代號%in%unique(FluUniqueID_2010to2015)][檢驗項目%in%c('72-768')])
  print(i)
}

for (i in c(51:112)){
  a<-fread(paste0('lab_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",'資料年月','歸戶代號','檢驗編號','檢驗項目','序號','檢體','檢驗單一項目','檢驗名稱縮寫',
                 '輸入日期','輸入時間','檢驗結果值','驗證日期','驗證時間','驗證註記','免驗證註記','報告完成註記','結果異動註記','檢驗值異常註記',
                 '檢驗值危機註記','檢驗值單位','檢驗參考值','危險值通知註記','資料年齡')
  checkedrapidtest<-rbind(checkedrapidtest,a[歸戶代號%in%unique(FluUniqueID_2010to2015)][檢驗項目%in%c('72-768')])
  print(i)
}
rm(a)

#判斷流感快速篩檢結果
lab_rapidtestfromSQL<-checkedrapidtest
lab_rapidtestfromSQL$檢驗結果值<-iconv(lab_rapidtestfromSQL$檢驗結果值,"big5","utf-8")
lab_rapidtestfromSQL$RapidTestResult<-""
lab_rapidtestfromSQL[grep("negative",tolower(檢驗結果值))]$RapidTestResult<-"negative"
lab_rapidtestfromSQL[RapidTestResult==""][grep("positive",tolower(檢驗結果值))]$RapidTestResult<-"positive"
lab_rapidtestfromSQL[RapidTestResult==""][grep("[+]",tolower(檢驗結果值))]$RapidTestResult<-"positive"
colnames(lab_rapidtestfromSQL)[3]<-"uniqueID"
lab_rapidtestfromSQL$驗證日期<-ymd(lab_rapidtestfromSQL$驗證日期)

lab_rapidtestfromSQL_episode<-merge(Flu_episode2010to2015,lab_rapidtestfromSQL,by = "uniqueID")
lab_rapidtestfromSQL_episode_tidy<-lab_rapidtestfromSQL_episode[驗證日期>=startday & 驗證日期<=endday]

#快篩檢驗-各病程標籤
Flu_rapidtest_positive<-unique(lab_rapidtestfromSQL_episode_tidy[RapidTestResult=='positive']$episodeno)
Flu_rapidtest_negative<-unique(lab_rapidtestfromSQL_episode_tidy[RapidTestResult=='negative'][!episodeno%in%Flu_rapidtest_positive]$episodeno)
Flu_rapidtest_nolab<-Flu_episode2010to2015[!episodeno%in%c(Flu_rapidtest_positive,Flu_rapidtest_negative)]$episodeno

#快篩為陽性的檢驗結果表，故排序後取最後一筆檢驗資料(因positive會排序在negative後面)
lab_rapidtestfromSQL_tidy<-lab_rapidtestfromSQL_episode[order(episodeno,RapidTestResult)]
lab_rapidtestfromSQL_tidy<-lab_rapidtestfromSQL_tidy[,.SD[c(.N)],by = "episodeno"] 

#流感病毒類型
lab_rapidtestfromSQL_tidy$VirusType<-''
lab_rapidtestfromSQL_tidy$ExamName<-lab_rapidtestfromSQL_tidy$檢驗名稱縮寫
lab_rapidtestfromSQL_tidy$ExamName<-gsub('Inf A','Influenza A',lab_rapidtestfromSQL_tidy$ExamName)
lab_rapidtestfromSQL_tidy$ExamName<-gsub('Inf B','Influenza B',lab_rapidtestfromSQL_tidy$ExamName)
lab_rapidtestfromSQL_tidy[RapidTestResult=='positive']$VirusType<-substring(lab_rapidtestfromSQL_tidy[RapidTestResult=='positive']$ExamName,11,11)



rm(lab_rapidtestfromSQL_episode,lab_rapidtestfromSQL)
