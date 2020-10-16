#彙整
Flu_episode2010to2015_Summarize<-Flu_episode2010to2015

#流感檢驗(篩選過程來自"FluCasesCriteria.R")
Flu_episode2010to2015_Summarize<-merge(Flu_episode2010to2015_Summarize,Flu_episode2010to2015_FluVirus[,c('episodeno','FluCases'),with=F],by='episodeno')

#肺部合併症
# *至少需接收一次X光治療(必要條件)
Flu_episode2010to2015_Summarize$Xray<-NA
Flu_episode2010to2015_Summarize[episodeno%in%Xray_episodeno_AtLeastOnce]$Xray<-T

## *下列五項條件符合其中一項為肺部合併症(必要條件)
# 1. 呼吸治療(呼吸治療藥物或氧氣)
Flu_episode2010to2015_Summarize$INHA_Drug<-NA
Flu_episode2010to2015_Summarize[episodeno%in%Total_drug_INHA_episodenolist]$INHA_Drug<-T
Flu_episode2010to2015_Summarize$Oxygen<-NA
Flu_episode2010to2015_Summarize[episodeno%in%oxygen_episodeno_AtLeastOnce]$Oxygen<-T

# 2. 插管(胸管)
Flu_episode2010to2015_Summarize$chesttube<-NA
Flu_episode2010to2015_Summarize[episodeno%in%chesttube_episodeno_AtLeastOnce]$chesttube<-T

# 3.急救處置(急救藥物、氣切內管)
Flu_episode2010to2015_Summarize$EndotrachealTube<-NA
Flu_episode2010to2015_Summarize[episodeno%in%Endo_episodeno_AtLeastOnce]$EndotrachealTube<-T
Flu_episode2010to2015_Summarize$ACLS_Drug<-NA
Flu_episode2010to2015_Summarize[episodeno%in%Total_drug_INHA_episodenolist]$ACLS_Drug<-T

# 4. 血氧分析
Flu_episode2010to2015_Summarize$BloodGasAnalysis<-NA
Flu_episode2010to2015_Summarize[episodeno%in%BloodGasAnalysis_episodeno]$BloodGasAnalysis<-T

# 5.痰液培養陽性
Flu_episode2010to2015_Summarize$SputumCulturePositive<-NA
Flu_episode2010to2015_Summarize[episodeno%in%SputumCultureData_positive_episodeno]$SputumCulturePositive<-T

###符合肺部合併症案例定義
Flu_episode2010to2015_Summarize$PulmonaryComplicationCases<-NA
Flu_episode2010to2015_Summarize[episodeno%in%Xray_episodeno_AtLeastOnce][episodeno%in%
                                                                           c(Total_drug_INHA_episodenolist,oxygen_episodeno_AtLeastOnce,
                                                                             chesttube_episodeno_AtLeastOnce,Endo_episodeno_AtLeastOnce,Total_drug_INHA_episodenolist,
                                                                             BloodGasAnalysis_episodeno,SputumCultureData_positive_episodeno)]$PulmonaryComplicationCases<-T


#侵襲性細菌感染
# 1.檢驗(Blood Culture是否異常，篩選過程來自"BloodCulture.R")

Flu_episode2010to2015_Summarize$BloodCulture<-""
Flu_episode2010to2015_Summarize[episodeno%in%bloodculturedata_positive_episodeno]$BloodCulture<-"positive"
Flu_episode2010to2015_Summarize[episodeno%in%bloodculturedata_negative_episodeno]$BloodCulture<-"negative"
Flu_episode2010to2015_Summarize[episodeno%in%bloodculturedata_nolab_episodeno]$BloodCulture<-"nolab"

# 2.診斷 (篩選過程來自"InvasiveBaterialInfection_Diagnosis.R")
Flu_episode2010to2015_Summarize$IBI_Diagnosis<-NA
Flu_episode2010to2015_Summarize[episodeno%in%c(Total_TSS_episode,Total_sepsis_episode)]$IBI_Diagnosis<-T

###符合侵襲性細菌感染案例定義
Flu_episode2010to2015_Summarize$IBICases<-NA
Flu_episode2010to2015_Summarize[episodeno%in%c(Total_TSS_episode,Total_sepsis_episode,bloodculturedata_positive_episodeno)]$IBICases<-T


#心肌炎

# 1.檢驗(troponin-I和CK是否異常，篩選過程來自"FluComplication_Myopathy.R")
#   troponin-I
Flu_episode2010to2015_Summarize$TroponinI<-NA
Flu_episode2010to2015_Summarize[episodeno%in%lab_troponinI_episodeno]$TroponinI<-T

#   CK 檢驗值
Flu_episode2010to2015_Summarize$CK_MB<-NA
Flu_episode2010to2015_Summarize[episodeno%in%checkedCKMB_episodeno]$CK_MB<-T

# 2.慢性心臟疾病病史 (篩選過程來自"FluComplication_Myopathy.R")
Flu_episode2010to2015_Summarize$CHD_History<-NA
Flu_episode2010to2015_Summarize[episodeno%in%CHDpast_diagnosis]$CHD_History<-T

###符合心肌炎案例定義
Flu_episode2010to2015_Summarize$MyopathyCases<-NA
Flu_episode2010to2015_Summarize[episodeno%in%c(lab_troponinI_episodeno,checkedCKMB_episodeno)&!episodeno%in%c(CHDpast_diagnosis)]$MyopathyCases<-T

#無住院資料之病程
Flu_episode2010to2015_Summarize$FluCasesWithoutAdmission<-NA
Flu_episode2010to2015_Summarize[episodeno%in%FluCasesWithoutAdmission_Episodeno]$FluCasesWithoutAdmission<-T

#流感重症案例
Flu_episode2010to2015_Summarize$SevereComplicatedInfluenza<-''
Flu_episode2010to2015_Summarize[is.na(FluCasesWithoutAdmission)][FluCases=='FluPositive'][PulmonaryComplicationCases==T|MyopathyCases==T|IBICases==T]$SevereComplicatedInfluenza<-T
Flu_episode2010to2015_Summarize[is.na(SevereComplicatedInfluenza)]$SevereComplicatedInfluenza<-'non-Severe'
##肺部合併症
nrow(Flu_episode2010to2015_Summarize[SevereComplicatedInfluenza==T][PulmonaryComplicationCases==T])

##心肌炎
nrow(Flu_episode2010to2015_Summarize[SevereComplicatedInfluenza==T][MyopathyCases==T])

##侵襲性細菌感染
nrow(Flu_episode2010to2015_Summarize[SevereComplicatedInfluenza==T][IBICases==T])

#細菌培養為陽性案例
Flu_episode2010to2015_Summarize$BacterialCulturePositive<-NA
Flu_episode2010to2015_Summarize[episodeno%in%culturePositiveEpisodeno]$BacterialCulturePositive<-T

#病毒培養為陽性案例
Flu_episode2010to2015_Summarize$VirusCulturePositive<-NA
Flu_episode2010to2015_Summarize[episodeno%in%positiveVirusIsolationResult[!VirusType%in%c('InfluenzaA','InfluenzaB')]$episodeno]$VirusCulturePositive<-T

#Bacterial Co-infection案例
Flu_episode2010to2015_Summarize$BacterialCoinfection<-NA
Flu_episode2010to2015_Summarize[FluCases=='FluPositive'&BacterialCulturePositive==T]$BacterialCoinfection<-T

#Virus Co-infection 案例
Flu_episode2010to2015_Summarize$VirusCoinfection<-NA
Flu_episode2010to2015_Summarize[FluCases=='FluPositive'&VirusCulturePositive==T]$VirusCoinfection<-T

#流感用藥案例
Flu_episode2010to2015_Summarize$FluDrugUse<-''
Flu_episode2010to2015_Summarize[episodeno%in%Flu_useFluDrug]$FluDrugUse<-'T'
Flu_episode2010to2015_Summarize[FluDrugUse=='']$FluDrugUse<-'F'

#開始使用流感藥物為病程第幾天?
Flu_episode2010to2015_Summarize<-merge(Flu_episode2010to2015_Summarize,FluDrugData[,.SD[c(1)],by='episodeno'][,c('episodeno','drug_start'),with=F],all.x=T)
Flu_episode2010to2015_Summarize[is.na(drug_start)]$drug_start<-0

#年齡層
source('~/FluProjectForGithub/RMDforFluCases/WHOAgeGroup.R')
