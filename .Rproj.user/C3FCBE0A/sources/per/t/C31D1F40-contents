# create the data set with just totals
total_included_data<-state_program_grants[!is.na(state_program_grants$total_amount_per),]
#get counts for first cutoff
first_cutoff<-summarise(total_included_data[total_included_data$total_amount_per<535.49,], n=n())
names(first_cutoff)[2]<-"first_cutoff"

#get counts for second cutoff
second_cutoff<-summarise(total_included_data[total_included_data$total_amount_per<2136.27,], n=n())
names(second_cutoff)[2]<-"second_cutoff"

#get counts for third cutoff
third_cutoff<-summarise(total_included_data[total_included_data$total_amount_per<315.86,], n=n())
names(third_cutoff)[2]<-"third_cutoff_raw"

#get counts for fourth cutoff
fourth_cutoff<-summarise(total_included_data[total_included_data$total_amount_per<1260.08,], n=n())
names(fourth_cutoff)[2]<-"fourth_cutoff"

#generate table
chapter_4_table<-merge(first_cutoff,second_cutoff)
chapter_4_table<-merge(chatper_4_table,third_cutoff)
chapter_4_table<-merge(chatper_4_table,fourth_cutoff)

#get percentage numbers
chapter_4_table<-merge(chapter_4_table, summarise(total_included_data,n=n()))
chapter_4_table$first_cutoff_per<-chapter_4_table$first_cutoff/chapter_4_table$n
chapter_4_table$second_cutoff_per<-chapter_4_table$second_cutoff/chapter_4_table$n
chapter_4_table$third_cutoff_per<-chapter_4_table$third_cutoff/chapter_4_table$n
chapter_4_table$fourth_cutoff_per<-chapter_4_table$fourth_cutoff/chapter_4_table$n

write.xlsx(chapter_4_table,"chapter_4_table.xlsx")