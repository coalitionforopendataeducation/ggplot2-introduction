# Filename:	2-introduction-to-choropleth-maps.R
# Title:	Creating a choropleth map with ggplot2
# Author:	Tom Schenk Jr.
# Created:	2014-06-01
# Modified:
# Libraries: ggplot2, XML, maps
# Notes: Used in Chicago Data Visualization Group tutorials in 2012.

# LOAD UP GGPLOT2
library(ggplot2)

# PROPER TIME SERIES DATA
str(economics) # Explore the economics data set that comes with ggplot2.

# PLOT THE RELATIONSHIP OF UNEMPLOYMENT AND TIME
p <- ggplot(economics, aes(x = date, y = unemploy))
p + geom_line()

# LETS ALSO ANALYZE THE RELATIONSHIP OF UNEMPLOYMENT _RATE_, UNEMPLOYMENT, AND TIME
p + geom_line(aes(size = uempmed)) # Ehh, clear to you?
p + geom_line(aes(color = unempmed)) # Hey, that's clearer

# REMEMBER YOU CAN USE MATHEMATICAL ANALYSIS AS WELL. SO LET'S MANIPULATE THE DATA
# UNEMPLOYMENT RATE = UNEMPLOYMENT  / WORKING POPULATION, HOWEVER, WORKING POPULATION IS NOT KNOWN.
# BUT WITH SOME ALGEBRA, WE CAN FIND THE WORKING POPULATION = UNEMPLOYED / UNEMPLOYMENT RATE.
# SO LET'S GET THE DATA TOGETHER
unempl.perc <- economics$uempmed / 100 # Changed unemployment into a proper decimal rate
working.pop <- economics$unemploy / unempl.perc # Save the new working population rate
economics.new <- data.frame(economics, unempl.perc, working.pop) # New data frame

# NOW PLOT THE WORKING POPULATION AND POPULATION OVER TIME
m <- ggplot(economics.new, aes(x = date)) # We need to rebuild our "base"
m + geom_line(aes(y = pop)) + geom_line(aes(y = working.pop)) # Layer lines

# REMEMBER, EMPLOYMENT RATE IS WORKING POPULATION/POPULATION, LET'S GRAPH THAT WITHOUT CREATING A NEW VARIABLE
m + geom_line(aes(y = working.pop/pop))

# INSTALL "XML" PACKAGE TO READ WIKIPEDIA TABLES
install.packages("XML")  # Note to Ubuntu users, you may need to install libxml2-dev beforehand.
library(XML)

# READ DATA FROM "LIST OF U.S. STATES BY GDP" FROM WIKIPEDIA
states <- readHTMLTable(doc="http://en.wikipedia.org/wiki/List_of_U.S._states_by_GDP")

# ANALYZE THE STRUCTURE OF THE DATA
str(states) # Not too helpful
names(states) # Much better, a lot of nulls because of dirty Wikipedia data
states[[2]] # Gives us the first table of data
state.econ <- states[[2]] # Lets store this frame elsewhere.
states[[3]] # This looks like the right data as well
gsp <- states[[3]] # Let's store this data frame elsewhere.

# ANALYZE AND CLEAN DATA
str(state.econ) # Looks good.
str(gsp) # This is messy, the column names aren't right
gsp <- gsp[-1:-2, ] # Get rid of the first two rows.
names(gsp) <- c("State", "Rank.2009", "GSP.2009", "Rank.2008", "GSP.2008", "Rank.2007", "GSP.2007", "Rank.2006", "GSP.2006", "Rank.2005", "GSP.2005") # Fix variable names

# DATA WAS IMPORTED WITH COMMA'S, WE NEED TO CLEAN UP THE NUMERIC VALUES
# FIRST, TRY "AS.NUMERIC" OR "AS.INTEGER"

for(i in 2:11){
	gsp[ ,i] <- gsub(",","",gsp[,i])
	gsp[ ,i] <- as.integer(gsp[ ,i])
}


# OK, SO WHAT ANALYSIS CAN WE DO WITH THESE DATA? DISCUSS. DO.

# MAPPING DATA IS ALL THE RAGE (BUT A LITTLE OVER-RATE), SO LET'S GO THROUGH THOSE STEPS
# THERE ARE TWO PARTS TO MAPPING DATA: (1) THE "SHAPE-FILES" ARE THE GEOGRAPHIC COORDINATES THAT CORRESPOND TO ANY PART OF A MAP (E.G., CITY, STATE, COUNTRY).
# (2) THE DATA IS ANOTHER COMPONENT WHICH HAS THE SAME GEOGRAPHIC CODING (E.G., LAT/LON) AS THE SHAPE FILE. 

# WE WILL USE THE "MAPS" PACKAGE FOR BASIC SHAPEFILES (THERE ARE MUCH BETTER AVAILABLE, BUT THIS IS FINE FOR NOW)
library(maps)
usa <- map_data("state") # Load all U.S. states into this variable.
str(usa) # Take a peek at the data.

# LET'S LOAD THE ENTIRE UNITED STATES
ggplot(usa) + geom_polygon(aes(x=long, y=lat)) # Simple plot

# NOW LET'S GRAB A PIECE OF THE GSP DATA
gsp.2009 <- data.frame(gsp$State, gsp$GSP.2009) 
names(gsp.2009) <- c("region", "gsp.2009") # Rename variables to match the shapefile data so they can be merged.
gsp.2009$region <- tolower(gsp.2009$region) # Need to make state names all lowercase otherwise it won't merge.

# MERGE THE DATA WITH THE USA SHAPE FILE
usa.gsp.2009 <- merge(usa, gsp.2009, by="region", all=TRUE)
str(usa.gsp.2009) # Data was merged on state names, now the lat/long is alongside the GSP data.

# PLOT!
u <- ggplot(usa.gsp.2009, aes(x=long, y=lat))
u + geom_polygon(aes(group=group, fill=gsp.2009))
u + geom_polygon(aes(group=group, fill=gsp.2009)) + scale_fill_gradient(low = "white", high="steelblue") # Custom colors
u + geom_polygon(aes(group=group, fill=gsp.2009)) + scale_fill_gradient(low = "white", high="steelblue") + borders("state") # Now add grey borders