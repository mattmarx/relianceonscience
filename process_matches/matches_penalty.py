import pandas as pd
import numpy as np
import datetime
import os
import glob
import re
import sys
import time
import warnings
warnings.filterwarnings('ignore')

"""
Author: Joshua Chu
Date: Mar 22, 2023

This script is used to compare the publication and patent dates for each record in the input
file. The command structure is shown below and requires 3 different arguements to process
the data. Instead of writing two different scripts, the frontorbody user input is applied so
the script can identify the correct file types (i.e., front vs body). The year is simply the
current patent year. So, if you are processing 2022 patents, you would use the year 2022.
Finally, in most case you will be performing annual updates. However, if in the future
another batch update (like what was done in 2023 for 2022 patents) is performed, the user
can indicate to the script the type of update being performed. All 3 are necessary to find
the files and save the output file as the correct name and location.

command structre: python3 matches_front_penalty.py <front or body> <year> <annual or batch>
"""

if len(sys.argv) < 4:
    print("command usage: python3 matches_penalty.py <front or body> <year> <annual or batch>")
    sys.exit()

frontorbody=sys.argv[1]
year=sys.argv[2]
annualorbatch=sys.argv[3]

### build the directory and file name required to be processed and save
### the file as 'filetoprocess'
joined_files="./googlePatents/" + frontorbody + "patents*.txt"
joined_list=glob.glob(joined_files)
li=[]


#### this block imports the dataset, rename columns, and converts the patent id
#### column to lowercase strings
t0=time.time()

for filename in joined_list:
    df=pd.read_csv(filename,sep="\t",lineterminator='\n',header=None)
    li.append(df)

patents=pd.concat(li,axis=0)
patents.rename(columns={0:'PatentID',1:'YEAR'},inplace=True)
patents.PatentID=patents.PatentID.str.lower()
patents['replaceZeros']=np.where(patents.YEAR==0,np.nan,patents.YEAR)
patents=patents.drop(labels=['YEAR'],axis=1)
patents.rename(columns={'replaceZeros':'YEAR'},inplace=True)

t1=time.time()
total=t1-t0
print("Total time is %4f" % (total/60), "mins\n")

patents.info(null_counts=True)
print("\n")

t0=time.time()

inputfile="./scoredresults/scored_" + str(frontorbody) + "_oa_" + str(year) + str(annualorbatch) +".tsv"

ros=pd.read_csv(inputfile,sep="\t",lineterminator='\n',error_bad_lines=False,skiprows=[0],header=None)
ros.rename(columns={0:'ReferenceSource',1:'Confidence',2:'VolIssPageScore',3:'TitleScore',4:'LevMinDist',5:'TitlePct',
           6:'BestTitlePct3+',7:'PerfectUntil',8:'JournalScore',9:'CODE',10:'YEAR',11:'VOL',12:'ISSUE',13:'FIRSTPAGE',
           14:'LASTPAGE',15:'FIRSTAUTHOR',16:'TITLE',17:'JOURNAL',18:'PatentID',19:'PatentLine'}
           ,inplace=True)
ros['PatentID']=ros['PatentID'].str.lower()

t1=time.time()
total=t1-t0
print("Total time is %4f" % (total/60), "mins\n")

ros.info(null_counts=True)
print("\n")
ros.head()


t0=time.time()

patMerge=patents.merge(ros,on=['PatentID'],how='right')

t1=time.time()
total=t1-t0
print("Total time is %4f" % (total/60), "mins\n")

patMerge.info(null_counts=True)
print("\n")
patMerge.head()

t0=time.time()

patMerge.YEAR_y=patMerge.YEAR_y.astype(float)

patMerge['diff']=patMerge['YEAR_x'] - patMerge['YEAR_y']
patMerge['match']=np.where(patMerge['YEAR_x'].isnull(),0,
                           np.where(patMerge['diff'] < -10,20,
                                    np.where((patMerge['diff'] < -5) & (patMerge['diff'] >= -10), 5,
                                              np.where((patMerge['diff'] < -1) & (patMerge['diff'] >= -5),1,0))))

t1=time.time()
total=t1-t0
print("Total time is %4f" % (total/60), "mins\n")

patMerge.info(null_counts=True)
print("\n")
patMerge.head()


t0=time.time()

patMerge1=patMerge.iloc[:,[2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,0,20,22]].copy()
patMerge1.rename(columns={'YEAR_y':'YEAR'},inplace=True)
patMerge1['match']=patMerge1['match'].astype(int)

t1=time.time()
total=t1-t0
print("Total time is %4f" % (total/60), "mins\n")

patMerge1.info(null_counts=True)
print("\n")
patMerge1.head()


t0=time.time()

patMerge1['conf']=patMerge1['Confidence']-patMerge1['match']
patMerge2=patMerge1.drop(labels=['Confidence','match'],axis=1)

addCol=patMerge2.pop('conf')
patMerge2.insert(1,"Confidence",pd.DataFrame(addCol))

t1=time.time()
total=t1-t0
print("Total time is %4f" % (total/60), "mins\n")

patMerge2.info(null_counts=True)
print("\n")
patMerge2.head()

if annualorbatch == 'annual':
    outputfile="./scoredresults/scored_" + str(frontorbody) + "_oa_" + str(year) + "annualpenalty.tsv"

elif annualorbatch == 'batch':
    outputfile="./scoredresults/scored_" + str(frontorbody) + "_oa_" + str(year) + "batchpenalty.tsv"

patMerge2.to_csv(outputfile,sep="\t",index=False)
os.chmod(outputfile,0o777)
