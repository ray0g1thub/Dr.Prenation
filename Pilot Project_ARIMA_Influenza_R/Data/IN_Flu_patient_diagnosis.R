#住院病人診斷碼整理(n=53037)
IN_Flu_patient_diagnosis<-subset(patient_basic_information, select = c(歸戶代號, 住院號, 住院日期, 出院日期, 來源別, 
                                                                           診斷類別1,診斷類別2,診斷類別3, 診斷類別4,診斷類別5,
                                                                           診斷類別6,診斷類別7,診斷類別8, 診斷類別9,診斷類別10
))
IN_Flu_patient_diagnosis<-IN_Flu_patient_diagnosis[住院號 %in% total_patient_list$VisitId]
#出入院時間處理
keyin_time_IN<-transform(IN_Flu_patient_diagnosis$住院日期, 住院日期 = as.Date(as.character(IN_Flu_patient_diagnosis$住院日期), "%Y%m%d"))
IN_Flu_patient_diagnosis<-cbind(IN_Flu_patient_diagnosis, keyin_time_IN)
IN_Flu_patient_diagnosis<-subset(IN_Flu_patient_diagnosis, select = c(-住院日期, -X_data))

mbd_time_IN<-transform(IN_Flu_patient_diagnosis$出院日期, 出院日期 = as.Date(as.character(IN_Flu_patient_diagnosis$出院日期), "%Y%m%d"))
IN_Flu_patient_diagnosis<-cbind(IN_Flu_patient_diagnosis, mbd_time_IN)
IN_Flu_patient_diagnosis<-subset(IN_Flu_patient_diagnosis, select = c(-出院日期, -X_data))
IN_Flu_patient_diagnosis<-IN_Flu_patient_diagnosis[order(IN_Flu_patient_diagnosis$住院日期,na.last = TRUE, decreasing = FALSE)]

rm(keyin_time_IN, mbd_time_IN)

#長表轉寬表_手術碼

IN_Flu_patient_diagnosis<-melt(IN_Flu_patient_diagnosis, id.vars = c("歸戶代號","住院號","來源別","住院日期","出院日期"),
                               variable.name = "診斷序號", 
                               value.name = "診斷碼")
IN_Flu_patient_diagnosis$診斷序號<-gsub("診斷類別", "", IN_Flu_patient_diagnosis$診斷序號)
IN_Flu_patient_diagnosis<-IN_Flu_patient_diagnosis[!診斷碼==""]

IN_Flu_patient_diagnosis<-IN_Flu_patient_diagnosis[order(IN_Flu_patient_diagnosis$歸戶代號,IN_Flu_patient_diagnosis$住院日期,na.last = TRUE, decreasing = FALSE)]

##########################################

#住院病人中文診斷整理(n=53027)
IN_Flu_patient_diagnosis_chinese<-subset(patient_basic_information, select = c(歸戶代號, 住院號, 住院日期, 出院日期, 來源別, 
                                                                                   診斷類別名稱1,診斷類別名稱2,診斷類別名稱3, 診斷類別名稱4,診斷類別名稱5,
                                                                                   診斷類別名稱6,診斷類別名稱7,診斷類別名稱8, 診斷類別名稱9,診斷類別名稱10))
IN_Flu_patient_diagnosis_chinese<-IN_Flu_patient_diagnosis_chinese[住院號 %in% total_patient_list$VisitId]
#出入院時間處理
keyin_time_IN<-transform(IN_Flu_patient_diagnosis_chinese$住院日期, 住院日期 = as.Date(as.character(IN_Flu_patient_diagnosis_chinese$住院日期), "%Y%m%d"))
IN_Flu_patient_diagnosis_chinese<-cbind(IN_Flu_patient_diagnosis_chinese, keyin_time_IN)
IN_Flu_patient_diagnosis_chinese<-subset(IN_Flu_patient_diagnosis_chinese, select = c(-住院日期, -X_data))

mbd_time_IN<-transform(IN_Flu_patient_diagnosis_chinese$出院日期, 出院日期 = as.Date(as.character(IN_Flu_patient_diagnosis_chinese$出院日期), "%Y%m%d"))
IN_Flu_patient_diagnosis_chinese<-cbind(IN_Flu_patient_diagnosis_chinese, mbd_time_IN)
IN_Flu_patient_diagnosis_chinese<-subset(IN_Flu_patient_diagnosis_chinese, select = c(-出院日期, -X_data))
IN_Flu_patient_diagnosis_chinese<-IN_Flu_patient_diagnosis_chinese[order(IN_Flu_patient_diagnosis_chinese$住院日期,na.last = TRUE, decreasing = FALSE)]

rm(keyin_time_IN, mbd_time_IN)
#長表轉寬表_診斷碼

IN_Flu_patient_diagnosis_chinese<-melt(IN_Flu_patient_diagnosis_chinese, id.vars = c("歸戶代號","住院號","來源別","住院日期","出院日期"),
                                       variable.name = "診斷序號", 
                                       value.name = "中文診斷代碼")
IN_Flu_patient_diagnosis_chinese$診斷序號<-gsub("診斷類別名稱", "", IN_Flu_patient_diagnosis_chinese$診斷序號)

IN_Flu_patient_diagnosis_chinese<-IN_Flu_patient_diagnosis_chinese[!中文診斷代碼==""]
IN_Flu_patient_diagnosis_chinese<-IN_Flu_patient_diagnosis_chinese[order(IN_Flu_patient_diagnosis_chinese$歸戶代號,IN_Flu_patient_diagnosis_chinese$住院日期,na.last = TRUE, decreasing = FALSE)]
####################################
#結合中文處置名稱及處置代碼
IN_Flu_patient_diagnosis<-merge(IN_Flu_patient_diagnosis,IN_Flu_patient_diagnosis_chinese, by = c("歸戶代號","住院號","來源別","住院日期","出院日期","診斷序號"))
IN_Flu_patient_diagnosis<-IN_Flu_patient_diagnosis[order(IN_Flu_patient_diagnosis$歸戶代號,IN_Flu_patient_diagnosis$住院日期,na.last = TRUE, decreasing = FALSE)]
rm(IN_Flu_patient_diagnosis_chinese)

saveRDS(IN_Flu_patient_diagnosis, file = "IN_Flu_patient_diagnosis.rds")