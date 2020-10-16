#沒有住院紀錄的病程

#住院診斷檔
#住院
#IN_diagnosis_RAW.rds 為11116_住診診斷檔.csv，共1個檔案
IN_diagnosis<-readRDS('IN_diagnosis_RAW.rds')

IN_diagnosis<-subset(IN_diagnosis, select = c(院區,歸戶代號, 住院號, 住院日期, 出院日期, 來源別, 
                                                診斷類別1,診斷類別2,診斷類別3, 診斷類別4,診斷類別5,
                                                診斷類別6,診斷類別7,診斷類別8, 診斷類別9,診斷類別10))
IN_diagnosis_EpisodeCases<-IN_diagnosis[歸戶代號%in%FluUniqueID_2010to2015]

IN_diagnosis_EpisodeCases$admissionDate<-ymd(IN_diagnosis_EpisodeCases$住院日期)
IN_diagnosis_EpisodeCases$dischargeDate<-ymd(IN_diagnosis_EpisodeCases$出院日期)
IN_diagnosis_EpisodeCases<-IN_diagnosis_EpisodeCases[,c("歸戶代號","住院號","院區","admissionDate","dischargeDate","來源別")]
IN_diagnosis_EpisodeCases$dataSource<-"IN"

colnames(IN_diagnosis_EpisodeCases)<-c("uniqueID","visitID","branch","admissionDate","dischargeDate","Source","dataSource")
IN_diagnosis_EpisodeCases<-merge(unique(IN_diagnosis_EpisodeCases),Flu_episode2010to2015,by='uniqueID')
IN_diagnosis_EpisodeCases<-IN_diagnosis_EpisodeCases[admissionDate>=startday&dischargeDate<=endday]
IN_diagnosis_EpisodeCases_episodeno<-IN_diagnosis_EpisodeCases$episodeno
FluCasesWithoutAdmission_Episodeno<-Flu_episode2010to2015[!episodeno%in%IN_diagnosis_EpisodeCases_episodeno]$episodeno
