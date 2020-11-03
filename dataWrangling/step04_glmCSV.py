# step04_glmCSV.py

import pandas as pd
import numpy as np

# change viewing options
pd.set_option("display.max_rows", 3, "display.max_columns", None)

# read in subsetData
subsetData = pd.read_csv('subsetData.csv', sep=',', header=0)
primerCSV = subsetData.copy()

# drop metaData columns, retain species data
primerCSV = primerCSV.drop(['ID', 'Plot', 'Burn', 'Dune'], axis=1)

# transpose dataframe: species on y axis (index), sites on x axis (header)
primerCSV = primerCSV.transpose()

# start the glmCSV with the metaData columns
glmCSV = subsetData[['ID', 'Plot', 'Burn', 'Dune']]

# set up lists
richness_list = []
abundance_list = []

for i in range(len(subsetData)):
	# counts number of species in the site
	richness_list.append(np.count_nonzero(primerCSV[i]))
	# sums the total number of seeds in the site
	abundance_list.append(primerCSV[i].sum())

# create the species richness column
glmCSV['Num_Species'] = richness_list
# create the total abundance column
glmCSV['Tot_Abundance'] = abundance_list

# write out file
glmCSV.to_csv(r'/path/to/glmCSV.csv', index=False)
