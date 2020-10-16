import os
import pandas as pd

stations = ["C0C480","C0C490","C0C650","C0C660"]

average = pd.DataFrame(columns=["year","week","average","max","min","rain"])

def load(station):
    filePath = station+".csv"
    df = pd.read_csv(filePath,skiprows=[0])
    return df

for station in stations:
    if average.empty:
        average = average.append(load(station))
    else:
        df = load(station)
        average["average"] = average["average"].add(df["average"])
        average["max"] = average["max"].add(df["max"])
        average["min"] = average["min"].add(df["min"])
        average["rain"] = average["rain"].add(df["rain"])

average["average"] = round(average["average"]/4,1)
average["max"] = round(average["max"]/4,1)
average["min"] = round(average["min"]/4,1)
average["rain"] = round(average["rain"]/4,1)
average.to_csv("average.csv",index=False)
        
    
