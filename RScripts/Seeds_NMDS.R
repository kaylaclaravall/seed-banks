
##################################################################
##                          Section 1:                          ##
##                        Calculate nMDS                        ##
##################################################################

library(vegan)
library(MASS)

# read in primerCSV
SeedData <- read.csv("data/primerCSV.csv", header=TRUE)
ActiveData <- SeedData[as.logical(rowSums(SeedData != 0)), ]

# read in siteFactors
SeedFactors <- read.csv("data/siteFactors.csv", header=TRUE)
SeedFactors <- SeedFactors[as.logical(rowSums(SeedData != 0)), ]

# exclude outliers from ordination
ActiveData <- ActiveData[!grepl('SH.5.Crest.11',SeedFactors$Plot),]
SeedFactors <- SeedFactors[!grepl('SH.5.Crest.11', SeedFactors$Plot),]
# outlier
ActiveData <- ActiveData[!grepl('MC.C.Crest.14',SeedFactors$Plot),]
SeedFactors <- SeedFactors[!grepl('MC.C.Crest.14', SeedFactors$Plot),]

# fourth-root transformation of species count data
TransSeedData <- (ActiveData)^(1/4)



# calculate dissimilarity matrix using Bray curtis distance
Seed_Factor <- factor(SeedFactors$Burn)
nMDS_Seed <- metaMDS(TransSeedData, distance="bray", k=2)
# Uncomment line for 3D ordination
# nMDS_Seed <- metaMDS(TransSeedData, distance="bray", k=3)


# print NMDS output; see stress value
nMDS_Seed



# data wrangling to plot ordination
library(FactoMineR)

# write out x-y coordinates of the NMDS ordination into 'points.csv'
write.infile(nMDS_Seed[["points"]], 'Data/points.csv', sep=',')

# read in points.csv
points_df <- read.csv('Data/points.csv')

# create column 'MDS1'
nmds_points <- cbind(SeedFactors, MDS1 = points_df$MDS1)
# create column 'MDS2
nmds_points <- cbind(nmds_points, MDS2 = points_df$MDS2)


# Uncomment the following lines for 3D ordination
# nmds_points <- cbind(nmds_points, MDS3 = points_df$MDS3)
# 
# 
# library(car)
# library(rgl)
# scatter3d(x = nmds_points$MDS1, y = nmds_points$MDS2, z = nmds_points$MDS3,
#           groups = nmds_points$Dune,
#           surface=FALSE, ellipsoid = TRUE, grid = FALSE,
#           surface.col = c("#1B9E77", "#D95F02", "#7570B3"),
#           axis.scales = FALSE,
#           labels = nmds_points$Plot)

##################################################################
##                          Section 2:                          ##
##                          Plot nMDS                           ##
##################################################################

# alternative method to exclude outliers
# nmds_points <- nmds_points[!grepl('SH.5.Crest.11',nmds_points$Plot),]


library(ggpubr) # ggscatter function
library(cowplot) # plot_grid function

p1 <- ggscatter(nmds_points, x = "MDS1", y = "MDS2", color = "Burn", shape = "Burn",
                #label = "Plot",# repel = TRUE,
                ellipse = TRUE,# ellipse.type = 'convex',
                palette = "Dark2", alpha = 0.8,
                size = 5) +
  theme(text=element_text(size=25)) +
  labs(color = "Burn Status", shape = "Burn Status", fill = "Burn Status")

p2 <- ggscatter(nmds_points, x = "MDS1", y = "MDS2", color = "Dune", shape = "Dune",
                #label = "Plot",# repel = TRUE,
                ellipse = TRUE,# ellipse.type = 'convex',
                palette = "Dark2", alpha = 0.8,
                size = 5) +
  theme(text=element_text(size=25)) +
  labs(color = "Dune Position", shape = "Dune Position", fill = "Dune Position")


plot_grid(p1, p2, labels = "AUTO", label_size = 35)
# > export > PDF> 18.75 x 10


##################################################################
##                          Section 3:                          ##
##                          PERMANOVA                           ##
##################################################################

# conduct PERMANOVA
adonis(TransSeedData ~ Burn*Dune, data = SeedFactors, permutations = 999)

# set variables for the following function
x = TransSeedData
factors=SeedFactors$Burn

# create custom function for pairwise PERMANOVA constrasts
pairwise.adonis <- function(x,factors, sim.function = 'vegdist', sim.method = 'bray', p.adjust.m ='bonferroni')
{
  library(vegan)
  
  co = combn(unique(as.character(factors)),2)
  pairs = c()
  F.Model =c()
  R2 = c()
  p.value = c()
  
  
  for(elem in 1:ncol(co)){
    if(sim.function == 'daisy'){
      library(cluster); x1 = daisy(x[factors %in% c(co[1,elem],co[2,elem]),],metric=sim.method)
    } else{x1 = vegdist(x[factors %in% c(co[1,elem],co[2,elem]),],method=sim.method)}
    
    ad = adonis(x1 ~ factors[factors %in% c(co[1,elem],co[2,elem])] );
    pairs = c(pairs,paste(co[1,elem],'vs',co[2,elem]));
    F.Model =c(F.Model,ad$aov.tab[1,4]);
    R2 = c(R2,ad$aov.tab[1,5]);
    p.value = c(p.value,ad$aov.tab[1,6])
  }
  p.adjusted = p.adjust(p.value,method=p.adjust.m)
  sig = c(rep('',length(p.adjusted)))
  sig[p.adjusted <= 0.05] <-'.'
  sig[p.adjusted <= 0.01] <-'*'
  sig[p.adjusted <= 0.001] <-'**'
  sig[p.adjusted <= 0.0001] <-'***'
  
  pairw.res = data.frame(pairs,F.Model,R2,p.value,p.adjusted,sig)
  
  return(pairw.res)
  
} 

# compare burn status
pairwiseSeeds = pairwise.adonis(TransSeedData, SeedFactors$Burn)
pairwiseSeeds

# compare dune position
pairwiseSeeds = pairwise.adonis(TransSeedData, SeedFactors$Dune)
pairwiseSeeds
