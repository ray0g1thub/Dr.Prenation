library(data.table)
library(lubridate)
total_Flu_episode_new<-readRDS('total_Flu_episode_new.rds')
firstrow_totalepisode<-total_Flu_episode_new[,.SD[1],by = episodeno]
saveRDS(firstrow_totalepisode,'firstrow_totalepisode.rds')


Flu_start_end<-firstrow_totalepisode[,c(1,2,6,7,18,19),with = F]
CDC_Time<-fread('CopyOfCDC_Time.csv')
CDC_Time$CDC_date<-ymd(CDC_Time$CDC_date)
colnames(CDC_Time)[1]<-"startday"
Flu_start_end<-merge(Flu_start_end,CDC_Time,by = "startday")
Flu_start_end<-Flu_start_end[,c(2:5,1,6:8),with =F]
saveRDS(Flu_start_end,"Flu_start_end.rds")


Flu_2010to2015_EPISODEwithCDC<-Flu_start_end[CDC_year%in%c(2010:2015)]
saveRDS(Flu_2010to2015_EPISODEwithCDC,'Flu_2010to2015_EPISODEwithCDC.rds')

uniqueID_unique<-unique(total_Flu_episode_new$uniqueID)
visitID_unique<-unique(total_Flu_episode_new$visitID)
