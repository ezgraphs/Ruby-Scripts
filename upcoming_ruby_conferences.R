#
#
# Set the current working directory
#
setwd('<PresentWorkingDirectory>')

#
# Read in the data
#
df=read.csv('<PresentWorkingDirectory>ruby_conference_locations.txt',header=TRUE,sep=';')
df$City=gsub(',.*$','',df$Location)

#
# Create Maps
#
library(ggplot2)
library(maps)

world=map_data('world2')

plotMap = function(textAng, x1, x2, y1, y2 ){
   p = ggplot(data=df) 
   p = p + geom_point(aes(x=lng, y=lat, color=Date)) + borders('world') 
   p = p + geom_text(aes(x=lng, y=lat, label = City, size=3), angle=textAng) 
   p = p + coord_map()
   p = p + scale_x_continuous(limits = c(x1,x2))
   p = p + scale_y_continuous(limits = c(y1, y2)) 
   p
}

#World
plotMap(textAng=15, x1=-130, x2=150, y1=-40, y2=60 )
ggsave('RubyConferencesWorld.png')

# US
plotMap(textAng=0, x1=-130, x2=-30, y1=-57, y2=75)
ggsave('RubyConferencesUS.png')

# Japan
plotMap(textAng=0, x1=130, x2=143, y1=25, y2=42)
ggsave('RubyConferencesJapan.png')

# Europe
plotMap(textAng=0, x1=-10, x2=45, y1=40, y2=75)
ggsave('RubyConferencesEurope.png')