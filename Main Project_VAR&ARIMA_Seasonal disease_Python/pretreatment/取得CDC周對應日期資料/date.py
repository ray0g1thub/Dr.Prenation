
def date_generate(yearFrom,weekFrom,yearEnd,weekEnd,outputPath):
    from datetime import datetime
    import csv
    import os

    file_path = os.path.join("data","CDC_yearweek.csv")

    try:
        with open(outputPath,'w',newline='') as out_file:
            writer = csv.writer(out_file)
            with open(file_path,'r',newline='') as in_file:
                rows = csv.reader(in_file)
                recoded = False
                for row in rows:
                    year = row[0]
                    week = row[1]
                    if not year.isnumeric() or not week.isnumeric():
                        pass
                    elif int(year) == int(yearFrom) and int(week) == int(weekFrom):
                        recoded = True
                        writer.writerow(row[0:3])
                    elif int(year) == int(yearEnd) and int(week) == int(weekEnd):
                        recoded = False
                        writer.writerow(row[0:3])
                    elif recoded:
                        writer.writerow(row[0:3])
                    else:
                        pass
    except Exception as e:
        print(e)
    else:
        print("Successful done!")

    """
    try:
        with open("out.csv", 'a', newline='') as out:
            writer = csv.writer(out)
            # to complete the week number of 2018
            row = ["2018", "1", "2017/12/31", "2018_01"] # first day
            writer.writerow(row)
            day_counter = 1
            week_counter = 1
            days = 365 # 2018 days number
            monthly_days = [0,31,28,31,30,31,30,31,31,30,31,30,31]
            accumulate_day = [0]
            for i in range(1,len(monthly_days)):
                accumulate_day.append(accumulate_day[i-1] + monthly_days[i])
                #print(accumulate_day[i])
            accumulate_counter = 1 # because aleardy writen the first day
            for i in range(1,1+days):
                day_counter += 1
                row = ["2018"]
                if day_counter > 7:
                    day_counter = 1
                    week_counter += 1
                row.append(str(week_counter))
                if i > accumulate_day[accumulate_counter]:
                    accumulate_counter += 1
                row.append("2018/"+str(accumulate_counter)+"/"+str(i-accumulate_day[accumulate_counter-1]))
                if week_counter < 10:
                    row.append("2018_"+"0"+str(week_counter))
                else:
                    row.append("2018_"+str(week_counter))
                writer.writerow(row)
            
    except Exception as e:
        print(e)
    else:
        print("Successful done!")
    """
    # the problem of week 53 in 2018 is still not deal yet
