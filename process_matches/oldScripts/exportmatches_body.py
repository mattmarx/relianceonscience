import pandas as pd
import numpy as np
import datetime
import os
import re
import time
import warnings
warnings.filterwarnings('ignore')

"""
Author: Joshua Chu
Date: Feb 28, 2023

This file processes body citations and standardizes the data utilizing the criteria
extracted from the exportmatches_body_mag2021.do stata script. If the output does
not look as expected, you can review the original stata script found in this directory

"""

### this determines the current year and subtracts one from the variable
### because we are processing the previous year. For example, at the time
### of writing this script it was 2023, meaning, we are processing 2022
year=(datetime.date.today().year) - 1
#year=2021

### build the directory and file name required to be processed and save
### the file as 'filetoprocess'
dir=os.listdir("./scoredresults")
regex="scored_body_mag_" + str(year) + ".+?bestonly\.tsv"

for fil in dir:
 match = re.findall(regex,fil)

 if len(match) > 0:
  file=match

filetoprocess="./scoredresults/" + file[0]


t0=time.time()

### this block imports the dataset, rename columns, and converts the patent id
### column to lowercase strings
ros=pd.read_csv(filetoprocess,delimiter='\t',usecols=[0,1,9,18],quoting=3)
ros.rename(columns={0:'ReferenceSource',1:'Confidence',9:'CODE',18:'PatentID'},inplace=True)
ros.PatentID=ros.PatentID.str.lower()

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

ros.info(null_counts=True)
print("\n",ros)


t0=time.time()

### the proceeding steps were transferred from the stata script
### exportmatches_body_mag2021.do; some steps are slightly different
### but the output file is the same. If the Python output does not look
### correct, return to the above stata script found in the cwd

### determines the length of the ReferenceSource column and copies the
### value in a new column called ReferenceSourceLen; the resulting column
### was utilized to filter any records that were a length of 3 or less along
### with records having a confidence level greater or equal to 1
ros["ReferenceSourceLen"]= ros["ReferenceSource"].str.len()
rosSub=ros.loc[(ros['ReferenceSourceLen']<=3) & (ros['Confidence']>=1)].copy()

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

rosSub.info(null_counts=True)
print("\n",rosSub)


t0=time.time()

### rename columns inplace and copies the set to ensure it is not overwritten
rosSub.rename(columns={'ReferenceSource':'reftype','Confidence':'confscore','CODE':'oaid','PatentID':'patent'},
              inplace=True)
rosSub1=rosSub.iloc[:,0:4].reset_index(drop=True).copy()

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
rosSub1.suffix=rosSub1.suffix.replace(np.nan,'')

rosSub1['rmLeading']=rosSub1.digits.str.lstrip('0')

rosSub1['newPat']=rosSub1['prefix'] + rosSub1['rmLeading'] + rosSub1['suffix']
rosSub2=rosSub1.iloc[:,[0,1,2,8]].copy()

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
rosSub2.patent=rosSub2.patent.str.replace("__","")
rosSub2['confscore']=rosSub2['confscore'].where(rosSub1['confscore'] < 10, 10)

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

rosSub2.info(null_counts=True)
print("\n",rosSub2)


t0=time.time()

### drop any record with an empty cell and drop duplicates (keep the first)
rosSub2.dropna(inplace=True)
rosSub2.oaid=rosSub2.oaid.astype(int)
rosSub2.drop_duplicates(keep='first',inplace=True)

t1=time.time()
total=t1-t0
print("Total time is %.2f" % (total/60), "mins\n")

rosSub2.info(null_counts=True)
print("\n",rosSub2)


a="./scoredresults/" + "scored_body_mag_bestonlyexport" + str(year) + ".tsv"

rosSub2.to_csv(a,header=True,index=False,sep='\t')
os.chmod(a,0o777)
