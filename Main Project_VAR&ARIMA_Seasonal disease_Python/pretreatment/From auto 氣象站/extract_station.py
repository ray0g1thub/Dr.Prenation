def station(station_id):

    import csv
    import os
    import re

    def format_translate(integer):
        if integer < 10:
            return "0" + str(integer)
        else:
            return str(integer)

    days_in_month = [0,31,28,31,30,31,30,31,31,30,31,30,31]#11,12

    out_dir = os.path.join("data","metro_unzip",station_id)
    if not os.path.exists(out_dir):
        os.makedirs(out_dir)
    """----------------------------------------------------------------------------------------------------------"""
    year = "2017"
    inDir = os.path.join("data","stations")
    inTxt = str(station_id)+".txt"
    inPath = os.path.join(inDir,inTxt)
    outDir = os.path.join("data","metro_unzip",station_id)
    outCsv = station_id+"-"+year+"01-12"+"-"+"average-temperature.csv"
    outPath = os.path.join(outDir,outCsv)
    with open(inPath,'r') as inFile, open(outPath,'w',newline='') as outFile:
        writer = csv.writer(outFile, delimiter=',')
        header = ["date","average","max","min"]
        writer.writerow(header)
        lines = inFile.readlines()
        month = 1
        day = 1
        counter = 0
        accumlate_temperature = 0
        maxTemperatureInDay = -99
        minTemperatureInDay = 99
        for line in lines:
            currentLine = line.split()
            if not currentLine:
                continue
            else:
                #print(currentLine)
                pass
            todayPattern = year + format_translate(month) + format_translate(day) + r"(\d\d)"
            todayPattern = re.compile(todayPattern)
            tomorrowPattern = year + format_translate(month) + format_translate(day+1) + r"(\d\d)"
            tomorrowPattern = re.compile(tomorrowPattern)
            NextMonthPattern = year + format_translate(month+1) + format_translate(1) + r"(\d\d)"
            NextMonthPattern = re.compile(NextMonthPattern)
            if re.fullmatch(NextMonthPattern, currentLine[1]):
                #if currentLine[1][0:4] == "2017":
                #    print(re.fullmatch(NextMonthPattern, currentLine[1]),currentLine[1])
                if counter > 0:
                    date = year + "/" + format_translate(month) + "/" + format_translate(day)
                    average_temperature = accumlate_temperature/counter
                    new_row = [date,average_temperature,maxTemperatureInDay,minTemperatureInDay]
                    print(new_row)
                    writer.writerow(new_row)

                    maxTemperatureInDay = -99
                    minTemperatureInDay = 99
                    accumlate_temperature = 0
                    counter = 0
                #record today
                if float(currentLine[3]) > 0:
                    if maxTemperatureInDay < float(currentLine[3]):
                        maxTemperatureInDay = float(currentLine[3])
                    if minTemperatureInDay > float(currentLine[3]):
                        minTemperatureInDay = float(currentLine[3])
                    accumlate_temperature+=float(currentLine[3])
                    counter+=1
                month+=1
                day = 1
            elif re.fullmatch(tomorrowPattern, currentLine[1]):
                #if currentLine[1][0:4] == "2017":
                #   print(re.fullmatch(tomorrowPattern, currentLine[1]),currentLine[1])
                #Settlement the last day
                if counter > 0:
                    date = year + "/" + format_translate(month) + "/" + format_translate(day)
                    average_temperature = accumlate_temperature/counter
                    new_row = [date,average_temperature,maxTemperatureInDay,minTemperatureInDay]
                    print(new_row)
                    writer.writerow(new_row)

                    maxTemperatureInDay = -99
                    minTemperatureInDay = 99
                    accumlate_temperature = 0
                    counter = 0
                #record today
                if float(currentLine[3]) > 0:
                    if maxTemperatureInDay < float(currentLine[3]):
                        maxTemperatureInDay = float(currentLine[3])
                    if minTemperatureInDay > float(currentLine[3]):
                        minTemperatureInDay = float(currentLine[3])
                    accumlate_temperature+=float(currentLine[3])
                    counter+=1
                day+=1
            elif re.fullmatch(todayPattern, currentLine[1]):
                #if currentLine[1][0:4] == "2017":
                #    print(re.fullmatch(todayPattern, currentLine[1]),currentLine[1])
                if float(currentLine[3]) > 0:
                    if maxTemperatureInDay < float(currentLine[3]):
                        maxTemperatureInDay = float(currentLine[3])
                    if minTemperatureInDay > float(currentLine[3]):
                        minTemperatureInDay = float(currentLine[3])
                    accumlate_temperature+=float(currentLine[3])
                    counter+=1

    print(year+" "+"is finished.")
    """----------------------------------------------------------------------------------------------------------"""
    year = "2018" # month 01-10
    for month in range(1,10+1):
        try:
            in_csv_dir = os.path.join("data","metro_unzip","Metro_2018")
            in_csv_name = year + format_translate(month) + ".csv"
            in_csv_path = os.path.join(in_csv_dir,in_csv_name)
            with open( in_csv_path, 'r', newline='', encoding='big5') as in_csv:
                rows = csv.reader(in_csv)
                out_csv_name = year+format_translate(month)+"-"+station_id[0:-1]+".csv"
                out_csv_path = os.path.join(in_csv_dir,out_csv_name)
                with open(out_csv_path, 'w', newline='') as out_csv:
                    writer = csv.writer(out_csv, delimiter=',')
                    for row in rows:
                        if str(row[1]) == station_id[0:-1]:
                            row[0] = None
                            new_row = [row[1],row[2],row[7]]
                            writer.writerow(new_row)
        except Exception as e:
            print(e)
        else:
            #print(in_csv_name + " " +"Successfully done.")
            pass

        try:
            in_csv_dir = os.path.join("data","metro_unzip","Metro_2018")
            in_csv_name = year+format_translate(month)+"-"+station_id[0:-1]+".csv"
            in_csv_path = os.path.join(in_csv_dir,in_csv_name)
            with open(in_csv_path, 'r', newline='') as in_csv:
                rows = csv.reader(in_csv)
                out_csv_name = year+format_translate(month)+"-"+station_id[0:-1]+"-daily_average_temperature.csv"
                out_csv_path = os.path.join(in_csv_dir,out_csv_name)
                with open(out_csv_path, 'w', newline='') as out_csv:
                    writer = csv.writer(out_csv, delimiter=',')
                    day = 1
                    counter = 0
                    accumlate_temperature = 0
                    maxTemperatureInDay = -99
                    minTemperatureInDay = 99
                    for row in rows:
                        date = year + "/" +  format_translate(month) + "/" + format_translate(day)
                        pattern = date + " " + r"(\d\d:\d\d)"
                        pattern = re.compile(pattern)
                        if re.fullmatch(pattern, row[1]):
                            if row[2]!='':
                                if maxTemperatureInDay < float(row[2]):
                                    maxTemperatureInDay = float(row[2])
                                if minTemperatureInDay > float(row[2]) and float(row[2]) > 0:
                                    minTemperatureInDay = float(row[2])
                                accumlate_temperature+=float(row[2])
                                counter+=1
                        else:
                            average_temperature = accumlate_temperature/counter
                            new_row = [date,average_temperature,maxTemperatureInDay,minTemperatureInDay]
                            writer.writerow(new_row)
                            
                            maxTemperatureInDay = -99
                            minTemperatureInDay = 99
                            accumlate_temperature = 0
                            counter = 0
                            
                            day+=1
                            date = year + "/" +  format_translate(month) + "/" + format_translate(day)
                            pattern = date + " " + r"(\d\d:\d\d)"
                            pattern = re.compile(pattern)
                            if re.fullmatch(pattern, row[1]):
                                if row[2]!='':
                                    if maxTemperatureInDay < float(row[2]):
                                        maxTemperatureInDay = float(row[2])
                                    if minTemperatureInDay > float(row[2]) and float(row[2]) > 0:
                                        minTemperatureInDay = float(row[2])
                                    accumlate_temperature+=float(row[2])
                                    counter+=1
        except Exception as e:
            print(e)
        else:
            #print(in_csv_name + " " + "Successfully done.")
            pass
    #merge csv
    try:
        out_csv_dir = os.path.join("data","metro_unzip",station_id)
        out_csv_name = station_id+"-"+year+"01-10-average-temperature.csv"
        out_csv_path = os.path.join(out_csv_dir,out_csv_name)
        with open(out_csv_path, 'w', newline='') as out_csv:
            writer = csv.writer(out_csv)
            for month in range(1,10+1):
                in_csv_dir = os.path.join("data","metro_unzip","Metro_2018")
                in_csv_name = year+format_translate(month)+"-"+station_id[0:-1]+"-daily_average_temperature.csv"
                in_csv_path = os.path.join(in_csv_dir,in_csv_name)
                with open(in_csv_path, 'r', newline='') as in_csv:
                    rows = csv.reader(in_csv)
                    for row in rows:
                        writer.writerow(row)
    except Exception as e:
        print(e)
    else:
        print(year+"(01-10)"+" "+"is finished.")
    """----------------------------------------------------------------------------------------------------------"""
    year = "2018"#month 11-12
    for month in range(11,12+1):
        for day in range(1,days_in_month[month]+1):
            try:
                dir_name = year + format_translate(month)
                in_csv_dir = os.path.join("data","metro_unzip",dir_name)
                in_csv_name = "metro_" + year + format_translate(month) + format_translate(day)+".csv"
                in_csv_path = os.path.join(in_csv_dir,in_csv_name)
                with open(in_csv_path, 'r', newline='') as in_csv:
                    out_csv_name = station_id+"-"+year + format_translate(month) + format_translate(day)+".csv"
                    out_csv_path = os.path.join(out_dir,out_csv_name)
                    with open(out_csv_path, 'w', newline='') as out_csv:
                        writer = csv.writer(out_csv)
                        rows = csv.reader(in_csv)
                        header = next(rows)
                        writer.writerow(header)
                        for row in rows:
                            if str(row[0]) == station_id:
                                writer.writerow(row)
            except Exception as e:
                print(e)
            else:
                print(in_csv_name+" : "+"Successfully done.")
        try:
            out_csv_name = station_id + "-" + year + format_translate(month)+"-"+"daily_average_temperature"+".csv"
            out_csv_path = os.path.join(out_dir,out_csv_name)
            with open(out_csv_path,'w',newline='') as out_csv:
                writer = csv.writer(out_csv)
                #writer.writerow(["date","tempature"])
                for day in range(1,days_in_month[month]+1):
                    in_csv_name = station_id+"-"+year + format_translate(month) + format_translate(day)+".csv"
                    in_csv_path = os.path.join(out_dir,in_csv_name)
                    try:
                        with open(in_csv_path, 'r', newline='') as in_csv:
                            rows = csv.reader(in_csv)
                            date = year + "/" +  format_translate(month) + "/" + format_translate(day)
                            counter = 0
                            accumlate_temperature = 0
                            maxTemperatureInDay = -99
                            minTemperatureInDay = 99
                            for row in rows:
                                try:
                                    if float(row[5]) != -99:
                                        if maxTemperatureInDay < float(row[5]):
                                            maxTemperatureInDay = float(row[5])
                                        if minTemperatureInDay > float(row[5]):
                                            minTemperatureInDay = float(row[5])
                                        accumlate_temperature += float(row[5])
                                        counter+=1
                                except Exception as e:
                                    print(e)
                            if counter != 0:
                                daily_average_temperature =   accumlate_temperature / counter
                                new_row = [date,daily_average_temperature,maxTemperatureInDay,minTemperatureInDay]
                                writer.writerow(new_row)
                    except Exception as e:
                        print(e)
        except Exception as e:
            print(e)
        else:
            print(year+"("+str(month)+")"+" "+"is finished.")
    """----------------------------------------------------------------------------------------------------------"""
    year = "2019" #month 01-12
    for month in range(1,12+1):
        for day in range(1,days_in_month[month]+1):
            try:
                dir_name = year + format_translate(month)
                in_csv_dir = os.path.join("data","metro_unzip",dir_name)
                in_csv_name = "metro_" + year + format_translate(month) + format_translate(day)+".csv"
                in_csv_path = os.path.join(in_csv_dir,in_csv_name)
                with open(in_csv_path, 'r', newline='') as in_csv:
                    out_csv_name = station_id+"-"+year + format_translate(month) + format_translate(day)+".csv"
                    out_csv_path = os.path.join(out_dir,out_csv_name)
                    with open(out_csv_path, 'w', newline='') as out_csv:
                        writer = csv.writer(out_csv)
                        rows = csv.reader(in_csv)
                        header = next(rows)
                        writer.writerow(header)
                        for row in rows:
                            if str(row[0]) == station_id:
                                writer.writerow(row)
            except Exception as e:
                print(e)
            else:
                print(in_csv_name+" : "+"Successfully done.")
        try:
            out_csv_name = station_id + "-" + year + format_translate(month)+"-"+"daily_average_temperature"+".csv"
            out_csv_path = os.path.join(out_dir,out_csv_name)
            with open(out_csv_path,'w',newline='') as out_csv:
                writer = csv.writer(out_csv)
                #writer.writerow(["date","tempature"])
                for day in range(1,days_in_month[month]+1):
                    in_csv_name = station_id+"-"+year + format_translate(month) + format_translate(day)+".csv"
                    in_csv_path = os.path.join(out_dir,in_csv_name)
                    try:
                        with open(in_csv_path, 'r', newline='') as in_csv:
                            rows = csv.reader(in_csv)
                            date = year + "/" +  format_translate(month) + "/" + format_translate(day)
                            counter = 0
                            accumlate_temperature = 0
                            maxTemperatureInDay = -99
                            minTemperatureInDay = 99
                            for row in rows:
                                try:
                                    if float(row[5]) != -99:
                                        if maxTemperatureInDay < float(row[5]):
                                            maxTemperatureInDay = float(row[5])
                                        if minTemperatureInDay > float(row[5]):
                                            minTemperatureInDay = float(row[5])
                                        accumlate_temperature += float(row[5])
                                        counter+=1
                                except Exception as e:
                                    print(e)
                            if counter != 0:
                                daily_average_temperature =   accumlate_temperature / counter
                                new_row = [date,daily_average_temperature,maxTemperatureInDay,minTemperatureInDay]
                                writer.writerow(new_row)
                    except Exception as e:
                        print(e)
        except Exception as e:
            print(e)
        else:
            print(year+"("+str(month)+")"+" "+"is finished.")
    """----------------------------------------------------------------------------------------------------------"""
    #merge all daily tempature csv from 201701-201912
    try:
        out_csv_dir = os.path.join("data")
        out_csv_name = station_id+"-"+"2017-2019"+"-"+"average-temperature.csv"
        out_csv_path = os.path.join(out_csv_dir,out_csv_name)
        with open(out_csv_path, 'w', newline='') as out_csv:
            writer = csv.writer(out_csv)
            in_csv_dir = os.path.join("data","metro_unzip",station_id)
            #201701-201712
            year = "2017"
            in_csv_name = station_id+"-"+year+"01-12"+"-"+"average-temperature.csv"
            in_csv_path = os.path.join(in_csv_dir,in_csv_name)
            with open(in_csv_path, 'r', newline='') as in_csv:
                    rows = csv.reader(in_csv)
                    for row in rows:
                        writer.writerow(row)
            #201801-201810
            year = "2018"
            in_csv_name = station_id+"-"+year+"01-10"+"-"+"average-temperature.csv"
            in_csv_path = os.path.join(in_csv_dir,in_csv_name)
            with open(in_csv_path, 'r', newline='') as in_csv:
                    rows = csv.reader(in_csv)
                    for row in rows:
                        writer.writerow(row)
            #201811-201812
            year = "2018"
            for month in range(11,12+1):
                in_csv_name = station_id+"-"+year+format_translate(month)+"-"+"daily_average_temperature.csv"
                in_csv_path = os.path.join(in_csv_dir,in_csv_name)
                with open(in_csv_path, 'r', newline='') as in_csv:
                    rows = csv.reader(in_csv)
                    for row in rows:
                        writer.writerow(row)
            #201901-201912
            year = "2019"
            for month in range(1,12+1):
                in_csv_name = station_id+"-"+year+format_translate(month)+"-"+"daily_average_temperature.csv"
                in_csv_path = os.path.join(in_csv_dir,in_csv_name)
                with open(in_csv_path, 'r', newline='') as in_csv:
                    rows = csv.reader(in_csv)
                    for row in rows:
                        writer.writerow(row)            
    except Exception as e:
        print(e)
    else:
        print(out_csv_name + " " +"Successfully done.")
    
