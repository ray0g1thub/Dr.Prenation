import os
import csv
import pandas as pd
import sys

def formater(integer):
    if integer < 10:
        return "0"+str(integer)
    else:
        return str(integer)

def oneTurn(station):
    weekDays = 7
    with open(station+".csv",'w',newline='') as outCsv:
        writer = csv.writer(outCsv)
        fileDir = station
        averageTemperature = 0
        maxTemperature = -99
        minTemperature = 99
        rain = 0
        weekOfYestoday = 0
        counterForDate = 0
        writer.writerow(["station: "+station])
        writer.writerow(["year","week","average","max","min","rain"])
        for year in range(2017,2020):
            for month in range(1,13):
                fileName = station+"-"+str(year)+"-"+formater(month)+".csv"
                filePath = os.path.join(fileDir,fileName)
                df = pd.read_csv(filePath, skiprows=[0,2])
                df = df.filter(["觀測時間(day)","氣溫(℃)","最高氣溫(℃)","最低氣溫(℃)","降水量(mm)"])
                for day in df.iterrows():
                    date = str(year)+"/"+str(month)+"/"+str(day[1]["觀測時間(day)"])
                    if counterForDate == dfDates["week"].size:
                        averageTemperature = round(averageTemperature/weekDays,1)
                        writer.writerow([str(year),str(weekOfYestoday),str(averageTemperature),str(maxTemperature),str(minTemperature),str(rain)])
                        return
                    elif dfDates["date"][counterForDate] == date:
                        #print(dfDates["date"][counterForDate] , date)
                        if weekOfYestoday == 0:
                            pass
                        elif dfDates["week"][counterForDate] != weekOfYestoday:
                            averageTemperature = round(averageTemperature/weekDays,1)
                            writer.writerow([str(year),str(weekOfYestoday),str(averageTemperature),str(maxTemperature),str(minTemperature),str(rain)])
                            averageTemperature = 0
                            maxTemperature = -99
                            minTemperature = 99
                            rain = 0
                            weekDays = 7
                        try:
                            averageTemperature+=float(day[1]["氣溫(℃)"])
                        except Exception as e:
                            print(year,month,day[1]["觀測時間(day)"])
                            print(e,"氣溫(℃)")
                            weekDays -= 1
                        try:
                            maxTemperature = max(maxTemperature,float(day[1]["最高氣溫(℃)"]))
                        except Exception as e:
                            print(year,month,day[1]["觀測時間(day)"])
                            print(e,"最高氣溫(℃)")
                        try:
                            minTemperature = min(minTemperature,float(day[1]["最低氣溫(℃)"]))
                        except Exception as e:
                            print(year,month,day[1]["觀測時間(day)"])
                            print(e,"最低氣溫(℃)")
                        try:
                            rain+=float(day[1]["降水量(mm)"])
                        except Exception as e:
                            print(year,month,day[1]["觀測時間(day)"])
                            print(e,"降水量(mm)")
                        if counterForDate != 0:
                            weekOfYestoday = dfDates["week"][counterForDate]
                        counterForDate+=1
if __name__ == "__main__":
    stations = ["C0C480","C0C490","C0C650","C0C660"]
    #stations=["C0C480"]
    datePath = "date_2017~2019.csv"
    header=["year","week","date"]
    dfDates = pd.read_csv(datePath, names=header)
    #print(dfDates["date"][0])
    for station in stations:
        oneTurn(station)
