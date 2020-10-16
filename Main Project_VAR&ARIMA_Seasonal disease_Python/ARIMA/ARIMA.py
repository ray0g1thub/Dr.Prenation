def score(data_forecasts,data,start,end):
    from statsmodels.tsa.stattools import acf
    import numpy as np

    print(data_forecasts)

    def adjust(val, length= 6):
        return str(val).ljust(length)
    
    def forecast_accuracy(forecast, actual):
        mape = np.mean(np.abs(forecast - actual)/np.abs(actual))  # MAPE
        me = np.mean(forecast - actual)             # ME
        mae = np.mean(np.abs(forecast - actual))    # MAE
        mpe = np.mean((forecast - actual)/actual)   # MPE
        rmse = np.mean((forecast - actual)**2)**.5  # RMSE
        return({'mape':mape, 'me':me, 'mae': mae, 'mpe': mpe, 'rmse':rmse})

    accuracy_prod = forecast_accuracy(data_forecasts, data[start-1:end-1])
    for k, v in accuracy_prod.items():
        print(str(adjust(k)) + ': ' + str(round(v,4))+'\n')


def ARIMA(isPass=False):
    if isPass:
        pass
    else:
        from statsmodels.tsa.arima_model import ARIMA
        import pmdarima as pm
        import os
        import pandas as pd
        from pmdarima.model_selection import train_test_split
        import numpy as np
        import matplotlib.pyplot as plt
        """
        filePath = os.path.join("流感及其所致肺炎健保就診人次.csv")
        data = pd.read_csv(filePath, header=0)
        data = data["流感及其所致肺炎健保就診人次"]
        """
        filePath = os.path.join("健保就診總人次.csv")
        data = pd.read_csv(filePath, header=0)
        data = data["健保就診總人次"]
        
        #start = data.size -52 +1
        start = data.size -52 +15
        end = data.size+1
        forecasts = []
        for i in range(start,end):
            df = data[0:i]
            train, test = train_test_split(df, test_size=1)
            #print(train,test)
            model = pm.auto_arima(train, m=12, error_action='ignore')
            """
            model = pm.auto_arima(train, start_p=1, start_q=1,
                                  test='adf',       # use adftest to find optimal 'd'
                                  max_p=3, max_q=3, # maximum p and q
                                  m=1,              # frequency of series
                                  d=None,           # let model determine 'd'
                                  seasonal=False,   # No Seasonality
                                  start_P=0, 
                                  D=0, 
                                  trace=True,
                                  error_action='ignore',  
                                  suppress_warnings=True, 
                                  stepwise=True)
            """
            forecast = model.predict(test.shape[0])
            print(round(forecast[0],0))
            forecasts.append(round(forecast[0],0))

        # Visualize the forecasts (blue=train, green=forecasts)
        x = np.arange(data.shape[0])
        #print(x)
        plt.plot(x[start-1:end-1], data[start-1:end-1], c='blue')
        #print(data[start-1:end-1].size)
        plt.plot(x[start-1:end-1], forecasts, c='green')
        plt.savefig("健保就診總人次"+"-ARIMA"+"-2"+".png")
        score(forecasts,data,start,end)


