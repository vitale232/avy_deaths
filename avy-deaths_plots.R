library(ggplot2)
library(ggmap)
library(sp)
library(rgdal)

setwd('/home/vitale232/Documents/avy_deaths/')
df = read.csv('./avy_deaths.csv', 
              as.is=1:6)

df$date = as.Date(df$date)
df$fatalities = as.numeric(df$fatalities)
df[which(df$state == ' '), 'state'] = NA
df[which(df$activity == 'SNOWBOARD '), 'activity'] = 'SNOWBOARD'
df[which(df$activity == 'SNOWMOBILE '), 'activity'] = 'SNOWMOBILE'


df$state = as.factor(df$state)
df$activity = as.factor(df$activity)


bc_ski_states = c('AB', 'AK', 'BC', 'CA', 'CO', 'ID', 'MT', 'OR',
                  'UT', 'WA', 'WY', 'NV')
bc_ski = df[df$state %in% bc_ski_states, ]
fats = aggregate(fatalities ~ state, bc_ski, sum)
state_table = table(bc_ski$state)
state_levels = names(state_table)[order(state_table, decreasing=TRUE)]
bc_ski$state = factor(bc_ski$state, levels=state_levels)

# pdf('./fatalities_state-activity.pdf', height=8, width=10)
# png('./fatalities_state-activity.png', height=8, width=10, units='in', res=300)
qplot(state, data=bc_ski, geom='bar', fill=activity, main='Avalanche Fatalities from 1998-2014 AD') + 
  xlab('State or Province') + ylab('Fatalities') + theme(text=element_text(size=20)) +
  annotate('text', label='Data source:\n http://www.avalanche.org/', y=95, x=7.5, hjust=0)
# dev.off()

climb = bc_ski[which(bc_ski$activity == 'CLIMB' & 
                     bc_ski$state %in% c('AK', 'WA', 'AB', 'CO')), ]
climb$month = format(climb$date, '%m')
climb_table = table(climb$state)
climb_levels = names(climb_table)[order(climb_table, decreasing=TRUE)]
climb$state = factor(climb$state, levels=climb_levels)

# qplot(state, data=climb, geom='bar', fill=month)


# qplot(month, data=bc_ski, geom='bar', fill=state)
# qplot(state, data=bc_ski, geom='bar', fill=month)
# 
# 
# qplot(state, data=df, geom='bar', fill=activity, main='Avalance Fatalities from 1998-2014') + 
#   xlab('State or Province') + ylab('Fatalities') + theme(text=element_text(size=20))
# 
# df$year = as.numeric(format(df$date, '%Y'))
# df$month = as.factor(format(df$date, '%m'))
# 
# qplot(year, data=df, geom='bar', fill=state)
# qplot(state, data=df, geom='bar', fill=month)
# 
# coords = geocode(paste(df$location, df$state), output='latlon')
# 
# df$x = coords$lon
# df$y = coords$lat
# 
# spdf = na.omit(df)
# coordinates(spdf) = ~x+y
# 
# proj4string(spdf) = CRS('+proj=longlat +datum=WGS84')
# 
# states = readOGR(dsn=file.path(getwd(), 'states'), 
#                  layer='states')
# canada = readOGR(dsn=file.path(getwd(), 'Canada'),
#                  layer='Canada')
# states = spTransform(states, CRS(proj4string(spdf)))
# canada = spTransform(canada, CRS(proj4string(spdf)))
# 
# plot(states, axes=TRUE)
# plot(canada, add=TRUE)
# plot(spdf, add=TRUE, col='darkred')
# 
# writeOGR(spdf, file.path(getwd(), 'avys.geojson'), layer='nc', driver='GeoJSON')
# 
