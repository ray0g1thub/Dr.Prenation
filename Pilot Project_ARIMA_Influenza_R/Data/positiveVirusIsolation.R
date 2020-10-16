#Virus Isolation
#使用lab_i.csv檔案為"11116_檢驗結果歷史檔"共112個檔案

checkedVirusIsolation<-NULL
for (i in c(1:50)){
  a<-fread(paste0('lab_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",'資料年月','歸戶代號','檢驗編號','檢驗項目','序號','檢體','檢驗單一項目','檢驗名稱縮寫',
                 '輸入日期','輸入時間','檢驗結果值','驗證日期','驗證時間','驗證註記','免驗證註記','報告完成註記','結果異動註記','檢驗值異常註記',
                 '檢驗值危機註記','檢驗值單位','檢驗參考值','危險值通知註記','資料年齡')
  checkedVirusIsolation<-rbind(checkedVirusIsolation,a[歸戶代號%in%unique(FluUniqueID_2010to2015)][檢驗項目%in%c('72-901')])
  print(i)
}

for (i in c(51:112)){
  a<-fread(paste0('lab_',i,'.csv'),colClasses = "character")
  colnames(a)<-c("院區",'資料年月','歸戶代號','檢驗編號','檢驗項目','序號','檢體','檢驗單一項目','檢驗名稱縮寫',
                 '輸入日期','輸入時間','檢驗結果值','驗證日期','驗證時間','驗證註記','免驗證註記','報告完成註記','結果異動註記','檢驗值異常註記',
                 '檢驗值危機註記','檢驗值單位','檢驗參考值','危險值通知註記','資料年齡')
  checkedVirusIsolation<-rbind(checkedVirusIsolation,a[歸戶代號%in%unique(FluUniqueID_2010to2015)][檢驗項目%in%c('72-901')])
  print(i)
}
rm(a)
#篩選落在病程區間內檢驗資料
lab_VirusIsolationfromSQL<-checkedVirusIsolation
lab_VirusIsolationfromSQL$檢驗結果值<-iconv(lab_VirusIsolationfromSQL$檢驗結果值,"big5","utf8")
colnames(lab_VirusIsolationfromSQL)[3]<-"uniqueID"

lab_VirusIsolationfromSQL$VirusIsolationResult<-""
lab_VirusIsolationfromSQL[VirusIsolationResult==""][grepl("growth",tolower(檢驗結果值))]$VirusIsolationResult<-"negative"
lab_VirusIsolationfromSQL[VirusIsolationResult==""][grepl("isolated",tolower(檢驗結果值))]$VirusIsolationResult<-"negative"
lab_VirusIsolationfromSQL[VirusIsolationResult==""][grepl("influenza",tolower(檢驗結果值))][!grepl("para",tolower(檢驗結果值))]$VirusIsolationResult<-"positive"
lab_VirusIsolationfromSQL[VirusIsolationResult==""][grepl("negative",tolower(檢驗結果值))]$VirusIsolationResult<-"negative"

table(lab_VirusIsolationfromSQL[VirusIsolationResult!='negative']$檢驗結果值)

#VirusIsolation陽性檢驗結果分類
positiveVirusIsolation<-lab_VirusIsolationfromSQL[VirusIsolationResult!='negative']
positiveVirusIsolation$InfluenzaA<-''
positiveVirusIsolation[grepl("influenza a",tolower(檢驗結果值))]$InfluenzaA<-'T'
positiveVirusIsolation$InfluenzaB<-''
positiveVirusIsolation[grepl("influenza b",tolower(檢驗結果值))]$InfluenzaB<-'T'
positiveVirusIsolation$Adenovirus<-''
positiveVirusIsolation[grepl("adenovirus",tolower(檢驗結果值))]$Adenovirus<-'T'
positiveVirusIsolation$Enterovirus<-''
positiveVirusIsolation[grepl("enterovirus",tolower(檢驗結果值))]$Enterovirus<-'T'
positiveVirusIsolation$HerpesVirus<-''
positiveVirusIsolation[grepl("hsv|herpes virus",tolower(檢驗結果值))]$HerpesVirus<-'T'
positiveVirusIsolation$Cytomegalovirus<-''
positiveVirusIsolation[grepl("cmv|cytomegalovirus",tolower(檢驗結果值))]$Cytomegalovirus<-'T'
positiveVirusIsolation$RSV<-''
positiveVirusIsolation[grepl("rsv|respiratory syncytial virus",tolower(檢驗結果值))]$RSV<-'T'
positiveVirusIsolation$parainfluenza<-''
positiveVirusIsolation[grepl("parainfluenza",tolower(檢驗結果值))]$parainfluenza<-'T'
positiveVirusIsolation$metapneumovirus<-''
positiveVirusIsolation[grepl("metapneumovirus",tolower(檢驗結果值))]$metapneumovirus<-'T'
positiveVirusIsolation$hMPV<-''
positiveVirusIsolation[grepl("hmpv",tolower(檢驗結果值))]$hMPV<-'T'


positiveVirusIsolationResult<-positiveVirusIsolation[,c(3,7:10,12,25:35),with=F]
positiveVirusIsolationResult$輸入日期<-ymd(positiveVirusIsolationResult$輸入日期)
colnames(positiveVirusIsolationResult)[1]<-'uniqueID'
positiveVirusIsolationResult<-merge(positiveVirusIsolationResult,Flu_episode2010to2015,by='uniqueID',all.x=T)
positiveVirusIsolationResult<-positiveVirusIsolationResult[輸入日期>=startday&輸入日期<=endday+7]
positiveVirusIsolationResult<-melt(positiveVirusIsolationResult,id.vars=c("uniqueID","檢體","檢驗單一項目",'檢驗名稱縮寫','輸入日期','檢驗結果值','episodeno',
                                                                          'startday','endday','no','CDC_year','CDC_week','sex','birthdate'))
positiveVirusIsolationResult<-positiveVirusIsolationResult[variable!='VirusIsolationResult'][value=='T']


#VirusIsolation檢驗-各病程標籤
lab_VirusIsolationfromSQL_merge<-merge(lab_VirusIsolationfromSQL,Flu_episode2010to2015,by='uniqueID',all.x=T)
lab_VirusIsolationfromSQL_merge$輸入日期<-ymd(lab_VirusIsolationfromSQL_merge$輸入日期)
lab_VirusIsolationfromSQL_merge<-lab_VirusIsolationfromSQL_merge[輸入日期>=startday&輸入日期<=endday+7]
Flu_VirusIsolation_positive<-unique(positiveVirusIsolationResult[variable%in%c('InfluenzaA','InfluenzaB')]$episodeno)
Flu_VirusIsolation_negative<-unique(lab_VirusIsolationfromSQL_merge[VirusIsolationResult=='negative'][!episodeno%in%Flu_VirusIsolation_positive]$episodeno)
Flu_VirusIsolation_nolab<-Flu_episode2010to2015[!episodeno%in%c(Flu_VirusIsolation_positive,Flu_VirusIsolation_negative)]$episodeno


#VirusType欄位為病毒類型
positiveVirusIsolationResult$VirusType<-''
positiveVirusIsolationResult[variable%in%"Enterovirus"][grepl("9",tolower(檢驗結果值))]$VirusType<-'Enterovirus COX.A9'
positiveVirusIsolationResult[variable%in%"Enterovirus"][grepl("5",tolower(檢驗結果值))]$VirusType<-'Enterovirus COX.B5'

positiveVirusIsolationResult[variable%in%"HerpesVirus"][grepl("1|type",tolower(檢驗結果值))]$VirusType<-'HSV-1'
positiveVirusIsolationResult[variable%in%"HerpesVirus"][grepl("2",tolower(檢驗結果值))]$VirusType<-'HSV-2'


positiveVirusIsolationResult[variable%in%"parainfluenza"][grepl("1",tolower(檢驗結果值))]$VirusType<-'Parainfluenza 1'
positiveVirusIsolationResult[variable%in%"parainfluenza"][VirusType!='Parainfluenza 1']$VirusType<-'Parainfluenza 3'

positiveVirusIsolationResult[VirusType=='']$VirusType<-positiveVirusIsolationResult[VirusType=='']$variable





##病程中 病毒種類分布
unique(positiveVirusIsolationResult[,c("episodeno","VirusType"),with=F])[,.N,by=VirusType]
##病程中  各病程有多少培養出病毒
unique(positiveVirusIsolationResult[,c("episodeno","VirusType"),with=F])[,.N,by=episodeno][,.N,by=N]

#VirusIsolation結果視覺化
library(ggplot2)
ggplot(unique(positiveVirusIsolationResult[,c("episodeno","VirusType"),with=F])[,.N,by=VirusType],aes(x = reorder(VirusType, -N),y=N))+geom_bar(stat = "identity")+
  labs(x='Pathogen',y='Episode')+theme_bw()+theme(axis.text.x=element_text(angle=45, hjust=1))

rm(lab_VirusIsolationfromSQL_episode,lab_VirusIsolationfromSQL,checkedIgG,checkedVirusIsolation)
