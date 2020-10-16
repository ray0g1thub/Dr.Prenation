library(data.table)

#匯入有流感診斷碼的患者資料，並以歸戶代號uniqueID及入院日期admissionDate排列
Flu_List_withICD<-Flu_total_list_last[,c("uniqueID","visitID","branch","diagnosis_code",
                                         "diagnosis_sequence","admissionDate","dischargeDate","dataSource",      
                                         "Source")]
Flu_List_withICD$no<-1:nrow(Flu_List_withICD)
Flu_episode<-unique(Flu_List_withICD[order(uniqueID,admissionDate)][,c("uniqueID","visitID","admissionDate","dischargeDate","no")])
#計算episode
#比較各筆資料間時間差異，若第二次的入院日期與第一次的出院日期相差小於14天，則歸類為同一流感病程

#為進行比較，將下一列的入院日期向前移一個row，放入newdate欄位
#將第二次的入院日期與第一次的出院日期時間差放入timediff欄位
Flu_episode$newdate <- c(Flu_episode$admissionDate[-1], NA)
Flu_episode$timediff<- Flu_episode$newdate-Flu_episode$dischargeDate
#由於每個歸戶代號uniqueID的最後一筆資料不能和下一個歸戶代號uniqueID的第一筆資料進行時間差比較，故將它取出建立Flu_episode_last變數，將門診號/住院號visitID比對Flu_episode_last$visitID將其時間差設為0
#判斷時間差是否>14天，判斷結果放於notinrange。由於時間差為後一筆-前一筆，故將其向下推移一格，放於notinrange1
Flu_episode_last<-Flu_episode[!duplicated(Flu_episode$uniqueID,fromLast=TRUE),]
Flu_episode[visitID %in% Flu_episode_last$visitID]$timediff<-0
#
Flu_episode$notinrange<-Flu_episode$timediff>14
Flu_episode$notinrange1<-"NA"
Flu_episode$notinrange1[-1] <- Flu_episode$notinrange
#計算每個歸戶代號uniqueID的第一個病程位置Flu_episode_first，若為第一筆資料，將其notinrange1設為TRUE
#以每個歸戶代號uniqueID對notinrange1欄位累加後可得episodenum為每個歸戶代號uniqueID的病程數
Flu_episode_first<-Flu_episode[!duplicated(Flu_episode$uniqueID,fromLast=FALSE),]
Flu_episode[no %in% Flu_episode_first$no]$notinrange1<-TRUE
Flu_episode$notinrange1<-as.logical(Flu_episode$notinrange1)
#Flu_episode$notinrange1 <-ifelse(Flu_episode$notinrange1%in% FALSE, yes = 0, no = 1)
Flu_episode<- Flu_episode[, episodenum := cumsum(notinrange1)]
Flu_episode<-subset(Flu_episode, select = c(-newdate, -timediff, -notinrange, -notinrange1))
rm(Flu_episode_first,Flu_episode_last)
#將每個歸戶代號uniqueID及病程序號episodenum的第一列取出，作為病程起始日Flu_episode_start
#將每個歸戶代號uniqueID及病程序號episodenum的最後一列取出，作為病程結束日Flu_episode_end
#給每個病程流水序號episodeno
Flu_episode_start<-Flu_episode[, .SD[c(1)],by = c('uniqueID','episodenum')][,c("uniqueID","admissionDate","no")]
Flu_episode_end<-Flu_episode[, .SD[c(.N)],by = c('uniqueID','episodenum')][,c("uniqueID","dischargeDate")]
Flu_episode_start_end<-cbind(Flu_episode_start,Flu_episode_end[,2])
Flu_episode_start_end_last<-unique(Flu_episode_start_end[, .SD[c(1)],by = c('uniqueID','admissionDate','dischargeDate')][,c("uniqueID","admissionDate","dischargeDate","no")])



Flu_episode_start_end_last$episodeno<-1:nrow(Flu_episode_start_end_last)
colnames(Flu_episode_start_end_last)[2]<-'startday'
colnames(Flu_episode_start_end_last)[3]<-'endday'
##全部:147519 episode, 189032資料
#Flu_episode_start_end_last<-merge(Flu_episode_start_end_last,Flu_total_list_last[,c("no","branch","CDC_year","CDC_week","sex","birthdate")],by=c('no'),all.x=T)
#rm(Flu_episode_end,Flu_episode_start,Flu_episode_start_end)

