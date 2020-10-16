##撈取呼吸治療藥物及急救藥物
PTuniqueID_2010to2015<-unique(Flu_2010to2015_EPISODEwithCDC$uniqueID)
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
  ER_druglist_INHA<-rbind(ER_druglist_INHA,a[歸戶代號%in%PTuniqueID_2010to2015][給藥途徑%in%c("INHA")])
  ER_druglist_ACLSdrug<-rbind(ER_druglist_ACLSdrug,a[歸戶代號%in%PTuniqueID_2010to2015][substring(醫囑編號,1,7)%in%ACLS_drug])
  
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
  
IN_druglist_INHA<-rbind(IN_druglist_INHA,a[歸戶代號%in%PTuniqueID_2010to2015][給藥途徑%in%c("INHA")])
IN_druglist_ACLSdrug<-rbind(IN_druglist_ACLSdrug,a[歸戶代號%in%PTuniqueID_2010to2015][substring(醫囑編號,1,7)%in%ACLS_drug])
  
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
  
  OPD_druglist_INHA<-rbind(OPD_druglist_INHA,a[歸戶代號%in%PTuniqueID_2010to2015][給藥途徑%in%c("INHA")])
  OPD_druglist_ACLSdrug<-rbind(OPD_druglist_ACLSdrug,a[歸戶代號%in%PTuniqueID_2010to2015][substring(醫囑編號,1,7)%in%ACLS_drug])
}

OPD_druglist_INHA<-OPD_druglist_INHA[substring(輸入日期,1,4)%in%yearrange]
OPD_druglist_ACLSdrug<-OPD_druglist_ACLSdrug[substring(輸入日期,1,4)%in%yearrange]

###save files
saveRDS(ER_druglist_ACLSdrug,"ER_druglist_ACLSdrug.rds")
saveRDS(IN_druglist_ACLSdrug,"IN_druglist_ACLSdrug.rds")
saveRDS(OPD_druglist_ACLSdrug,"OPD_druglist_ACLSdrug.rds")
saveRDS(ER_druglist_INHA,"ER_druglist_INHA.rds")
saveRDS(IN_druglist_INHA,"IN_druglist_INHA.rds")
saveRDS(OPD_druglist_INHA,"OPD_druglist_INHA.rds")