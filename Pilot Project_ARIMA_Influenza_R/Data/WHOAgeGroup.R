#年紀算法(病程起始日-生日)/365後四捨五入至小數點第2位
Flu_episode2010to2015_Summarize$age<-round((Flu_episode2010to2015_Summarize$startday-Flu_episode2010to2015_Summarize$birthdate)/365,digits = 2)


#以WHO Agegroup判斷年齡分層
Flu_episode2010to2015_Summarize$agegroup<-""
Flu_episode2010to2015_Summarize[age<5]$agegroup<-"0-4"
Flu_episode2010to2015_Summarize[age>=5&age<15]$agegroup<-"5-14"
Flu_episode2010to2015_Summarize[age>=15&age<50]$agegroup<-"15-49"
Flu_episode2010to2015_Summarize[age>=50&age<65]$agegroup<-"50-64"
Flu_episode2010to2015_Summarize[age>=65&age<75]$agegroup<-"65-74"
Flu_episode2010to2015_Summarize[age>=75]$agegroup<-"75+"

