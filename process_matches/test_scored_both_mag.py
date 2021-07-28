import pandas as pd
import numpy as np
df = pd.read_csv('scored_both_mag_bestonlyexport2020.tsv',sep='\t', index_col=None)
df.reset_index(inplace=True)
print(df.head())
print(df.groupby('reftype')['confscore'].describe())
print(df.groupby('wherefound').count())
