#85052 病程 人口學資料
#性別
Flu_episode2010to2015_Summarize[,.N,by='sex']

#年齡層
Flu_episode2010to2015_Summarize[,.N,by='agegroup']
#年齡層百分比
round(Flu_episode2010to2015_Summarize[,.N,by='agegroup']$N/85052,3)*100

#流感相關檢驗結果
Flu_episode2010to2015_Summarize[,.N,by='FluCases']
round(Flu_episode2010to2015_Summarize[,.N,by='FluCases']$N/85052,3)*100

#流感陽性檢驗結果中，各檢驗數
Flu_episode2010to2015_FluVirus[FluCases=='FluPositive'][,.N,by='IgGResult']
Flu_episode2010to2015_FluVirus[FluCases=='FluPositive'][,.N,by='RapidTestResult']
Flu_episode2010to2015_FluVirus[FluCases=='FluPositive'][,.N,by='RNAdetection']
Flu_episode2010to2015_FluVirus[FluCases=='FluPositive'][,.N,by='VirusIsolation']

#流感陽性檢驗結果中，各檢驗百分比
round(Flu_episode2010to2015_FluVirus[FluCases=='FluPositive'][,.N,by='IgGResult'][IgGResult=='positive']$N/19052,3)*100
round(Flu_episode2010to2015_FluVirus[FluCases=='FluPositive'][,.N,by='RapidTestResult'][RapidTestResult=='positive']$N/19052,3)*100
round(Flu_episode2010to2015_FluVirus[FluCases=='FluPositive'][,.N,by='RNAdetection'][RNAdetection=='positive']$N/19052,3)*100
round(Flu_episode2010to2015_FluVirus[FluCases=='FluPositive'][,.N,by='VirusIsolation'][VirusIsolation=='positive']$N/19052,3)*100

#各院區比例
#皮爾森相關係數


Flu_episode2010to2015_Summarize[FluCases=='FluPositive' & is.na(FluCasesWithoutAdmission)]
Flu_episode2010to2015_Summarize[SevereComplicatedInfluenza==T][PulmonaryComplicationCases==T]
Flu_episode2010to2015_Summarize[SevereComplicatedInfluenza==T][MyopathyCases==T]
Flu_episode2010to2015_Summarize[SevereComplicatedInfluenza==T][IBICases==T]
