
def VAR(isPass=False):
    if isPass:
        pass
    else:
        import pandas as pd
        import numpy as np
        import matplotlib.pyplot as plt
        import os
        import sys

        #Import Statsmodels
        from statsmodels.tsa.api import VAR
        from statsmodels.tsa.stattools import adfuller
        from statsmodels.tools.eval_measures import rmse, aic
        from statsmodels.tsa.stattools import grangercausalitytests

        #Load temperature data
        def temperature(temperatureType):
            filepath = os.path.join("0917","average.csv")
            df = pd.read_csv(filepath)

            average_tempature = pd.DataFrame(df["average"])
            average_tempature.columns=["week_average"]
            
            max_tempature = pd.DataFrame(df["max"])
            max_tempature.columns=["week_max"]
            
            min_tempature = pd.DataFrame(df["min"])
            min_tempature.columns=["week_min"]
            
            difference_tempature = pd.DataFrame(df[df.columns[2]]-df[df.columns[3]],columns=["week_difference"])

            rain = pd.DataFrame(df["rain"])
            rain.columns=["week_rain"]
            """
            filepath = os.path.join("流感及其所致肺炎健保就診人次.csv")
            illness = pd.read_csv(filepath)
            #print(illness)
            illness_number = pd.DataFrame(illness["流感及其所致肺炎健保就診人次"])
            illness_number.columns=["illness_number"]
            """
            filepath = os.path.join("健保就診總人次.csv")
            illness = pd.read_csv(filepath)
            #print(illness)
            illness_number = pd.DataFrame(illness["健保就診總人次"])
            illness_number.columns=["illness_number"]

            
            if temperatureType == "average":
                df_new = pd.concat([average_tempature,illness_number],axis=1)
            elif temperatureType == "max":
                df_new = pd.concat([max_tempature,illness_number],axis=1)
            elif temperatureType == "min":
                df_new = pd.concat([min_tempature,illness_number],axis=1)
            elif temperatureType == "difference":
                df_new = pd.concat([difference_tempature,illness_number],axis=1)
            elif temperatureType == "rain":
                df_new = pd.concat([rain,illness_number],axis=1)
            else:#default is average temperature
                df_new = pd.concat([average_tempature,illness_number],axis=1)
            
            return df_new

        def grangers_causation_matrix(data, variables, varitest='ssr_chi2test', verbose=False):
            maxlag = 12
            test = 'ssr_chi2test'
            df = pd.DataFrame(np.zeros((len(variables), len(variables))), columns=variables, index=variables)
            
            for c in df.columns:
                for r in df.index:
                    test_result = grangercausalitytests(data[[r, c]], maxlag=maxlag, verbose=False)
                    p_values = [round(test_result[i+1][0][test][1],4) for i in range(maxlag)]
                    if verbose: print(f'Y = {r}, X = {c}, P Values = {p_values}')
                    min_p_value = np.min(p_values)
                    df.loc[r, c] = min_p_value
                    
            df.columns = [var + '_x' for var in variables]
            df.index = [var + '_y' for var in variables]
            
            return df

        def adjust(val, length= 6):
            return str(val).ljust(length)

        def cointegration_test(df,f, alpha=0.05):
            from statsmodels.tsa.vector_ar.vecm import coint_johansen
            """Perform Johanson's Cointegration Test and Report Summary"""
            out = coint_johansen(df,-1,5)
            d = {'0.90':0, '0.95':1, '0.99':2}
            traces = out.lr1
            cvts = out.cvt[:, d[str(1-alpha)]]

            # Summary
            f.write('Name   ::  Test Stat > C(95%)    =>   Signif  \n' + '--'*20 + '\n')
            for col, trace, cvt in zip(df.columns, traces, cvts):
                f.write(str(adjust(col)) + ':: ' + str(adjust(round(trace,2), 9)) + ">" + str(adjust(cvt, 8)) + ' =>  ' + str(trace > cvt)+'\n')

        def adfuller_test(series, f, signif=0.05, name='', verbose=False):
            """Perform ADFuller to test for Stationarity of given series and print report"""
            r = adfuller(series, autolag='AIC')
            output = {'test_statistic':round(r[0], 4), 'pvalue':round(r[1], 4), 'n_lags':round(r[2], 4), 'n_obs':r[3]}
            p_value = output['pvalue'] 
            def adjust(val, length= 6): return str(val).ljust(length)

            # Print Summary
            f.write(f'    Augmented Dickey-Fuller Test on "{name}"' + "\n   " + '-'*47)
            f.write('\n')
            f.write(f' Null Hypothesis: Data has unit root. Non-Stationary.')
            f.write('\n')
            f.write(f' Significance Level    = {signif}')
            f.write('\n')
            f.write(f' Test Statistic        = {output["test_statistic"]}')
            f.write('\n')
            f.write(f' No. Lags Chosen       = {output["n_lags"]}')
            f.write('\n')

            for key,val in r[4].items():
                f.write(f' Critical value {adjust(key)} = {round(val, 3)}')
                f.write('\n')

            if p_value <= signif:
                f.write(f" => P-Value = {p_value}. Rejecting Null Hypothesis.")
                f.write('\n')
                f.write(f" => Series is Stationary.")
                f.write('\n')
            else:
                f.write(f" => P-Value = {p_value}. Weak evidence to reject the Null Hypothesis.")
                f.write('\n')
                f.write(f" => Series is Non-Stationary.")
                f.write('\n')
                
        def step6(df):
            #Step 6
            f.write('\n'+"STEP 6"+'\n')
            f.write("Granger’s Causality Test\n")
            f.write(grangers_causation_matrix(df, variables = df.columns).to_string()+'\n')
            f.write('--'*20+'\n')
        
        def step7(df):
            #Step 7
            f.write('\n'+"STEP 7"+'\n')
            f.write("Cointegration Test\n")
            cointegration_test(df,f)
            f.write('--'*20+'\n')
            
        def step8(df,nobs):
            #Step 8
            f.write('\n'+"STEP 8"+'\n')
            df_train, df_test = df[0:-nobs], df[-nobs:]
            return df_train, df_test

        def step9(df_train):
            #Step 9
            f.write('\n'+"STEP 9"+'\n')
            f.write("Augmented Dickey-Fuller Test\n")
            for name, column in df_train.iteritems():
                adfuller_test(column, f, name=column.name)
                f.write('\n')
            f.write('--'*20+'\n')

            #due to none diff
            df_differenced = df_train
            return df_differenced

        def step10(df_differenced):
            #Step 10
            f.write('\n'+"STEP 10"+'\n')
            model = VAR(df_differenced)
            AIC = sys.maxsize
            optimal_AIC = 0
            BIC = sys.maxsize
            optimal_BIC = 0
            FPE = sys.maxsize
            optimal_FPE = 0
            HQIC = sys.maxsize
            optimal_HQIC = 0
            
            for i in [1,2,3,4,5,6,7,8,9]:
                result = model.fit(i)
                if result.aic < AIC:
                    AIC = result.aic
                    optimal_AIC = i
                if result.bic < BIC:
                    BIC = result.bic
                    optimal_BIC = i
                if result.fpe < FPE:
                    FPE = result.fpe
                    optimal_FPE = i
                if result.hqic < HQIC:
                    HQIC = result.hqic
                    optimal_HQIC = i
                f.write('Lag Order =' + str(i) + '\n')
                f.write('AIC : ' + str(result.aic) + '\n')
                f.write('BIC : ' + str(result.bic) + '\n')
                f.write('FPE : ' + str(result.fpe) + '\n')
                f.write('HQIC: ' + str(result.hqic) + '\n')

            f.write('-'*20+'\n')
            optimal_str = "Optimal:"+"\n"
            optimal_str+= "AIC: " + str(AIC) + '\n' + "Lag Order: " + str(optimal_AIC) + '\n'
            optimal_str+= "BIC: " + str(BIC) + '\n' + "Lag Order: " + str(optimal_BIC) + '\n'
            optimal_str+= "FPE: " + str(FPE) + '\n' + "Lag Order: " + str(optimal_FPE) + '\n'
            optimal_str+= "HQIC: " + str(HQIC) + '\n' + "Lag Order: " + str(optimal_HQIC) + '\n'
            f.write(optimal_str)

            return optimal_AIC, model

        def step11(optimal_AIC, model):
            #Step 11
            f.write('\n'+"STEP 11"+'\n')
            model_fitted = model.fit(optimal_AIC)
            f.write(str(model_fitted.summary()))

            return model_fitted
            
        def step12(model_fitted,df):
            #Step 12
            f.write('\n'+"STEP 12"+'\n')
            from statsmodels.stats.stattools import durbin_watson
            out = durbin_watson(model_fitted.resid)

            for col, val in zip(df.columns, out):
                f.write(str(adjust(col)) + ':' + str(round(val, 2)) + '\n')

        def step13(model_fitted,df_differenced):
            #Step 13
            f.write('\n'+"STEP 13"+'\n')
            # Get the lag order
            lag_order = model_fitted.k_ar
            f.write(str(lag_order)+'\n')  #> 4

            # Input data for forecasting
            forecast_input = df_differenced.values[-lag_order:]
            f.write(str(forecast_input)+'\n')
            # Forecast
            fc = model_fitted.forecast(y=forecast_input, steps=nobs)
            df_forecast = pd.DataFrame(fc, index=df.index[-nobs:], columns=df.columns)
            f.write(str(df_forecast)+'\n')

            return df_forecast
            
        def step14(df_train,df_forecast,temperatureType):
            #Step 14
            f.write('\n'+"STEP 14"+'\n')
            def invert_transformation(df_train, df_forecast, diff=False):
                """Revert back the differencing to get the forecast to original scale."""
                df_fc = df_forecast.copy()
                columns = df_train.columns
                if diff:
                    for col in columns:        
                        # Roll back 2nd Diff
                        df_fc[str(col)+'_1d'] = (df_train[col].iloc[-1]-df_train[col].iloc[-2]) + df_fc[str(col)+'_2d'].cumsum()
                        # Roll back 1st Diff
                        df_fc[str(col)+'_forecast'] = df_train[col].iloc[-1] + df_fc[str(col)+'_1d'].cumsum()
                else:
                    for col in columns: 
                        df_fc[str(col)+'_forecast'] = df_fc[str(col)]
                return df_fc

            df_results = invert_transformation(df_train, df_forecast, diff=False)        
            df_results.loc[:, ['week_'+temperatureType+"_forecast", 'illness_number_forecast']]

            return df_results

        def step15(df,df_results,df_test,temperatureType):    
            #Step 15
            f.write('\n'+"STEP 15"+'\n')
            fig, axes = plt.subplots(nrows=int(len(df.columns)), ncols=1, dpi=150, figsize=(10,10))
            for i, (col,ax) in enumerate(zip(df.columns, axes.flatten())):
                df_results[col+'_forecast'].plot(legend=True, ax=ax).autoscale(axis='x',tight=True)
                df_test[col].plot(legend=True, ax=ax);
                ax.set_title(col + ": Forecast vs Actuals")
                ax.xaxis.set_ticks_position('none')
                ax.yaxis.set_ticks_position('none')
                ax.spines["top"].set_alpha(0)
                ax.tick_params(labelsize=6)

            plt.tight_layout()
            plt.savefig(os.path.join("data",temperatureType+" "+"step 15.png"))
            plt.clf()
            
        def step16(df_results,df_test,temperatureType):
            #Step 16
            f.write('\n'+"STEP 16"+'\n')
            from statsmodels.tsa.stattools import acf
            
            def forecast_accuracy(forecast, actual):
                #print(np.abs(actual))
                #print(np.abs(forecast - actual))
                #print(np.abs(forecast - actual)/np.abs(actual))
                mape = np.mean(np.abs(forecast - actual)/np.abs(actual))  # MAPE
                me = np.mean(forecast - actual)             # ME
                mae = np.mean(np.abs(forecast - actual))    # MAE
                mpe = np.mean((forecast - actual)/actual)   # MPE
                rmse = np.mean((forecast - actual)**2)**.5  # RMSE
                return({'mape':mape, 'me':me, 'mae': mae, 'mpe': mpe, 'rmse':rmse})

            if not temperatureType == "rain":
                f.write('Forecast Accuracy of: '+'week_'+temperatureType+'\n')
                #print(df_results['week_'+temperatureType+"_forecast"].values, df_test['week_'+temperatureType].values)
                try:
                    accuracy_prod = forecast_accuracy(df_results['week_'+temperatureType+"_forecast"].values, df_test['week_'+temperatureType].values)
                    for k, v in accuracy_prod.items():
                        f.write(str(adjust(k)) + ': ' + str(round(v,4))+'\n')
                except Exception as e:
                    print(e)
                
            f.write('Forecast Accuracy of: illness_number'+'\n')
            accuracy_prod = forecast_accuracy(df_results['illness_number_forecast'].values, df_test['illness_number'].values)
            for k, v in accuracy_prod.items():
                f.write(str(adjust(k)) + ': ' + str(round(v,4))+'\n')
                
        #VAR funcion context start
        #time stamp
        import datetime
        now = datetime.datetime.now()
        array = [str(now.month),str(now.day),str(now.hour),str(now.minute),str(now.second)]
        timeStamp = "-".join(array)

        temperatureType = ["average","max","min","difference","rain"]
        for tempType in temperatureType:
            #open result file
            array = [tempType,"result",timeStamp,".txt"]
            filename = " ".join(array)
            f = open(os.path.join("data",filename),'w')

            #load data
            data = temperature(tempType)

            #plot the figure of loaded data
            data.plot()
            plt.savefig(os.path.join("data",tempType+" "+"step 5.png"))

            f.write(data.to_string() + '\n')
            f.write('--'*20+'\n')

            columns = ['week_'+tempType,"illness_number"]
            data_forecast = pd.DataFrame(columns=columns)
            data_length = data["illness_number"].count()
            #start = data_length-52+1
            start = data_length-52+15
            end = data_length+1
            data_test = data[start-1:]
            nobs = 1
            for i in range(start,end):
                df = data[0:i]
                
                step6(df)
                step7(df)
                df_train, df_test = step8(df,nobs)
                df_differenced = step9(df_train)
                optimal_AIC, model= step10(df_differenced)
                model_fitted = step11(optimal_AIC,model)
                step12(model_fitted,df)
                df_forecast = step13(model_fitted,df_differenced) 
                data_forecast = data_forecast.append(df_forecast)
                df_results = step14(df_train,df_forecast,tempType)
            columns = ['week_'+tempType+"_forecast","illness_number_forecast"]
            data_forecast.columns = columns

            data_forecast.plot()
            plt.savefig(os.path.join("data",tempType+" "+"data_forecast.png"))

            data_test.plot()
            plt.savefig(os.path.join("data",tempType+" "+"data_test.png"))

            step15(data,data_forecast,data_test,tempType)
            #print(data_forecast,data_test)
            step16(data_forecast,data_test,tempType)
            #close redult file
            f.close()
