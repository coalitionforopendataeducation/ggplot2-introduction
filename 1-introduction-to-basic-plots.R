# Filename:	1-introduction-to-basic-plots.R
# Title:	Introduction to Basic Plots in ggplot2
# Author:	Tom Schenk Jr. (adapted from Hadley Wickham)
# Created:	2014-06-01
# Modified:
# Libraries: ggplot2
# Notes: Heavily adpated from online tutorials provided by Hadley Wickham on http://docs.ggplot2.org. Was used in Chicago Data Visualization tutorials in 2012.


#INSTALLS ggplot2 PACKAGE. YOU WILL BE ASKED TO PICK A SERVER
install.packages("ggplot2")

#IF ALREADY INSTALLED, THIS WILL LOAD IT FOR USE
library(ggplot2)

# SIMPLE HISTOGRAM USING QPLOT() "QUICK PLOT" FUNCTION
qplot(rating, data=movies, geom="histogram")

# CAN CONTROL OTHER VISUAL ELEMENTS THROUGH OPTIONS
qplot(rating, data=movies, geom="histogram", binwidth=0.1)

# A WEIGHTED HISTOGRAM
qplot(rating, data=movies, weight=votes, geom="histogram", binwidth=0.1)

# NOW A SCATTER PLOT
qplot(mpaa, rating, data=movies)

# JITTER TO PREVENT OVER PLOTTING
qplot(mpaa, rating, data=movies, geom="jitter")

# LAYER OTHER PLOT TYPES
qplot(mpaa, rating, data=movies, geom=c("boxplot", "jitter"))

# OOPS, OTHER WAY
qplot(mpaa, rating, data=movies, geom=c("jitter", "boxplot"))

# ADD OTHER DIMENSTIONS THROUGH COLORS
qplot(mpaa, rating, data=movies, geom=c("jitter"), color=factor(Action))

# ANOTHER DATA SET WITH CONTINUOUS DATA
qplot(wt, mpg, data=mtcars, color=factor(cyl))

# QPLOT() IS QUICK, BUT LIMITED IN OPTIONS. GGPLOT() GIVES YOU FULL CONTROL
# SAME PLOT AS BEFORE USING GGPLOT()
ggplot(mtcars, aes(x=wt, y=mpg, color=factor(cyl))) + geom_point()

# THE AES() OPTION CONTROLS THE AESTHETIC VALUES
ggplot(mtcars, aes(x=wt, y=mpg, color=factor(cyl), shape=qsec)) + geom_point()

# GGPLOT IS BUILT AROUND THE GRAMMAR OF GRAPHICS TO BUILD LAYERS
p <- ggplot(mtcars, aes(x=wt, y=mpg))
p + geom_point(aes(color=factor(cyl), shape=qsec))

# THE FIRST P PRODUCES NOTHING, THE USER LAYERS THE GRAPHICAL ELEMENTS
p + geom_point(aes(color=factor(cyl), shape=qsec)) + geom_jitter(position=position_jitter(height=5))

# OVERLAY A LOESS ON A DOT PLOT
p + geom_point(aes(color=factor(cyl))) + stat_smooth()

# THE ORIGINAL p DOESN'T CONTAIN DATA, SO LINE WITHOUT POINTS IS:
p + stat_smooth()

# CAN ALSO USE LM OR GLM MODEL
p + stat_smooth(method="lm") + geom_point()

# MAKING THE LINE VERY UGLY
p + stat_smooth(fill="blue", size=2, alpha=1)

# OVERLAY A LEAST-SQUARES REGRESSOR FOR EACH CYL
c <- ggplot(mtcars, aes(y=wt, x=mpg, color=factor(cyl)))
c + stat_smooth(method=lm) + geom_point()

# FACETING BREAKS THE GRAPH INTO GRIDS FOR ANALYSIS
p + geom_point() + facet_grid(. ~ cyl)

# CAN OVERLAY A LEAST-SQUARES REGRESSION FOR EACH FACET
p + geom_point() + stat_smooth(method=lm) + facet_grid(. ~ cyl)

# ADD SOME COLOR
c <- ggplot(mtcars, aes(y=wt, x=mpg, color=factor(cyl)))
c + geom_point() + stat_smooth(method=lm)

# EXTRAPOLATING THE LINES
c + geom_point() + stat_smooth(method=lm, fullrange=TRUE, alpha=0.1)

##########################
# SOME MEANINGFUL EXAMPLES


setwd("C:\\Users\\tls573\\Dropbox\\Chicago Data Visualization\\ggplot2")
crime <- read.csv("Data\\Crimes_-_2011.csv")

# FIX DATA
str(crime) # Show data structures
crime$Date <- strptime(crime$Date, "%m/%d/%Y %H:%M") # Changes date from factor to proper POSIXlt date.
crime$Ward <- as.factor(crime$Ward) # Ward isn't a continuous variable, it's distinct sets
crime$Beat <- as.factor(crime$Beat) # Beat isn't a continuous variable, it's distinct sets

date.graph <- ggplot(crime, aes(x = Date)) # This prepares graphs with Date on the x-axis.
date.graph + geom_histogram() # Create a histogram with a date of crime on the x-axis. Shows the frequency of crime.
date.graph + geom_histogram(binwidth = range(x)/30)

qplot(date, data=crime, geom="histogram")

# THERE ARE LOTS OF GEOMETRIC SHAPES TO DISPLAY DATA
# SOME BASIC SHAPES ARE:
#
# geom_bar() a bar graph
# geom_histogram() a histogram
# geom_density() like a histogram, but shows periodic distribution
# geom_line() line graph
# geom_point() scatterplot
# geom_boxplot() Boxplot

# EXAMPLE DENSITY FUNCTION 
date.graph + geom_density() # SHOWS THE PERIODIC DISTRIBUTION OF CRIMES
date.graph + geom_density()
date.graph + geom_density(adjust = 1/2) # ROUGH
date.graph + geom_density(adjust = 3) # SMOOTH
date.graph + geom_density(fill="blue") # A BLUE PLOT
date.graph + geom_density(fill="blue", alpha = .2) # BLUE AND TRANSPARENT
date.graph + geom_density(size = 2) + geom_histogram(aes(y=..density..)) # DRAW DENSITY AND HISTOGRAM, MUST ADJUST HISTOGRAM TO DENSITY
date.graph + geom_histogram(aes(y=..density..)) + geom_density(size = 2) # SAME AS PREVIOUS GRAPH, BUT THE DENSITY IS DRAWN ON TOP

# EXAMPLES OF THE BAR CHART
crime.type <- qplot(Primary.Type, data=crime, geom="bar") # COLUMN GRAPH OF CRIMES BY PRIMARY TYPE OF CRIME
crime.type + coord_flip() # Horizontal bar chart

# WE HAVE SOME TYPE-Os THAT ARE CREATING DUPLICATIONS. LET'S FIX THIS.
levels(crime$Primary.Type)
levels(crime$Primary.Type)[11] <- "INTERFERENCE WITH PUBLIC OFFICER"
levels(crime$Primary.Type)[22] <- "OTHER OFFENSE"

ggplot(crime, aes(x = Primary.Type)) + geom_bar() + coord_flip() # SAME HORIZONTAL BAR CHART AS ABOVE

# PLOT THE WARD AND ARRESTS
ward.graph <- qplot(Ward, data=crime, geom="bar") # Which ward has the most crimes?
ward.graph + coord_flip() # Graph it with horizontal bar chart
ward.arrests <- ggplot(crime, aes(x = Ward, fill = Arrest))
ward.arrests + geom_bar() + coord_flip()

# PLOT THE WARD AND CRIME TYPE
ward.crime.type <- ggplot(crime, aes(x= Ward, y = Primary.Type))
ward.crime.type + geom_point() # LOTS OF OVERPLOTTING
ward.crime.type + geom_point(position="jitter") # JITTER THE PLOT, BETTER, BUT NOT PERFECT

# PLOT THE WARD, CRIME TYPE, AND WHETHER THERE WAS AN ARREST
ward.crime.arrest <- ggplot(crime, aes(x = Ward, y = Primary.Type))
ward.crime.arrest + geom_point(aes(color = Arrest),position = "jitter") # Color shows whether there was an arrest
ward.crime.arrest + geom_point(aes(color = Arrest, shape = Domestic), position = "jitter") # Now we add a shape to determine if there was an arrest...but it's getting a bit thick.

# DO CERTAIN CRIMES HAPPEN DURING CERTAIN PERIODS?
arrest.time <- ggplot(crime, aes(x = Date))
arrest.time + geom_histogram() + facet_grid(Arrest ~ Domestic) 


#
# NOW LET'S WORK WITH THE PROPOSED CHICAGO BUDGET DATA FOR 2013.
#

# IMPORT BUDGET DATA
budget <- read.csv("Data\\Budget_-_2013_Budget_Recommendations_-_Appropriations.csv")

# FIX DATA
budget$X2012.APPROPRATION <- as.numeric(sub("\\$","",budget$X2012.APPROPRATION))
budget$X2012.REVISED.APPROPRIATION <- as.numeric(sub("\\$","",budget$X2012.REVISED.APPROPRIATION))
budget$X2013.RECOMMENDATION <- as.numeric(sub("\\$","",budget$X2013.RECOMMENDATION))

names(budget)[10] <- "X2012.APPROPRIATION" # RENAME MISSPELLED VARIABLE
budget$DEPARTMENT.NUMBER <- as.factor(budget$DEPARTMENT.NUMBER)

budget <- budget[-4382, ]; budget <- budget[-4381, ]; budget <- budget[-4380, ]; budget <- budget[-4033, ]; budget <- budget[-2576, ]

# DISTRIBUTION OF INCOME SOURCES FOR EACH DEPARTMENT
budget.distribution <- ggplot(budget, aes(x = DEPARTMENT.DESCRIPTION, y = X2013.RECOMMENDATION))
budget.distribution + geom_boxplot() + coord_flip()

# CHANGE IN AMOUNTS
budget.comparisons <- ggplot(budget, aes(x = X2013.RECOMMENDATION, y = X2012.REVISED.APPROPRIATION)) 
budget.comparisons + geom_point() # GRAPH LAST YEAR APPROPRIATIONS TO 2013
budget.comparisons + geom_point() + geom_abline(intercept = 0, slope = 1) # THE DIAGONAL LINE QUICKLY SHOWS WHO RECEIVED AN INCREASE

# LET'S LOOK HOW THE DISTRIBUTION OF FUNDS HAS CHANGED FOR SALARIES
budget.salaries <- subset(budget, APPROPRIATION.ACCOUNT.DESCRIPTION == "SALARIES AND WAGES - ON PAYROLL")
budget.account <- ggplot(budget.salaries, aes(x = X2013.RECOMMENDATION))
budget.account + geom_histogram(binwidth=100000) + scale_y_continuous(limits = c(0, 20))