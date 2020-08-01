# Carry trade portfolio UIP analysis portfolio sorting
# Author: Kyle Lackinger
# Last Update: 30 July 2020
# Dependencies: FullDatav2.csv data file

import pandas as pd
import numpy as np
from operator import itemgetter



# Read in data 
df = pd.read_csv('FullDatav2.csv', na_values='NA')

countries = ['GBP', 'SEK', 'ZAR', 'NZD', 'CAD', 'FRF', 'BEF', 
             'HKD', 'ESP', 'HUF', 'MXN', 'KES',
             'JPY', 'ISL', 'LKR', 'AUD', 'DEU', 'DKK', 'ITL',
             'CHF', 'COP', 'NOK', 'KRW', 'NLG', 'RUB']

# Drop unneccesary rows
modDF = df.drop(df.index[231:313])

# Add columns to construct country lists to track sorts
j = 1
k = 2
for i in countries:
    modDF[i] = modDF.iloc[:,j:k+1].values.tolist()
    j += 2
    k += 2

# Drop original columsn of df
catDF = modDF.drop(modDF.columns[1:51], axis = 1)
catDF.to_csv('test2.csv')

dfList = catDF.values.tolist()

# Append country name for tracking and sort each month
k = 1
for p in range(len(dfList)):
    for q in range(len(countries)):
        dfList[p][q+1].append(countries[q])
    dfList[p] = sorted(dfList[p][1:], key = itemgetter(0))

# Package back into a dataframe for ease of use in Python
sortDF = pd.DataFrame(list(zip(*dfList[:]))).add_prefix('col')

colList = sortDF.columns.tolist()
dateList = modDF['Date'].tolist()

# Make column names meaningful for readability
ind = 0
for colName in colList:
    newDF = pd.DataFrame(sortDF[colName].to_list(), columns = ['i.diff.'+dateList[ind], 'lambda.'+dateList[ind], 'country.'+dateList[ind]])
    sortDF = pd.concat([sortDF, newDF], axis = 1)
    ind += 1

# Full data set with interest rate differentials and excess returns sorted every month    
finalDF = sortDF.drop(sortDF.columns[0:206], axis = 1)

sortDF.to_csv('file.csv', index = False)
finalDF.to_csv('sorted.csv', index = False)

# Portfolio dataframes pre and post 2008M6
port1DF = finalDF.drop(finalDF.index[5:])
port1PreZ = port1DF.drop(port1DF.columns[303:], axis = 1)
port1PostZ = port1DF.drop(port1DF.columns[:303], axis = 1)

port2DF = finalDF.drop(finalDF.index[0:5])
port2DF = port2DF.drop(port2DF.index[5:26])
port2PreZ = port2DF.drop(port2DF.columns[303:], axis = 1)
port2PostZ = port2DF.drop(port2DF.columns[:303], axis = 1)

port3DF = finalDF.drop(finalDF.index[0:10])
port3DF = port3DF.drop(port3DF.index[5:26])
port3PreZ = port3DF.drop(port3DF.columns[303:], axis = 1)
port3PostZ = port3DF.drop(port3DF.columns[:303], axis = 1)

port4DF = finalDF.drop(finalDF.index[0:15])
port4DF = port4DF.drop(port4DF.index[5:26])
port4PreZ = port4DF.drop(port4DF.columns[303:], axis = 1)
port4PostZ = port4DF.drop(port4DF.columns[:303], axis = 1)

port5DF = finalDF.drop(finalDF.index[0:20])
port5PreZ = port5DF.drop(port5DF.columns[303:], axis = 1)
port5PostZ = port5DF.drop(port5DF.columns[:303], axis = 1)

preZColList = port1PreZ.columns.tolist()
postZColList = port1PostZ.columns.tolist()
iDiffListPre = []
lambdaListPre = []
iDiffListPost = []
lambdaListPost = []

# Generate column names to average over pre and post ZLB
sub = 'i.diff'
for text in preZColList:
    if sub in text:
        iDiffListPre.append(text)
        
for text in postZColList:
    if sub in text:
        iDiffListPost.append(text)
        
sub2 = 'lambda'
for text in preZColList:
    if sub2 in text:
        lambdaListPre.append(text)
        
for text in postZColList:
    if sub2 in text:
        lambdaListPost.append(text)
        
preIntDiffMeanP1 = port1PreZ[iDiffListPre].mean().mean()
postIntDiffMeanP1 = port1PostZ[iDiffListPost].mean().mean()
preLamMeanP1 = port1PreZ[lambdaListPre].mean().mean()
postLamMeanP1 = port1PostZ[lambdaListPost].mean().mean()

preIntDiffMeanP2 = port2PreZ[iDiffListPre].mean().mean()
postIntDiffMeanP2 = port2PostZ[iDiffListPost].mean().mean()
preLamMeanP2 = port2PreZ[lambdaListPre].mean().mean()
postLamMeanP2 = port2PostZ[lambdaListPost].mean().mean()

preIntDiffMeanP3 = port3PreZ[iDiffListPre].mean().mean()
postIntDiffMeanP3 = port3PostZ[iDiffListPost].mean().mean()
preLamMeanP3 = port3PreZ[lambdaListPre].mean().mean()
postLamMeanP3 = port3PostZ[lambdaListPost].mean().mean()

preIntDiffMeanP4 = port4PreZ[iDiffListPre].mean().mean()
postIntDiffMeanP4 = port4PostZ[iDiffListPost].mean().mean()
preLamMeanP4 = port4PreZ[lambdaListPre].mean().mean()
postLamMeanP4 = port4PostZ[lambdaListPost].mean().mean()

preIntDiffMeanP5 = port5PreZ[iDiffListPre].mean().mean()
postIntDiffMeanP5 = port5PostZ[iDiffListPost].mean().mean()
preLamMeanP5 = port5PreZ[lambdaListPre].mean().mean()
postLamMeanP5 = port5PostZ[lambdaListPost].mean().mean()

summaryTable = np.asarray([[preIntDiffMeanP1, preIntDiffMeanP2, preIntDiffMeanP3,
                              preIntDiffMeanP4, preIntDiffMeanP5], [preLamMeanP1,
                                                                    preLamMeanP2, preLamMeanP3, 
                                                                    preLamMeanP4, preLamMeanP5], 
                                                                    [postIntDiffMeanP1, postIntDiffMeanP2, postIntDiffMeanP3, postIntDiffMeanP4, postIntDiffMeanP5],
                                                                    [postLamMeanP1, postLamMeanP2, postLamMeanP3, postLamMeanP4, postLamMeanP5]])
                                                                    
np.savetxt('summaryTable.csv', summaryTable, delimiter = ',')