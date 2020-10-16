Flu Prediction models for Linkou and Kaohsiung Branch\_ETS
================

匯入套件Import Library
----------------------

``` r
library(data.table)
library(forecast)
library(MLmetrics)
```

    ## 
    ## Attaching package: 'MLmetrics'

    ## The following object is masked from 'package:base':
    ## 
    ##     Recall

林口院區資料Episode Data from Linkou Branch
-------------------------------------------

``` r
Flu_Linkou_313<-readRDS('Flu_Linkou_313.rds')

Flu_Linkou_313$year_week_no<-1:313
Flu_Linkou_313[is.na(N)]$N<-0
Flu_Linkou_313$Log_N<-log10((Flu_Linkou_313$N)+1)
```

### Function for Model Evaluation

``` r
model_evaluaion <- function(prediction, real) {
  MAE_value<-round(MAE(prediction,real) ,digits=2)
  MAPE_value <- round(MAPE(prediction,real)*100 ,digits=1)
  RMSE_value <- round(RMSE(prediction,real) ,digits=2)
  RMSPE_value <- round(RMSPE(prediction,real)*100 ,digits=1)
   print(paste("MAE:",MAE_value," MAPE:",MAPE_value,
               " RMSE:",RMSE_value," RMSPE:",RMSPE_value))
}
```

### 每週更新模型\_林口 Updating Interval: Weekly (Linkou)

``` r
Linkou_week_ets<-NULL
Linkou_Test_prediction_ets_week<-NULL
Linkou_Test_prediction_ets_week<-Flu_Linkou_313[,c('year_week_CDC', 'year_week_no','Log_N'),with = F]
Linkou_Test_method_ets_week<-NULL
Linkou_Test_prediction_ets_week$anti_yhat<-numeric()
for(i in c(1:52)){
  sts <- msts(Flu_Linkou_313[1:(261+1*(i-1))]$Log_N,start=c(2010,01),seasonal.periods =365.25/7)
  method<-forecast(sts,method = "ets",h=1,allow.multiplicative.trend=T)$method
  # Forecast using ETS method 
  Linkou_week_ets =rbind(Linkou_week_ets,data.frame(forecast(sts,method = "ets",h=1,allow.multiplicative.trend=T)))
  Linkou_Test_method_ets_week<-rbind(Linkou_Test_method_ets_week,method)
  
}
Linkou_Test_prediction_ets_week[262:313]$anti_yhat<-10^Linkou_week_ets$Point.Forecast-1

Linkou_Test_prediction_ets_week<-data.table(Linkou_Test_prediction_ets_week)

saveRDS(Linkou_Test_prediction_ets_week[,c('year_week_CDC','year_week_no','anti_yhat'),with=F],'Flu_ETS_Weekly_Linkou.rds')

#model_evaluation
model_evaluaion(Linkou_Test_prediction_ets_week[262:313]$anti_yhat,Flu_Linkou_313[262:313]$N)
```

    ## [1] "MAE: 17.09  MAPE: 26.1  RMSE: 23.99  RMSPE: 31.5"

### 每月更新模型\_林口 Updating Interval: Monthly (Linkou)

``` r
Linkou_month_ets<-NULL
Linkou_Test_prediction_ets_month<-NULL
Linkou_Test_prediction_ets_month<-Flu_Linkou_313[,c('year_week_CDC', 'year_week_no','Log_N'),with = F]
Linkou_Test_method_ets_month<-NULL
Linkou_Test_prediction_ets_month$anti_yhat<-numeric()
for(i in c(1:13)){
  sts <- msts(Flu_Linkou_313[1:(261+4*(i-1))]$Log_N,start=c(2010,01),seasonal.periods =365.25/7)
  method<-forecast(sts,method = "ets",h=4,allow.multiplicative.trend=T)$method
  # Forecast using ETS method 
  Linkou_month_ets =rbind(Linkou_month_ets,data.frame(forecast(sts,method = "ets",h=4,allow.multiplicative.trend=T)))
  Linkou_Test_method_ets_month<-rbind(Linkou_Test_method_ets_month,method)
  
}
Linkou_Test_prediction_ets_month[262:313]$anti_yhat<-10^Linkou_month_ets$Point.Forecast-1

Linkou_Test_prediction_ets_month<-data.table(Linkou_Test_prediction_ets_month)

saveRDS(Linkou_Test_prediction_ets_month[,c('year_week_CDC','year_week_no','anti_yhat'),with=F],'Flu_ETS_Monthly_Linkou.rds')

#model_evaluation
model_evaluaion(Linkou_Test_prediction_ets_month[262:313]$anti_yhat,Flu_Linkou_313[262:313]$N)
```

    ## [1] "MAE: 23.05  MAPE: 33.2  RMSE: 32.39  RMSPE: 41.4"

### 每季更新模型\_林口 Updating Interval:Quarterly (Linkou)

``` r
Linkou_season_ets<-NULL
Linkou_Test_prediction_ets_season<-NULL
Linkou_Test_prediction_ets_season<-Flu_Linkou_313[,c('year_week_CDC', 'year_week_no','Log_N'),with = F]
Linkou_Test_method_ets_season<-NULL
Linkou_Test_prediction_ets_season$anti_yhat<-numeric()
for(i in c(1:4)){
  sts <- msts(Flu_Linkou_313[1:(261+13*(i-1))]$Log_N,start=c(2010,01),seasonal.periods =365.25/7)
  method<-forecast(sts,method = "ets",h=13,allow.multiplicative.trend=T)$method
  # Forecast using ETS method 
  Linkou_season_ets =rbind(Linkou_season_ets,data.frame(forecast(sts,method = "ets",h=13,allow.multiplicative.trend=T)))
  Linkou_Test_method_ets_season<-rbind(Linkou_Test_method_ets_season,method)
  
}
Linkou_Test_prediction_ets_season[262:313]$anti_yhat<-10^Linkou_season_ets$Point.Forecast-1

Linkou_Test_prediction_ets_season<-data.table(Linkou_Test_prediction_ets_season)

saveRDS(Linkou_Test_prediction_ets_season[,c('year_week_CDC','year_week_no','anti_yhat'),with=F],'Flu_ETS_Quarterly_Linkou.rds')

#model_evaluation
model_evaluaion(Linkou_Test_prediction_ets_season[262:313]$anti_yhat,Flu_Linkou_313[262:313]$N)
```

    ## [1] "MAE: 28.65  MAPE: 51.2  RMSE: 38.73  RMSPE: 67"

### 每年更新模型\_林口 Updating Interval: Yearly (Linkou)

``` r
Linkou_year_ets<-NULL
Linkou_Test_prediction_ets_year<-NULL
Linkou_Test_prediction_ets_year<-Flu_Linkou_313[,c('year_week_CDC', 'year_week_no','Log_N'),with = F]
Linkou_Test_method_ets_year<-NULL
Linkou_Test_prediction_ets_year$anti_yhat<-numeric()
for(i in c(1:1)){
  sts <- msts(Flu_Linkou_313[1:(261+52*(i-1))]$Log_N,start=c(2010,01),seasonal.periods =365.25/7)
  method<-forecast(sts,method = "ets",h=52,allow.multiplicative.trend=T)$method
  # Forecast using ETS method 
  Linkou_year_ets =rbind(Linkou_year_ets,data.frame(forecast(sts,method = "ets",h=52,allow.multiplicative.trend=T)))
  Linkou_Test_method_ets_year<-rbind(Linkou_Test_method_ets_year,method)
  
}
Linkou_Test_prediction_ets_year[262:313]$anti_yhat<-10^Linkou_year_ets$Point.Forecast-1

Linkou_Test_prediction_ets_year<-data.table(Linkou_Test_prediction_ets_year)

saveRDS(Linkou_Test_prediction_ets_year[,c('year_week_CDC','year_week_no','anti_yhat'),with=F],'Flu_ETS_Yearly_Linkou.rds')

#model_evaluation
model_evaluaion(Linkou_Test_prediction_ets_year[262:313]$anti_yhat,Flu_Linkou_313[262:313]$N)
```

    ## [1] "MAE: 43.32  MAPE: 67.6  RMSE: 54.46  RMSPE: 69.7"

<hr>
高雄院區資料Episode Data from Kaohsiung Branch
----------------------------------------------

``` r
Flu_Kaohsiung_313<-readRDS('Flu_Kaohsiung_313.rds')
Flu_Kaohsiung_313<-rbind(Flu_Kaohsiung_313,data.table(year_week_CDC="2014_47",N=0),fill=T)
Flu_Kaohsiung_313<-Flu_Kaohsiung_313[order(year_week_CDC)]
Flu_Kaohsiung_313$year_week_no<-1:313
Flu_Kaohsiung_313[is.na(N)]$N<-0
Flu_Kaohsiung_313$Log_N<-log10((Flu_Kaohsiung_313$N)+1)
```

### 每週更新模型\_高雄 Updating Interval: Weekly (Kaohsiung)

``` r
Kao_week_ets<-NULL
Kao_Test_prediction_ets_week<-NULL
Kao_Test_prediction_ets_week<-Flu_Kaohsiung_313[,c('year_week_CDC', 'year_week_no','Log_N'),with = F]
Kao_Test_method_ets_week<-NULL
Kao_Test_prediction_ets_week$anti_yhat<-numeric()
for(i in c(1:52)){
  sts <- msts(Flu_Kaohsiung_313[1:(261+1*(i-1))]$Log_N,start=c(2010,01),seasonal.periods =365.25/7)
  method<-forecast(sts,method = "ets",h=1,allow.multiplicative.trend=T)$method
  # Forecast using ETS method 
  Kao_week_ets =rbind(Kao_week_ets,data.frame(forecast(sts,method = "ets",h=1,allow.multiplicative.trend=T)))
  Kao_Test_method_ets_week<-rbind(Kao_Test_method_ets_week,method)
  
}
Kao_Test_prediction_ets_week[262:313]$anti_yhat<-10^Kao_week_ets$Point.Forecast-1

Kao_Test_prediction_ets_week<-data.table(Kao_Test_prediction_ets_week)

saveRDS(Kao_Test_prediction_ets_week[,c('year_week_CDC','year_week_no','anti_yhat'),with=F],'Flu_ETS_Weekly_Kaohsiung.rds')


#model_evaluation
model_evaluaion(Kao_Test_prediction_ets_week[262:313]$anti_yhat,Flu_Kaohsiung_313[262:313]$N)
```

    ## [1] "MAE: 16.18  MAPE: 34.6  RMSE: 24.72  RMSPE: 49"

### 每月更新模型\_高雄 Updating Interval: Monthly (Kaohsiung)

``` r
Kao_month_ets<-NULL
Kao_Test_prediction_ets_month<-NULL
Kao_Test_prediction_ets_month<-Flu_Kaohsiung_313[,c('year_week_CDC', 'year_week_no','Log_N'),with = F]
Kao_Test_method_ets_month<-NULL
Kao_Test_prediction_ets_month$anti_yhat<-numeric()
for(i in c(1:13)){
  sts <- msts(Flu_Kaohsiung_313[1:(261+4*(i-1))]$Log_N,start=c(2010,01),seasonal.periods =365.25/7)
  method<-forecast(sts,method = "ets",h=4,allow.multiplicative.trend=T)$method
  # Forecast using ETS method 
  Kao_month_ets =rbind(Kao_month_ets,data.frame(forecast(sts,method = "ets",h=4,allow.multiplicative.trend=T)))
  Kao_Test_method_ets_month<-rbind(Kao_Test_method_ets_month,method)
  
}
Kao_Test_prediction_ets_month[262:313]$anti_yhat<-10^Kao_month_ets$Point.Forecast-1

Kao_Test_prediction_ets_month<-data.table(Kao_Test_prediction_ets_month)

saveRDS(Kao_Test_prediction_ets_month[,c('year_week_CDC','year_week_no','anti_yhat'),with=F],'Flu_ETS_Monthly_Kaohsiung.rds')

#model_evaluation
model_evaluaion(Kao_Test_prediction_ets_month[262:313]$anti_yhat,Flu_Kaohsiung_313[262:313]$N)
```

    ## [1] "MAE: 21.54  MAPE: 39.5  RMSE: 33.92  RMSPE: 56"

### 每季更新模型\_高雄 Updating Interval: Quarterly (Kaohsiung)

``` r
Kao_season_ets<-NULL
Kao_Test_prediction_ets_season<-NULL
Kao_Test_prediction_ets_season<-Flu_Kaohsiung_313[,c('year_week_CDC', 'year_week_no','Log_N'),with = F]
Kao_Test_method_ets_season<-NULL
Kao_Test_prediction_ets_season$anti_yhat<-numeric()
for(i in c(1:4)){
  sts <- msts(Flu_Kaohsiung_313[1:(261+13*(i-1))]$Log_N,start=c(2010,01),seasonal.periods =365.25/7)
  method<-forecast(sts,method = "ets",h=13,allow.multiplicative.trend=T)$method
  # Forecast using ETS method 
  Kao_season_ets =rbind(Kao_season_ets,data.frame(forecast(sts,method = "ets",h=13,allow.multiplicative.trend=T)))
  Kao_Test_method_ets_season<-rbind(Kao_Test_method_ets_season,method)
  
}
Kao_Test_prediction_ets_season[262:313]$anti_yhat<-10^Kao_season_ets$Point.Forecast-1

Kao_Test_prediction_ets_season<-data.table(Kao_Test_prediction_ets_season)

saveRDS(Kao_Test_prediction_ets_season[,c('year_week_CDC','year_week_no','anti_yhat'),with=F],'Flu_ETS_Quarterly_Kaohsiung.rds')

#model_evaluation
model_evaluaion(Kao_Test_prediction_ets_season[262:313]$anti_yhat,Flu_Kaohsiung_313[262:313]$N)
```

    ## [1] "MAE: 30.68  MAPE: 70  RMSE: 40.62  RMSPE: 93.5"

### 每年更新模型\_高雄 Updating Interval: Yearly (Kaohsiung)

``` r
Kao_year_ets<-NULL
Kao_Test_prediction_ets_year<-NULL
Kao_Test_prediction_ets_year<-Flu_Kaohsiung_313[,c('year_week_CDC', 'year_week_no','Log_N'),with = F]
Kao_Test_method_ets_year<-NULL
Kao_Test_prediction_ets_year$anti_yhat<-numeric()
for(i in c(1:1)){
  sts <- msts(Flu_Kaohsiung_313[1:(261+52*(i-1))]$Log_N,start=c(2010,01),seasonal.periods =365.25/7)
  method<-forecast(sts,method = "ets",h=52,allow.multiplicative.trend=T)$method
  # Forecast using ETS method 
  Kao_year_ets =rbind(Kao_year_ets,data.frame(forecast(sts,method = "ets",h=52,allow.multiplicative.trend=T)))
  Kao_Test_method_ets_year<-rbind(Kao_Test_method_ets_year,method)
  
}
Kao_Test_prediction_ets_year[262:313]$anti_yhat<-10^Kao_year_ets$Point.Forecast-1

Kao_Test_prediction_ets_year<-data.table(Kao_Test_prediction_ets_year)

saveRDS(Kao_Test_prediction_ets_year[,c('year_week_CDC','year_week_no','anti_yhat'),with=F],'Flu_ETS_Yearly_Kaohsiung.rds')

#model_evaluation
model_evaluaion(Kao_Test_prediction_ets_year[262:313]$anti_yhat,Flu_Kaohsiung_313[262:313]$N)
```

    ## [1] "MAE: 39.88  MAPE: 71.3  RMSE: 54.65  RMSPE: 75.2"
