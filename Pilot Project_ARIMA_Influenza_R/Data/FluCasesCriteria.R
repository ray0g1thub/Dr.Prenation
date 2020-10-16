#流感病毒陽性案例

Flu_episode2010to2015_FluVirus<-Flu_episode2010to2015
#流感病毒抗體
Flu_episode2010to2015_FluVirus$IgGResult<-''
Flu_episode2010to2015_FluVirus[episodeno%in%Flu_IgG_positive]$IgGResult<-"positive"
Flu_episode2010to2015_FluVirus[IgGResult==''][episodeno%in%Flu_IgG_negative]$IgGResult<-"negative"
Flu_episode2010to2015_FluVirus[IgGResult==''][episodeno%in%Flu_IgG_nolab]$IgGResult<-'nolab'

#流感病毒快篩
Flu_episode2010to2015_FluVirus$RapidTestResult<-''
Flu_episode2010to2015_FluVirus[episodeno%in%Flu_rapidtest_positive]$RapidTestResult<-"positive"
Flu_episode2010to2015_FluVirus[RapidTestResult==''][episodeno%in%Flu_rapidtest_negative]$RapidTestResult<-"negative"
Flu_episode2010to2015_FluVirus[RapidTestResult==''][episodeno%in%Flu_rapidtest_nolab]$RapidTestResult<-'nolab'


#RNAdetection
Flu_episode2010to2015_FluVirus$RNAdetection<-''
Flu_episode2010to2015_FluVirus[episodeno%in%Flu_RNAdetection_positive]$RNAdetection<-"positive"
Flu_episode2010to2015_FluVirus[RNAdetection==''][episodeno%in%Flu_RNAdetection_negative]$RNAdetection<-"negative"
Flu_episode2010to2015_FluVirus[RNAdetection==''][episodeno%in%Flu_RNAdetection_nolab]$RNAdetection<-'nolab'

#VirusIsolation
Flu_episode2010to2015_FluVirus$VirusIsolation<-''
Flu_episode2010to2015_FluVirus[episodeno%in%Flu_VirusIsolation_positive]$VirusIsolation<-"positive"
Flu_episode2010to2015_FluVirus[VirusIsolation==''][episodeno%in%Flu_VirusIsolation_negative]$VirusIsolation<-"negative"
Flu_episode2010to2015_FluVirus[VirusIsolation==''][episodeno%in%Flu_VirusIsolation_nolab]$VirusIsolation<-'nolab'

#四項流感檢驗中，一項有檢驗出流感陽性，即為流感案例
Flu_episode2010to2015_FluVirus$FluCases<-''
Flu_episode2010to2015_FluVirus[IgGResult=='positive'|RapidTestResult=='positive'|RNAdetection=='positive'|VirusIsolation=='positive']$FluCases<-'FluPositive'
Flu_episode2010to2015_FluVirus[IgGResult=='nolab'&RapidTestResult=='nolab'&RNAdetection=='nolab'&VirusIsolation=='nolab']$FluCases<-'nolab'
Flu_episode2010to2015_FluVirus[FluCases=='']$FluCases<-'FluNegative'
