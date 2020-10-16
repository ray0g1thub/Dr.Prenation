import pandas as pd
import os
import matplotlib.pyplot as plt

if __name__ == "__main__":
    fileDir = os.path.join("data","Influenza")
    fileName = "NHI_Influenza.csv"
    filePath = os.path.join(fileDir, fileName)

    with open(filePath, 'r') as inCSV:
        df = pd.read_csv(inCSV, encoding="utf-8",header=0)

        def filterByCondition(df,column,condition):
            filter = df[column].isin(condition)
            return df[filter]

        def filterAndReindex(df,column,condition):
            filter = df[column].isin(condition)
            df = df[filter]
            value = [i for i in range(0, df["週"].count())]
            index = df.index
            dictionary  = dict(zip(index,value))
            return df.rename(index=dictionary)

        df = filterByCondition(df,"就診類別",["門診"])
        df = filterByCondition(df,"縣市",["桃園市"])
        df = filterByCondition(df,"年",["2017","2018","2019"])

        df_new = pd.DataFrame()
        conditions = [["0-4"],["5-14"],["15-24"],["25-64"],["65+"]]
        for condition in conditions:
            if df_new.empty:
                #df_new = filterAndReindex(df,"年齡別",condition)["流感及其所致肺炎健保就診人次"]
                df_new = filterAndReindex(df,"年齡別",condition)["健保就診總人次"]
            else:
                #df_new = df_new.add(filterAndReindex(df,"年齡別",condition)["流感及其所致肺炎健保就診人次"])
                df_new = df_new.add(filterAndReindex(df,"年齡別",condition)["健保就診總人次"])

        df_other = pd.DataFrame()
        df_temp = filterAndReindex(df,"年齡別",["0-4"])
        columns = ["年","週","就診類別","縣市"]
        for col in columns:
            if df_other.empty:
                df_other = df_temp[col]
            else:
                df_other = pd.concat([df_other,df_temp[col]],axis=1)
        df_new.plot()
        plt.savefig("健保就診總人次.jpg")
        df_new = pd.concat([df_other,df_new],axis=1)
        df_new.to_csv("健保就診總人次.csv",index=False,encoding="utf-8")

