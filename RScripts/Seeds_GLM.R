##################################################################
##                        Data Wrangling                        ##
##################################################################

# read in data
raw_df <- read.csv('data/glmCSV.csv')
primer_df <- read.csv('data/primerCSV.csv')

# square root and fourth root transformations
raw_df$Num_Sp_SqRoot ='^'(raw_df$Num_Species,1/2)
raw_df$Num_Sp_FrRoot ='^'(raw_df$Num_Species,1/4)
raw_df$Abun_SqRoot ='^'(raw_df$Tot_Abundance,1/2)
raw_df$Abun_FrRoot ='^'(raw_df$Tot_Abundance,1/4)

# calculate diversity metrics
library(vegan)
SWI <- diversity(primer_df, index='shannon')
SDI <- diversity(primer_df, index='simpson')

# concat diversity metrics onto main dataframe
glm_df <- cbind(raw_df, SWI = SWI)
glm_df <- cbind(glm_df, SDI = SDI)

# specifying the order it will appear on the graph
glm_df$Burn <- factor(glm_df$Burn, levels = c("Unburnt/burnt", "Burnt/unburnt", "Unburnt/unburnt"))



#################################################################
##                             SWI                             ##
#################################################################

# plot barplot 
library(ggpubr)
ggbarplot(glm_df, x = "Burn", y = "SWI", fill = "Dune", color = "Dune",
          ylab = "Shannon-Wiener Diversity Index",
          position = position_dodge(0.8), alpha = 0.3,
          add = c("mean_se")) +
  scale_fill_brewer(name='Dune Position', palette = 'Dark2') +
  scale_color_brewer(name='Dune Position', palette = 'Dark2') +
  scale_x_discrete(name = '',
                   labels = c("Unburnt/burnt", "Burnt/unburnt", "Unburnt/unburnt")) +
  theme(text=element_text(size=25))

# > export > PDF > 18.75 x 10


#------ significance
library(car)

# set the constrasts required for type III SS
options(contrasts = c("contr.sum", "contr.poly"))

# linear model with interaction
fit.SWI <- lm(SWI ~ Burn*Dune, data=glm_df)

# type III ANOVA
aov.SWI <- Anova(fit.SWI, type ='III')
aov.SWI

#------ effect size
library(effectsize)

# calculate partial eta-squared
effect.SWI <- eta_squared(aov.SWI, partial=TRUE)
effect.SWI

# specifying the order it will appear on the graph
effect.SWI$Parameter <- factor(effect.SWI$Parameter, levels = c("Burn:Dune", "Dune", "Burn"))

# plot the effect size with 90% CI
library(ggplot2)
p1 <- ggplot(effect.SWI, aes(x=Eta2_partial, y=Parameter)) +
  geom_point(size = 5, pch=c(21, 16, 16)) +
  geom_errorbarh(aes(xmin = CI_low, xmax = CI_high)) +
  labs(x = expression(Partial~eta^{2})) +
  xlim(0, 0.13) +
  geom_vline(xintercept = 0, alpha=0.5, linetype="dashed") +
  theme_classic() +
  theme(text=element_text(size=25), axis.title.y = element_blank())

p1


#---- assumptions
# Levene's Test for Homogeneity of Variance
leveneTest(fit.SWI, center = mean)
# Shapiro-Wilk normality test
shapiro.test(residuals(fit.SWI))


#---- Games-Howell
library(userfriendlyscience)

# conduct pairwise post-hoc tests
oneway(glm_df$Dune, y = glm_df$SWI, posthoc = 'games-howell')






#################################################################
##                             SDI                             ##
#################################################################

ggbarplot(glm_df, x = "Burn", y = "SDI", fill = "Dune", color = "Dune",
          ylab = "Simpson's Diversity Index",
          position = position_dodge(0.8), alpha = 0.3,
          add = c("mean_se")) +
  scale_fill_brewer(name='Dune Position', palette = 'Dark2') +
  scale_color_brewer(name='Dune Position', palette = 'Dark2') +
  scale_x_discrete(name = '',
                   labels = c("Unburnt/burnt", "Burnt/unburnt", "Unburnt/unburnt")) +
  theme(text=element_text(size=25))


#------ significance
fit.SDI <- lm(SDI ~ Burn*Dune, data=glm_df)
aov.SDI <- Anova(fit.SDI, type ='III')
aov.SDI

#------ effect size
effect.SDI <- eta_squared(aov.SDI, partial=TRUE)
effect.SDI


effect.SDI$Parameter <- factor(effect.SDI$Parameter, levels = c("Burn:Dune", "Dune", "Burn"))

p2 <- ggplot(effect.SDI, aes(x=Eta2_partial, y=Parameter)) +
  geom_point(size = 5, pch=c(16, 16, 21)) +
  geom_errorbarh(aes(xmin = CI_low, xmax = CI_high)) +
  labs(x = expression(Partial~eta^{2})) +
  xlim(0, 0.13) +
  geom_vline(xintercept = 0, alpha=0.5, linetype="dashed") +
  theme_classic() +
  theme(text=element_text(size=25), axis.title.y = element_blank())

p2



library(cowplot)
plot_grid(p1, p2, nrow = 1, align = 'h', labels = "AUTO", label_size = 35)

#---- assumptions
leveneTest(fit.SDI, center = mean)
shapiro.test(residuals(fit.SDI))

#---- Games-Howell
oneway(glm_df$Burn, y = glm_df$SDI, posthoc = 'games-howell')
oneway(glm_df$Dune, y = glm_df$SDI, posthoc = 'games-howell')








#################################################################
##                         Num_Species                         ##
#################################################################

ggbarplot(glm_df, x = "Burn", y = "Num_Species", fill = "Dune", color = "Dune",
          ylab = "Species Richness",
          position = position_dodge(0.8), alpha = 0.3,
          add = c("mean_se")) +
  scale_fill_brewer(name='Dune Position', palette = 'Dark2') +
  scale_color_brewer(name='Dune Position', palette = 'Dark2') +
  scale_x_discrete(name = '',
                   labels = c("Unburnt/burnt", "Burnt/unburnt", "Unburnt/unburnt")) +
  theme(text=element_text(size=25))

#------ significance
fit.Num_Species <- lm(Num_Species ~ Burn*Dune, data=glm_df)
aov.Num_Species <- Anova(fit.Num_Species, type ='III')
aov.Num_Species

#------ effect size
effect.Num_Species <- eta_squared(aov.Num_Species, partial=TRUE)
effect.Num_Species

#---- assumptions
leveneTest(fit.Num_Species, center = mean)
shapiro.test(residuals(fit.Num_Species))



#--------------------------------------------------
#                 transformed
#--------------------------------------------------

#------ significance
fit.Num_Sp_FrRoot <- lm(Num_Sp_FrRoot ~ Burn*Dune, data=glm_df)
aov.Num_Sp_FrRoot <- Anova(fit.Num_Sp_FrRoot, type ='III')
aov.Num_Sp_FrRoot

#------ effect size
effect.Num_Sp_FrRoot <- eta_squared(aov.Num_Sp_FrRoot, partial=TRUE)
effect.Num_Sp_FrRoot


effect.Num_Sp_FrRoot$Parameter <- factor(effect.Num_Sp_FrRoot$Parameter, levels = c("Burn:Dune", "Dune", "Burn"))

p3 <- ggplot(effect.Num_Sp_FrRoot, aes(x=Eta2_partial, y=Parameter)) +
  geom_point(size = 5, pch=c(21, 16, 21)) +
  geom_errorbarh(aes(xmin = CI_low, xmax = CI_high)) +
  labs(x = expression(Partial~eta^{2})) +
  xlim(0, 0.13) +
  geom_vline(xintercept = 0, alpha=0.5, linetype="dashed") +
  theme_classic() +
  theme(text=element_text(size=25), axis.title.y = element_blank())

p3




#---- assumptions
leveneTest(fit.Num_Sp_FrRoot, center = mean)
shapiro.test(residuals(fit.Num_Sp_FrRoot))

#---- Games-Howell
oneway(glm_df$Dune, y = glm_df$Num_Sp_FrRoot, posthoc = 'games-howell')





#################################################################
##                          Abundance                          ##
#################################################################

ggbarplot(glm_df, x = "Burn", y = "Tot_Abundance", fill = "Dune", color = "Dune",
          ylab = "Abundance",
          position = position_dodge(0.8), alpha = 0.3,
          add = c("mean_se")) +
  scale_fill_brewer(name='Dune Position', palette = 'Dark2') +
  scale_color_brewer(name='Dune Position', palette = 'Dark2') +
  scale_x_discrete(name = '',
                   labels = c("Unburnt/burnt", "Burnt/unburnt", "Unburnt/unburnt")) +
  theme(text=element_text(size=25))

#------ significance
fit.Tot_Abundance <- lm(Tot_Abundance ~ Burn*Dune, data=glm_df)
aov.Tot_Abundance <- Anova(fit.Tot_Abundance, type ='III')
aov.Tot_Abundance

#------ effect size
effect.Tot_Abundance <- eta_squared(aov.Tot_Abundance, partial=TRUE)
effect.Tot_Abundance

#---- assumptions
leveneTest(fit.Tot_Abundance, center = mean)
shapiro.test(residuals(fit.Tot_Abundance))


#--------------------------------------------------
#                 transformed
#--------------------------------------------------

#------ significance
fit.Abun_FrRoot <- lm(Abun_FrRoot ~ Burn*Dune, data=glm_df)
aov.Abun_FrRoot <- Anova(fit.Abun_FrRoot, type ='III')
aov.Abun_FrRoot

#------ effect size
effect.Abun_FrRoot <- eta_squared(aov.Abun_FrRoot, partial=TRUE)
effect.Abun_FrRoot

effect.Abun_FrRoot$Parameter <- factor(effect.Abun_FrRoot$Parameter, levels = c("Burn:Dune", "Dune", "Burn"))

p4 <- ggplot(effect.Abun_FrRoot, aes(x=Eta2_partial, y=Parameter)) +
  geom_point(size = 5, pch=c(21, 16, 16)) +
  geom_errorbarh(aes(xmin = CI_low, xmax = CI_high)) +
  labs(x = expression(Partial~eta^{2})) +
  xlim(0, 0.13) +
  geom_vline(xintercept = 0, alpha=0.5, linetype="dashed") +
  theme_classic() +
  theme(text=element_text(size=25), axis.title.y = element_blank())

p4

plot_grid(p3, p4, nrow = 1, align = 'h', labels = "AUTO", label_size = 35)

plot_grid(p1, p2, p3, p4, nrow = 2, align = 'hv', labels = "AUTO", label_size = 35)


#---- assumptions
leveneTest(fit.Abun_FrRoot, center = mean)
shapiro.test(residuals(fit.Abun_FrRoot))

#---- Games-Howell
oneway(glm_df$Dune, y = glm_df$Abun_FrRoot, posthoc = 'games-howell')

