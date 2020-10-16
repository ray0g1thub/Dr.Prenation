##血液培養檔案來自11116_微生物結果檔_i.csv，共三個檔案
bloodculturedata<-NULL
for (i in c(1:3)){
  
  a<-fread(paste0('11116_微生物結果檔_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",	"資料年月",	"uniqueID",	"檢驗編號",	"檢驗項目",	"序號",	"檢體",	"檢驗名稱縮寫",	"細菌代號",	"細菌名稱",	"生長狀態",
                 "抹片值說明",	"輸入日期",	"輸入時間",	"驗證日期",	"驗證時間",	"驗證註記",	"免驗證註記",	"列印註記",	"結果異動註記",	"報告狀態",	"抹片驗證註記",
                 "抹片結果異動註記",	"抹片驗證日期",	"抹片驗證時間",	"危險值通知註記",	"抹片輸入日期",	"抹片輸入時間",	"資料年齡")
  bloodculturedata<-rbind(bloodculturedata,a[uniqueID%in%unique(FluUniqueID_2010to2015)][檢驗項目%in%c('72-607')][檢體%in%c("B","BM")])
  print(i)
}
rm(a)
bloodculturedata$驗證日期<-ymd(bloodculturedata$驗證日期)
bloodculturedata_episode<-merge(bloodculturedata[,c(1,3:11,15),with =F],Flu_episode2010to2015,by ="uniqueID")

#取在病程區間內的檢驗資料
bloodculturedata_episode_tidy<-bloodculturedata_episode[驗證日期>=startday & 驗證日期<=endday]  #6956
#判斷培養結果
bloodculturedata_episode_tidy$bloodculturedata<-""
bloodculturedata_episode_tidy[grep("growth",tolower(細菌名稱))]$bloodculturedata<-"negative"
bloodculturedata_episode_tidy[bloodculturedata==""]$bloodculturedata<-"positive"

bloodculturedata_episode_tidy<-bloodculturedata_episode_tidy[order(episodeno,bloodculturedata)]
bloodculturedata_episode_tidy<-bloodculturedata_episode_tidy[,.SD[c(.N)],by = "episodeno"] #整理後的表格
#血液培養結果病程標籤
bloodculturedata_positive_episodeno<-unique(bloodculturedata_episode_tidy[bloodculturedata=='positive']$episodeno)
bloodculturedata_negative_episodeno<-unique(bloodculturedata_episode_tidy[bloodculturedata=='negative'][!episodeno%in%bloodculturedata_positive_episodeno]$episodeno)
bloodculturedata_nolab_episodeno<-unique(Flu_episode2010to2015[!episodeno%in%c(bloodculturedata_positive_episodeno,bloodculturedata_negative_episodeno)]$episodeno)


rm(bloodculturedata,bloodculturedata_episode)