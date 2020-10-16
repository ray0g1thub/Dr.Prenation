source('library_document.R')
Flu_2010to2015_EPISODEwithCDC<-readRDS('Flu_2010to2015_EPISODEwithCDC.rds')
ACLSDrug_Freq<-c('IRRE','ONCE',"PRN","STAT")

##ER_druglist_ACLS_data整理
ER_druglist_ACLSdrug<-readRDS('ER_druglist_ACLSdrug.rds')
ER_druglist_ACLSdrug_data<-ER_druglist_ACLSdrug[,c(3,4,6,10,12,16),with =F]
ER_druglist_ACLSdrug_data$輸入日期<-ymd(ER_druglist_ACLSdrug_data$輸入日期)
ER_druglist_ACLSdrug_data$藥物名稱<-substring(ER_druglist_ACLSdrug_data$醫囑編號,1,7)
colnames(ER_druglist_ACLSdrug_data)[1]<-"uniqueID"

Total_drug_ACLS_ER<-merge(Flu_2010to2015_EPISODEwithCDC,ER_druglist_ACLSdrug_data,by = "uniqueID")
Total_drug_ACLS_ER<-unique(Total_drug_ACLS_ER[輸入日期>startday & 輸入日期<endday])
Total_drug_ACLS_ER<-unique(Total_drug_ACLS_ER[頻率%in%ACLSDrug_Freq])
saveRDS(Total_drug_ACLS_ER,"Total_drug_ACLS_ER.rds")
Total_drug_ACLS_episodenolist<-unique(Total_drug_ACLS_ER[頻率%in%ACLSDrug_Freq]$episodeno)#ER: 164

##OPD_druglist_ACLS_data整理

OPD_druglist_ACLSdrug<-readRDS('OPD_druglist_ACLSdrug.rds')
OPD_druglist_ACLSdrug<-OPD_druglist_ACLSdrug[!連續處方=="Y"]
OPD_druglist_ACLSdrug_data<-OPD_druglist_ACLSdrug[,c(3,4,6,10,12,16),with =F]
OPD_druglist_ACLSdrug_data$藥物名稱<-substring(OPD_druglist_ACLSdrug_data$醫囑編號,1,7)
OPD_druglist_ACLSdrug_data$輸入日期<-ymd(OPD_druglist_ACLSdrug_data$輸入日期)
colnames(OPD_druglist_ACLSdrug_data)[1]<-"uniqueID"

Total_drug_ACLSdrug_OPD<-merge(Flu_2010to2015_EPISODEwithCDC,OPD_druglist_ACLSdrug_data,by = "uniqueID")
Total_drug_ACLSdrug_OPD<-unique(Total_drug_ACLSdrug_OPD[輸入日期>startday & 輸入日期<endday][頻率%in%ACLSDrug_Freq])
Total_drug_ACLS_episodenolist<-unique(c(Total_drug_ACLS_episodenolist,unique(Total_drug_ACLSdrug_OPD$episodeno)))  ##OPD 23  ##ER+OPD 184
saveRDS(Total_drug_ACLSdrug_OPD,"Total_drug_ACLSdrug_OPD.rds")
####住院使用急救療藥物@@ 不確定

IN_druglist_ACLSdrug<-readRDS("IN_druglist_ACLSdrug.rds")
IN_druglist_ACLSdrug_data<-IN_druglist_ACLSdrug[,c(3,5,6,7,11,19,21),with =F]
IN_druglist_ACLSdrug_data$起始日<-ymd(paste0(1911+as.numeric(substring(IN_druglist_ACLSdrug_data$起始日,1,3)),substring(IN_druglist_ACLSdrug_data$起始日,4,7)))
IN_druglist_ACLSdrug_data$結束日<-ymd(paste0(1911+as.numeric(substring(IN_druglist_ACLSdrug_data$結束日,1,3)),substring(IN_druglist_ACLSdrug_data$結束日,4,7)))
colnames(IN_druglist_ACLSdrug_data)[1]<-"uniqueID"
Total_drug_ACLSdrug_IN<-merge(Flu_2010to2015_EPISODEwithCDC[,c(1:6),with =F],IN_druglist_ACLSdrug_data,by = "uniqueID")
Total_drug_ACLSdrug_IN<-Total_drug_ACLSdrug_IN[起始日>startday & 起始日<endday][用法%in%ACLSDrug_Freq]
length(unique(Total_drug_ACLSdrug_IN$episodeno))
nrow(Total_drug_ACLSdrug_IN[,.N,by = episodeno])  ##832
nrow(Total_drug_ACLSdrug_IN[,.N,by = episodeno][!N==1]) ##526
View(table(Total_drug_ACLSdrug_IN[episodeno%in%Total_drug_ACLSdrug_IN[,.N,by = episodeno][N==1]$episodeno][起始日<=結束日]$醫囑類別))  ##DC佔99%
ACLSdrug_IN_episode<-unique(c(Total_drug_ACLSdrug_IN[,.N,by = episodeno][!N==1]$episode,
                              Total_drug_ACLSdrug_IN[episodeno%in%Total_drug_ACLSdrug_IN[,.N,by = episodeno][N==1]$episodeno][起始日<=結束日][!醫囑類別=="DC"]$episodeno))

Total_drug_ACLS_episodenolist<-unique(c(Total_drug_ACLS_episodenolist,ACLSdrug_IN_episode)) #三個相加675
Flu_2010to2015_EPISODEwithCDC$ACLS_drug<-""
Flu_2010to2015_EPISODEwithCDC_table<-Flu_2010to2015_EPISODEwithCDC
Flu_2010to2015_EPISODEwithCDC_table[episodeno%in%Total_drug_ACLS_episodenolist]$ACLS_drug<-"Y"  ##675

saveRDS(Flu_2010to2015_EPISODEwithCDC_table,"Flu_2010to2015_EPISODEwithCDC_table.rds")
saveRDS(Total_drug_ACLS_episodenolist,'Total_drug_ACLS_episodenolist.rds')



