#Flu_episode
Flu_List_withICD<-readRDS('Flu_List_withICD.rds')
Flu_episode<-Flu_List_withICD[order(uniqueID,admissionDate)]

####計算episode####
Flu_episode<- Flu_episode[,c(3,1,2,6,7,4,5,8,9),with =F]
Flu_episode$newdate <- c(Flu_episode$admissionDate[-1], NA)
Flu_episode$timediff<- Flu_episode$newdate-Flu_episode$dischargeDate

Flu_episode_last<-Flu_episode[!duplicated(Flu_episode$uniqueID,fromLast=TRUE),]
Flu_episode[visitID %in% Flu_episode_last$visitID]$timediff<-0
Flu_episode$notinrange<-Flu_episode$timediff>14
Flu_episode$notinrange1<-"NA"
Flu_episode$notinrange1[-1] <- Flu_episode$notinrange

Flu_episode_first<-Flu_episode[!duplicated(Flu_episode$uniqueID,fromLast=FALSE),]
Flu_episode[visitID %in% Flu_episode_first$visitID]$notinrange1<-TRUE
Flu_episode$notinrange1<-as.logical(Flu_episode$notinrange1)
Flu_episode$notinrange1 <-ifelse(Flu_episode$notinrange1%in% FALSE, yes = 0, no = 1)
Flu_episode<- Flu_episode[, episodenum := cumsum(notinrange1), by=list(uniqueID)]
Flu_episode<-subset(Flu_episode, select = c(-newdate, -timediff, -notinrange, -notinrange1))
rm(Flu_episode_first,Flu_episode_last)
