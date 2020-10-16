#A/B 型流感病毒抗體檢驗(Influenza A, B IgG)篩選
#使用lab_i.csv檔案為"11116_檢驗結果歷史檔"共112個檔案

checkedIgG<-NULL
for (i in c(1:50)){
  a<-fread(paste0('lab_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",'資料年月','歸戶代號','檢驗編號','檢驗項目','序號','檢體','檢驗單一項目','檢驗名稱縮寫',
                 '輸入日期','輸入時間','檢驗結果值','驗證日期','驗證時間','驗證註記','免驗證註記','報告完成註記','結果異動註記','檢驗值異常註記',
                 '檢驗值危機註記','檢驗值單位','檢驗參考值','危險值通知註記','資料年齡')
  checkedIgG<-rbind(checkedIgG,a[歸戶代號%in%unique(FluUniqueID_2010to2015)][檢驗項目%in%c('72-959','72-960','72-961')])
  print(i)
}

for (i in c(51:112)){
  a<-fread(paste0('lab_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",'資料年月','歸戶代號','檢驗編號','檢驗項目','序號','檢體','檢驗單一項目','檢驗名稱縮寫',
                 '輸入日期','輸入時間','檢驗結果值','驗證日期','驗證時間','驗證註記','免驗證註記','報告完成註記','結果異動註記','檢驗值異常註記',
                 '檢驗值危機註記','檢驗值單位','檢驗參考值','危險值通知註記','資料年齡')
  checkedIgG<-rbind(checkedIgG,a[歸戶代號%in%unique(FluUniqueID_2010to2015)][檢驗項目%in%c('72-959','72-960','72-961')])
  print(i)
}
rm(a)

lab_IgGfromSQL<-checkedIgG
lab_IgGfromSQL$檢驗結果值<-iconv(lab_IgGfromSQL$檢驗結果值,"big5","utf8")
##lab_IgGfromSQL
lab_IgGfromSQL$驗證日期<-ymd(lab_IgGfromSQL$驗證日期)

table(lab_IgGfromSQL$檢驗結果值)
lab_IgGfromSQL$Flu_IgGResult<-""
lab_IgGfromSQL[grep("positive",tolower(檢驗結果值))]$Flu_IgGResult<-"positive"
lab_IgGfromSQL[Flu_IgGResult==""][grep("negative",tolower(檢驗結果值))]$Flu_IgGResult<-"negative"
lab_IgGfromSQL[Flu_IgGResult==""][grep("[+]",tolower(檢驗結果值))]$Flu_IgGResult<-"positive"
lab_IgGfromSQL[Flu_IgGResult==""][grep("[-]",tolower(檢驗結果值))]$Flu_IgGResult<-"negative"
lab_IgGfromSQL[Flu_IgGResult==""][grep("equivocal",tolower(檢驗結果值))]$Flu_IgGResult<-"positive"


colnames(lab_IgGfromSQL)[3]<-"uniqueID"
lab_IgGfromSQL<-merge(lab_IgGfromSQL,Flu_episode2010to2015,by = "uniqueID")
lab_IgGfromSQL_episode_tidy<-lab_IgGfromSQL[驗證日期>=startday &驗證日期<=endday]


#流感抗體檢驗-各病程標籤
Flu_IgG_positive<-unique(lab_IgGfromSQL_episode_tidy[Flu_IgGResult=='positive']$episodeno)
Flu_IgG_negative<-unique(lab_IgGfromSQL_episode_tidy[Flu_IgGResult=='negative'][!episodeno%in%Flu_IgG_positive]$episodeno)
Flu_IgG_nolab<-Flu_episode2010to2015[!episodeno%in%c(Flu_IgG_positive,Flu_IgG_negative)]$episodeno

#流感抗體檢驗為陽性的檢驗結果表，排序後取最後一筆檢驗資料(因positive會排序在negative後面)
lab_IgGfromSQL_episode_tidy<-lab_IgGfromSQL_episode_tidy[order(episodeno,Flu_IgGResult)]
lab_IgGfromSQL_episode_tidy<-lab_IgGfromSQL_episode_tidy[,.SD[c(.N)],by = "episodeno"]


#病毒抗體檢驗出的流感病毒類型
lab_IgGfromSQL_episode_tidy$VirusType<-''
lab_IgGfromSQL_episode_tidy[Flu_IgGResult=='positive']$VirusType<-substring(lab_IgGfromSQL_episode_tidy[Flu_IgGResult=='positive']$檢驗名稱縮寫,4,4)


