import unzip
import extract_station
import date
import counting_tempature
import VAR
import ARIMA

import os

def pretreatment():
    #unzip.unzip()
    #extract_station.station("466990")
    #missing date: 2018/11/01、2018/12/27
    #missing date was filled by hand
    #outputPtah = os.path.join("data","date_2015~2019.csv")

    #date.date_generate("2015","01","2019","52",outputPtah)
    
    tempaturePath = os.path.join("data","466990-2017-2019-average-temperature.csv")
    datePath = os.path.join("data","date_2017~2019.csv")
    outputPath = os.path.join("data","tempature.csv")
    counting_tempature.counting_tempature(tempaturePath,datePath,outputPath)
    
if __name__ == '__main__':
    #pretreatment()
    #VAR.VAR(isPass=False)
    ARIMA.ARIMA(isPass=False)
