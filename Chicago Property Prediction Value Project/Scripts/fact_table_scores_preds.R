library(tidyverse)
library(forcats)
library(RMySQL);
library(ggplot2);
library(DBI);


datapath<-"C:/Users/willd/Documents/Summer 2019 Courses/MSCA Data Engineering Platforms/Final_Project/datclean/fact_table_scores/"

crime_scores<-(read.csv(file=paste(datapath,"Zip Crime Scores v2.csv",sep="/"),
                        header=TRUE,sep=","))
business_scores<-(read.csv(file=paste(datapath,"Zip Code Biz License Scores.csv",sep="/"),
                        header=TRUE,sep="," ))
groceries_scores<-(read.csv(file=paste(datapath,"grocery_score_sqft.csv",sep="/"),
                           header=TRUE,sep="," ))
schools_scores<-(read.csv(file=paste(datapath,"Schools_scores_2.csv",sep="/"),
                            header=TRUE,sep=","))
property_scores<-(read.csv(file=paste(datapath,"Zip Property Values.csv",sep="/"),
                          header=TRUE,sep=","))

fact_table<-(read.csv(file=paste(datapath,"Fact_Values.csv",sep="/"),
                      header=TRUE,sep=",",colClasses=c("integer","numeric","NULL","numeric",rep("NULL",5) )))

fact_table<-select(crime_scores,zip_code,crime_score) %>% 
  left_join(fact_table,crime_scores,by = "zip_code")

fact_table<-select(property_scores,zip_code,actual_aug_value) %>% 
  left_join(fact_table,property_scores,by = "zip_code")



fact_table<-left_join(fact_table,business_scores,by = c("zip_code"="Zip.Code"))
fact_table<-select(groceries_scores,zip_code,score) %>% left_join(fact_table,groceries_scores,
                                                                  by = c("zip_code"="zip_code"))

fact_table<-select(schools_scores,Zip_code,"Per.school") %>% right_join(fact_table,by = c("Zip_code"="zip_code"))

names(fact_table)[2]= c("school_score")
names(fact_table)[3]= c("count_groceries")
names(fact_table)[8]= c("business_score")


fact_table<-fact_table[c("Zip_code","predicted_aug_value","actual_aug_value",
                         "difference","count_groceries","crime_score",
                         "business_score","school_score")]


#60602, 60604, 60714 have no property value estimates available
#omit these zips for fact_values table

fact_table <- fact_table %>%
  filter(Zip_code != 60602) %>%
  filter(Zip_code != 60604) %>%
  filter(Zip_code != 60714) 


#for school scores, if is.na replace with zero


mean(linear_reg$fitted.values)

#Run the linear model here 

linear_reg <- lm(actual_aug_value ~ count_groceries + crime_score + business_score + school_score, data = fact_table)

summary(linear_reg)

fact_table$predicted_aug_value <- linear_reg$fitted.values
fact_table$difference <- linear_reg$residuals

#write CSV into MySQL files
write.table(fact_table, 
            file = "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/FactTable.csv",
            row.names=FALSE, 
            na="", 
            sep=",")

