library(ggplot2)

setwd('C:/Users/Mary/Documents/andrew')

df = read.csv('./avy_deaths.csv', 
              as.is=1:6)

df$date = as.Date(df$date)
df$fatalities = as.numeric(df$fatalities)
df$fatalities[is.na(df$fatalities)] = 0
df[which(df$state == ' '), 'state'] = NA
df[which(df$activity == 'SNOWBOARD '), 'activity'] = 'SNOWBOARD'
df[which(df$activity == 'SNOWMOBILE '), 'activity'] = 'SNOWMOBILE'


df$activity = as.factor(df$activity)


bc_ski_states = c('AB', 'AK', 'BC', 'CA', 'CO', 'ID', 'MT', 'OR',
                  'UT', 'WA', 'WY', 'NV')
bc_ski = df[df$state %in% bc_ski_states, ]

state_table = aggregate(fatalities ~ state, bc_ski, sum)
state_levels = na.omit(state_table$state)[order(state_table$fatalities, decreasing=TRUE)]
bc_ski$state = factor(bc_ski$state, levels=state_levels)

ggp = ggplot(bc_ski) + geom_bar(aes(x=state, weight=fatalities, fill=activity))
ggp + ggtitle('Avalanche Fatalities from 1998-2014 AD') + 
  xlab('State or Province') + ylab('Fatalities') + theme(text=element_text(size=20)) +
  annotate('text', label='Data source:\n http://www.avalanche.org', y=116, x=9.25, hjust=0)
