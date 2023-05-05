import pandas as pd
import numpy as np
import datetime
import os
import sys
import re
import glob
import time
import warnings
warnings.filterwarnings('ignore')

"""
Author: Joshua Chu
Date: March 23, 2023

This file processes front or body citations and standardizes the data utilizing the criteria
extracted from the exportmatches_front_mag2021.do stata script. If the output does not look
as expected, you can review the original stata script found in this directory

command structure: python3 exportmatches.py <front or body>
"""

if len(sys.argv) < 2:
    print("command usage: python3 exportmatches.py <front or body>")
    sys.exit()

frontorbody=sys.argv[1]

### this determines the current year and subtracts one from the variable
### because we are processing the previous year. For example, at the time
### of writing this script it was 2023, meaning, we are processing 2022
year=(datetime.date.today().year) - 1

### Delete scored_body_oa_yearbestonlyexport.tsv file if it exists
a="./scoredresults/" + "scored_front_oa_" + str(year) + "bestonlyexport.tsv"
b="./scoredresults/" + "scored_body_oa_" + str(year) + "bestonlyexport.tsv"

if os.path.exists(a) and frontorbody == 'front':
    os.remove(a)

if os.path.exists(b) and frontorbody == 'body':
    os.remove(b)


### build the directory and file name required to be processed and save
### the file as 'filetoprocess'
if frontorbody == 'front':
    joined_files="./scoredresults/" + "scored_" + frontorbody + "_oa_*bestonly.tsv"
    joined_list=glob.glob(joined_files)
    li=[]

elif frontorbody == 'body':
    joined_list=glob.glob("./scoredresults/" + "scored_" + str(frontorbody) + "_oa_*bestonly.tsv")
#    joined_list.extend(glob.glob("./scoredresults/" + "scored_" + str(frontorbody) + "_oa_*bestonlywgrobid.tsv"))
    li=[]

## this block imports the dataset, rename columns, and converts the patent id
## column to lowercase strings
t0=time.time()

for filename in joined_list:
    df=pd.read_csv(filename,sep="\t",lineterminator='\n',error_bad_lines=False,header=None)
    li.append(df)

filetoprocess=pd.concat(li,axis=0)
ros=filetoprocess.iloc[:,[0,1,9,18]].copy()

ros.rename(columns={0:'ReferenceSource',1:'Confidence',9:'CODE',18:'PatentID'},inplace=True)
ros.PatentID=ros.PatentID.str.lower()

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

ros.info(null_counts=True)
print("\n",ros)


t0=time.time()

### the proceeding steps were transferred from the stata script
### exportmatches_front_mag2021.do; some steps are slightly different
### but the output file is the same. If the Python output does not look
### correct, return to the above stata script found in the cwd

### determines the length of the ReferenceSource column and copies the
### value in a new column called ReferenceSourceLen; the resulting column
### was utilized to filter any records that were a length of 3 or less along
### with records having a confidence level greater or equal to 1
ros["ReferenceSourceLen"] = ros['ReferenceSource'].str.len()
ros["Confidence"]=ros["Confidence"].astype(int)
ros.dropna(inplace=True)
ros1=ros.loc[ros['CODE']!='CODE']
rosSub=ros1.loc[(ros1['ReferenceSourceLen']<=3) & (ros1['Confidence']>=1)].copy()

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

rosSub.info(null_counts=True)
print("\n",rosSub)

### add the body field to dataset
t0=time.time()

if frontorbody == 'front':
    rosSub['body']=0

elif frontorbody == 'body':
    rosSub['body']=1

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

rosSub.info(null_counts=True)
print("\n",rosSub)


t0=time.time()

### rename columns inplace and copies the set to ensure it is not overwritten
rosSub.rename(columns={'ReferenceSource':'reftype','Confidence':'confscore','CODE':'oaid','PatentID':'patent'},
              inplace=True)
rosSub1=rosSub.iloc[:,0:6].reset_index(drop=True).copy()

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

rosSub1.info(null_counts=True)
print("\n",rosSub1)


t0=time.time()

### this section standardizes the patent number by extracting the digits, prefix,
### and the suffix. Any leading zeros were removed from the digits and suffixes
### that were Nan were coverted to empty. The extracted data were combined to
### format the patent numbers to __suffix-digits-suffix__. Sometimes there are
### letters combined with the digits. This is okay and standard for patent numbers
rosSub1['digits']=rosSub1.patent.str.extract(r'(\d+(?:\.\d+)?)')
rosSub1['prefix']=rosSub1.patent.str.extract(r'(\D+)')
rosSub1['suffix']=rosSub1.patent.str.extract(r'(-[A-z0-9]+$)')

rosSub1['rmLeading']=rosSub1.digits.str.lstrip('0')

rosSub1['newPat']=rosSub1['prefix'] + rosSub1['digits'] + rosSub1['suffix']
rosSub2=rosSub1.iloc[:,[0,1,2,10,5]].copy()

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

rosSub2.info(null_counts=True)
print("\n",rosSub2)

t0=time.time()

### columns were renamed and the underscores were removed from the patent numbers;
### confidence scores above 10 were also set to 10. For example, a score of 17 was
### converted to 10
rosSub2.rename(columns={'newPat':'patent'},inplace=True)
rosSub2.patent=rosSub2.patent.replace("__","")
rosSub2['confscore']=rosSub2['confscore'].where(rosSub2['confscore'] < 10, 10)

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

rosSub2.info(null_counts=True)
print("\n",rosSub2)

t0=time.time()

### drop any record with an empty cell and drop duplicates (keep the first)
rosSub2.dropna(inplace=True)
rosSub2.oaid=rosSub2.oaid.astype(int)
rosSub2.sort_values(by=['oaid','patent','confscore'],ascending=False,inplace=True)
rosSub2.drop_duplicates(subset=['oaid','patent'], keep='first',inplace=True)

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

rosSub2.info(null_counts=True)
print("\n",rosSub2)

c="./scoredresults/" + "scored_" + frontorbody + "_oa_" + str(year) + "bestonlyexport.tsv"

rosSub2.to_csv(c,header=True,index=False,sep='\t')
os.chmod(c,0o777)
