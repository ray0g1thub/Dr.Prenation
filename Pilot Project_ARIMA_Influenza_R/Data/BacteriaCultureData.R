#細菌培養資料來自11116_微生物結果檔_i.csv，共三個檔案

cultureData<-data.table()
for (i in c(1:3)){
  a<-fread(paste0('11116_微生物結果檔_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",	"資料年月",	"uniqueID",	"檢驗編號",	"檢驗項目",	"序號",	"檢體",	"檢驗名稱縮寫",	"細菌代號",
                 "細菌名稱",	"生長狀態",	"抹片值說明",	"輸入日期",	"輸入時間",	"驗證日期",	"驗證時間",	"驗證註記",	"免驗證註記",
                 "列印註記",	"結果異動註記",	"報告狀態",	"抹片驗證註記",	"抹片結果異動註記",	"抹片驗證日期",	"抹片驗證時間",
                 "危險值通知註記",	"抹片輸入日期",	"抹片輸入時間",	"資料年齡")
  cultureData<-rbind(cultureData,a[uniqueID%in%Flu_episode2010to2015_Summarize$uniqueID],fill=T)
  print(i)
}

cultureData$輸入日期<-ymd(cultureData$輸入日期)
#與重症案例合併
cultureData<-merge(cultureData,Flu_episode2010to2015_Summarize,by='uniqueID',allow.cartesian=TRUE)
cultureData<-cultureData[輸入日期>=startday&輸入日期<=endday+7]

#細菌培養結果整理
cultureData$no<-1:nrow(cultureData)
cultureData$細菌名稱<-iconv(cultureData$細菌名稱,'big-5','utf-8')
cultureData$cultureResult<-''
cultureData[grepl("normal|no growth for|no growth  |no  growth for |no growth to date|no  growth  for |no growth  to date|colony|mixed flora|aerobes & anaerobes no growth to date|contamination|negative",tolower(細菌名稱))]$cultureResult<-'negative'

cultureData[grepl("same",tolower(細菌名稱))]$cultureResult<-'same'
cultureData[cultureResult==''][grepl("gram",tolower(細菌名稱))][grepl("+",tolower(細菌名稱))]$cultureResult<-'gram positive'
cultureData[cultureResult==''][grepl("gm",tolower(細菌名稱))][grepl("[+]",tolower(細菌名稱))]$cultureResult<-'gram positive'
cultureData[cultureResult==''][grepl("gram",tolower(細菌名稱))][grepl("-",tolower(細菌名稱))]$cultureResult<-'gram negative'
cultureData[cultureResult==''][grepl("gm",tolower(細菌名稱))][grepl("[-]",tolower(細菌名稱))]$cultureResult<-'gram negative'
cultureData[cultureResult==''][grepl("yeast",tolower(細菌名稱))]$cultureResult<-'Yeast-like'
cultureData[cultureResult==''][grepl("aerobes",tolower(細菌名稱))]$cultureResult<-'aerobes'
cultureData[cultureResult=='']$cultureResult<-cultureData[cultureResult=='']$細菌名稱

#篩選檢體類型
includeCultureType2<-c('B','BAL','SP','FB','TH','PL','CSF','BW','BA','U','SSS','SC','FU','SCD','SV','UU','SEV')
unique(cultureData[檢體%in%includeCultureType2][,c('episodeno','cultureResult')][!cultureResult%in%c('negative','same')])[,.N,by=episodeno][,.N,by=N]
unique(cultureData[檢體%in%includeCultureType2][,c('episodeno','cultureResult')][!cultureResult%in%c('negative','same')])[,.N,by=episodeno][N=='8']

#細菌培養結果呈現陽性的病程
culturePositiveEpisodeno<-unique(cultureData[檢體%in%includeCultureType2][,c('episodeno','cultureResult')][!cultureResult%in%c('negative','same')]$episodeno)

#細菌培養結果視覺化呈現(看哪種細菌最多)
cultureData$no<-1:nrow(cultureData)
ggplot(unique(cultureData[檢體%in%includeCultureType2][,c('episodeno','cultureResult')][!cultureResult%in%c('negative','same')])[,.N,by=cultureResult][1:20],aes(x = reorder(cultureResult, -N),y=N))+geom_bar(stat = "identity")+
  labs(x='Pathogen',y='Episode')+theme_bw()+theme(axis.text.x=element_text(angle=45, hjust=1))

#細菌培養陽性結果分類(grouping)
write.csv(cultureData[檢體%in%includeCultureType2][,c('episodeno','cultureResult','no')][!cultureResult%in%c('negative','same')],'BacterialCultureData_Grouping.csv',row.names = F)

