import pandas as pd
import numpy as np
import datetime
import sys
import os
import re
import glob
import time
import warnings
warnings.filterwarnings('ignore')

"""
Author: Joshua Chu
Date: Mar 28, 2023

This file processes body citations and standardizes the data utilizing the criteria
extracted from the exportmatches_both_mag2021.do stata script. If the output does
not look as expected, you can review the original stata script found in this directory

"""
if len(sys.argv) < 1:
    print("command usage: python3 exportmatchesfrontbody.py")
    sys.exit()

elif len(sys.argv) > 1:
    print("command usage: python3 exportmatchesfrontbody.py")
    sys.exit()

### this determines the current year and subtracts one from the variable
### because we are processing the previous year. For example, at the time
### of writing this script it was 2023, meaning, we are processing 2022
year=(datetime.date.today().year) - 1

### Delete scored_body_oa_yearbestonlyexport.tsv file if it exists
a="./scoredresults/" + "scored_both_oa_" + str(year) + "bestonlyexport.tsv"

if os.path.exists(a):
    os.remove(a)

### build the directory and file name required to be processed and save
### the file as 'filetoprocess'
joined_files="./scoredresults/" + "scored_*" + "_oa_*bestonlyexport.tsv"
joined_list=glob.glob(joined_files)
li=[]

### this block imports the dataset, rename columns, and converts the patent id
### column to lowercase strings
t0=time.time()

for filename in joined_list:
    df=pd.read_csv(filename,sep="\t",lineterminator='\n')
    li.append(df)

filetoprocess=pd.concat(li,axis=0)
ros=filetoprocess.copy()
ros.patent=ros.patent.str.replace("__","",regex=True)
ros.reset_index(drop=True,inplace=True)

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

ros.info(null_counts=True)
print("\n",ros)


t0=time.time()

rosbothgb=ros.groupby(by=['oaid','patent'])['body'].mean()
rosbothgb1=pd.DataFrame(rosbothgb).reset_index(drop=False)

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

rosbothgb1.info(null_counts=True)
print("\n",rosbothgb1)


t0=time.time()

rosbothmerge=ros.merge(rosbothgb1,on=['oaid','patent'],how='inner')
rosbothmerge1=rosbothmerge.iloc[:,[0,1,2,3,5]].copy()

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

rosbothmerge1.info(null_counts=True)
print("\n",rosbothmerge1)


t0=time.time()

rosbothmerge1['wherefound']=np.where(rosbothmerge1.body_y == 1.0,'bodyonly',
                                     np.where(rosbothmerge1.body_y == 0.0,'frontonly','both'))

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

rosbothmerge1.info(null_counts=True)
print("\n",rosbothmerge1)


t0=time.time()

rosbothmerge2=rosbothmerge1.iloc[:,[0,1,2,3,5]].copy()
#rosbothmerge2.drop_duplicates(keep='first',inplace=True)

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

rosbothmerge2.info(null_counts=True)
print("\n",rosbothmerge2)


t0=time.time()

rosbothmerge2.patent=rosbothmerge2.patent.replace("us-us|us-","us",regex=True)
rosbothmerge2.patent=rosbothmerge2.patent.replace("^us","us-",regex=True)
rosbothmerge2.patent=rosbothmerge2.patent.replace("^re","us-re",regex=True)
rosbothmerge2.patent=rosbothmerge2.patent.replace("^pp","us-pp",regex=True)
rosbothmerge2.patent=rosbothmerge2.patent.replace("^d","us-d",regex=True)
rosbothmerge2.patent=rosbothmerge2.patent.replace("^us-de-","de-",regex=True)

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

rosbothmerge2.info(null_counts=True)
print("\n",rosbothmerge2)


t0=time.time()

rosbothmerge2['prefix']=rosbothmerge2['patent'].str.extract(r'(^us)')
rosbothmerge2['uspto']=np.where(rosbothmerge2['prefix'] == 'us',1,0)
rosbothmerge2['newreftype']=np.where((rosbothmerge2['reftype'] != 'app') & (rosbothmerge2['uspto'] == 0),'exm',
                                      np.where((rosbothmerge2['reftype'] != 'exm') & (rosbothmerge2['uspto'] == 1),'app',rosbothmerge2['reftype']))

rosfinal=rosbothmerge2.iloc[:,[7,1,2,3,6,4]].copy()
rosfinal1=rosfinal.copy()
rosfinal1.confscore=rosfinal1.confscore.astype(int)
rosfinal1.rename(columns={'newreftype':'reftype'},inplace=True)

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

rosfinal1.info(null_counts=True)
print("\n",rosfinal1)
#rosfinal1.to_csv("./checkdrops.tsv",header=True,index=False,sep='\t')


t0=time.time()

rosfinal1.sort_values(by=['confscore','oaid','patent'],ascending = [False, True, True],inplace=True)
rosfinal1.drop_duplicates(subset=['oaid','patent'],keep='first',inplace=True)
rosfinal2=rosfinal1.reset_index(drop=True)

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

rosfinal2.info(null_counts=True)
print("\n",rosfinal2)


rosfinal2.to_csv(a,header=True,index=False,sep='\t')
os.chmod(a,0o777)
