"""
    file name format: metro_<year><month><day>.zip
    
    "metro" means 局屬氣象站
    "auto" means 自動氣象站

"""

def unzip():

    import zipfile
    import shutil
    import os
    
    path_zip_from = os.path.join("data","metro_zip")
    path_unzip_to = os.path.join("data","metro_unzip")
    isExist = os.path.exists(path_unzip_to)
    if not isExist:
        os.makedirs(path_unzip_to)

    """
    unzip 2019 history data
    """
    zip_2019 = "2019.zip"
    in_path = os.path.join(path_zip_from, zip_2019)
    with zipfile.ZipFile(in_path, 'r') as zip_file:
        zip_file.extractall(path_unzip_to)
    for i in range(1,13):
        if i < 10:
            month = "0" + str(i)
        else:
            month = str(i)
        if i < 7:
            file_name = "metro_2019" + month
        else:        
            file_name = "2019" + month
        in_path = os.path.join(path_unzip_to, "2019", file_name + ".zip")
        with zipfile.ZipFile(in_path, 'r') as zip_file:
            zip_file.extractall(path_unzip_to)

    # delete the directory "2019"
    # Careful!!
    path = os.path.join("metro_unzip", "2019")
    try:
        shutil.rmtree(path)
    except OSError as e:
        print(e)
    else:
        print("The directory is delete successfully!")

    """
    unzip 2018/01-2018/11 history data
    """
    zip_2018 = "Metro_2018.zip"
    in_path = path_zip_from + "\\" + zip_2018
    with zipfile.ZipFile(in_path, 'r') as zip_file:
        zip_file.extractall(path_unzip_to)

    """
    unzip 2018/11 history data
    """
    zip_201811 = "metro_201811.zip"
    in_path = path_zip_from + "\\" + zip_201811
    with zipfile.ZipFile(in_path, 'r') as zip_file:
        zip_file.extractall(path_unzip_to)

    """
    unzip 2018/12 history data
    """
    zip_201812 = "metro_201812.zip"
    in_path = path_zip_from + "\\" + zip_201812
    with zipfile.ZipFile(in_path, 'r') as zip_file:
        zip_file.extractall(path_unzip_to)


    """
    unzip 2018/11-2019/12 days data
    """
    import os
    days_of_month = [0,31,28,31,30,31,30,31,31,30,31,30,31]

    year = "2018"
    for i in range(11,13):
        directory_name = year + str(i)
        for j in range(1,days_of_month[i]+1):
            try:
                if j < 10:
                    month = "0" + str(j)
                else:
                    month = str(j)
                zip_file_name = "metro_" + directory_name + month + ".zip"
                zip_path = path_unzip_to + "\\" + directory_name + "\\" + zip_file_name
                unzip_to = path_unzip_to + "\\" + directory_name
                with zipfile.ZipFile(zip_path, 'r') as zip_file:
                    zip_file.extractall(unzip_to)
                #Carefully!!
                os.remove(zip_path)    
            except Exception as e:
                print(e)
            else:
                print("Successfully unzip: " + zip_file_name)

    year = "2019"
    for i in range(1,13):
        if i < 10:
            directory_name = year + "0" + str(i)
        else:
            directory_name = year + str(i)
        for j in range(1,days_of_month[i]+1):
            try:
                if j < 10:
                    month = "0" + str(j)
                else:
                    month = str(j)
                zip_file_name = "metro_" + directory_name + month + ".zip"
                zip_path = path_unzip_to + "\\" + directory_name + "\\" + zip_file_name
                unzip_to = path_unzip_to + "\\" + directory_name
                with zipfile.ZipFile(zip_path, 'r') as zip_file:
                    zip_file.extractall(unzip_to)
                #Carefully!!
                os.remove(zip_path)    
            except Exception as e:
                print(e)
            else:
                print("Successfully unzip: " + zip_file_name)
