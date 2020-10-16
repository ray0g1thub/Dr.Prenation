##ER_druglist_INHA_data整理
ER_druglist_INHA<-readRDS('ER_druglist_INHA.rds')
ER_druglist_INHA_data<-ER_druglist_INHA[,c(3,4,6,10,12,16),with =F]
ER_druglist_INHA_data$輸入日期<-ymd(ER_druglist_INHA_data$輸入日期)
ER_druglist_INHA_data$藥物名稱<-substring(ER_druglist_INHA_data$醫囑編號,1,7)
colnames(ER_druglist_INHA_data)[1]<-"uniqueID"

Total_drug_INHA_ER<-merge(Flu_2010to2015_EPISODEwithCDC,ER_druglist_INHA_data,by = "uniqueID")
Total_drug_INHA_ER<-unique(Total_drug_INHA_ER[輸入日期>startday & 輸入日期<endday])
Total_drug_INHA_episodenolist<-unique(Total_drug_INHA_ER$episodeno)  #ER:episodeno:147
rm(Total_drug_INHA_ER)
##OPD_druglist_INHA_data整理
OPD_druglist_INHA<-readRDS('OPD_druglist_INHA.rds')
OPD_druglist_INHA<-OPD_druglist_INHA[!連續處方=="Y"]
OPD_druglist_INHA_data<-OPD_druglist_INHA[,c(3,4,6,10,12,16),with =F]
OPD_druglist_INHA_data$藥物名稱<-substring(OPD_druglist_INHA_data$醫囑編號,1,7)
OPD_druglist_INHA_data$輸入日期<-ymd(OPD_druglist_INHA_data$輸入日期)
colnames(OPD_druglist_INHA_data)[1]<-"uniqueID"

Total_drug_INHA_OPD<-merge(Flu_2010to2015_EPISODEwithCDC,OPD_druglist_INHA_data,by = "uniqueID")
Total_drug_INHA_OPD<-unique(Total_drug_INHA_OPD[輸入日期>startday & 輸入日期<endday])
Total_drug_INHA_episodenolist<-unique(c(Total_drug_INHA_episodenolist,unique(Total_drug_INHA_OPD$episodeno)))  #OPD episodeno:115  >>ER+OPD = 259

Flu_2010to2015_EPISODEwithCDC$Inhalation_drug<-""
Flu_2010to2015_EPISODEwithCDC[episodeno%in%Total_drug_INHA_episodenolist]$Inhalation_drug<-"Y"

####住院使用呼吸治療藥物@@ 不確定
IN_druglist_INHA<-readRDS("IN_druglist_INHA.rds")
IN_druglist_INHA_data<-IN_druglist_INHA[,c(3,5,6,7,11,19,21),with =F]
IN_druglist_INHA_data$起始日<-ymd(paste0(1911+as.numeric(substring(IN_druglist_INHA_data$起始日,1,3)),substring(IN_druglist_INHA_data$起始日,4,7)))
IN_druglist_INHA_data$結束日<-ymd(paste0(1911+as.numeric(substring(IN_druglist_INHA_data$結束日,1,3)),substring(IN_druglist_INHA_data$結束日,4,7)))
colnames(IN_druglist_INHA_data)[1]<-"uniqueID"
Total_drug_INHA_IN<-merge(Flu_2010to2015_EPISODEwithCDC[,c(1:6),with =F],IN_druglist_INHA_data,by = "uniqueID")
Total_drug_INHA_IN<-Total_drug_INHA_IN[起始日>startday & 起始日<endday]
unique(Total_drug_INHA_IN$episodeno)
nrow(Total_drug_INHA_IN[,.N,by = episodeno])  ##2606
nrow(Total_drug_INHA_IN[,.N,by = episodeno][!N==1]) ##1846
#View(table(Total_drug_INHA_IN[episodeno%in%Total_drug_INHA_IN[,.N,by = episodeno][N==1]$episodeno]$醫囑類別))  ##DC佔90.6%

INHAdrug_IN_episode<-unique(c(Total_drug_INHA_IN[,.N,by = episodeno][!N==1]$episode,
                              Total_drug_INHA_IN[episodeno%in%Total_drug_INHA_IN[,.N,by = episodeno][N==1]$episodeno][起始日<=結束日][!醫囑類別=="DC"]$episodeno))


Total_drug_INHA_episodenolist<-unique(c(Total_drug_INHA_episodenolist,INHAdrug_IN_episode)) #2478
Flu_2010to2015_EPISODEwithCDC_table$Inhalation_drug<-""
Flu_2010to2015_EPISODEwithCDC_table[episodeno%in%Total_drug_INHA_episodenolist]$Inhalation_drug<-"Y"  ##2478

saveRDS(Total_drug_INHA_episodenolist,'Total_drug_INHA_episodenolist.rds')
saveRDS(Flu_2010to2015_EPISODEwithCDC_table,"Flu_2010to2015_EPISODEwithCDC_table.rds")
