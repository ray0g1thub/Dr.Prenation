#篩選重症案例 85052
Flu_episode2010to2015<-readRDS('Flu_episode2010to2015.rds')
FluUniqueID_2010to2015<-Flu_episode2010to2015$uniqueID

#匯入住院醫囑
#檔案來源(IN_order_i.csv)為11116_住診醫囑檔，共58個檔案
colnames_IN_order<-c('院區','資料年月','歸戶代號','開立日期','住院號','科別','醫師代號','收費編號','單位','數量','用法','方向','醫囑常規用法開始日',
                     '醫囑常規用法結束日','轉日期','用法總次數','醫囑取消',	'序號',	'開立日期',	'每日量',	'醫師',	'結束日',	'註記',	'X光檢查細項代號',
                     '首日量',	'ICU註記',	'保險',	'尾日量',	'表單',	'醫囑類',	'用法頻率',	'註記',	'醫囑取消註記',	'每週用法註記',	'收費管制代碼',	'案件類別',
                     '起始日',	'轉檔日期',	'轉檔時間',	'類別',	'開單醫師姓名',	'程式處理註記',	'資料年齡')

IN_order<-NULL
for (i in c(1:58)){
  a<-fread(paste0("IN_order_",i,".csv"))
  print(i)
  colnames(a)<-colnames_IN_order
  IN_order<-rbind(IN_order,a[歸戶代號%in%FluUniqueID_2010to2015])
  rm(a)
}

##轉日期格式
colnames(IN_order)[19]<-"開立日期_2"
colnames(IN_order)[32]<-"註記_2"
library(lubridate)
IN_order$開立日期<-ymd(IN_order$開立日期)
IN_order$開立日期_2<-ymd(IN_order$開立日期_2)
IN_order$結束日<-ymd(IN_order$結束日)
IN_order$起始日<-ymd(IN_order$起始日)

##調整序號
library(stringr)
IN_order$序號<-as.numeric(IN_order$序號)
IN_order$序號<-str_pad(IN_order$序號,2,"left","0")

####X光檢查代碼#####
xray_code<-c('X75-011','X75-012','X75-013','X75-014','X75-021','X75-031','X75-032','X75-051')

##############IN肺部X光檢查###########
Flu_Xray_IN<-IN_order[收費編號%in%xray_code][order(歸戶代號,開立日期,住院號,序號)]
Flu_Xray_IN$醫囑取消日期<-as.character(Flu_Xray_IN$醫囑取消日期)
Flu_Xray_IN<-Flu_Xray_IN[is.na(醫囑取消日期)]
Flu_Xray_IN_p<-Flu_Xray_IN[,c("歸戶代號","住院號","開立日期","收費編號"),]
colnames(Flu_Xray_IN_p)<-c("uniqueID","visitID","orderTime","chargenumber")
Flu_Xray_IN_merge<-merge(Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],Flu_Xray_IN_p,by = 'uniqueID')
Flu_Xray_IN_merge<-Flu_Xray_IN_merge[orderTime>=startday & orderTime<=endday]
Xray_episodeno_IN<-unique(Flu_Xray_IN_merge$episodeno)

###########ER肺部X光檢查############
##匯入急診醫囑
##檔案來源(ER_order_i.csv)為急診醫囑檔，共26個檔案

colnames_ER_order<-c('院區','資料年月','歸戶代號','輸入日期','門診號','醫囑編號',	'序號','數量','檢體','用法','部位一',
                     '部位二','部位三','部位四','部位五','方向一','方向二','方向三','方向四','方向五','急件','註記','單價','醫囑類別','檢體容器','階段','檢查別','類別','攝影方式代號','攝影方向','顯影劑','資料年齡')


ER_order<-NULL
for (i in c(1:26)){
  a<-fread(paste0("ER_order_",i,".csv"))
  print(i)
  colnames(a)<-colnames_ER_order
  ER_order<-rbind(ER_order,a[歸戶代號%in%FluUniqueID_2010to2015])
  rm(a)
}

ER_order$輸入日期<-ymd(ER_order$輸入日期)
ER_order$序號<-as.numeric(ER_order$序號)
ER_order$序號<-str_pad(ER_order$序號,2,"left","0")
Flu_Xray_ER<-ER_order[醫囑編號%in%xray_code][order(歸戶代號,輸入日期,門診號,序號)][!用法=="DC"]
Flu_Xray_ER_p<-Flu_Xray_ER[,c("歸戶代號","門診號","輸入日期","醫囑編號"),]
colnames(Flu_Xray_ER_p)<-c("uniqueID","visitID","orderTime","chargenumber")
Flu_Xray_ER_merge<-merge(Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],Flu_Xray_ER_p,by = 'uniqueID')
Flu_Xray_ER_merge<-Flu_Xray_ER_merge[orderTime>=startday & orderTime<=endday]
Xray_episodeno_ER<-unique(Flu_Xray_ER_merge$episodeno)

##至少一次X光病程##
Xray_episodeno_AtLeastOnce<-unique(c(Xray_episodeno_ER,Xray_episodeno_IN))

rm(Flu_Xray_ER,Flu_Xray_ER_merge,Flu_Xray_ER_p,Flu_Xray_IN,Flu_Xray_IN_merge,Flu_Xray_IN_p)
rm(Xray_episodeno_ER,Xray_episodeno_IN)

############插管檢查代碼###########
Endo_code<-c('JOD154','G11-047','ID918-045','ID919-013','M32-043')
###########IN 插管##########
Flu_Endo_IN<-IN_order[收費編號%in%Endo_code][order(歸戶代號,開立日期,住院號,序號)]
Flu_Endo_IN$醫囑取消日期<-as.character(Flu_Endo_IN$醫囑取消日期)
Flu_Endo_IN<-Flu_Endo_IN[is.na(醫囑取消日期)]
Flu_Endo_IN_p<-Flu_Endo_IN[,c("歸戶代號","住院號","開立日期","收費編號"),]
colnames(Flu_Endo_IN_p)<-c("uniqueID","visitID","orderTime","chargenumber")
Flu_Endo_IN_merge<-merge(Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],Flu_Endo_IN_p,by = 'uniqueID')
Flu_Endo_IN_merge<-Flu_Endo_IN_merge[orderTime>=startday & orderTime<=endday]
Endo_episodeno_IN<-unique(Flu_Endo_IN_merge$episodeno)

###########ER Endo插管##########
Flu_Endo_ER<-ER_order[醫囑編號%in%Endo_code][order(歸戶代號,輸入日期,門診號,序號)][!用法=="DC"]
Flu_Endo_ER_p<-Flu_Endo_ER[,c("歸戶代號","門診號","輸入日期","醫囑編號"),]
colnames(Flu_Endo_ER_p)<-c("uniqueID","visitID","orderTime","chargenumber")
Flu_Endo_ER_merge<-merge(Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],Flu_Endo_ER_p,by = 'uniqueID')
Flu_Endo_ER_merge<-Flu_Endo_ER_merge[orderTime>=startday & orderTime<=endday]
Endo_episodeno_ER<-unique(Flu_Endo_ER_merge$episodeno)

#在急診或住診至少一次Endo插管
Endo_episodeno_AtLeastOnce<-unique(c(Endo_episodeno_ER,Endo_episodeno_IN))

rm(Flu_Endo_IN,Flu_Endo_IN_merge,Flu_Endo_IN_p,Flu_Endo_ER_merge,Flu_Endo_ER_p,Flu_Endo_ER)
rm(Endo_episodeno_ER,Endo_episodeno_IN)

#########AMBU############
AMBU_code<-'57009B'
###########IN AMBU##########
Flu_AMBU_IN<-IN_order[收費編號%in%AMBU_code][order(歸戶代號,開立日期,住院號,序號)]
Flu_AMBU_IN$醫囑取消日期<-as.character(Flu_AMBU_IN$醫囑取消日期)
Flu_AMBU_IN<-Flu_AMBU_IN[is.na(醫囑取消日期)]

Flu_AMBU_IN_p<-Flu_AMBU_IN[,c("歸戶代號","住院號","開立日期","收費編號"),]
colnames(Flu_AMBU_IN_p)<-c("uniqueID","visitID","orderTime","chargenumber")
Flu_AMBU_IN_merge<-merge(Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],Flu_AMBU_IN_p,by = 'uniqueID')
Flu_AMBU_IN_merge<-Flu_AMBU_IN_merge[orderTime>=startday & orderTime<=endday]
AMBU_episodeno_IN<-unique(Flu_AMBU_IN_merge$episodeno)
###########ER AMBU##########
Flu_AMBU_ER<-ER_order[醫囑編號%in%AMBU_code][order(歸戶代號,輸入日期,門診號,序號)][!用法=="DC"]
Flu_AMBU_ER_p<-Flu_AMBU_ER[,c("歸戶代號","門診號","輸入日期","醫囑編號"),]
colnames(Flu_AMBU_ER_p)<-c("uniqueID","visitID","orderTime","chargenumber")
Flu_AMBU_ER_merge<-merge(Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],Flu_AMBU_ER_p,by = 'uniqueID')
Flu_AMBU_ER_merge<-Flu_AMBU_ER_merge[orderTime>=startday & orderTime<=endday]
AMBU_episodeno_ER<-unique(Flu_AMBU_ER_merge$episodeno)
AMBU_episodeno_AtLeastOnce<-unique(c(AMBU_episodeno_ER,AMBU_episodeno_IN))

rm(Flu_AMBU_IN,Flu_AMBU_IN_merge,Flu_AMBU_IN_p,Flu_AMBU_ER_merge,Flu_AMBU_ER_p,Flu_AMBU_ER)
rm(AMBU_episodeno_ER,AMBU_episodeno_IN)
############CPR#############
CPR_code<-c('G11-028','47029C','ID918-041','ID919-050','G11-027','E80-033')
###########IN CPR###########
Flu_CPR_IN<-IN_order[收費編號%in%CPR_code][order(歸戶代號,開立日期,住院號,序號)]
Flu_CPR_IN$醫囑取消日期<-as.character(Flu_CPR_IN$醫囑取消日期)
Flu_CPR_IN<-Flu_CPR_IN[is.na(醫囑取消日期)]
Flu_CPR_IN_p<-Flu_CPR_IN[,c("歸戶代號","住院號","開立日期","收費編號"),]
colnames(Flu_CPR_IN_p)<-c("uniqueID","visitID","orderTime","chargenumber")
Flu_CPR_IN_merge<-merge(Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],Flu_CPR_IN_p,by = 'uniqueID')
Flu_CPR_IN_merge<-Flu_CPR_IN_merge[orderTime>=startday & orderTime<=endday]
CPR_episodeno_IN<-unique(Flu_CPR_IN_merge$episodeno)

###########ER CPR##########
Flu_CPR_ER<-ER_order[醫囑編號%in%CPR_code][order(歸戶代號,輸入日期,門診號,序號)][!用法=="DC"]
Flu_CPR_ER_p<-Flu_CPR_ER[,c("歸戶代號","門診號","輸入日期","醫囑編號"),]
colnames(Flu_CPR_ER_p)<-c("uniqueID","visitID","orderTime","chargenumber")
Flu_CPR_ER_merge<-merge(Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],Flu_CPR_ER_p,by = 'uniqueID')
Flu_CPR_ER_merge<-Flu_CPR_ER_merge[orderTime>=startday & orderTime<=endday]
CPR_episodeno_ER<-unique(Flu_CPR_ER_merge$episodeno)

CPR_episodeno_AtLeastOnce<-unique(c(CPR_episodeno_ER,CPR_episodeno_IN))

rm(Flu_CPR_IN,Flu_CPR_IN_merge,Flu_CPR_IN_p,Flu_CPR_ER_merge,Flu_CPR_ER_p,Flu_CPR_ER)
rm(CPR_episodeno_ER,CPR_episodeno_IN)
###########呼吸器、ECMO代碼###########

Ventilator_code<-c('57001B','57002B','57023B','57024B','57029C','M21-168','M21-169','M21-170')
ECMO_code<-c('ID918-114')

####################################
###########IN 呼吸器##########
Flu_Ventilator_IN<-IN_order[收費編號%in%Ventilator_code][order(歸戶代號,開立日期,住院號,序號)]
Flu_Ventilator_IN$醫囑取消日期<-as.character(Flu_Ventilator_IN$醫囑取消日期)
Flu_Ventilator_IN<-Flu_Ventilator_IN[is.na(醫囑取消日期)]
Flu_Ventilator_IN_p<-Flu_Ventilator_IN[,c("歸戶代號","住院號","開立日期","收費編號"),]
colnames(Flu_Ventilator_IN_p)<-c("uniqueID","visitID","orderTime","chargenumber")
Flu_Ventilator_IN_merge<-merge(Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],Flu_Ventilator_IN_p,by = 'uniqueID')
Flu_Ventilator_IN_merge<-Flu_Ventilator_IN_merge[orderTime>=startday & orderTime<=endday]
Ventilator_episodeno_IN<-unique(Flu_Ventilator_IN_merge$episodeno)

###########ER 呼吸器##########
Flu_Ventilator_ER<-ER_order[醫囑編號%in%Ventilator_code][order(歸戶代號,輸入日期,門診號,序號)][!用法=="DC"]
Flu_Ventilator_ER_p<-Flu_Ventilator_ER[,c("歸戶代號","門診號","輸入日期","醫囑編號"),]
colnames(Flu_Ventilator_ER_p)<-c("uniqueID","visitID","orderTime","chargenumber")
Flu_Ventilator_ER_merge<-merge(Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],Flu_Ventilator_ER_p,by = 'uniqueID')
Flu_Ventilator_ER_merge<-Flu_Ventilator_ER_merge[orderTime>=startday & orderTime<=endday]
Ventilator_episodeno_ER<-unique(Flu_Ventilator_ER_merge$episodeno)
Ventilator_episodeno_AtLeastOnce<-unique(c(Ventilator_episodeno_ER,Ventilator_episodeno_IN))
rm(Flu_Ventilator_IN,Flu_Ventilator_IN_merge,Flu_Ventilator_IN_p,Flu_Ventilator_ER_merge,Flu_Ventilator_ER_p,Flu_Ventilator_ER)
rm(Ventilator_episodeno_ER,Ventilator_episodeno_IN)

############IN ECMO##########
Flu_ECMO_IN<-IN_order[收費編號%in%ECMO_code][order(歸戶代號,開立日期,住院號,序號)]
Flu_ECMO_IN$醫囑取消日期<-as.character(Flu_ECMO_IN$醫囑取消日期)
Flu_ECMO_IN<-Flu_ECMO_IN[is.na(醫囑取消日期)]
Flu_ECMO_IN_p<-Flu_ECMO_IN[,c("歸戶代號","住院號","開立日期","收費編號"),]
colnames(Flu_ECMO_IN_p)<-c("uniqueID","visitID","orderTime","chargenumber")
Flu_ECMO_IN_merge<-merge(Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],Flu_ECMO_IN_p,by = 'uniqueID')
Flu_ECMO_IN_merge<-Flu_ECMO_IN_merge[orderTime>=startday & orderTime<=endday]
ECMO_episodeno_IN<-unique(Flu_ECMO_IN_merge$episodeno)

############ER ECMO###########
Flu_ECMO_ER<-ER_order[醫囑編號%in%ECMO_code][order(歸戶代號,輸入日期,門診號,序號)][!用法=="DC"]
Flu_ECMO_ER_p<-Flu_ECMO_ER[,c("歸戶代號","門診號","輸入日期","醫囑編號"),]
colnames(Flu_ECMO_ER_p)<-c("uniqueID","visitID","orderTime","chargenumber")
Flu_ECMO_ER_merge<-merge(Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],Flu_ECMO_ER_p,by = 'uniqueID')
Flu_ECMO_ER_merge<-Flu_ECMO_ER_merge[orderTime>=startday & orderTime<=endday]
ECMO_episodeno_ER<-unique(Flu_ECMO_ER_merge$episodeno)
ECMO_episodeno_AtLeastOnce<-unique(c(ECMO_episodeno_ER,ECMO_episodeno_IN))

rm(Flu_ECMO_IN,Flu_ECMO_IN_merge,Flu_ECMO_IN_p,Flu_ECMO_ER_merge,Flu_ECMO_ER_p,Flu_ECMO_ER)
rm(ECMO_episodeno_ER,ECMO_episodeno_IN)

#####################################
#IN chesttube
chesttube<-c("S42-001","M32-609","56010B","E80-221")
Flu_chesttube_IN<-IN_order[收費編號%in%chesttube][order(歸戶代號,開立日期,住院號,序號)]
Flu_chesttube_IN$醫囑取消日期<-as.character(Flu_chesttube_IN$醫囑取消日期)
Flu_chesttube_IN<-Flu_chesttube_IN[is.na(醫囑取消日期)]
Flu_chesttube_IN_p<-Flu_chesttube_IN[,c("歸戶代號","住院號","開立日期","收費編號"),]
colnames(Flu_chesttube_IN_p)<-c("uniqueID","visitID","orderTime","chargenumber")
Flu_chesttube_IN_merge<-merge(Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],Flu_chesttube_IN_p,by = 'uniqueID')
Flu_chesttube_IN_merge<-Flu_chesttube_IN_merge[orderTime>=startday & orderTime<=endday]
chesttube_episodeno_IN<-unique(Flu_chesttube_IN_merge$episodeno)

###ER_chesttube
Flu_chesttube_ER<-ER_order[醫囑編號%in%chesttube][order(歸戶代號,輸入日期,門診號,序號)][!用法=="DC"]
Flu_chesttube_ER_p<-Flu_chesttube_ER[,c("歸戶代號","門診號","輸入日期","醫囑編號"),]
colnames(Flu_chesttube_ER_p)<-c("uniqueID","visitID","orderTime","chargenumber")
Flu_chesttube_ER_merge<-merge(Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],Flu_chesttube_ER_p,by = 'uniqueID')
Flu_chesttube_ER_merge<-Flu_chesttube_ER_merge[orderTime>=startday & orderTime<=endday]
chesttube_episodeno_ER<-unique(Flu_chesttube_ER_merge$episodeno)
chesttube_episodeno_AtLeastOnce<-unique(c(chesttube_episodeno_ER,chesttube_episodeno_IN))

rm(Flu_chesttube_IN,Flu_chesttube_IN_merge,Flu_chesttube_IN_p,Flu_chesttube_ER_merge,Flu_chesttube_ER_p,Flu_chesttube_ER)
rm(chesttube_episodeno_ER,chesttube_episodeno_IN)

#####使用氧氣#####
oxygen<-c("57004C","57019C","57020C","E80-030","G11_050","G11-100",
          "S52-001","S52-002","S53-725")
Flu_oxygen_IN<-IN_order[收費編號%in%oxygen][order(歸戶代號,開立日期,住院號,序號)]
Flu_oxygen_IN$醫囑取消日期<-as.character(Flu_oxygen_IN$醫囑取消日期)
Flu_oxygen_IN<-Flu_oxygen_IN[is.na(醫囑取消日期)]
Flu_oxygen_IN_p<-Flu_oxygen_IN[,c("歸戶代號","住院號","開立日期","收費編號"),]
colnames(Flu_oxygen_IN_p)<-c("uniqueID","visitID","orderTime","chargenumber")
Flu_oxygen_IN_merge<-merge(Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],Flu_oxygen_IN_p,by = 'uniqueID')
Flu_oxygen_IN_merge<-Flu_oxygen_IN_merge[orderTime>=startday & orderTime<=endday]
oxygen_episodeno_IN<-unique(Flu_oxygen_IN_merge$episodeno)

###ER_oxygen
Flu_oxygen_ER<-ER_order[醫囑編號%in%oxygen][order(歸戶代號,輸入日期,門診號,序號)][!用法=="DC"]
Flu_oxygen_ER_p<-Flu_oxygen_ER[,c("歸戶代號","門診號","輸入日期","醫囑編號"),]
colnames(Flu_oxygen_ER_p)<-c("uniqueID","visitID","orderTime","chargenumber")
Flu_oxygen_ER_merge<-merge(Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],Flu_oxygen_ER_p,by = 'uniqueID')
Flu_oxygen_ER_merge<-Flu_oxygen_ER_merge[orderTime>=startday & orderTime<=endday]
oxygen_episodeno_ER<-unique(Flu_oxygen_ER_merge$episodeno)
oxygen_episodeno_AtLeastOnce<-unique(c(oxygen_episodeno_ER,oxygen_episodeno_IN))

rm(Flu_oxygen_IN,Flu_oxygen_IN_merge,Flu_oxygen_IN_p,Flu_oxygen_ER_merge,Flu_oxygen_ER_p,Flu_oxygen_ER)
rm(oxygen_episodeno_ER,oxygen_episodeno_IN)

###血氧氣體分析#######
bloodgas<-c("ID919-072","L72-530","L72-530*")
Flu_bloodgas_IN<-IN_order[收費編號%in%bloodgas][order(歸戶代號,開立日期,住院號,序號)]
Flu_bloodgas_IN$醫囑取消日期<-as.character(Flu_bloodgas_IN$醫囑取消日期)
Flu_bloodgas_IN<-Flu_bloodgas_IN[is.na(醫囑取消日期)]
Flu_bloodgas_IN_p<-Flu_bloodgas_IN[,c("歸戶代號","住院號","開立日期","收費編號"),]
colnames(Flu_bloodgas_IN_p)<-c("uniqueID","visitID","orderTime","chargenumber")
Flu_bloodgas_IN_merge<-merge(Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],Flu_bloodgas_IN_p,by = 'uniqueID')
Flu_bloodgas_IN_merge<-Flu_bloodgas_IN_merge[orderTime>=startday & orderTime<=endday]
bloodgas_episodeno_IN<-unique(Flu_bloodgas_IN_merge$episodeno)

###ER_bloodgas
Flu_bloodgas_ER<-ER_order[醫囑編號%in%bloodgas][order(歸戶代號,輸入日期,門診號,序號)][!用法=="DC"]
Flu_bloodgas_ER_p<-Flu_bloodgas_ER[,c("歸戶代號","門診號","輸入日期","醫囑編號"),]
colnames(Flu_bloodgas_ER_p)<-c("uniqueID","visitID","orderTime","chargenumber")
Flu_bloodgas_ER_merge<-merge(Flu_episode2010to2015[,c("uniqueID","episodeno","startday","endday")],Flu_bloodgas_ER_p,by = 'uniqueID')
Flu_bloodgas_ER_merge<-Flu_bloodgas_ER_merge[orderTime>=startday & orderTime<=endday]
bloodgas_episodeno_ER<-unique(Flu_bloodgas_ER_merge$episodeno)
bloodgas_episodeno_AtLeastOnce<-unique(c(bloodgas_episodeno_ER,bloodgas_episodeno_IN))

rm(Flu_bloodgas_IN,Flu_bloodgas_IN_merge,Flu_bloodgas_IN_p,Flu_bloodgas_ER_merge,Flu_bloodgas_ER_p,Flu_bloodgas_ER)
rm(bloodgas_episodeno_ER,bloodgas_episodeno_IN)
