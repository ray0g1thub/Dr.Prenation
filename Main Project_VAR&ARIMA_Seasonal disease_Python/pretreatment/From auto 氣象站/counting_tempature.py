

def counting_tempature(tempaturePath,datePath,outputPath):
    import csv
    import re

    def format_translate(integer):
        if integer < 10:
            return "0" + str(integer)
        else:
            return str(integer)
        
    def adjust(date):
        match = re.search(r'(\d+)/(\d+)/(\d+)',date)
        return str(int(match.group(1)))+"/"+str(int(match.group(2)))+"/"+str(int(match.group(3)))

    try:
        with open(tempaturePath, 'r', newline='') as in_csv_1, open(datePath, 'r', newline='') as in_csv_2:
            temperature_data = csv.reader(in_csv_1)
            date_data = csv.reader(in_csv_2)
            with open(outputPath, 'w', newline='') as out_csv:
                writer = csv.writer(out_csv)
                #initial
                writer.writerow(["week","average","max","min"])
                week = 1
                week_max_temp = -99
                week_min_temp = 99
                week_accumlate_temp = 0
                week_day_counter = 1
                #skip first row
                row_temperature_data = next(temperature_data)
                row_temperature_data = next(temperature_data)
                
                for row in date_data:
                    row_temperature = str(row_temperature_data[0]).split("/")
                    row_temperature = row_temperature[0]+"/"+str(int(row_temperature[1]))+"/"+str(int(row_temperature[2]))
                    if str(row[2]) == str(row_temperature):
                        print(str(row[2]), str(row_temperature))
                        if int(row[1]) != week:
                            #recode this week
                            week_average_temp = week_accumlate_temp/week_day_counter
                            new_row = [week,week_average_temp,week_max_temp,week_min_temp]
                            writer.writerow(new_row)
                            #initial next week
                            week_accumlate_temp = 0
                            week_day_counter = 0
                            week_max_temp = -99
                            week_min_temp =  99
                            
                            if week != 52:
                                week+=1
                            else:
                                week = 1
                        else:
                            pass
                        week_max_temp = max(float(row_temperature_data[2]),week_max_temp)
                        week_min_temp = min(float(row_temperature_data[3]),week_min_temp)
                        week_accumlate_temp += float(row_temperature_data[1])
                        row_temperature_data = next(temperature_data)
                        week_day_counter+=1
                    else:
                        continue
                #for last week
                week_average_temp = week_accumlate_temp/week_day_counter
                new_row = [week,week_average_temp,week_max_temp,week_min_temp]
                writer.writerow(new_row)
    except Exception as e:
        print(e)
    else:
        print("Successfully done.")
