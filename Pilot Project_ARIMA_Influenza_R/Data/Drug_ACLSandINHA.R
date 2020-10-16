##撈取呼吸治療藥物及急救藥物
ACLS_drug<-c("PFA070P","PFA025P","EMS-213","PED008P","EMS-742","P62735P","PIG100P","EMS-216","PFA017P","PEA005P","PEA008P","PLC018P","PEA004P","PA030P","PIC020P","PIC041P","PEA024P","PFA018P","EMS-278",
             "PGA028P","PFA080P","EMS-030","EMS-051","PGD028P","PAA013P","PFE040P","PFE034M","PEA032P","PIB008P","P6A940P","PFA052P")
yearrange<-c(2010:2016)

##ER drug
setwd("~/Flu_fromSQL/ER_drug")
ER_druglist_INHA<-NULL
ER_druglist_ACLSdrug<-NULL
for(i in c(1:8)){
  a<-fread(paste0("ER_drug_",i,".csv"),colClasses = "character")
  colnames(a)<-c("院區",	"資料年月",	"歸戶代號",	"輸入日期",	"門診號",	"醫囑編號",	"序號",	"劑量",	"劑量單位",	"頻率",	"飯前飯後代號",	"給藥途徑",	"計價單位",	"天數",
                 "自費天數",	"註記",	"單價",	"轉換單位一",	"轉換單位二",	"轉換劑量一",	"轉換劑量二",	"總量",	"自費總量",	"劑量一",	"劑量二",	"特殊頻率",	"自費",	"藥品項次",	"資料年齡")
  ER_druglist_INHA<-rbind(ER_druglist_INHA,a[歸戶代號%in%FluUniqueID_2010to2015][給藥途徑%in%c("INHA")])
  ER_druglist_ACLSdrug<-rbind(ER_druglist_ACLSdrug,a[歸戶代號%in%FluUniqueID_2010to2015][substring(醫囑編號,1,7)%in%ACLS_drug])

}
ER_druglist_INHA<-ER_druglist_INHA[substring(輸入日期,1,4)%in%yearrange]

ER_druglist_ACLSdrug<-ER_druglist_ACLSdrug[substring(輸入日期,1,4)%in%yearrange]
##IN drug

setwd("~/Flu_fromSQL/IN_drug")
IN_druglist_INHA<-NULL
IN_druglist_ACLSdrug<-NULL
for(i in c(1:45)){
  a<-fread(paste0("IN_drug_",i,".csv"),colClasses = "character")
  colnames(a)<-c("院區",	"資料年月",	"歸戶代號",	"開立日期",	"住院號",	"醫囑類別",	"醫囑編號",
                 "劑量1",	"劑量2",	"單位",	"用法",	"用法2",	"飯前後",	'總量單位',	
                 "數量",	"給藥途徑",	"流速",	"點滴瓶",	"起始日",	"起始時間",	"結束日",	"護理站成本代號",	"註記",
                 "備份日",	"異動確認日",	"續用註記",	"續用量",	"開立日期",	"本日量",	"藥名",	"取消日",
                 "首日量",	"整檔註記",	"本日技術次數",	"首日量技術次數",	"尾日量技術次數",	"本日技",	"尾日量",
                 "註記",	"特殊給藥",	"自費",	"計價",	"剩餘量",	"註記",	"序號",	"轉檔日期",	"時間",	"本日量",
                 "開單醫師",	"資料年齡")
  
  IN_druglist_INHA<-rbind(IN_druglist_INHA,a[歸戶代號%in%FluUniqueID_2010to2015][給藥途徑%in%c("INHA")])
  IN_druglist_ACLSdrug<-rbind(IN_druglist_ACLSdrug,a[歸戶代號%in%FluUniqueID_2010to2015][substring(醫囑編號,1,7)%in%ACLS_drug])
  
}
IN_druglist_INHA<-IN_druglist_INHA[substring(開立日期,1,4)%in%yearrange]
IN_druglist_ACLSdrug<-IN_druglist_ACLSdrug[substring(開立日期,1,4)%in%yearrange]
##OPD drug

setwd("~/Flu_fromSQL/OPD_drug")
OPD_druglist_INHA<-NULL
OPD_druglist_ACLSdrug<-NULL
for(i in c(1:80)){
  a<-fread(paste0("OPD_drug_",i,".csv"),colClasses = "character")
  colnames(a)<-c("院區",	"資料年月",	"歸戶代號",	"輸入日期",	"門診號",	"醫囑編號",
                 "序號",	"劑量",	"劑量單位",	"頻率",	"飯前飯後代號",	"給藥途徑",	"計價單位",
                 "天數",	"自費天數",	"註記",	"劑別",	"轉換單位一",	"轉換單位二",	"轉換劑量一",
                 "轉換劑量二",	"總量",	"自費總量",	"劑量一",	"劑量二",	"特殊頻率",	"自費",
                 "藥品項次",	"修改",	"新增",	"連續處方",	"煎煮方式",	"控制號",	"IRRE單日",
                 "IRRE雙日",	"IRRE上午",	"IRRE下午",	"IRRE晚上",	"IRRE睡前",
                 "週一",	"週二",	"週三",	"週四",	"週五",	"週六",	"週日",
                 "流速",	"點滴瓶",	"中藥範本代號",	"藥局健保總量",	"藥局自費總量",
                 "藥品名稱",	"疫苗代號",	"資料年齡")
  
  OPD_druglist_INHA<-rbind(OPD_druglist_INHA,a[歸戶代號%in%FluUniqueID_2010to2015][給藥途徑%in%c("INHA")]) #改成[給藥途徑%in%c("INHA","I")]
  OPD_druglist_ACLSdrug<-rbind(OPD_druglist_ACLSdrug,a[歸戶代號%in%FluUniqueID_2010to2015][substring(醫囑編號,1,7)%in%ACLS_drug])
}

OPD_druglist_INHA<-OPD_druglist_INHA[substring(輸入日期,1,4)%in%yearrange]
OPD_druglist_ACLSdrug<-OPD_druglist_ACLSdrug[substring(輸入日期,1,4)%in%yearrange]

###save files
#saveRDS(ER_druglist_ACLSdrug,"ER_druglist_ACLSdrug.rds")
#saveRDS(IN_druglist_ACLSdrug,"IN_druglist_ACLSdrug.rds")
#saveRDS(OPD_druglist_ACLSdrug,"OPD_druglist_ACLSdrug.rds")
#saveRDS(ER_druglist_INHA,"ER_druglist_INHA.rds")
#saveRDS(IN_druglist_INHA,"IN_druglist_INHA.rds")
#saveRDS(OPD_druglist_INHA,"OPD_druglist_INHA.rds")





ACLSDrug_Freq<-c('IRRE','ONCE',"PRN","STAT")

##ER_druglist_ACLS_data整理
#ER_druglist_ACLSdrug<-readRDS('ER_druglist_ACLSdrug.rds')
ER_druglist_ACLSdrug_data<-ER_druglist_ACLSdrug[,c("歸戶代號","輸入日期","醫囑編號","頻率","給藥途徑","註記"),with =F]
ER_druglist_ACLSdrug_data$輸入日期<-ymd(ER_druglist_ACLSdrug_data$輸入日期)
ER_druglist_ACLSdrug_data$藥物名稱<-substring(ER_druglist_ACLSdrug_data$醫囑編號,1,7)
colnames(ER_druglist_ACLSdrug_data)[1]<-"uniqueID"

Total_drug_ACLS_ER<-merge(Flu_episode2010to2015[,c("uniqueID","startday","endday","no","episodeno"),with=F],ER_druglist_ACLSdrug_data,by = "uniqueID")
Total_drug_ACLS_ER<-unique(Total_drug_ACLS_ER[輸入日期>=startday & 輸入日期<=endday])
Total_drug_ACLS_ER<-unique(Total_drug_ACLS_ER[頻率%in%ACLSDrug_Freq])
#saveRDS(Total_drug_ACLS_ER,"Total_drug_ACLS_ER.rds")
Total_drug_ACLS_episodenolist<-unique(Total_drug_ACLS_ER[頻率%in%ACLSDrug_Freq]$episodeno)#ER: 164

##OPD_druglist_ACLS_data整理

#OPD_druglist_ACLSdrug<-readRDS('OPD_druglist_ACLSdrug.rds')
OPD_druglist_ACLSdrug<-OPD_druglist_ACLSdrug[!連續處方=="Y"]
OPD_druglist_ACLSdrug_data<-OPD_druglist_ACLSdrug[,c("歸戶代號","輸入日期","醫囑編號","頻率","給藥途徑","註記"),with =F]
OPD_druglist_ACLSdrug_data$藥物名稱<-substring(OPD_druglist_ACLSdrug_data$醫囑編號,1,7)
OPD_druglist_ACLSdrug_data$輸入日期<-ymd(OPD_druglist_ACLSdrug_data$輸入日期)
colnames(OPD_druglist_ACLSdrug_data)[1]<-"uniqueID"

Total_drug_ACLSdrug_OPD<-merge(Flu_episode2010to2015[,c("uniqueID","startday","endday","no","episodeno"),with=F],OPD_druglist_ACLSdrug_data,by = "uniqueID")
Total_drug_ACLSdrug_OPD<-unique(Total_drug_ACLSdrug_OPD[輸入日期>=startday & 輸入日期<=endday][頻率%in%ACLSDrug_Freq])
Total_drug_ACLS_episodenolist<-unique(c(Total_drug_ACLS_episodenolist,unique(Total_drug_ACLSdrug_OPD$episodeno)))  ##OPD 23  ##ER+OPD 184
#saveRDS(Total_drug_ACLSdrug_OPD,"Total_drug_ACLSdrug_OPD.rds")


#IN_druglist_ACLSdrug<-readRDS("IN_druglist_ACLSdrug.rds")
IN_druglist_ACLSdrug_data<-IN_druglist_ACLSdrug[,c("歸戶代號","住院號","醫囑類別","醫囑編號","用法","起始日","結束日"),with =F]
IN_druglist_ACLSdrug_data$起始日<-ymd(paste0(1911+as.numeric(substring(IN_druglist_ACLSdrug_data$起始日,1,3)),substring(IN_druglist_ACLSdrug_data$起始日,4,7)))
IN_druglist_ACLSdrug_data$結束日<-ymd(paste0(1911+as.numeric(substring(IN_druglist_ACLSdrug_data$結束日,1,3)),substring(IN_druglist_ACLSdrug_data$結束日,4,7)))
colnames(IN_druglist_ACLSdrug_data)[1]<-"uniqueID"
Total_drug_ACLSdrug_IN<-merge(Flu_episode2010to2015[,c("uniqueID","startday","endday","no","episodeno"),with=F],IN_druglist_ACLSdrug_data,by = "uniqueID")
#[!醫囑類別=="DC"] 排除停藥的案例
Total_drug_ACLSdrug_IN<-Total_drug_ACLSdrug_IN[起始日>startday & 起始日<endday][用法%in%ACLSDrug_Freq][!醫囑類別=="DC"]
length(unique(Total_drug_ACLSdrug_IN$episodeno))
nrow(Total_drug_ACLSdrug_IN[,.N,by = episodeno])  ##832
nrow(Total_drug_ACLSdrug_IN[,.N,by = episodeno][!N==1]) ##526
#View(table(Total_drug_ACLSdrug_IN[episodeno%in%Total_drug_ACLSdrug_IN[,.N,by = episodeno][N==1]$episodeno][起始日<=結束日]$醫囑類別))  ##DC佔99%

#以episodeno來看藥囑頻率時(Total_drug_ACLSdrug_IN[,.N,by = episodeno])
#用藥藥囑頻率超過一次(N>1)的，都是有持續用藥的，在資料上不會有開立藥囑的起始日和結束日顛倒的問題，即使有的話，至少會有一筆是起始日<=結束日的
#如果一個病程的用藥藥囑頻率只有一次，當時有發現藥用時間上的問題，擔心篩選到的資料有錯誤，所以加上[起始日<=結束日]這個條件
ACLSdrug_IN_episode<-unique(c(Total_drug_ACLSdrug_IN[,.N,by = episodeno][!N==1]$episode,
                              Total_drug_ACLSdrug_IN[episodeno%in%Total_drug_ACLSdrug_IN[,.N,by = episodeno][N==1]$episodeno][起始日<=結束日][!醫囑類別=="DC"]$episodeno))

Total_drug_ACLS_episodenolist<-unique(c(Total_drug_ACLS_episodenolist,ACLSdrug_IN_episode)) #三個相加675


Flu_2010to2015_EPISODEwithCDC_table$ACLS_drug<-NA
Flu_2010to2015_EPISODEwithCDC_table[episodeno%in%Total_drug_ACLS_episodenolist]$ACLS_drug<-T  ##675



######################################
##ER_druglist_INHA_data整理
#ER_druglist_INHA<-readRDS('ER_druglist_INHA.rds')
ER_druglist_INHA_data<-ER_druglist_INHA[,c("歸戶代號","輸入日期","醫囑編號","頻率","給藥途徑","註記"),with =F]
ER_druglist_INHA_data$輸入日期<-ymd(ER_druglist_INHA_data$輸入日期)
ER_druglist_INHA_data$藥物名稱<-substring(ER_druglist_INHA_data$醫囑編號,1,7)
colnames(ER_druglist_INHA_data)[1]<-"uniqueID"

Total_drug_INHA_ER<-merge(Flu_episode2010to2015[,c("uniqueID","startday","endday","no","episodeno"),with=F],ER_druglist_INHA_data,by = "uniqueID")
Total_drug_INHA_ER<-unique(Total_drug_INHA_ER[輸入日期>=startday & 輸入日期<=endday])
table(Total_drug_INHA_ER$醫囑編號)
Total_drug_INHA_ER<-Total_drug_INHA_ER[!grepl("P4A045E",醫囑編號)]
#Total_drug_INHA_ER<-Total_drug_INHA_ER[!grepl("P4A045E|P6A101M|PMA011E|PMA015E|PMA034E|PQB015E|PQB037E",醫囑編號)]
Total_drug_INHA_episodenolist<-unique(Total_drug_INHA_ER$episodeno)  #ER:episodeno:58
rm(Total_drug_INHA_ER)
##OPD_druglist_INHA_data整理
#OPD_druglist_INHA<-readRDS('OPD_druglist_INHA.rds')
OPD_druglist_INHA<-OPD_druglist_INHA[!連續處方=="Y"]
OPD_druglist_INHA_data<-OPD_druglist_INHA[,c("歸戶代號","輸入日期","醫囑編號","頻率","給藥途徑","註記"),with =F]
OPD_druglist_INHA_data$藥物名稱<-substring(OPD_druglist_INHA_data$醫囑編號,1,7)
OPD_druglist_INHA_data$輸入日期<-ymd(OPD_druglist_INHA_data$輸入日期)
colnames(OPD_druglist_INHA_data)[1]<-"uniqueID"

Total_drug_INHA_OPD<-merge(Flu_episode2010to2015[,c("uniqueID","startday","endday","no","episodeno"),with=F],OPD_druglist_INHA_data,by = "uniqueID")
Total_drug_INHA_OPD<-unique(Total_drug_INHA_OPD[輸入日期>=startday & 輸入日期<=endday])
Total_drug_INHA_OPD<-Total_drug_INHA_OPD[!grepl("P4A045E",醫囑編號)]
#Total_drug_INHA_OPD<-Total_drug_INHA_OPD[!grepl("P4A045E|P6A101M|PMA011E|PMA015E|PMA034E|PQB015E|PQB037E|PMA001E|PQB052E|PMA008E|PMA054E|PQB005E",醫囑編號)]
Total_drug_INHA_episodenolist<-unique(c(Total_drug_INHA_episodenolist,unique(Total_drug_INHA_OPD$episodeno)))  #OPD episodeno:115  >> ER+OPD = 259

#Flu_2010to2015_EPISODEwithCDC$Inhalation_drug<-""
#Flu_2010to2015_EPISODEwithCDC[episodeno%in%Total_drug_INHA_episodenolist]$Inhalation_drug<-"Y"

####住院使用呼吸治療藥物
#IN_druglist_INHA<-readRDS("IN_druglist_INHA.rds")
IN_druglist_INHA_data<-IN_druglist_INHA[,c("歸戶代號","住院號","醫囑類別","醫囑編號","用法","起始日","結束日"),with =F]
IN_druglist_INHA_data$起始日<-ymd(paste0(1911+as.numeric(substring(IN_druglist_INHA_data$起始日,1,3)),substring(IN_druglist_INHA_data$起始日,4,7)))
IN_druglist_INHA_data$結束日<-ymd(paste0(1911+as.numeric(substring(IN_druglist_INHA_data$結束日,1,3)),substring(IN_druglist_INHA_data$結束日,4,7)))
colnames(IN_druglist_INHA_data)[1]<-"uniqueID"
Total_drug_INHA_IN<-merge(Flu_episode2010to2015[,c("uniqueID","startday","endday","no","episodeno"),with=F],IN_druglist_INHA_data,by = "uniqueID")
Total_drug_INHA_IN<-Total_drug_INHA_IN[起始日>=startday & 起始日<=endday]
Total_drug_INHA_IN[!grepl("P4A045E",醫囑編號)]
#Total_drug_INHA_IN[!grepl("P4A045E|P6A101M|PMA011E|PMA015E|PMA034E|PQB015E|PQB037E|PMA001E|PQB052E|PMA008E|PMA054E|PQB005E|PCC204P|PQB051E|P6A103E",醫囑編號)]
unique(Total_drug_INHA_IN$episodeno)
nrow(Total_drug_INHA_IN[,.N,by = episodeno])  ##2606
nrow(Total_drug_INHA_IN[,.N,by = episodeno][!N==1]) ##1846
#View(table(Total_drug_INHA_IN[episodeno%in%Total_drug_INHA_IN[,.N,by = episodeno][N==1]$episodeno]$醫囑類別))  ##DC佔90.6%

INHAdrug_IN_episode<-unique(c(Total_drug_INHA_IN[,.N,by = episodeno][!N==1]$episode,
                              Total_drug_INHA_IN[episodeno%in%Total_drug_INHA_IN[,.N,by = episodeno][N==1]$episodeno][起始日<=結束日][!醫囑類別=="DC"]$episodeno))


Total_drug_INHA_episodenolist<-unique(c(Total_drug_INHA_episodenolist,INHAdrug_IN_episode)) #2406
#Flu_2010to2015_EPISODEwithCDC_table$Inhalation_drug<-""
#Flu_2010to2015_EPISODEwithCDC_table[episodeno%in%Total_drug_INHA_episodenolist]$Inhalation_drug<-"Y"  ##2478

#saveRDS(Total_drug_INHA_episodenolist,'Total_drug_INHA_episodenolist_0514.rds')
#Flu_2010to2015_EPISODEwithCDC_table$INHA_drug<-NA
#Flu_2010to2015_EPISODEwithCDC_table[episodeno%in%Total_drug_INHA_episodenolist]$INHA_drug<-T
#saveRDS(Flu_2010to2015_EPISODEwithCDC_table,"Flu_2010to2015_EPISODEwithCDC_table_0514.rds")
