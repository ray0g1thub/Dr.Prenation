流感病程資料處理
================

流感重症病程資料準備
--------------------

### 匯入套件

``` r
library(data.table)
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following objects are masked from 'package:data.table':
    ## 
    ##     hour, isoweek, mday, minute, month, quarter, second, wday,
    ##     week, yday, year

    ## The following object is masked from 'package:base':
    ## 
    ##     date

``` r
library(knitr)
```

### 取各病程第一筆資料做為episode的起始日和結束日

``` r
total_Flu_episode_new<-readRDS('total_Flu_episode_new.rds')
firstrow_totalepisode<-total_Flu_episode_new[,.SD[1],by = episodeno]
#saveRDS(firstrow_totalepisode,'firstrow_totalepisode.rds')
knitr::kable(head(firstrow_totalepisode))
```

|  episodeno| uniqueID                                 | visitID                                  | diagnosis\_code | diagnosis\_sequence | admissionDate | dischargeDate | branch | Source | dataSource | sex | birthdate  | age        | lastdischargedate |   no| timediff | notinrange |  episodenum| startday   | endday     |
|----------:|:-----------------------------------------|:-----------------------------------------|:----------------|:--------------------|:--------------|:--------------|:-------|:-------|:-----------|:----|:-----------|:-----------|:------------------|----:|:---------|:-----------|-----------:|:-----------|:-----------|
|          1| 00009A1E1CC139FF8373EDD9CB70C758108E8F06 | 994BCA1FBBD8806A5453ED6B6B52DA9297156AE8 | 4878            | 03                  | 2011-03-28    | 2011-03-28    | 8      |        | ER         | M   | 1927-10-05 | 83.53 days | NA                |    1| NA       | TRUE       |           1| 2011-03-28 | 2011-03-28 |
|          2| 00009A1E1CC139FF8373EDD9CB70C758108E8F06 | DE5197506ED39A40A10E642FD24352BD78F26956 | 4878            | 04                  | 2011-12-26    | 2011-12-26    | 8      |        | ER         | M   | 1927-10-05 | 84.28 days | 2011-03-28        |    2| 273 days | TRUE       |           2| 2011-12-26 | 2011-12-26 |
|          3| 000154F2FB429763BFB8BD1AFB2FD05616916D38 | 2DF787640B3E4278CE6B1DB54B8AA9C7A79E8C62 | 4871            | 03                  | 2013-03-17    | 2013-03-17    | 3      |        | ER         | F   | 1980-01-15 | 33.19 days | NA                |    3| NA       | TRUE       |           1| 2013-03-17 | 2013-03-17 |
|          4| 00015BCBDCA62981A9A4C5059103419BC649D2A1 | 22A284253C56183F0B8F2705AB33B3493E8FBC11 | 4871            | 02                  | 2013-01-25    | 2013-01-25    | 3      |        | ER         | M   | 1952-07-31 | 60.53 days | NA                |    4| NA       | TRUE       |           1| 2013-01-25 | 2013-01-25 |
|          5| 00015BCBDCA62981A9A4C5059103419BC649D2A1 | B2DA28700051D29FE111DFF3C6753E14F1559595 | 4871            | 01                  | 2015-01-16    | 2015-01-16    | 3      |        | ER         | M   | 1952-07-31 | 62.50 days | 2013-01-25        |    5| 721 days | TRUE       |           2| 2015-01-16 | 2015-01-16 |
|          6| 000182FB2BC700A653D09DE78CE2550C62836CB7 | BFE8A12B266ABC424CA5FCA1BCD0A2005F50DD9A | 4871            | 01                  | 2010-01-13    | 2010-01-13    | 2      |        | ER         | M   | 1976-06-22 | 33.58 days | NA                |    6| NA       | TRUE       |           1| 2010-01-13 | 2010-01-13 |

### 串接疾管署的年週對照表

``` r
Flu_start_end<-firstrow_totalepisode[,c(1,2,6,7,19,20),with = F]
CDC_Time<-fread('CopyOfCDC_Time1.csv')
CDC_Time$CDC_date<-ymd(CDC_Time$CDC_date)
colnames(CDC_Time)[1]<-"startday"
Flu_start_end<-merge(Flu_start_end,CDC_Time,by = "startday",all.x = T)
Flu_start_end<-Flu_start_end[,c(2:5,1,6:8),with =F]
knitr::kable(head(Flu_start_end))
```

|  episodeno| uniqueID                                 | admissionDate | dischargeDate | startday   | endday     |  CDC\_year|  CDC\_week|
|----------:|:-----------------------------------------|:--------------|:--------------|:-----------|:-----------|----------:|----------:|
|     140556| F4A502EC3E91541A5D89A3DDAF419CBC851FAD12 | 2005-12-18    | 2006-01-12    | 2005-12-18 | 2006-01-12 |         NA|         NA|
|       3536| 061B2D706A34515A0DD109E496AC9605C84AC901 | 2005-12-29    | 2006-01-02    | 2005-12-29 | 2006-01-02 |         NA|         NA|
|      65015| 71378025EB9EF4552AA4A101941FE7A2A5FBAC69 | 2006-01-01    | 2006-01-01    | 2006-01-01 | 2006-01-01 |       2006|          1|
|     139272| F272C25BA088704925195EEF23948B3FDC90DBD4 | 2006-01-01    | 2006-01-01    | 2006-01-01 | 2006-01-01 |       2006|          1|
|      10478| 123C03C09BAC175DB35EE4ECE8711C8EBFA6DA01 | 2006-01-02    | 2006-01-02    | 2006-01-02 | 2006-01-02 |       2006|          1|
|      11151| 13622A94D05FB0EE0B1F859C595A0147EEF76F58 | 2006-01-02    | 2006-01-02    | 2006-01-02 | 2006-01-02 |       2006|          1|

``` r
#saveRDS(Flu_start_end,"Flu_start_end.rds")
```

### 取欲分析的2010-2015年資料

``` r
Flu_2010to2015_EPISODEwithCDC<-Flu_start_end[CDC_year%in%c(2010:2015)]
knitr::kable(head(Flu_start_end))
```

|  episodeno| uniqueID                                 | admissionDate | dischargeDate | startday   | endday     |  CDC\_year|  CDC\_week|
|----------:|:-----------------------------------------|:--------------|:--------------|:-----------|:-----------|----------:|----------:|
|     140556| F4A502EC3E91541A5D89A3DDAF419CBC851FAD12 | 2005-12-18    | 2006-01-12    | 2005-12-18 | 2006-01-12 |         NA|         NA|
|       3536| 061B2D706A34515A0DD109E496AC9605C84AC901 | 2005-12-29    | 2006-01-02    | 2005-12-29 | 2006-01-02 |         NA|         NA|
|      65015| 71378025EB9EF4552AA4A101941FE7A2A5FBAC69 | 2006-01-01    | 2006-01-01    | 2006-01-01 | 2006-01-01 |       2006|          1|
|     139272| F272C25BA088704925195EEF23948B3FDC90DBD4 | 2006-01-01    | 2006-01-01    | 2006-01-01 | 2006-01-01 |       2006|          1|
|      10478| 123C03C09BAC175DB35EE4ECE8711C8EBFA6DA01 | 2006-01-02    | 2006-01-02    | 2006-01-02 | 2006-01-02 |       2006|          1|
|      11151| 13622A94D05FB0EE0B1F859C595A0147EEF76F58 | 2006-01-02    | 2006-01-02    | 2006-01-02 | 2006-01-02 |       2006|          1|

``` r
#saveRDS(Flu_2010to2015_EPISODEwithCDC,'Flu_2010to2015_EPISODEwithCDC.rds')
```
