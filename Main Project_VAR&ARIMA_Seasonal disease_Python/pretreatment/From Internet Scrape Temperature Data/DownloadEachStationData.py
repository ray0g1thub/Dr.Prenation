from urllib.request import urlretrieve, urlopen
from bs4 import BeautifulSoup
import csv
from urllib.parse import unquote, quote
import os

def formater(integer):
    if integer < 10:
        return "0"+str(integer)
    else:
        return str(integer)
#stationNumber = ["C0C480","C0C490","C0C650","C0C660"]
#stationName = ["桃園","八德","平鎮","楊梅"]
stationNumber = ["C0C480"]
stationName = ["桃園"]

for station in zip(stationNumber,stationName):
    #for year in range(2017,2020):
    for year in range(2017,2018):
        #for month in range(1,13):
        for month in range(7,8):
            mainUrlString = "https://e-service.cwb.gov.tw/HistoryDataQuery/MonthDataController.do?"
            commandString = "command=viewMain"
            stationNumberString = "station="+str(station[0])
            stationNameString = "stname="+quote(quote(station[1]))
            dateString = "datepicker="+str(year)+"-"+formater(month)
            url = mainUrlString + commandString +"&"+ stationNumberString +"&"+ stationNameString +"&"+ dateString + "#"
            
            html = urlopen(url)
            bsObj = BeautifulSoup(html,"html.parser")
            table = bsObj.find(id='MyTable')
            output_rows = []
            for table_row in table.findAll('tr'):
                types = ['th','td']
                for t in types:
                    output_row=[]
                    columns = table_row.findAll(t)
                    for column in columns:
                        output_row.append(column.text)
                    if output_row:
                        output_rows.append(output_row)
            fileDir = station[0]
            if not os.path.exists(fileDir):
                os.mkdir(fileDir)
            fileName = station[0]+"-"+str(year)+"-"+formater(month)+".csv"
            filePath = os.path.join(fileDir,fileName)
            with open(filePath, 'w', encoding="utf-8",newline='') as csvfile:
                writer = csv.writer(csvfile)
                for row in output_rows:
                    str_row=[]
                    for byte in row:
                        if isinstance(byte,str):
                            str_row.append(byte)
                        else:
                            str_row.append(byte.decode())
                    writer.writerow(str_row)
