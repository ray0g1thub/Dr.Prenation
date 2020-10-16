Flu Prediction models for Linkou and Kaohsiung Branch\_Prophet
================

匯入套件Import Library
----------------------

``` r
library(data.table)
library(forecast)
library(prophet)
```

    ## Loading required package: Rcpp

``` r
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
CDC_yearweek_data<-readRDS('CDC_yearweek_data.rds')
CDC_yearweek_data_firstdayofweek<-CDC_yearweek_data[,.SD[c(1)],year_week_CDC]
Flu_Linkou_313<-merge(Flu_Linkou_313,CDC_yearweek_data_firstdayofweek[,c(1,4),with=F])

Flu_Linkou_313$Log_N<-log10((Flu_Linkou_313$N)+1)
Linkou_Test_week<-Flu_Linkou_313[,c('startday','Log_N'),with = F]
colnames(Linkou_Test_week)<-c('ds','y')
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
Linkou_Test_prediction_week<-NULL
for (i in c(1:52)){
  Linkou_Test_week$floor<-0
  
  m <- prophet(Linkou_Test_week[1:(260+i),],changepoint.prior.scale = 0.1)
  
  future<-make_future_dataframe(m,periods = 1,freq = 'week',include_history = F)
  future$floor<-0
  forecast <- predict(m, future)
  Linkou_Test_prediction_week <- rbind(Linkou_Test_prediction_week,forecast)
}
```

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.

    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -5.5285
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -5.91744
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.03652
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.26582
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.9097
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.5087
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.88651
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -9.15735
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.37734
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.76797
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.90932
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.08116
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.44144
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.93702
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.63584
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.29422
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.74181
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.97955
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.75267
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.37408
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.9087
    ## Optimization terminated normally: 
    ##   Convergence detected: absolute parameter change was below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.84576
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.36085
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.97388
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -9.09269
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.91894
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.43924
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.30096
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.4879
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.37048
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.0225
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -5.99281
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.02723
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.01653
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.00226
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.05403
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.17308
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.51983
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.16085
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.01147
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.04108
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.03826
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.03556
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.0037
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.01175
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.00367
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.48057
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.21387
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.04806
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.0231
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.78902
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.20872
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

``` r
Linkou_Test_prediction_week$anti_yhat<-(10^Linkou_Test_prediction_week$yhat)-1

Linkou_Test_prediction_week$year_week_no<-262:313
Linkou_Test_prediction_week<-data.table(Linkou_Test_prediction_week)

saveRDS(Linkou_Test_prediction_week[,c('year_week_no','anti_yhat'),with=F],'Flu_Prophet_Weekly_Linkou.rds')

#model_evaluation
model_evaluaion(Linkou_Test_prediction_week$anti_yhat,Flu_Linkou_313[262:313]$N)
```

    ## [1] "MAE: 27.72  MAPE: 38.4  RMSE: 40.01  RMSPE: 50.2"

### 每月更新模型\_林口 Updating Interval: Monthly (Linkou)

``` r
Linkou_Test_month<-Flu_Linkou_313[,c('startday','Log_N'),with = F]
colnames(Linkou_Test_month)<-c('ds','y')
Linkou_Test_prediction_month<-NULL

for (i in c(1:13)){
  Linkou_Test_month$floor<-0
  
  m <- prophet(Linkou_Test_month[1:(261+4*(i-1)),],changepoint.prior.scale = 0.1)
  
  future<-make_future_dataframe(m,periods = 4,freq='week',include_history = F)
  future$floor<-0
  forecast <- predict(m, future)
  Linkou_Test_prediction_month<-rbind(Linkou_Test_prediction_month,forecast)
}
```

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.

    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -5.5285
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.9097
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.37734
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.44144
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.74181
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.9087
    ## Optimization terminated normally: 
    ##   Convergence detected: absolute parameter change was below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -9.09269
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.4879
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.02723
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.17308
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.04108
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.01175
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.04806
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

``` r
Linkou_Test_prediction_month$anti_yhat<-(10^Linkou_Test_prediction_month$yhat)-1

Linkou_Test_prediction_month$year_week_no<-262:313
Linkou_Test_prediction_month<-data.table(Linkou_Test_prediction_month)

saveRDS(Linkou_Test_prediction_month[,c('year_week_no','anti_yhat'),with=F],'Flu_Prophet_Monthly_Linkou.rds')

#model_evaluation
model_evaluaion(Linkou_Test_prediction_month$anti_yhat,Flu_Linkou_313[262:313]$N)
```

    ## [1] "MAE: 30.03  MAPE: 41.8  RMSE: 43.11  RMSPE: 53.9"

### 每季更新模型\_林口 Updating Interval:Quarterly (Linkou)

``` r
Linkou_Test_seasonal<-Flu_Linkou_313[,c('startday','Log_N'),with = F]
colnames(Linkou_Test_seasonal)<-c('ds','y')
Linkou_Test_prediction_seasonal<-NULL

for (i in c(1:4)){
  Linkou_Test_seasonal$floor<-0
  
  m <- prophet(Linkou_Test_seasonal[1:(261+13*(i-1)),],changepoint.prior.scale = 0.1)
  
  future<-make_future_dataframe(m,periods = 13,freq='week',include_history = F)
  future$floor<-0
  forecast <- predict(m, future)
  Linkou_Test_prediction_seasonal<-rbind(Linkou_Test_prediction_seasonal,forecast)
}
```

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.

    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -5.5285
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.93702
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.43924
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.01147
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

``` r
Linkou_Test_prediction_seasonal$anti_yhat<-(10^Linkou_Test_prediction_seasonal$yhat)-1

Linkou_Test_prediction_seasonal$year_week_no<-262:313
Linkou_Test_prediction_seasonal<-data.table(Linkou_Test_prediction_seasonal)

saveRDS(Linkou_Test_prediction_seasonal[,c('year_week_no','anti_yhat'),with=F],'Flu_Prophet_Quarterly_Linkou.rds')

#model_evaluation
model_evaluaion(Linkou_Test_prediction_seasonal$anti_yhat,Flu_Linkou_313[262:313]$N)
```

    ## [1] "MAE: 30.12  MAPE: 41.8  RMSE: 43.6  RMSPE: 54.5"

### 每年更新模型\_林口 Updating Interval: Yearly (Linkou)

``` r
Linkou_Test_yearly<-Flu_Linkou_313[,c('startday','Log_N'),with = F]
colnames(Linkou_Test_yearly)<-c('ds','y')
Linkou_Test_prediction_yearly<-NULL

for (i in c(1:1)){
  Linkou_Test_yearly$floor<-0
  
  m <- prophet(Linkou_Test_yearly[1:(261+52*(i-1)),],changepoint.prior.scale = 0.1)
  
  future<-make_future_dataframe(m,periods = 52,freq='week',include_history = F)
  future$floor<-0
  forecast <- predict(m, future)
  Linkou_Test_prediction_yearly<-rbind(Linkou_Test_prediction_yearly,forecast)
}
```

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.

    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -5.5285
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

``` r
Linkou_Test_prediction_yearly$anti_yhat<-(10^Linkou_Test_prediction_yearly$yhat)-1

Linkou_Test_prediction_yearly$year_week_no<-262:313
Linkou_Test_prediction_yearly<-data.table(Linkou_Test_prediction_yearly)

saveRDS(Linkou_Test_prediction_yearly[,c('year_week_no','anti_yhat'),with=F],'Flu_Prophet_Yearly_Linkou.rds')

#model_evaluation
model_evaluaion(Linkou_Test_prediction_yearly$anti_yhat,Flu_Linkou_313[262:313]$N)
```

    ## [1] "MAE: 31.1  MAPE: 43.7  RMSE: 43.69  RMSPE: 54.5"

<hr>
高雄院區資料Episode Data from Kaohsiung Branch
----------------------------------------------

``` r
Flu_Kaohsiung_313<-readRDS('Flu_Kaohsiung_313.rds')
Flu_Kaohsiung_313<-rbind(Flu_Kaohsiung_313,data.table(year_week_CDC="2014_47",N=0),fill=T)
Flu_Kaohsiung_313<-Flu_Kaohsiung_313[order(year_week_CDC)]
CDC_yearweek_data<-readRDS('CDC_yearweek_data.rds')
CDC_yearweek_data_firstdayofweek<-CDC_yearweek_data[,.SD[c(1)],year_week_CDC]
Flu_Kaohsiung_313<-merge(Flu_Kaohsiung_313,CDC_yearweek_data_firstdayofweek[,c(1,4),with=F])

Flu_Kaohsiung_313$Log_N<-log10((Flu_Kaohsiung_313$N)+1)
```

### 每週更新模型\_高雄 Updating Interval: Weekly (Kaohsiung)

``` r
Kao_Test_week<-Flu_Kaohsiung_313[,c('startday','Log_N'),with = F]
colnames(Kao_Test_week)<-c('ds','y')
Kao_Test_week$year_week_no<-1:313
Kao_Test_prediction_week<-NULL
for (i in c(1:52)){
  Kao_Test_week$floor<-0
  
  m <- prophet(Kao_Test_week[1:(260+i),],changepoint.prior.scale = 0.1)
  
  future<-make_future_dataframe(m,periods = 1,freq = 'week',include_history = F)
  future$floor<-0
  forecast <- predict(m, future)
  Kao_Test_prediction_week <- rbind(Kao_Test_prediction_week,forecast)
}
```

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.

    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.69272
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.07806
    ## Optimization terminated normally: 
    ##   Convergence detected: absolute parameter change was below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.8297
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.21955
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.03813
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.05408
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.72575
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -10.4405
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -9.47488
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -10.2858
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -9.45569
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -11.0342
    ## Optimization terminated normally: 
    ##   Convergence detected: absolute parameter change was below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -11.0908
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -11.5164
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -12.6088
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -12.2646
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -11.9807
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -11.2862
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -9.6595
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -10.538
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.8429
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -11.2651
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -11.7215
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -11.5358
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -12.8028
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -11.9505
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -10.5115
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -10.4342
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.95242
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.6964
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -9.14075
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.9941
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.1978
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.00635
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.83605
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.17876
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.08507
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.85825
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.70643
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.73102
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.76259
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.75697
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.75161
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.80792
    ## Optimization terminated normally: 
    ##   Convergence detected: absolute parameter change was below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.70873
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.7373
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.21912
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.70726
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.70907
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.89411
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.95488
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.96348
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

``` r
Kao_Test_prediction_week$anti_yhat<-(10^Kao_Test_prediction_week$yhat)-1

Kao_Test_prediction_week$year_week_no<-262:313
Kao_Test_prediction_week<-data.table(Kao_Test_prediction_week)

saveRDS(Kao_Test_prediction_week[,c('year_week_no','anti_yhat'),with=F],'Flu_Prophet_Weekly_Kaohsiung.rds')

#model_evaluation
model_evaluaion(Kao_Test_prediction_week$anti_yhat,Flu_Kaohsiung_313[262:313]$N)
```

    ## [1] "MAE: 31.12  MAPE: 69.6  RMSE: 43.14  RMSPE: 87.7"

### 每月更新模型\_高雄 Updating Interval: Monthly (Kaohsiung)

``` r
Kao_Test_month<-Flu_Kaohsiung_313[,c('startday','Log_N'),with = F]
colnames(Kao_Test_month)<-c('ds','y')
Kao_Test_prediction_month<-NULL

for (i in c(1:13)){
  Kao_Test_month$floor<-0
  
  m <- prophet(Kao_Test_month[1:(261+4*(i-1)),],changepoint.prior.scale = 0.1)
  
  future<-make_future_dataframe(m,periods = 4,freq='week',include_history = F)
  future$floor<-0
  forecast <- predict(m, future)
  Kao_Test_prediction_month<-rbind(Kao_Test_prediction_month,forecast)
}
```

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.

    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.69272
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.03813
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -9.47488
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -11.0908
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -11.9807
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.8429
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -12.8028
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.95242
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.1978
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -8.08507
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.76259
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.70873
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.70907
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

``` r
Kao_Test_prediction_month$anti_yhat<-(10^Kao_Test_prediction_month$yhat)-1

Kao_Test_prediction_month$year_week_no<-262:313
Kao_Test_prediction_month<-data.table(Kao_Test_prediction_month)

saveRDS(Kao_Test_prediction_month[,c('year_week_no','anti_yhat'),with=F],'Flu_Prophet_Monthly_Kaohsiung.rds')

#model_evaluation
model_evaluaion(Kao_Test_prediction_month$anti_yhat,Flu_Kaohsiung_313[262:313]$N)
```

    ## [1] "MAE: 32.92  MAPE: 75.9  RMSE: 45.07  RMSPE: 96.1"

### 每季更新模型\_高雄 Updating Interval: Quarterly (Kaohsiung)

``` r
Kao_Test_seasonal<-Flu_Kaohsiung_313[,c('startday','Log_N'),with = F]
colnames(Kao_Test_seasonal)<-c('ds','y')
Kao_Test_prediction_seasonal<-NULL

for (i in c(1:4)){
  Kao_Test_seasonal$floor<-0
  
  m <- prophet(Kao_Test_seasonal[1:(261+13*(i-1)),],changepoint.prior.scale = 0.1)
  
  future<-make_future_dataframe(m,periods = 13,freq='week',include_history = F)
  future$floor<-0
  forecast <- predict(m, future)
  Kao_Test_prediction_seasonal<-rbind(Kao_Test_prediction_seasonal,forecast)
}
```

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.

    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.69272
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -11.5164
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -10.5115
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.
    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -7.73102
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

``` r
Kao_Test_prediction_seasonal$anti_yhat<-(10^Kao_Test_prediction_seasonal$yhat)-1

Kao_Test_prediction_seasonal$year_week_no<-262:313
Kao_Test_prediction_seasonal<-data.table(Kao_Test_prediction_seasonal)

saveRDS(Kao_Test_prediction_seasonal[,c('year_week_no','anti_yhat'),with=F],'Flu_Prophet_Quarterly_Kaohsiung.rds')

#model_evaluation
model_evaluaion(Kao_Test_prediction_seasonal$anti_yhat,Flu_Kaohsiung_313[262:313]$N)
```

    ## [1] "MAE: 33.85  MAPE: 77.8  RMSE: 46.53  RMSPE: 97.8"

### 每年更新模型\_高雄 Updating Interval: Yearly (Kaohsiung)

``` r
Kao_Test_yearly<-Flu_Kaohsiung_313[,c('startday','Log_N'),with = F]
colnames(Kao_Test_yearly)<-c('ds','y')
Kao_Test_prediction_yearly<-NULL

for (i in c(1:1)){
  Kao_Test_yearly$floor<-0
  
  m <- prophet(Kao_Test_yearly[1:(261+52*(i-1)),],changepoint.prior.scale = 0.1)
  
  future<-make_future_dataframe(m,periods = 52,freq='week',include_history = F)
  future$floor<-0
  forecast <- predict(m, future)
  Kao_Test_prediction_yearly<-rbind(Kao_Test_prediction_yearly,forecast)
}
```

    ## Disabling weekly seasonality. Run prophet with weekly.seasonality=TRUE to override this.

    ## Disabling daily seasonality. Run prophet with daily.seasonality=TRUE to override this.

    ## Initial log joint probability = -6.69272
    ## Optimization terminated normally: 
    ##   Convergence detected: relative gradient magnitude is below tolerance

``` r
Kao_Test_prediction_yearly$anti_yhat<-(10^Kao_Test_prediction_yearly$yhat)-1

Kao_Test_prediction_yearly$year_week_no<-262:313
Kao_Test_prediction_yearly<-data.table(Kao_Test_prediction_yearly)

saveRDS(Kao_Test_prediction_yearly[,c('year_week_no','anti_yhat'),with=F],'Flu_Prophet_Yearly_Kaohsiung.rds')

#model_evaluation
model_evaluaion(Kao_Test_prediction_yearly$anti_yhat,Flu_Kaohsiung_313[262:313]$N)
```

    ## [1] "MAE: 32.61  MAPE: 63  RMSE: 46.27  RMSPE: 81.5"
