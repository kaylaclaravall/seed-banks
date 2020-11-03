# step03_primerCSV.py

import pandas as pd
pd.set_option("display.max_rows", 3, "display.max_columns", None)


# read in subsetData
subsetData = pd.read_csv('subsetData.csv', sep=',', header=0)


primerCSV = subsetData.copy()
primerCSV = primerCSV.drop(['ID', 'Plot', 'Burn', 'Dune'], axis=1)
primerCSV.to_csv(r'/Users/kyleclaravall/Google Drive/UNI DOCS/2020_SEM2/BIOL3907/Seed Banks/local_panda/primerCSV.csv', index=False)


siteFactors = subsetData[['ID', 'Plot', 'Burn', 'Dune']]
siteFactors.to_csv(r'/Users/kyleclaravall/Google Drive/UNI DOCS/2020_SEM2/BIOL3907/Seed Banks/local_panda/siteFactors.csv', index=False)
