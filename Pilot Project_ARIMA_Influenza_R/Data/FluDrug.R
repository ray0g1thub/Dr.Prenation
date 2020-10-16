# 流感藥物
Flu_drug<-c('PZA183M','PNA021M','PNA025M','P4A090M','P4A045E','P6A545E','P6A890P')


##急診藥物資料
FluDrugData_ER<-data.table()
for (i in c(1:8)){
  Drug_raw<-fread(paste0('ER_drug_',i,'.csv'),colClasses = 'character')
  colnames(Drug_raw)<-c('院區',	'資料年月',	'uniqueID',	'輸入日期',	'門診號',	'醫囑編號',	'序號',	'劑量',	'劑量單位',	'頻率',	'飯前飯後代號',	'給藥途徑',
                        '計價單位',	'天數',	'自費天數',	'註記',	'單價',	'轉換單位一',	'轉換單位二',	'轉換劑量一',	'轉換劑量二',
                        '總量',	'自費總量',	'劑量一',	'劑量二','特殊頻率','自費',	'藥品項次',	'資料年齡')
  FluDrugData_ER<-rbind(FluDrugData_ER,Drug_raw[uniqueID%in%FluUniqueID_2010to2015][substring(醫囑編號,1,7)%in%Flu_drug])
  print(i)
  rm(Drug_raw)
}

#門診藥物

FluDrugData_OPD<-data.table()
for (i in c(1:80)){
  Drug_raw<-fread(paste0('OPD_drug_',i,'.csv'),colClasses = 'character')
  colnames(Drug_raw)<-c('院區',	'資料年月',	'uniqueID',	'輸入日期',	'門診號',	'醫囑編號',	'序號',	'劑量',	'劑量單位',	'頻率',	'飯前飯後代號',
                        '給藥途徑',	'計價單位',	'天數',	'自費天數',	'註記',	'劑別',	'轉換單位一',	'轉換單位二',	'轉換劑量一',	'轉換劑量二',	
                        '總量',	'自費總量',	'劑量一',	'劑量二',	'特殊頻率',	'自費',	'藥品項次',	'修改',	'新增',	'連續處方',	'煎煮方式',	'控制號',
                        'IRRE單日',	'IRRE雙日',	'IRRE上午',	'IRRE下午',	'IRRE晚上',	'IRRE睡前',	'週一',	'週二',	'週三',	'週四',	'週五',	'週六',	'週日',
                        '流速',	'點滴瓶',	'中藥範本代號',	'藥局健保總量',	'藥局自費總量',	'藥品名稱',	'疫苗代號',	'資料年齡')
  FluDrugData_OPD<-rbind(FluDrugData_OPD,Drug_raw[uniqueID%in%FluUniqueID_2010to2015][substring(醫囑編號,1,7)%in%Flu_drug])
  print(i)
  rm(Drug_raw)
}

#住院藥物


FluDrugData_IN <-data.table()
for (i in c(1:45)){
  Drug_raw<-fread(paste0('IN_drug_',i,'.csv'),colClasses = 'character')
  colnames(Drug_raw)<-c('院區',	'資料年月',	'uniqueID',	'開立日期',	'住院號',	'醫囑類別',	'藥品編號',	'劑量1(整數)',
                        '劑量2(小數)',	'單位',	'用法',	'用法2',	'飯前後',	'總量單位',	'數量',	'途徑',	'流速',	'點滴瓶',	'起始日',	'起始時間',
                        '結束日',	'護理站成本代號',	'註記',	'備份日',	'異動確認日',	'續用註記',	'續用量',	'開立日期',	'本日量',	'藥名',	'取消日',	'首日量',
                        '整檔註記',	'本日技術次數',	'首日量技術次數',	'尾日量技術次數',	'本日技',	'尾日量',	'註記',	'特殊給藥',	'自費',	'計價',	'剩餘量',	'註記',
                        '序號',	'轉檔日期',	'時間',	'本日量',	'開單醫師',	'資料年齡')
  
  FluDrugData_IN<-rbind(FluDrugData_IN,Drug_raw[uniqueID%in%FluUniqueID_2010to2015][substring(藥品編號,1,7)%in%Flu_drug])
  print(i)
  rm(Drug_raw)
}

####
FluDrugData_ER<-merge(FluDrugData_ER[,c('uniqueID', '輸入日期','醫囑編號'),with=F],Flu_episode2010to2015[,c('episodeno','uniqueID','startday','endday'),with=F],by='uniqueID',all.x = T)
FluDrugData_ER$輸入日期<-ymd(FluDrugData_ER$輸入日期)
FluDrugData_ER<-unique(FluDrugData_ER[輸入日期>=startday&輸入日期<=endday])
FluDrugData_ER$drug_start<-FluDrugData_ER$輸入日期-FluDrugData_ER$startday+1

FluDrugData_OPD<-merge(FluDrugData_OPD[,c('uniqueID', '輸入日期','醫囑編號'),with=F],Flu_episode2010to2015[,c('episodeno','uniqueID','startday','endday'),with=F],by='uniqueID',all.x = T)
FluDrugData_OPD$輸入日期<-ymd(FluDrugData_OPD$輸入日期)
FluDrugData_OPD<-unique(FluDrugData_OPD[輸入日期>=startday&輸入日期<=endday])
FluDrugData_OPD$drug_start<-FluDrugData_OPD$輸入日期-FluDrugData_OPD$startday+1

FluDrugData_IN<-merge(FluDrugData_IN[,c('uniqueID',  '起始日', '藥品編號'),with=F],Flu_episode2010to2015[,c('episodeno','uniqueID','startday','endday'),with=F],by='uniqueID',all.x = T)
FluDrugData_IN$起始日<-ymd(paste0(as.numeric(substring(FluDrugData_IN$起始日,1,3))+1911,substring(FluDrugData_IN$起始日,4,7)))

FluDrugData_IN<-unique(FluDrugData_IN[起始日>=startday&起始日<=endday])
FluDrugData_IN$drug_start<-FluDrugData_IN$起始日-FluDrugData_IN$startday+1

colnames(FluDrugData_ER)<-c("uniqueID","dataStartDate","drug_Name","episodeno","startday","endday","drug_start")
colnames(FluDrugData_OPD)<-c("uniqueID","dataStartDate","drug_Name","episodeno","startday","endday","drug_start")
colnames(FluDrugData_IN)<-c("uniqueID","dataStartDate","drug_Name","episodeno","startday","endday","drug_start")
FluDrugData<-rbind(FluDrugData_ER,FluDrugData_OPD,FluDrugData_IN)
FluDrugData$drug_Name<-substring(FluDrugData$drug_Name,1,7)
Flu_useFluDrug<-FluDrugData[order(episodeno,drug_start),][,.SD[1],by=episodeno]$episodeno
table(FluDrugData[order(episodeno,drug_start),][,.SD[1],by=episodeno]$drug_start)

#多久開始用藥?
ggplot(FluDrugData[order(episodeno,drug_start),][,.SD[1],by=episodeno][,.N,by = drug_start],aes(x = as.factor(drug_start),y=N))+geom_bar(stat = "identity")+
  labs(x='病程用藥起始時間',y='病程數')+theme_bw()
