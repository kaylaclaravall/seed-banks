# step04_glmCSV.py

import pandas as pd
import numpy as np

pd.set_option("display.max_rows", 3, "display.max_columns", None)

# read in subsetData
subsetData = pd.read_csv('subsetData.csv', sep=',', header=0)


primerCSV = subsetData.copy()
primerCSV = primerCSV.drop(['ID', 'Plot', 'Burn', 'Dune'], axis=1)
primerCSV = primerCSV.transpose()

glmCSV = subsetData[['ID', 'Plot', 'Burn', 'Dune']]

richness_list = []
abundance_list = []

for i in range(len(subsetData)):
	richness_list.append(np.count_nonzero(primerCSV[i]))
	abundance_list.append(primerCSV[i].sum())


glmCSV['Num_Species'] = richness_list
# glmCSV['Num_Species_sqRoot'] = np.sqrt(richness_list)

glmCSV['Tot_Abundance'] = abundance_list



print(glmCSV)

glmCSV.to_csv(r'/Users/kyleclaravall/Google Drive/UNI DOCS/2020_SEM2/BIOL3907/Seed Banks/local_panda/glmCSV.csv', index=False)

