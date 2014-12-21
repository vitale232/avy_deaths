library(ggplot2)

setwd('C:/Users/Mary/Documents/andrew')

avys = read.csv('avy_deaths.csv', header=TRUE)
avys$date = as.Date(avys$date)
avys$fatalities = as.numeric(as.character(avys$fatalities))
avys$fatalities[is.na(avys$fatalities)] = 0

avys$year = as.numeric(format(avys$date, '%Y'))
bc_ski_states = c('AB', 'AK', 'BC', 'CA', 'CO', 'ID', 'MT', 'OR',
                  'UT', 'WA', 'WY', 'NV')
bc_ski = avys[avys$state %in% bc_ski_states, ]

qplot(year, data=bc_ski, fill=state)

df1 = bc_ski[bc_ski$fatalities != 0, ]
df1$year = as.factor(df1$year)
# df2 = aggregate(fatalities ~ year, 
#                data=bc_ski[bc_ski$fatalities != 0 & (bc_ski$activity=='SKI' | bc_ski$activity=='SKI ' |
#                           bc_ski$activity=='SNOWBOARD' | bc_ski$activity=='SNOWBOARD '), ], 
#                FUN=sum)
df2 = aggregate(fatalities ~ year, bc_ski, sum)
df2$year = as.factor(df2$year)
df2$level = levels(df2$year)
p = ggplot() + geom_bar(aes(x=year, fill=state), data=df1)
p + geom_line(aes(x=as.numeric(df2$year), y=fatalities), data=df2, color='darkblue', size=1.5)


# p = ggplot(data=bc_ski[bc_ski$fatalities != 0, ]) + geom_bar(aes(x=as.factor(year), fill=state))  
# 
# test = aggregate(fatalities ~ year, 
#                  data=bc_ski[bc_ski$fatalities != 0 & (bc_ski$activity=='SKI' | bc_ski$activity=='SKI ' |
#                             bc_ski$activity=='SNOWBOARD' | bc_ski$activity=='SNOWBOARD '), ], 
#                  FUN=sum)
# p + geom_line(aes(x=as.factor(year), y=fatalities))
