patient_basic_information<-fread('C:/Users/DH/Documents/CGMH_flu/11116_疾病分類統計檔_1.csv') 

#住院病人處置代號整理(n=13632)
IN_Flu_patient_procedure<-subset(patient_basic_information, select = c(歸戶代號, 住院號, 住院日期, 出院日期, 來源別, 
                                                                        手術碼1,手術碼2,手術碼3, 手術碼4,手術碼5,
                                                                        手術碼6,手術碼7,手術碼8, 手術碼9,手術碼10
                                                                        ))
IN_Flu_patient_procedure<-IN_Flu_patient_procedure[住院號 %in% total_patient_list$VisitId]
  #出入院時間處理
keyin_time_IN<-transform(IN_Flu_patient_procedure$住院日期, 住院日期 = as.Date(as.character(IN_Flu_patient_procedure$住院日期), "%Y%m%d"))
IN_Flu_patient_procedure<-cbind(IN_Flu_patient_procedure, keyin_time_IN)
IN_Flu_patient_procedure<-subset(IN_Flu_patient_procedure, select = c(-住院日期, -X_data))

mbd_time_IN<-transform(IN_Flu_patient_procedure$出院日期, 出院日期 = as.Date(as.character(IN_Flu_patient_procedure$出院日期), "%Y%m%d"))
IN_Flu_patient_procedure<-cbind(IN_Flu_patient_procedure, mbd_time_IN)
IN_Flu_patient_procedure<-subset(IN_Flu_patient_procedure, select = c(-出院日期, -X_data))
IN_Flu_patient_procedure<-IN_Flu_patient_procedure[order(IN_Flu_patient_procedure$住院日期,na.last = TRUE, decreasing = FALSE)]

rm(keyin_time_IN, mbd_time_IN)

  #長表轉寬表_手術碼

IN_Flu_patient_procedure<-melt(IN_Flu_patient_procedure, id.vars = c("歸戶代號","住院號","來源別","住院日期","出院日期"),
     variable.name = "處置序號", 
     value.name = "處置代碼")
IN_Flu_patient_procedure$處置序號<-gsub("手術碼", "", IN_Flu_patient_procedure$處置序號)
IN_Flu_patient_procedure<-IN_Flu_patient_procedure[!處置代碼==""]

IN_Flu_patient_procedure<-IN_Flu_patient_procedure[order(IN_Flu_patient_procedure$歸戶代號,IN_Flu_patient_procedure$住院日期,na.last = TRUE, decreasing = FALSE)]
saveRDS(IN_Flu_patient_procedure, file = "IN_Flu_patient_procedure.rds")

##########################################

#住院病人中文處置整理(n=13632)
IN_Flu_patient_procedure_chinese<-subset(patient_basic_information, select = c(歸戶代號, 住院號, 住院日期, 出院日期, 來源別, 
                                                                        手術碼名稱1,手術碼名稱2,手術碼名稱3, 手術碼名稱4,手術碼名稱5,
                                                                        手術碼名稱6,手術碼名稱7,手術碼名稱8, 手術碼名稱9,手術碼名稱10))
IN_Flu_patient_procedure_chinese<-IN_Flu_patient_procedure_chinese[住院號 %in% total_patient_list$VisitId]
  #出入院時間處理
keyin_time_IN<-transform(IN_Flu_patient_procedure_chinese$住院日期, 住院日期 = as.Date(as.character(IN_Flu_patient_procedure_chinese$住院日期), "%Y%m%d"))
IN_Flu_patient_procedure_chinese<-cbind(IN_Flu_patient_procedure_chinese, keyin_time_IN)
IN_Flu_patient_procedure_chinese<-subset(IN_Flu_patient_procedure_chinese, select = c(-住院日期, -X_data))

mbd_time_IN<-transform(IN_Flu_patient_procedure_chinese$出院日期, 出院日期 = as.Date(as.character(IN_Flu_patient_procedure_chinese$出院日期), "%Y%m%d"))
IN_Flu_patient_procedure_chinese<-cbind(IN_Flu_patient_procedure_chinese, mbd_time_IN)
IN_Flu_patient_procedure_chinese<-subset(IN_Flu_patient_procedure_chinese, select = c(-出院日期, -X_data))
IN_Flu_patient_procedure_chinese<-IN_Flu_patient_procedure_chinese[order(IN_Flu_patient_procedure_chinese$住院日期,na.last = TRUE, decreasing = FALSE)]

rm(keyin_time_IN, mbd_time_IN)
  #長表轉寬表_手術碼

IN_Flu_patient_procedure_chinese<-melt(IN_Flu_patient_procedure_chinese, id.vars = c("歸戶代號","住院號","來源別","住院日期","出院日期"),
                               variable.name = "處置序號", 
                               value.name = "中文處置代碼")
IN_Flu_patient_procedure_chinese$處置序號<-gsub("手術碼名稱", "", IN_Flu_patient_procedure_chinese$處置序號)

IN_Flu_patient_procedure_chinese<-IN_Flu_patient_procedure_chinese[!中文處置代碼==""]

####################################
#結合中文處置名稱及處置代碼
IN_Flu_patient_procedure<-merge(IN_Flu_patient_procedure,IN_Flu_patient_procedure_chinese, by = c("歸戶代號","住院號","來源別","住院日期","出院日期","處置序號"))
IN_Flu_patient_procedure<-IN_Flu_patient_procedure[order(IN_Flu_patient_procedure$歸戶代號,IN_Flu_patient_procedure$住院日期,na.last = TRUE, decreasing = FALSE)]
saveRDS(IN_Flu_patient_procedure, file = "IN_Flu_patient_procedure.rds")
rm(IN_Flu_patient_procedure_chinese)
