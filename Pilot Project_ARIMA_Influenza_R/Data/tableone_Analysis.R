library(tableone)

#要分析的族群
AnalysisGroup<-Flu_episode2010to2015_Summarize[FluCases=='FluPositive' & is.na(FluCasesWithoutAdmission)]

myVars_AG <- c("sex",'agegroup','SevereComplicatedInfluenza','FluDrugUse','drug_start')
## 類別變項
catVars_AG <- c("sex",'agegroup','SevereComplicatedInfluenza','FluDrugUse')
## Create a TableOne object
nonorm_AG<-c('drug_start')

result_AG<-CreateTableOne(vars = myVars_AG, data = AnalysisGroup, factorVars = catVars_AG,strata = "SevereComplicatedInfluenza")
print(result_AG, nonnormal=nonorm_AG)

