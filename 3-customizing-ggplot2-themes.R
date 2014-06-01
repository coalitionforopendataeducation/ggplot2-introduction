# Filename:	3-customizing-ggplot2-themes.R
# Title:	Customizing and theming maps in ggplot2
# Author:	Tom Schenk Jr.
# Created:	2014-06-01
# Modified:
# Libraries: ggplot2
# Notes: Used in Chicago Data Visualization Group tutorials in 2012.


# Let's customize our plot outputs. First, load the library.

library(ggplot2)

# Plot something simple

p <- ggplot(mtcars, aes(x=cyl, y=mpg)) + geom_point(aes(color=qsec, size=wt))

# Change axis
p + scale_y_continuous(limits=c(0,40))

# Change Labels
p + scale_y_continuous(limits=c(0,40)) + labs(title="Size of engine and fuel efficiency \n [or, how I stopped worrying about my SUV]", x="Miles per Gallon", y="Cylinders")

# Choose the breaks for the x-axis
p + scale_y_continuous(limits=c(0,40)) + scale_x_continuous(limits=c(4,8), breaks=c(4,6,8))

# Relabel them too
p + scale_y_continuous(limits=c(0,40)) + scale_x_continuous(limits=c(4,8), breaks=c(4,6,8), labels=c("Small", "Medium", "Large"))

# Legends need some clarity too.
legend <- guides(color = guide_legend("Acceleration in quarter seconds"), size = guide_legend("Weight (in thousands)"))
p + legend

# Change colorbar to dots
legend <- guides(color=guide_legend("Now I'm dots"), size = guide_legend("Weight (in thousands"))
p + legend

# Can change how the data is aggregated. Let's change the number of bubbles in the guide.
legend <- guides(color = guide_colorbar("Acceleration in quarter seconds", order=2), size = guide_legend("Weight (in thousands)", order=1))
p + legend 

# Move the legend to the bottom
legend <- legend + theme(legend.position="bottom") # Remember you can store as variables
p + legend + theme(legend.position="bottom")

# And side-to-side legend entries
p + legend + theme(legend.position="bottom", legend.box="horizontal")

# Save some more space by moving the legend titles to the top
legend <- guides(color = guide_colorbar("Acceleration in quarter seconds", order=2, title.position="top"), size = guide_legend("Weight (in thousands)", order=1, title.position="top"))
p + legend + theme(legend.position="bottom", legend.box="horizontal")

# Add some color to the legend
p + legend + theme(legend.position="bottom", legend.box="horizontal", legend.background = element_rect(colour = "black"))

# Or fill the legend box
p + legend + theme(legend.position="bottom", legend.box="horizontal", legend.background = element_rect(fill = "gray")) # Eh, not quite

p + legend + theme(legend.position="bottom", legend.box="horizontal", legend.background = element_rect(fill = "gray"), legend.key = element_rect(fill="gray")) # Still not yet

p + legend + theme(legend.position="bottom", legend.box="horizontal", legend.background = element_rect(fill = "gray"), legend.key = element_rect(fill="gray", color="gray")) # Success!


# Change the color of the plots
p + scale_area(range = c(1,20)) # Range

# Annotate the graph to highlight points
p + annotate("text", x = 7.25, y = 15, label = "Really important ->")

# Or annotate with calculations
p + annotate("text", x = 6, y = 30, label = cor(mtcars$mpg, mtcars$cyl))


## Now let's change some elements of the plot theme

# Change plot background
p + theme(panel.background = element_rect(fill = "white"))

# White background with black axis lines
p + theme(panel.background=element_rect(fill = "white"), axis.line = element_line(color = "black"))

# Now change the major and turn-off minor grids
looks <- theme(panel.background=element_rect(fill = "white"), axis.line=element_line(color="black"), panel.grid.major = element_line(color = "grey", linetype="dotted"), panel.grid.minor = element_blank())
p + looks

# Remember, we can combine this with our legends
p + legend + looks