# step03_primerCSV.py

import pandas as pd

# change viewing options
pd.set_option("display.max_rows", 3, "display.max_columns", None)

# read in subsetData
subsetData = pd.read_csv('subsetData.csv', sep=',', header=0)
primerCSV = subsetData.copy()

# drop metaData columns, retain the species data
primerCSV = primerCSV.drop(['ID', 'Plot', 'Burn', 'Dune'], axis=1)
# write out file
primerCSV.to_csv(r'/path/to/primerCSV.csv', index=False)

# drop species data, retain the metaData columns
siteFactors = subsetData[['ID', 'Plot', 'Burn', 'Dune']]
# write out file
siteFactors.to_csv(r'/path/to/siteFactors.csv', index=False)
