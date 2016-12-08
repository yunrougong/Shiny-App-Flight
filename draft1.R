setwd('~/Desktop/US Domestic Flight shinyapp')
library(dplyr)
library(ggplot2)
library(googleVis)
library(ggmap)
library(stringr)
myflight <- read.csv('mydata.csv',stringsAsFactors=F)

sum(is.na(myflight))
#change the state DC to MA
myflight$O.state[myflight$O.state=='DC']<-'MA'
myflight$D.state[myflight$D.state=='DC']<-'MA'

#myflight <- subset(myflight, myflight$O.state !='DC')

# change the state.abb to full name 4
q <- myflight$O.state

#q <- str_trim(q,side='left')
y <- state.name[match(q,state.abb)]
myflight <- cbind(myflight,Ori.State=y)
myflight$O.state <- NULL
sum(is.na(myflight))
myflight0 <- myflight
o <- myflight$D.state
x <- state.name[match(o,state.abb)]
sum(is.na(x))
#x<- data.frame(x,stringsAsFactors = F)

myflight <- cbind(myflight,Des.State =x)
myflight$D.state <- NULL
sum(is.na(myflight))

#write.csv(myflight,file="myflight.csv",row.names = F)

df_out <- myflight%>%group_by(Year,Month,Ori.State)%>%
  summarise(Passengers_out=sum(Passengers),Flights_out=sum(Flights))

df_in <- myflight%>%group_by(Year,Month,Des.State)%>%
  summarise(Passengers_in=sum(Passengers),Flights_in=sum(Flights))


#out.1990 <- subset(df_out, Year=='1990')


#merge inflow and ourflow 
#df_merge <- cbind.data.frame(df_out,df_in,stringsAsFactors=F)

out1 <- select(df_out)
 

#dataframe state 
states <- cbind.data.frame(state.abb,state.name,stringsAsFactors=F)

#inner_join(tbl_df(myflight[1:10,]), tbl_df(states),
#           by = c("Origin.State" = "state.abb"))


v <- df_in$Passengers_in - df_out$Passengers_out
