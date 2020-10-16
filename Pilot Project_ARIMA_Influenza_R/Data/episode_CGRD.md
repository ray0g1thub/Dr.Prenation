### 此演算法以流感病程為例
```library(data.table)```

#### 匯入有流感診斷碼的患者資料，並以歸戶代號`uniqueID`及入院日期`admissionDate`排列
```
Flu_List_withICD<-readRDS('Flu_ListwithICD.rds')
Flu_episode<-Flu_List_withICD[order(uniqueID,admissionDate)]
```
#### 計算episode

比較各筆資料間時間差異，若第二次的入院日期與第一次的出院日期相差小於14天，則歸類為同一流感病程

* 為進行比較，將下一列的入院日期向前移一個row，放入`newdate`欄位
* 將第二次的入院日期與第一次的出院日期時間差放入`timediff`欄位

```
Flu_episode$newdate <- c(Flu_episode$admissionDate[-1], NA)
Flu_episode$timediff<- Flu_episode$newdate-Flu_episode$dischargeDate
```

* 由於每個歸戶代號`uniqueID`的最後一筆資料不能和下一個歸戶代號`uniqueID`的第一筆資料進行時間差比較，故將它取出建立`Flu_episode_last`變數，將門診號/住院號`visitID`比對`Flu_episode_last$visitID`將其時間差設為0
* 判斷時間差是否>14天，判斷結果放於`notinrange`。由於時間差為後一筆-前一筆，故將其向下推移一格，放於`notinrange1`

```
Flu_episode_last<-Flu_episode[!duplicated(Flu_episode$uniqueID,fromLast=TRUE),]
Flu_episode[visitID %in% Flu_episode_last$visitID]$timediff<-0
Flu_episode$notinrange<-Flu_episode$timediff>14
Flu_episode$notinrange1<-"NA"
Flu_episode$notinrange1[-1] <- Flu_episode$notinrange
```
* 計算每個歸戶代號`uniqueID`的第一個病程位置`Flu_episode_first`，若為第一筆資料，將其`notinrange1`設為`TRUE`
* 以每個歸戶代號`uniqueID`對`notinrange1`欄位累加後可得`episodenum`為每個歸戶代號`uniqueID`的病程數

```
Flu_episode_first<-Flu_episode[!duplicated(Flu_episode$uniqueID,fromLast=FALSE),]
Flu_episode[visitID %in% Flu_episode_first$visitID]$notinrange1<-TRUE
Flu_episode$notinrange1<-as.logical(Flu_episode$notinrange1)
Flu_episode$notinrange1 <-ifelse(Flu_episode$notinrange1%in% FALSE, yes = 0, no = 1)
Flu_episode<- Flu_episode[, episodenum := cumsum(notinrange1), by=list(uniqueID)]
Flu_episode<-subset(Flu_episode, select = c(-newdate, -timediff, -notinrange, -notinrange1))
rm(Flu_episode_first,Flu_episode_last)
```

* 將每個歸戶代號`uniqueID`及病程序號`episodenum`的第一列取出，作為病程起始日`Flu_episode_start`
* 將每個歸戶代號`uniqueID`及病程序號`episodenum`的最後一列取出，作為病程結束日`Flu_episode_end`
* 給每個病程流水序號`episodeno`

```
Flu_episode_start<-Flu_episode[, .SD[c(1)],by = c('uniqueID','episodenum')][,c(1:3,5,7:10)]
Flu_episode_end<-Flu_episode[, .SD[c(.N)],by = c('uniqueID','episodenum')][,c(1,6)]
Flu_episode_start_end<-cbind(Flu_episode_start,Flu_episode_end[,c(2),with =F])
colnames(Flu_episode_start_end)[4]<-"startday"
colnames(Flu_episode_start_end)[9]<-"endday"
Flu_episode_start_end<-Flu_episode_start_end[,c(1,5,6,3,7,8,4,9,2),with =F]
Flu_episode_start_end$episodeno<-1:150572
rm(Flu_episode_end,Flu_episode_start)
saveRDS(Flu_episode_start_end,'Flu_episode_start_end.rds')
```
