##痰液培養檔案來自11116_微生物結果檔_i.csv，共三個檔案

culturedata<-NULL
for (i in c(1:3)){
  
  a<-fread(paste0('11116_微生物結果檔_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",	"資料年月",	"uniqueID",	"檢驗編號",	"檢驗項目",	"序號",	"檢體",	"檢驗名稱縮寫",	"細菌代號",	"細菌名稱",	"生長狀態",
                 "抹片值說明",	"輸入日期",	"輸入時間",	"驗證日期",	"驗證時間",	"驗證註記",	"免驗證註記",	"列印註記",	"結果異動註記",	"報告狀態",	"抹片驗證註記",
                 "抹片結果異動註記",	"抹片驗證日期",	"抹片驗證時間",	"危險值通知註記",	"抹片輸入日期",	"抹片輸入時間",	"資料年齡")
  culturedata<-rbind(culturedata,a[uniqueID%in%unique(FluUniqueID_2010to2015)][檢驗項目%in%c('72-601')][檢體%in%c("PL","BAL","SP","BA","BW")])
  print(i)
}
rm(a)
culturedata$驗證日期<-ymd(culturedata$驗證日期)

#取在病程區間內的檢驗資料
SputumCultureData_Episode<-merge(culturedata[,c(1,3:11,15),with =F],Flu_episode2010to2015,by ="uniqueID")
SputumCultureData_Episode_tidy<-SputumCultureData_Episode[驗證日期>=startday & 驗證日期<=endday]  #4308

#判斷痰液培養結果
SputumCultureData_Episode_tidy$sputumculture<-""
SputumCultureData_Episode_tidy[grep("growth",tolower(細菌名稱))]$sputumculture<-"negative"
SputumCultureData_Episode_tidy[grep("flora",tolower(細菌名稱))]$sputumculture<-"negative"
SputumCultureData_Episode_tidy[sputumculture==""][grep("saliva",tolower(細菌名稱))]$sputumculture<-"negative"
SputumCultureData_Episode_tidy[sputumculture==""][grep("contamination",tolower(細菌名稱))]$sputumculture<-"contamination"
SputumCultureData_Episode_tidy[sputumculture==""][grep("[<]",tolower(細菌名稱))]$sputumculture<-"negative"
SputumCultureData_Episode_tidy[sputumculture==""]$sputumculture<-"positive"
SputumCultureData_Episode_tidy<-SputumCultureData_Episode_tidy[order(episodeno,sputumculture)]
SputumCultureData_Episode_tidy<-SputumCultureData_Episode_tidy[,.SD[c(.N)],by = "episodeno"]


#痰液培養結果病程標籤
SputumCultureData_positive_episodeno<-unique(SputumCultureData_Episode_tidy[sputumculture=='positive']$episodeno)
SputumCultureData_negative_episodeno<-unique(SputumCultureData_Episode_tidy[sputumculture=='negative'][!episodeno%in%SputumCultureData_positive_episodeno]$episodeno)
SputumCultureData_nolab_episodeno<-unique(Flu_episode2010to2015[!episodeno%in%c(SputumCultureData_positive_episodeno,SputumCultureData_negative_episodeno)]$episodeno)

