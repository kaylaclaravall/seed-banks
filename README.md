# Influences of fire and dune position on the composition of seed banks in the Simpson desert.
* This project uses multivariate statistics to examine the effect of fire and dune position on the composition of seed banks in the Simpson Desert.

### Data wrangling
* This folder contains the python scripts used to tidy the rawData into a workable format for downstream statistical analyses.
* Step 1 :
    * Enter data into rawData.csv
* **step02_subset.py** :
    * Outputs *subsetData.csv* ready for step03 and step04
* **step03_primerCSV.py** :
    * Outputs *primerCSV.csv* and *siteFactors.csv* ready for Seeds_NMDS.R
* **step04_glmCSV.py** :
    * Outputs *glmCSV.csv* ready for Seeds_GLM.R

### RScripts
* This folder contains the R scripts used to conduct multivariate analyses.
* **Seeds_NMDS.R** :
    * (1) conducts 2D non-metric multidimensional scaling (NMDS) with ordination plot output.
    * (2) Conducts a permutational multivariate analysis of variance (PERMANOVA).
* **Seeds_GLM.R** :
    * (1) Conducts two-way analysis of variance (ANOVA) with type III sums of squares followed by Games-Howell post-hoc tests with barplot outputs.
    * (2) Calculates partial eta-squared effect sizes and produces forest plot outputs. 

### Ordination plots


### Barplots


### Forest plots
