Flu Prediction models for Linkou and Kaohsiung Branch\_ARIMA
================

匯入套件Import Library
----------------------

``` r
library(data.table)
library(forecast)
library(gtools)
library(MLmetrics)
```

    ## 
    ## Attaching package: 'MLmetrics'

    ## The following object is masked from 'package:base':
    ## 
    ##     Recall

Function for Model Evaluation
-----------------------------

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

林口院區資料Episode Data from Linkou Branch
-------------------------------------------

``` r
Flu_Linkou_313<-readRDS('Flu_Linkou_313.rds')
Flu_Linkou_313$year_week_no<-1:313
```

### 每週更新模型\_林口 Updating Interval: Weekly (Linkou)

``` r
predictNULL_Flu_Linkou_313<-NULL
training_Flu_Linkou_313_model<-NULL
Flu_Linkou_313_model_coefficient<-NULL


for(i in 0:51){
      newtraining_Flu_Linkou_313<-ts(Flu_Linkou_313[c(1:(261+i)),]$N,start =c(2010,01),freq = 365.25/7)
    fit<-auto.arima(newtraining_Flu_Linkou_313)
    mmm<-data.frame(method = forecast(fit)$method)
    #print(i)
  
  newtraining_Flu_Linkou_313<-ts(Flu_Linkou_313[c(1:(261+i)),]$N,start =c(2010,01),freq = 365.25/7)
  fit_arima<-arima(newtraining_Flu_Linkou_313,order = fit$arma[c(1,6,2)],seasonal = list(order = fit$arma[c(3,7,4)],period = fit$arma[5]))
  mmm<-data.frame(method = forecast(fit_arima)$method,week = i)
  nnn<-data.frame(t(fit_arima$coef))
  training_Flu_Linkou_313_model<-rbind(training_Flu_Linkou_313_model,mmm)
  Flu_Linkou_313_model_coefficient<-rbind(Flu_Linkou_313_model_coefficient,nnn)
  ppp<-forecast(fit_arima,1)
  predictNULL_Flu_Linkou_313<-rbind(data.frame(predictNULL_Flu_Linkou_313),data.frame(ppp))
  #print(i)
}

predictNULL_Flu_Linkou_313$year_week_no<-""
predictNULL_Flu_Linkou_313$year_week_no<-262:313
predictNULL_Flu_Linkou_313<-data.table(predictNULL_Flu_Linkou_313)
predictNULL_Flu_Linkou_313[Point.Forecast<0]$Point.Forecast<-0

saveRDS(predictNULL_Flu_Linkou_313[,c('year_week_no','Point.Forecast'),with=F],'Flu_ARIMA_Weekly_Linkou.rds')

#trained_model
training_Flu_Linkou_313_model
```

    ##                             method week
    ## 1  ARIMA(2,0,0) with non-zero mean    0
    ## 2  ARIMA(2,0,0) with non-zero mean    1
    ## 3  ARIMA(2,0,0) with non-zero mean    2
    ## 4  ARIMA(2,0,0) with non-zero mean    3
    ## 5  ARIMA(2,0,0) with non-zero mean    4
    ## 6  ARIMA(2,0,0) with non-zero mean    5
    ## 7  ARIMA(2,0,0) with non-zero mean    6
    ## 8  ARIMA(2,0,0) with non-zero mean    7
    ## 9  ARIMA(2,0,0) with non-zero mean    8
    ## 10 ARIMA(2,0,0) with non-zero mean    9
    ## 11 ARIMA(2,0,0) with non-zero mean   10
    ## 12 ARIMA(2,0,0) with non-zero mean   11
    ## 13 ARIMA(2,0,0) with non-zero mean   12
    ## 14 ARIMA(2,0,0) with non-zero mean   13
    ## 15 ARIMA(2,0,0) with non-zero mean   14
    ## 16 ARIMA(2,0,0) with non-zero mean   15
    ## 17 ARIMA(2,0,0) with non-zero mean   16
    ## 18 ARIMA(2,0,0) with non-zero mean   17
    ## 19 ARIMA(2,0,0) with non-zero mean   18
    ## 20 ARIMA(2,0,0) with non-zero mean   19
    ## 21 ARIMA(2,0,0) with non-zero mean   20
    ## 22 ARIMA(2,0,0) with non-zero mean   21
    ## 23 ARIMA(2,0,0) with non-zero mean   22
    ## 24 ARIMA(2,0,0) with non-zero mean   23
    ## 25 ARIMA(2,0,0) with non-zero mean   24
    ## 26 ARIMA(2,0,0) with non-zero mean   25
    ## 27 ARIMA(2,0,0) with non-zero mean   26
    ## 28 ARIMA(2,0,0) with non-zero mean   27
    ## 29 ARIMA(2,0,0) with non-zero mean   28
    ## 30 ARIMA(2,0,0) with non-zero mean   29
    ## 31 ARIMA(2,0,0) with non-zero mean   30
    ## 32 ARIMA(2,0,0) with non-zero mean   31
    ## 33 ARIMA(2,0,0) with non-zero mean   32
    ## 34 ARIMA(2,0,0) with non-zero mean   33
    ## 35 ARIMA(2,0,0) with non-zero mean   34
    ## 36 ARIMA(2,0,0) with non-zero mean   35
    ## 37 ARIMA(2,0,0) with non-zero mean   36
    ## 38 ARIMA(2,0,0) with non-zero mean   37
    ## 39 ARIMA(2,0,0) with non-zero mean   38
    ## 40 ARIMA(2,0,0) with non-zero mean   39
    ## 41 ARIMA(2,0,0) with non-zero mean   40
    ## 42 ARIMA(2,0,0) with non-zero mean   41
    ## 43 ARIMA(2,0,0) with non-zero mean   42
    ## 44 ARIMA(2,0,0) with non-zero mean   43
    ## 45 ARIMA(2,0,0) with non-zero mean   44
    ## 46 ARIMA(2,0,0) with non-zero mean   45
    ## 47 ARIMA(2,0,0) with non-zero mean   46
    ## 48 ARIMA(2,0,0) with non-zero mean   47
    ## 49 ARIMA(2,0,0) with non-zero mean   48
    ## 50 ARIMA(2,0,0) with non-zero mean   49
    ## 51 ARIMA(2,0,0) with non-zero mean   50
    ## 52 ARIMA(2,0,0) with non-zero mean   51

``` r
#model_evaluation
model_evaluaion(predictNULL_Flu_Linkou_313$Point.Forecast,Flu_Linkou_313[262:313]$N)
```

    ## [1] "MAE: 13.89  MAPE: 27.2  RMSE: 20.22  RMSPE: 35.5"

### 每月更新模型\_林口 Updating Interval: Monthly (Linkou)

``` r
predictNULL_Flu_Linkou_313_Monthly<-NULL
training_Flu_Linkou_313_model_Monthly<-NULL
Flu_Linkou_313_model_coefficient_Monthly<-NULL


for(i in 0:51){
  if ((i+1)%%4==1){
    newtraining_Flu_Linkou_313_Monthly<-ts(Flu_Linkou_313[c(1:(261+i)),]$N,start =c(2010,01),freq = 365.25/7)
    fit_Monthly<-auto.arima(newtraining_Flu_Linkou_313_Monthly)
    mmm_Monthly<-data.frame(method = forecast(fit_Monthly)$method)
    #print(i)
  }
  
  newtraining_Flu_Linkou_313_Monthly<-ts(Flu_Linkou_313[c(1:(261+i)),]$N,start =c(2010,01),freq = 365.25/7)
  fit_Monthly_arima<-arima(newtraining_Flu_Linkou_313_Monthly,order = fit_Monthly$arma[c(1,6,2)],seasonal = list(order = fit_Monthly$arma[c(3,7,4)],period = fit_Monthly$arma[5]))
  mmm_Monthly<-data.frame(method = forecast(fit_Monthly_arima)$method,week = i)
  nnn<-data.frame(t(fit_Monthly_arima$coef))
  training_Flu_Linkou_313_model_Monthly<-rbind(training_Flu_Linkou_313_model_Monthly,mmm_Monthly)
  Flu_Linkou_313_model_coefficient_Monthly<-rbind(Flu_Linkou_313_model_coefficient_Monthly,nnn)
  ppp<-forecast(fit_Monthly_arima,1)
  predictNULL_Flu_Linkou_313_Monthly<-rbind(data.frame(predictNULL_Flu_Linkou_313_Monthly),data.frame(ppp))
  #print(i)
}
predictNULL_Flu_Linkou_313_Monthly$year_week_no<-262:313
predictNULL_Flu_Linkou_313_Monthly<-data.table(predictNULL_Flu_Linkou_313_Monthly)
predictNULL_Flu_Linkou_313_Monthly[Point.Forecast<0]$Point.Forecast<-0
saveRDS(predictNULL_Flu_Linkou_313_Monthly[,c('year_week_no','Point.Forecast'),with=F],'Flu_ARIMA_Monthly_Linkou.rds')

#trained_model
training_Flu_Linkou_313_model_Monthly
```

    ##                             method week
    ## 1  ARIMA(2,0,0) with non-zero mean    0
    ## 2  ARIMA(2,0,0) with non-zero mean    1
    ## 3  ARIMA(2,0,0) with non-zero mean    2
    ## 4  ARIMA(2,0,0) with non-zero mean    3
    ## 5  ARIMA(2,0,0) with non-zero mean    4
    ## 6  ARIMA(2,0,0) with non-zero mean    5
    ## 7  ARIMA(2,0,0) with non-zero mean    6
    ## 8  ARIMA(2,0,0) with non-zero mean    7
    ## 9  ARIMA(2,0,0) with non-zero mean    8
    ## 10 ARIMA(2,0,0) with non-zero mean    9
    ## 11 ARIMA(2,0,0) with non-zero mean   10
    ## 12 ARIMA(2,0,0) with non-zero mean   11
    ## 13 ARIMA(2,0,0) with non-zero mean   12
    ## 14 ARIMA(2,0,0) with non-zero mean   13
    ## 15 ARIMA(2,0,0) with non-zero mean   14
    ## 16 ARIMA(2,0,0) with non-zero mean   15
    ## 17 ARIMA(2,0,0) with non-zero mean   16
    ## 18 ARIMA(2,0,0) with non-zero mean   17
    ## 19 ARIMA(2,0,0) with non-zero mean   18
    ## 20 ARIMA(2,0,0) with non-zero mean   19
    ## 21 ARIMA(2,0,0) with non-zero mean   20
    ## 22 ARIMA(2,0,0) with non-zero mean   21
    ## 23 ARIMA(2,0,0) with non-zero mean   22
    ## 24 ARIMA(2,0,0) with non-zero mean   23
    ## 25 ARIMA(2,0,0) with non-zero mean   24
    ## 26 ARIMA(2,0,0) with non-zero mean   25
    ## 27 ARIMA(2,0,0) with non-zero mean   26
    ## 28 ARIMA(2,0,0) with non-zero mean   27
    ## 29 ARIMA(2,0,0) with non-zero mean   28
    ## 30 ARIMA(2,0,0) with non-zero mean   29
    ## 31 ARIMA(2,0,0) with non-zero mean   30
    ## 32 ARIMA(2,0,0) with non-zero mean   31
    ## 33 ARIMA(2,0,0) with non-zero mean   32
    ## 34 ARIMA(2,0,0) with non-zero mean   33
    ## 35 ARIMA(2,0,0) with non-zero mean   34
    ## 36 ARIMA(2,0,0) with non-zero mean   35
    ## 37 ARIMA(2,0,0) with non-zero mean   36
    ## 38 ARIMA(2,0,0) with non-zero mean   37
    ## 39 ARIMA(2,0,0) with non-zero mean   38
    ## 40 ARIMA(2,0,0) with non-zero mean   39
    ## 41 ARIMA(2,0,0) with non-zero mean   40
    ## 42 ARIMA(2,0,0) with non-zero mean   41
    ## 43 ARIMA(2,0,0) with non-zero mean   42
    ## 44 ARIMA(2,0,0) with non-zero mean   43
    ## 45 ARIMA(2,0,0) with non-zero mean   44
    ## 46 ARIMA(2,0,0) with non-zero mean   45
    ## 47 ARIMA(2,0,0) with non-zero mean   46
    ## 48 ARIMA(2,0,0) with non-zero mean   47
    ## 49 ARIMA(2,0,0) with non-zero mean   48
    ## 50 ARIMA(2,0,0) with non-zero mean   49
    ## 51 ARIMA(2,0,0) with non-zero mean   50
    ## 52 ARIMA(2,0,0) with non-zero mean   51

``` r
#model_evaluation
model_evaluaion(predictNULL_Flu_Linkou_313_Monthly$Point.Forecast,Flu_Linkou_313[262:313]$N)
```

    ## [1] "MAE: 13.89  MAPE: 27.2  RMSE: 20.22  RMSPE: 35.5"

### 每季更新模型\_林口 Updating Interval: Quarterly (Linkou)

``` r
predictNULL_Flu_Linkou_313_Quarterly<-NULL
training_Flu_Linkou_313_model_Quarterly<-NULL
Flu_Linkou_313_model_coefficient_Quarterly<-NULL


for(i in 0:51){
  if ((i+1)%%13==1){
    newtraining_Flu_Linkou_313_Quarterly<-ts(Flu_Linkou_313[c(1:(261+i)),]$N,start =c(2010,01),freq = 365.25/7)
    fit_Quarterly<-auto.arima(newtraining_Flu_Linkou_313_Quarterly)
    mmm_Quarterly<-data.frame(method = forecast(fit_Quarterly)$method)
    #print(i)
  }
  
  newtraining_Flu_Linkou_313_Quarterly<-ts(Flu_Linkou_313[c(1:(261+i)),]$N,start =c(2010,01),freq = 365.25/7)
  fit_Quarterly_arima<-arima(newtraining_Flu_Linkou_313_Quarterly,order = fit_Quarterly$arma[c(1,6,2)],seasonal = list(order = fit_Quarterly$arma[c(3,7,4)],period = fit_Quarterly$arma[5]))
  mmm_Quarterly<-data.frame(method = forecast(fit_Quarterly_arima)$method,week = i)
  nnn<-data.frame(t(fit_Quarterly_arima$coef))
  training_Flu_Linkou_313_model_Quarterly<-rbind(training_Flu_Linkou_313_model_Quarterly,mmm_Quarterly)
  Flu_Linkou_313_model_coefficient_Quarterly<-rbind(Flu_Linkou_313_model_coefficient_Quarterly,nnn)
  ppp<-forecast(fit_Quarterly_arima,1)
  predictNULL_Flu_Linkou_313_Quarterly<-rbind(data.frame(predictNULL_Flu_Linkou_313_Quarterly),data.frame(ppp))
  #print(i)
}

predictNULL_Flu_Linkou_313_Quarterly$year_week_no<-""
predictNULL_Flu_Linkou_313_Quarterly$year_week_no<-262:313
predictNULL_Flu_Linkou_313_Quarterly<-data.table(predictNULL_Flu_Linkou_313_Quarterly)
predictNULL_Flu_Linkou_313_Quarterly[Point.Forecast<0]$Point.Forecast<-0
saveRDS(predictNULL_Flu_Linkou_313_Quarterly[,c('year_week_no','Point.Forecast'),with=F],'Flu_ARIMA_Quarterly_Linkou.rds')

#trained_model
training_Flu_Linkou_313_model_Quarterly
```

    ##                             method week
    ## 1  ARIMA(2,0,0) with non-zero mean    0
    ## 2  ARIMA(2,0,0) with non-zero mean    1
    ## 3  ARIMA(2,0,0) with non-zero mean    2
    ## 4  ARIMA(2,0,0) with non-zero mean    3
    ## 5  ARIMA(2,0,0) with non-zero mean    4
    ## 6  ARIMA(2,0,0) with non-zero mean    5
    ## 7  ARIMA(2,0,0) with non-zero mean    6
    ## 8  ARIMA(2,0,0) with non-zero mean    7
    ## 9  ARIMA(2,0,0) with non-zero mean    8
    ## 10 ARIMA(2,0,0) with non-zero mean    9
    ## 11 ARIMA(2,0,0) with non-zero mean   10
    ## 12 ARIMA(2,0,0) with non-zero mean   11
    ## 13 ARIMA(2,0,0) with non-zero mean   12
    ## 14 ARIMA(2,0,0) with non-zero mean   13
    ## 15 ARIMA(2,0,0) with non-zero mean   14
    ## 16 ARIMA(2,0,0) with non-zero mean   15
    ## 17 ARIMA(2,0,0) with non-zero mean   16
    ## 18 ARIMA(2,0,0) with non-zero mean   17
    ## 19 ARIMA(2,0,0) with non-zero mean   18
    ## 20 ARIMA(2,0,0) with non-zero mean   19
    ## 21 ARIMA(2,0,0) with non-zero mean   20
    ## 22 ARIMA(2,0,0) with non-zero mean   21
    ## 23 ARIMA(2,0,0) with non-zero mean   22
    ## 24 ARIMA(2,0,0) with non-zero mean   23
    ## 25 ARIMA(2,0,0) with non-zero mean   24
    ## 26 ARIMA(2,0,0) with non-zero mean   25
    ## 27 ARIMA(2,0,0) with non-zero mean   26
    ## 28 ARIMA(2,0,0) with non-zero mean   27
    ## 29 ARIMA(2,0,0) with non-zero mean   28
    ## 30 ARIMA(2,0,0) with non-zero mean   29
    ## 31 ARIMA(2,0,0) with non-zero mean   30
    ## 32 ARIMA(2,0,0) with non-zero mean   31
    ## 33 ARIMA(2,0,0) with non-zero mean   32
    ## 34 ARIMA(2,0,0) with non-zero mean   33
    ## 35 ARIMA(2,0,0) with non-zero mean   34
    ## 36 ARIMA(2,0,0) with non-zero mean   35
    ## 37 ARIMA(2,0,0) with non-zero mean   36
    ## 38 ARIMA(2,0,0) with non-zero mean   37
    ## 39 ARIMA(2,0,0) with non-zero mean   38
    ## 40 ARIMA(2,0,0) with non-zero mean   39
    ## 41 ARIMA(2,0,0) with non-zero mean   40
    ## 42 ARIMA(2,0,0) with non-zero mean   41
    ## 43 ARIMA(2,0,0) with non-zero mean   42
    ## 44 ARIMA(2,0,0) with non-zero mean   43
    ## 45 ARIMA(2,0,0) with non-zero mean   44
    ## 46 ARIMA(2,0,0) with non-zero mean   45
    ## 47 ARIMA(2,0,0) with non-zero mean   46
    ## 48 ARIMA(2,0,0) with non-zero mean   47
    ## 49 ARIMA(2,0,0) with non-zero mean   48
    ## 50 ARIMA(2,0,0) with non-zero mean   49
    ## 51 ARIMA(2,0,0) with non-zero mean   50
    ## 52 ARIMA(2,0,0) with non-zero mean   51

``` r
#model_evaluation
model_evaluaion(predictNULL_Flu_Linkou_313_Quarterly$Point.Forecast,Flu_Linkou_313[262:313]$N)
```

    ## [1] "MAE: 13.89  MAPE: 27.2  RMSE: 20.22  RMSPE: 35.5"

### 每年更新模型\_林口 Updating Interval: Yearly (Linkou)

``` r
predictNULL_Flu_Linkou_313_YEARLY<-NULL
training_Flu_Linkou_313_model_YEARLY<-NULL
Flu_Linkou_313_model_coefficient_YEARLY<-NULL

newtraining_Flu_Linkou_313_YEARLY<-ts(Flu_Linkou_313[c(1:261),]$N,start =c(2010,01),freq = 365.25/7)
fit_YEARLY<-auto.arima(newtraining_Flu_Linkou_313_YEARLY)
mmm_YEARLY<-data.frame(method = forecast(fit_YEARLY)$method)

for(i in 0:51){
  
  newtraining_Flu_Linkou_313_YEARLY<-ts(Flu_Linkou_313[c(1:(261+i)),]$N,start =c(2010,01),freq = 365.25/7)
  fit_YEARLY_arima<-arima(newtraining_Flu_Linkou_313_YEARLY,order = fit_YEARLY$arma[c(1,6,2)],seasonal = list(order = fit_YEARLY$arma[c(3,7,4)],period = fit_YEARLY$arma[5]))
  mmm_YEARLY<-data.frame(method = forecast(fit_YEARLY_arima)$method,week = i)
  nnn<-data.frame(t(fit_YEARLY_arima$coef))
  training_Flu_Linkou_313_model_YEARLY<-rbind(training_Flu_Linkou_313_model_YEARLY,mmm_YEARLY)
  Flu_Linkou_313_model_coefficient_YEARLY<-rbind(Flu_Linkou_313_model_coefficient_YEARLY,nnn)
  ppp<-forecast(fit_YEARLY_arima,1)
  predictNULL_Flu_Linkou_313_YEARLY<-rbind(data.frame(predictNULL_Flu_Linkou_313_YEARLY),data.frame(ppp))
  #print(i)
}
predictNULL_Flu_Linkou_313_YEARLY$year_week_no<-262:313
predictNULL_Flu_Linkou_313_YEARLY<-data.table(predictNULL_Flu_Linkou_313_YEARLY)
predictNULL_Flu_Linkou_313_YEARLY[Point.Forecast<0]$Point.Forecast<-0
saveRDS(predictNULL_Flu_Linkou_313_YEARLY[,c('year_week_no','Point.Forecast'),with=F],'Flu_ARIMA_Yearly_Linkou.rds')

#trained_model
training_Flu_Linkou_313_model_YEARLY
```

    ##                             method week
    ## 1  ARIMA(2,0,0) with non-zero mean    0
    ## 2  ARIMA(2,0,0) with non-zero mean    1
    ## 3  ARIMA(2,0,0) with non-zero mean    2
    ## 4  ARIMA(2,0,0) with non-zero mean    3
    ## 5  ARIMA(2,0,0) with non-zero mean    4
    ## 6  ARIMA(2,0,0) with non-zero mean    5
    ## 7  ARIMA(2,0,0) with non-zero mean    6
    ## 8  ARIMA(2,0,0) with non-zero mean    7
    ## 9  ARIMA(2,0,0) with non-zero mean    8
    ## 10 ARIMA(2,0,0) with non-zero mean    9
    ## 11 ARIMA(2,0,0) with non-zero mean   10
    ## 12 ARIMA(2,0,0) with non-zero mean   11
    ## 13 ARIMA(2,0,0) with non-zero mean   12
    ## 14 ARIMA(2,0,0) with non-zero mean   13
    ## 15 ARIMA(2,0,0) with non-zero mean   14
    ## 16 ARIMA(2,0,0) with non-zero mean   15
    ## 17 ARIMA(2,0,0) with non-zero mean   16
    ## 18 ARIMA(2,0,0) with non-zero mean   17
    ## 19 ARIMA(2,0,0) with non-zero mean   18
    ## 20 ARIMA(2,0,0) with non-zero mean   19
    ## 21 ARIMA(2,0,0) with non-zero mean   20
    ## 22 ARIMA(2,0,0) with non-zero mean   21
    ## 23 ARIMA(2,0,0) with non-zero mean   22
    ## 24 ARIMA(2,0,0) with non-zero mean   23
    ## 25 ARIMA(2,0,0) with non-zero mean   24
    ## 26 ARIMA(2,0,0) with non-zero mean   25
    ## 27 ARIMA(2,0,0) with non-zero mean   26
    ## 28 ARIMA(2,0,0) with non-zero mean   27
    ## 29 ARIMA(2,0,0) with non-zero mean   28
    ## 30 ARIMA(2,0,0) with non-zero mean   29
    ## 31 ARIMA(2,0,0) with non-zero mean   30
    ## 32 ARIMA(2,0,0) with non-zero mean   31
    ## 33 ARIMA(2,0,0) with non-zero mean   32
    ## 34 ARIMA(2,0,0) with non-zero mean   33
    ## 35 ARIMA(2,0,0) with non-zero mean   34
    ## 36 ARIMA(2,0,0) with non-zero mean   35
    ## 37 ARIMA(2,0,0) with non-zero mean   36
    ## 38 ARIMA(2,0,0) with non-zero mean   37
    ## 39 ARIMA(2,0,0) with non-zero mean   38
    ## 40 ARIMA(2,0,0) with non-zero mean   39
    ## 41 ARIMA(2,0,0) with non-zero mean   40
    ## 42 ARIMA(2,0,0) with non-zero mean   41
    ## 43 ARIMA(2,0,0) with non-zero mean   42
    ## 44 ARIMA(2,0,0) with non-zero mean   43
    ## 45 ARIMA(2,0,0) with non-zero mean   44
    ## 46 ARIMA(2,0,0) with non-zero mean   45
    ## 47 ARIMA(2,0,0) with non-zero mean   46
    ## 48 ARIMA(2,0,0) with non-zero mean   47
    ## 49 ARIMA(2,0,0) with non-zero mean   48
    ## 50 ARIMA(2,0,0) with non-zero mean   49
    ## 51 ARIMA(2,0,0) with non-zero mean   50
    ## 52 ARIMA(2,0,0) with non-zero mean   51

``` r
#model_evaluation
model_evaluaion(predictNULL_Flu_Linkou_313_YEARLY$Point.Forecast,Flu_Linkou_313[262:313]$N)
```

    ## [1] "MAE: 13.89  MAPE: 27.2  RMSE: 20.22  RMSPE: 35.5"

<hr>
高雄院區資料Episode Data from Kaohsiung Branch
----------------------------------------------

``` r
Flu_Kaohsiung_313<-readRDS('Flu_Kaohsiung_313.rds')
Flu_Kaohsiung_313<-rbind(Flu_Kaohsiung_313,data.table(year_week_CDC="2014_47",N=0),fill=T)
Flu_Kaohsiung_313<-Flu_Kaohsiung_313[order(year_week_CDC)]
Flu_Kaohsiung_313$year_week_no<-1:313
```

### 每週更新模型\_高雄 Updating Interval: Weekly (Kaohsiung)

``` r
training_Flu_Kaohsiung_313_model<-NULL
predictNULL_Flu_Kaohsiung_313<-NULL
Flu_Kaohsiung_313_model_coefficient<-NULL
for(i in 0:51){
  newtraining_Flu_Kaohsiung_313<-ts(Flu_Kaohsiung_313[c(1:(261+i)),]$N,start =c(2010,01),freq = 365.25/7)
    fit<-auto.arima(newtraining_Flu_Kaohsiung_313)
    mmm<-data.frame(method = forecast(fit)$method)
    #print(i)
  newtraining_Flu_Kaohsiung_313<-ts(Flu_Kaohsiung_313[c(1:(261+i)),]$N,start =c(2010,01),freq = 365.25/7)
  fit_arima<-arima(newtraining_Flu_Kaohsiung_313,order = fit$arma[c(1,6,2)],seasonal = list(order = fit$arma[c(3,7,4)],period = fit$arma[5]),method="CSS")
  mmm<-data.frame(method = forecast(fit_arima)$method,week = i)
  nnn<-data.frame(t(fit_arima$coef))
  training_Flu_Kaohsiung_313_model<-rbind(training_Flu_Kaohsiung_313_model,mmm)
  Flu_Kaohsiung_313_model_coefficient<-smartbind(Flu_Kaohsiung_313_model_coefficient,nnn)
  ppp<-forecast(fit_arima,1)
  predictNULL_Flu_Kaohsiung_313<-rbind(data.frame(predictNULL_Flu_Kaohsiung_313),data.frame(ppp))
  #print(i)
}

predictNULL_Flu_Kaohsiung_313$year_week_no<-262:313
predictNULL_Flu_Kaohsiung_313<-data.table(predictNULL_Flu_Kaohsiung_313)
predictNULL_Flu_Kaohsiung_313[Point.Forecast<0]$Point.Forecast<-0
saveRDS(predictNULL_Flu_Kaohsiung_313[,c('year_week_no','Point.Forecast'),with=F],'Flu_ARIMA_Weekly_Kaohsiung.rds')

#trained_model
training_Flu_Kaohsiung_313_model
```

    ##                     method week
    ## 1  ARIMA(0,1,1)(0,0,1)[52]    0
    ## 2  ARIMA(0,1,1)(0,0,1)[52]    1
    ## 3  ARIMA(4,1,3)(1,0,0)[52]    2
    ## 4  ARIMA(5,1,2)(1,0,0)[52]    3
    ## 5  ARIMA(4,1,2)(1,0,0)[52]    4
    ## 6  ARIMA(5,1,2)(1,0,0)[52]    5
    ## 7  ARIMA(5,1,2)(1,0,0)[52]    6
    ## 8  ARIMA(5,1,5)(1,0,0)[52]    7
    ## 9  ARIMA(4,1,4)(1,0,0)[52]    8
    ## 10 ARIMA(5,1,5)(1,0,0)[52]    9
    ## 11 ARIMA(5,1,2)(1,0,1)[52]   10
    ## 12 ARIMA(5,1,2)(1,0,1)[52]   11
    ## 13 ARIMA(4,1,3)(1,0,0)[52]   12
    ## 14 ARIMA(5,1,2)(1,0,0)[52]   13
    ## 15 ARIMA(4,1,4)(1,0,0)[52]   14
    ## 16 ARIMA(5,1,5)(1,0,0)[52]   15
    ## 17 ARIMA(4,1,4)(1,0,0)[52]   16
    ## 18 ARIMA(4,1,4)(1,0,0)[52]   17
    ## 19 ARIMA(4,1,2)(1,0,0)[52]   18
    ## 20 ARIMA(5,1,2)(1,0,0)[52]   19
    ## 21 ARIMA(5,1,2)(1,0,0)[52]   20
    ## 22 ARIMA(4,1,4)(1,0,0)[52]   21
    ## 23 ARIMA(3,1,5)(1,0,0)[52]   22
    ## 24 ARIMA(0,1,1)(1,0,0)[52]   23
    ## 25 ARIMA(5,1,5)(1,0,0)[52]   24
    ## 26 ARIMA(0,1,1)(1,0,0)[52]   25
    ## 27 ARIMA(5,1,5)(1,0,0)[52]   26
    ## 28 ARIMA(4,1,3)(1,0,0)[52]   27
    ## 29 ARIMA(5,1,5)(1,0,0)[52]   28
    ## 30 ARIMA(4,1,4)(1,0,0)[52]   29
    ## 31 ARIMA(4,1,3)(1,0,0)[52]   30
    ## 32 ARIMA(4,1,3)(1,0,0)[52]   31
    ## 33 ARIMA(4,1,4)(1,0,0)[52]   32
    ## 34 ARIMA(4,1,4)(1,0,0)[52]   33
    ## 35 ARIMA(4,1,3)(1,0,0)[52]   34
    ## 36 ARIMA(4,1,3)(1,0,0)[52]   35
    ## 37 ARIMA(4,1,4)(1,0,0)[52]   36
    ## 38 ARIMA(5,1,5)(1,0,0)[52]   37
    ## 39 ARIMA(4,1,4)(1,0,0)[52]   38
    ## 40 ARIMA(4,1,4)(1,0,0)[52]   39
    ## 41 ARIMA(5,1,5)(1,0,0)[52]   40
    ## 42 ARIMA(5,1,5)(1,0,0)[52]   41
    ## 43 ARIMA(5,1,5)(1,0,0)[52]   42
    ## 44 ARIMA(4,1,3)(1,0,0)[52]   43
    ## 45 ARIMA(5,1,5)(1,0,0)[52]   44
    ## 46 ARIMA(5,1,5)(1,0,1)[52]   45
    ## 47 ARIMA(4,1,3)(1,0,0)[52]   46
    ## 48 ARIMA(4,1,4)(1,0,0)[52]   47
    ## 49 ARIMA(4,1,4)(1,0,0)[52]   48
    ## 50 ARIMA(4,1,4)(1,0,0)[52]   49
    ## 51 ARIMA(5,1,5)(1,0,0)[52]   50
    ## 52 ARIMA(3,1,3)(1,0,0)[52]   51

``` r
#model_evaluation
model_evaluaion(predictNULL_Flu_Kaohsiung_313$Point.Forecast,Flu_Kaohsiung_313[262:313]$N)
```

    ## [1] "MAE: 10.93  MAPE: 28.1  RMSE: 15.58  RMSPE: 38.8"

### 每月更新模型\_高雄 Updating Interval: Monthly (Kaohsiung)

``` r
predictNULL_Flu_Kaohsiung_313_Monthly<-NULL
training_Flu_Kaohsiung_313_model_Monthly<-NULL
Flu_Kaohsiung_313_model_coefficient_Monthly<-NULL


for(i in 0:51){
  if ((i+1)%%4==1){
    newtraining_Flu_Kaohsiung_313_Monthly<-ts(Flu_Kaohsiung_313[c(1:(261+i)),]$N,start =c(2010,01),freq = 365.25/7)
    fit_Monthly<-auto.arima(newtraining_Flu_Kaohsiung_313_Monthly)
    mmm_Monthly<-data.frame(method = forecast(fit_Monthly)$method)
    #print(i)
  }
  
  newtraining_Flu_Kaohsiung_313_Monthly<-ts(Flu_Kaohsiung_313[c(1:(261+i)),]$N,start =c(2010,01),freq = 365.25/7)
  fit_Monthly_arima<-arima(newtraining_Flu_Kaohsiung_313_Monthly,order = fit_Monthly$arma[c(1,6,2)],seasonal = list(order = fit_Monthly$arma[c(3,7,4)],period = fit_Monthly$arma[5]),method="CSS")
  mmm_Monthly<-data.frame(method = forecast(fit_Monthly_arima)$method,week = i)
  nnn<-data.frame(t(fit_Monthly_arima$coef))
  training_Flu_Kaohsiung_313_model_Monthly<-rbind(training_Flu_Kaohsiung_313_model_Monthly,mmm_Monthly)
  Flu_Kaohsiung_313_model_coefficient_Monthly<-smartbind(Flu_Kaohsiung_313_model_coefficient_Monthly,nnn)
  ppp<-forecast(fit_Monthly_arima,1)
  predictNULL_Flu_Kaohsiung_313_Monthly<-rbind(data.frame(predictNULL_Flu_Kaohsiung_313_Monthly),data.frame(ppp))
  #print(i)
}

predictNULL_Flu_Kaohsiung_313_Monthly$year_week_no<-262:313
predictNULL_Flu_Kaohsiung_313_Monthly<-data.table(predictNULL_Flu_Kaohsiung_313_Monthly)
predictNULL_Flu_Kaohsiung_313_Monthly[Point.Forecast<0]$Point.Forecast<-0
saveRDS(predictNULL_Flu_Kaohsiung_313_Monthly[,c('year_week_no','Point.Forecast'),with=F],'Flu_ARIMA_Monthly_Kaohsiung.rds')

#trained_model
training_Flu_Kaohsiung_313_model_Monthly
```

    ##                     method week
    ## 1  ARIMA(0,1,1)(0,0,1)[52]    0
    ## 2  ARIMA(0,1,1)(0,0,1)[52]    1
    ## 3  ARIMA(0,1,1)(0,0,1)[52]    2
    ## 4  ARIMA(0,1,1)(0,0,1)[52]    3
    ## 5  ARIMA(4,1,2)(1,0,0)[52]    4
    ## 6  ARIMA(4,1,2)(1,0,0)[52]    5
    ## 7  ARIMA(4,1,2)(1,0,0)[52]    6
    ## 8  ARIMA(4,1,2)(1,0,0)[52]    7
    ## 9  ARIMA(4,1,4)(1,0,0)[52]    8
    ## 10 ARIMA(4,1,4)(1,0,0)[52]    9
    ## 11 ARIMA(4,1,4)(1,0,0)[52]   10
    ## 12 ARIMA(4,1,4)(1,0,0)[52]   11
    ## 13 ARIMA(4,1,3)(1,0,0)[52]   12
    ## 14 ARIMA(4,1,3)(1,0,0)[52]   13
    ## 15 ARIMA(4,1,3)(1,0,0)[52]   14
    ## 16 ARIMA(4,1,3)(1,0,0)[52]   15
    ## 17 ARIMA(4,1,4)(1,0,0)[52]   16
    ## 18 ARIMA(4,1,4)(1,0,0)[52]   17
    ## 19 ARIMA(4,1,4)(1,0,0)[52]   18
    ## 20 ARIMA(4,1,4)(1,0,0)[52]   19
    ## 21 ARIMA(5,1,2)(1,0,0)[52]   20
    ## 22 ARIMA(5,1,2)(1,0,0)[52]   21
    ## 23 ARIMA(5,1,2)(1,0,0)[52]   22
    ## 24 ARIMA(5,1,2)(1,0,0)[52]   23
    ## 25 ARIMA(5,1,5)(1,0,0)[52]   24
    ## 26 ARIMA(5,1,5)(1,0,0)[52]   25
    ## 27 ARIMA(5,1,5)(1,0,0)[52]   26
    ## 28 ARIMA(5,1,5)(1,0,0)[52]   27
    ## 29 ARIMA(5,1,5)(1,0,0)[52]   28
    ## 30 ARIMA(5,1,5)(1,0,0)[52]   29
    ## 31 ARIMA(5,1,5)(1,0,0)[52]   30
    ## 32 ARIMA(5,1,5)(1,0,0)[52]   31
    ## 33 ARIMA(4,1,4)(1,0,0)[52]   32
    ## 34 ARIMA(4,1,4)(1,0,0)[52]   33
    ## 35 ARIMA(4,1,4)(1,0,0)[52]   34
    ## 36 ARIMA(4,1,4)(1,0,0)[52]   35
    ## 37 ARIMA(4,1,4)(1,0,0)[52]   36
    ## 38 ARIMA(4,1,4)(1,0,0)[52]   37
    ## 39 ARIMA(4,1,4)(1,0,0)[52]   38
    ## 40 ARIMA(4,1,4)(1,0,0)[52]   39
    ## 41 ARIMA(5,1,5)(1,0,0)[52]   40
    ## 42 ARIMA(5,1,5)(1,0,0)[52]   41
    ## 43 ARIMA(5,1,5)(1,0,0)[52]   42
    ## 44 ARIMA(5,1,5)(1,0,0)[52]   43
    ## 45 ARIMA(5,1,5)(1,0,0)[52]   44
    ## 46 ARIMA(5,1,5)(1,0,0)[52]   45
    ## 47 ARIMA(5,1,5)(1,0,0)[52]   46
    ## 48 ARIMA(5,1,5)(1,0,0)[52]   47
    ## 49 ARIMA(4,1,4)(1,0,0)[52]   48
    ## 50 ARIMA(4,1,4)(1,0,0)[52]   49
    ## 51 ARIMA(4,1,4)(1,0,0)[52]   50
    ## 52 ARIMA(4,1,4)(1,0,0)[52]   51

``` r
#model_evaluation
model_evaluaion(predictNULL_Flu_Kaohsiung_313_Monthly$Point.Forecast,Flu_Kaohsiung_313[262:313]$N)
```

    ## [1] "MAE: 10.95  MAPE: 27.9  RMSE: 16.19  RMSPE: 39.2"

### 每季更新模型\_高雄 Updating Interval: Quarterly (Kaohsiung)

``` r
predictNULL_Flu_Kaohsiung_313_Quarterly<-NULL
training_Flu_Kaohsiung_313_model_Quarterly<-NULL
Flu_Kaohsiung_313_model_coefficient_Quarterly<-NULL


for(i in 0:51){
  if ((i+1)%%13==1){
    newtraining_Flu_Kaohsiung_313_Quarterly<-ts(Flu_Kaohsiung_313[c(1:(261+i)),]$N,start =c(2010,01),freq = 365.25/7)
    fit_Quarterly<-auto.arima(newtraining_Flu_Kaohsiung_313_Quarterly)
    mmm_Quarterly<-data.frame(method = forecast(fit_Quarterly)$method)
    #print(i)
  }
  
  newtraining_Flu_Kaohsiung_313_Quarterly<-ts(Flu_Kaohsiung_313[c(1:(261+i)),]$N,start =c(2010,01),freq = 365.25/7)
  fit_Quarterly_arima<-arima(newtraining_Flu_Kaohsiung_313_Quarterly,order = fit_Quarterly$arma[c(1,6,2)],seasonal = list(order = fit_Quarterly$arma[c(3,7,4)],period = fit_Quarterly$arma[5]),method="CSS")
  mmm_Quarterly<-data.frame(method = forecast(fit_Quarterly_arima)$method,week = i)
  nnn<-data.frame(t(fit_Quarterly_arima$coef))
  training_Flu_Kaohsiung_313_model_Quarterly<-rbind(training_Flu_Kaohsiung_313_model_Quarterly,mmm_Quarterly)
  Flu_Kaohsiung_313_model_coefficient_Quarterly<-smartbind(Flu_Kaohsiung_313_model_coefficient_Quarterly,nnn)
  ppp<-forecast(fit_Quarterly_arima,1)
  predictNULL_Flu_Kaohsiung_313_Quarterly<-rbind(data.frame(predictNULL_Flu_Kaohsiung_313_Quarterly),data.frame(ppp))
  #print(i)
}

predictNULL_Flu_Kaohsiung_313_Quarterly$year_week_no<-262:313
predictNULL_Flu_Kaohsiung_313_Quarterly<-data.table(predictNULL_Flu_Kaohsiung_313_Quarterly)
predictNULL_Flu_Kaohsiung_313_Quarterly[Point.Forecast<0]$Point.Forecast<-0
saveRDS(predictNULL_Flu_Kaohsiung_313_Quarterly[,c('year_week_no','Point.Forecast'),with=F],'Flu_ARIMA_Quarterly_Kaohsiung.rds')

#trained_model
training_Flu_Kaohsiung_313_model_Quarterly
```

    ##                     method week
    ## 1  ARIMA(0,1,1)(0,0,1)[52]    0
    ## 2  ARIMA(0,1,1)(0,0,1)[52]    1
    ## 3  ARIMA(0,1,1)(0,0,1)[52]    2
    ## 4  ARIMA(0,1,1)(0,0,1)[52]    3
    ## 5  ARIMA(0,1,1)(0,0,1)[52]    4
    ## 6  ARIMA(0,1,1)(0,0,1)[52]    5
    ## 7  ARIMA(0,1,1)(0,0,1)[52]    6
    ## 8  ARIMA(0,1,1)(0,0,1)[52]    7
    ## 9  ARIMA(0,1,1)(0,0,1)[52]    8
    ## 10 ARIMA(0,1,1)(0,0,1)[52]    9
    ## 11 ARIMA(0,1,1)(0,0,1)[52]   10
    ## 12 ARIMA(0,1,1)(0,0,1)[52]   11
    ## 13 ARIMA(0,1,1)(0,0,1)[52]   12
    ## 14 ARIMA(5,1,2)(1,0,0)[52]   13
    ## 15 ARIMA(5,1,2)(1,0,0)[52]   14
    ## 16 ARIMA(5,1,2)(1,0,0)[52]   15
    ## 17 ARIMA(5,1,2)(1,0,0)[52]   16
    ## 18 ARIMA(5,1,2)(1,0,0)[52]   17
    ## 19 ARIMA(5,1,2)(1,0,0)[52]   18
    ## 20 ARIMA(5,1,2)(1,0,0)[52]   19
    ## 21 ARIMA(5,1,2)(1,0,0)[52]   20
    ## 22 ARIMA(5,1,2)(1,0,0)[52]   21
    ## 23 ARIMA(5,1,2)(1,0,0)[52]   22
    ## 24 ARIMA(5,1,2)(1,0,0)[52]   23
    ## 25 ARIMA(5,1,2)(1,0,0)[52]   24
    ## 26 ARIMA(5,1,2)(1,0,0)[52]   25
    ## 27 ARIMA(5,1,5)(1,0,0)[52]   26
    ## 28 ARIMA(5,1,5)(1,0,0)[52]   27
    ## 29 ARIMA(5,1,5)(1,0,0)[52]   28
    ## 30 ARIMA(5,1,5)(1,0,0)[52]   29
    ## 31 ARIMA(5,1,5)(1,0,0)[52]   30
    ## 32 ARIMA(5,1,5)(1,0,0)[52]   31
    ## 33 ARIMA(5,1,5)(1,0,0)[52]   32
    ## 34 ARIMA(5,1,5)(1,0,0)[52]   33
    ## 35 ARIMA(5,1,5)(1,0,0)[52]   34
    ## 36 ARIMA(5,1,5)(1,0,0)[52]   35
    ## 37 ARIMA(5,1,5)(1,0,0)[52]   36
    ## 38 ARIMA(5,1,5)(1,0,0)[52]   37
    ## 39 ARIMA(5,1,5)(1,0,0)[52]   38
    ## 40 ARIMA(4,1,4)(1,0,0)[52]   39
    ## 41 ARIMA(4,1,4)(1,0,0)[52]   40
    ## 42 ARIMA(4,1,4)(1,0,0)[52]   41
    ## 43 ARIMA(4,1,4)(1,0,0)[52]   42
    ## 44 ARIMA(4,1,4)(1,0,0)[52]   43
    ## 45 ARIMA(4,1,4)(1,0,0)[52]   44
    ## 46 ARIMA(4,1,4)(1,0,0)[52]   45
    ## 47 ARIMA(4,1,4)(1,0,0)[52]   46
    ## 48 ARIMA(4,1,4)(1,0,0)[52]   47
    ## 49 ARIMA(4,1,4)(1,0,0)[52]   48
    ## 50 ARIMA(4,1,4)(1,0,0)[52]   49
    ## 51 ARIMA(4,1,4)(1,0,0)[52]   50
    ## 52 ARIMA(4,1,4)(1,0,0)[52]   51

``` r
#model_evaluation
model_evaluaion(predictNULL_Flu_Kaohsiung_313_Quarterly$Point.Forecast,Flu_Kaohsiung_313[262:313]$N)
```

    ## [1] "MAE: 13.08  MAPE: 30.8  RMSE: 18.13  RMSPE: 42.7"

### 每年更新模型\_高雄 Updating Interval: Yearly (Kaohsiung)

``` r
predictNULL_Flu_Kaohsiung_313_YEARLY<-NULL
training_Flu_Kaohsiung_313_model_YEARLY<-NULL
Flu_Kaohsiung_313_model_coefficient_YEARLY<-NULL


for(i in 0:51){
  if ((i+1)%%52==1){
    newtraining_Flu_Kaohsiung_313_YEARLY<-ts(Flu_Kaohsiung_313[c(1:(261+i)),]$N,start =c(2010,01),freq = 365.25/7)
    fit_YEARLY<-auto.arima(newtraining_Flu_Kaohsiung_313_YEARLY)
    mmm_YEARLY<-data.frame(method = forecast(fit_YEARLY)$method)
    #print(i)
  }
  
  newtraining_Flu_Kaohsiung_313_YEARLY<-ts(Flu_Kaohsiung_313[c(1:(261+i)),]$N,start =c(2010,01),freq = 365.25/7)
  fit_YEARLY_arima<-arima(newtraining_Flu_Kaohsiung_313_YEARLY,order = fit_YEARLY$arma[c(1,6,2)],seasonal = list(order = fit_YEARLY$arma[c(3,7,4)],period = fit_YEARLY$arma[5]),method="CSS")
  mmm_YEARLY<-data.frame(method = forecast(fit_YEARLY_arima)$method,week = i)
  nnn<-data.frame(t(fit_YEARLY_arima$coef))
  training_Flu_Kaohsiung_313_model_YEARLY<-rbind(training_Flu_Kaohsiung_313_model_YEARLY,mmm_YEARLY)
  Flu_Kaohsiung_313_model_coefficient_YEARLY<-smartbind(Flu_Kaohsiung_313_model_coefficient_YEARLY,nnn)
  ppp<-forecast(fit_YEARLY_arima,1)
  predictNULL_Flu_Kaohsiung_313_YEARLY<-rbind(data.frame(predictNULL_Flu_Kaohsiung_313_YEARLY),data.frame(ppp))
  #print(i)
}
predictNULL_Flu_Kaohsiung_313_YEARLY$year_week_no<-262:313
predictNULL_Flu_Kaohsiung_313_YEARLY<-data.table(predictNULL_Flu_Kaohsiung_313_YEARLY)
predictNULL_Flu_Kaohsiung_313_YEARLY[Point.Forecast<0]$Point.Forecast<-0

saveRDS(predictNULL_Flu_Kaohsiung_313_YEARLY[,c('year_week_no','Point.Forecast'),with=F],'Flu_ARIMA_Yearly_Kaohsiung.rds')

#trained_model
training_Flu_Kaohsiung_313_model_YEARLY
```

    ##                     method week
    ## 1  ARIMA(0,1,1)(0,0,1)[52]    0
    ## 2  ARIMA(0,1,1)(0,0,1)[52]    1
    ## 3  ARIMA(0,1,1)(0,0,1)[52]    2
    ## 4  ARIMA(0,1,1)(0,0,1)[52]    3
    ## 5  ARIMA(0,1,1)(0,0,1)[52]    4
    ## 6  ARIMA(0,1,1)(0,0,1)[52]    5
    ## 7  ARIMA(0,1,1)(0,0,1)[52]    6
    ## 8  ARIMA(0,1,1)(0,0,1)[52]    7
    ## 9  ARIMA(0,1,1)(0,0,1)[52]    8
    ## 10 ARIMA(0,1,1)(0,0,1)[52]    9
    ## 11 ARIMA(0,1,1)(0,0,1)[52]   10
    ## 12 ARIMA(0,1,1)(0,0,1)[52]   11
    ## 13 ARIMA(0,1,1)(0,0,1)[52]   12
    ## 14 ARIMA(0,1,1)(0,0,1)[52]   13
    ## 15 ARIMA(0,1,1)(0,0,1)[52]   14
    ## 16 ARIMA(0,1,1)(0,0,1)[52]   15
    ## 17 ARIMA(0,1,1)(0,0,1)[52]   16
    ## 18 ARIMA(0,1,1)(0,0,1)[52]   17
    ## 19 ARIMA(0,1,1)(0,0,1)[52]   18
    ## 20 ARIMA(0,1,1)(0,0,1)[52]   19
    ## 21 ARIMA(0,1,1)(0,0,1)[52]   20
    ## 22 ARIMA(0,1,1)(0,0,1)[52]   21
    ## 23 ARIMA(0,1,1)(0,0,1)[52]   22
    ## 24 ARIMA(0,1,1)(0,0,1)[52]   23
    ## 25 ARIMA(0,1,1)(0,0,1)[52]   24
    ## 26 ARIMA(0,1,1)(0,0,1)[52]   25
    ## 27 ARIMA(0,1,1)(0,0,1)[52]   26
    ## 28 ARIMA(0,1,1)(0,0,1)[52]   27
    ## 29 ARIMA(0,1,1)(0,0,1)[52]   28
    ## 30 ARIMA(0,1,1)(0,0,1)[52]   29
    ## 31 ARIMA(0,1,1)(0,0,1)[52]   30
    ## 32 ARIMA(0,1,1)(0,0,1)[52]   31
    ## 33 ARIMA(0,1,1)(0,0,1)[52]   32
    ## 34 ARIMA(0,1,1)(0,0,1)[52]   33
    ## 35 ARIMA(0,1,1)(0,0,1)[52]   34
    ## 36 ARIMA(0,1,1)(0,0,1)[52]   35
    ## 37 ARIMA(0,1,1)(0,0,1)[52]   36
    ## 38 ARIMA(0,1,1)(0,0,1)[52]   37
    ## 39 ARIMA(0,1,1)(0,0,1)[52]   38
    ## 40 ARIMA(0,1,1)(0,0,1)[52]   39
    ## 41 ARIMA(0,1,1)(0,0,1)[52]   40
    ## 42 ARIMA(0,1,1)(0,0,1)[52]   41
    ## 43 ARIMA(0,1,1)(0,0,1)[52]   42
    ## 44 ARIMA(0,1,1)(0,0,1)[52]   43
    ## 45 ARIMA(0,1,1)(0,0,1)[52]   44
    ## 46 ARIMA(0,1,1)(0,0,1)[52]   45
    ## 47 ARIMA(0,1,1)(0,0,1)[52]   46
    ## 48 ARIMA(0,1,1)(0,0,1)[52]   47
    ## 49 ARIMA(0,1,1)(0,0,1)[52]   48
    ## 50 ARIMA(0,1,1)(0,0,1)[52]   49
    ## 51 ARIMA(0,1,1)(0,0,1)[52]   50
    ## 52 ARIMA(0,1,1)(0,0,1)[52]   51

``` r
#model_evaluation
model_evaluaion(predictNULL_Flu_Kaohsiung_313_YEARLY$Point.Forecast,Flu_Kaohsiung_313[262:313]$N)
```

    ## [1] "MAE: 14.67  MAPE: 35.6  RMSE: 20.85  RMSPE: 49.5"
