Plot of the best model
================

Library
-------

``` r
library(ggplot2)
library(data.table)
```

### Linkou (ETS)

``` r
Flu_ETS_Weekly_Linkou<-readRDS('Flu_ETS_Weekly_Linkou.rds')
Flu_Linkou_313<-readRDS('Flu_Linkou_313.rds')

ggplot() +
  geom_line(data = Flu_ETS_Weekly_Linkou[262:313], 
            aes(x =as.numeric(year_week_no), y = as.numeric(anti_yhat)),colour='red')+xlab('Time (year-week)')+ylab('Case count')+
  scale_x_continuous(breaks=seq(1, 313, 365.25/7),labels = c(2010:2015))+
  geom_line(data = Flu_Linkou_313[c(1:313),],aes(x =as.numeric(year_week_no), y = N),colour='black')+
  theme_classic(base_size = 20)
```

![](Plot_BestModels_files/figure-markdown_github/unnamed-chunk-2-1.png)

### Linkou (ARIMA)

``` r
Flu_ARIMA_Weekly_Linkou<-readRDS('Flu_ARIMA_Weekly_Linkou.rds')
Flu_Linkou_313<-readRDS('Flu_Linkou_313.rds')

ggplot() +
  geom_line(data = Flu_ARIMA_Weekly_Linkou, 
            aes(x =as.numeric(year_week_no), y = as.numeric(Point.Forecast)),colour='red')+xlab('Time (year-week)')+ylab('Case count')+
  scale_x_continuous(breaks=seq(1, 313, 365.25/7),labels = c(2010:2015))+
  geom_line(data = Flu_Linkou_313[c(1:313),],aes(x =as.numeric(year_week_no), y = N),colour='black')+
  theme_classic(base_size = 20)
```

![](Plot_BestModels_files/figure-markdown_github/unnamed-chunk-3-1.png)

### Linkou (Prophet)

``` r
Flu_Prophet_Weekly_Linkou<-readRDS('Flu_Prophet_Weekly_Linkou.rds')
Flu_Linkou_313<-readRDS('Flu_Linkou_313.rds')

ggplot() +
  geom_line(data = Flu_Prophet_Weekly_Linkou, 
            aes(x =as.numeric(year_week_no), y = as.numeric(anti_yhat)),colour='red')+xlab('Time (year-week)')+ylab('Case count')+
  scale_x_continuous(breaks=seq(1, 313, 365.25/7),labels = c(2010:2015))+
  geom_line(data = Flu_Linkou_313[c(1:313),],aes(x =as.numeric(year_week_no), y = N),colour='black')+
  theme_classic(base_size = 20)
```

![](Plot_BestModels_files/figure-markdown_github/unnamed-chunk-4-1.png)

### Kaohsiung (ETS)

``` r
Flu_ETS_Weekly_Kaohsiung<-readRDS('Flu_ETS_Weekly_Kaohsiung.rds')
Flu_Kaohsiung_313<-readRDS('Flu_Kaohsiung_313.rds')
Flu_Kaohsiung_313<-rbind(Flu_Kaohsiung_313,data.table(year_week_CDC="2014_47",N=0),fill=T)
Flu_Kaohsiung_313<-Flu_Kaohsiung_313[order(year_week_CDC)]
Flu_Kaohsiung_313$year_week_no<-1:313

ggplot() +
  geom_line(data = Flu_ETS_Weekly_Kaohsiung[262:313], 
            aes(x =as.numeric(year_week_no), y = as.numeric(anti_yhat)),colour='red')+xlab('Time (year-week)')+ylab('Case count')+
  scale_x_continuous(breaks=seq(1, 313, 365.25/7),labels = c(2010:2015))+
  geom_line(data = Flu_Kaohsiung_313[c(1:313),],aes(x =as.numeric(year_week_no), y = N),colour='black')+
  theme_classic(base_size = 20)
```

![](Plot_BestModels_files/figure-markdown_github/unnamed-chunk-5-1.png)

### Kaohsiung (ARIMA)

``` r
Flu_ARIMA_Weekly_Kaohsiung<-readRDS('Flu_ARIMA_Weekly_Kaohsiung.rds')
Flu_Kaohsiung_313<-readRDS('Flu_Kaohsiung_313.rds')
Flu_Kaohsiung_313<-rbind(Flu_Kaohsiung_313,data.table(year_week_CDC="2014_47",N=0),fill=T)
Flu_Kaohsiung_313<-Flu_Kaohsiung_313[order(year_week_CDC)]
Flu_Kaohsiung_313$year_week_no<-1:313

ggplot() +
  geom_line(data = Flu_ARIMA_Weekly_Kaohsiung, 
            aes(x =as.numeric(year_week_no), y = as.numeric(Point.Forecast)),colour='red')+xlab('Time (year-week)')+ylab('Case count')+
  scale_x_continuous(breaks=seq(1, 313, 365.25/7),labels = c(2010:2015))+
  geom_line(data = Flu_Kaohsiung_313[c(1:313),],aes(x =as.numeric(year_week_no), y = N),colour='black')+
  theme_classic(base_size = 20)
```

![](Plot_BestModels_files/figure-markdown_github/unnamed-chunk-6-1.png)

### Kaohsiung (Prophet)

``` r
Flu_Prophet_Weekly_Kaohsiung<-readRDS('Flu_Prophet_Weekly_Kaohsiung.rds')
Flu_Kaohsiung_313<-readRDS('Flu_Kaohsiung_313.rds')
Flu_Kaohsiung_313<-rbind(Flu_Kaohsiung_313,data.table(year_week_CDC="2014_47",N=0),fill=T)
Flu_Kaohsiung_313<-Flu_Kaohsiung_313[order(year_week_CDC)]
Flu_Kaohsiung_313$year_week_no<-1:313

ggplot() +
  geom_line(data = Flu_Prophet_Weekly_Kaohsiung, 
            aes(x =as.numeric(year_week_no), y = as.numeric(anti_yhat)),colour='red')+xlab('Time (year-week)')+ylab('Case count')+
  scale_x_continuous(breaks=seq(1, 313, 365.25/7),labels = c(2010:2015))+
  geom_line(data = Flu_Kaohsiung_313[c(1:313),],aes(x =as.numeric(year_week_no), y = N),colour='black')+
  theme_classic(base_size = 20)
```

![](Plot_BestModels_files/figure-markdown_github/unnamed-chunk-7-1.png)
