library(readxl)
library(dplyr)
library(xlsx)

#create a data frame that compares actual results for each state to estimates and number of grants above estimates
state_program_grants<-group_by(state_program_grants,state)

states_to_calc<-group_keys(state_program_grants)
states_column<-c()
actual_mean_column<-c()
model_estimates_column<-c()
auction_estimate_column<-c()
total_observations_column<-c()
above_model_column<-c()
above_auction_column<-c()
above_model_percent_column<-c()
above_auction_percent_column<-c()
t_statistic_column<-c()
p_value_column<-c()
for(state_index in 1:nrow(states_to_calc)){
  state_to_calc<-pull(states_to_calc[state_index,])
  print(state_to_calc)
  actual_mean<-mean(state_program_grants$grant_amount_per[state_program_grants$state==state_to_calc],na.rm=TRUE)
  model_estimate <- FCC_grant_estimates$model_estimates[FCC_grant_estimates$state==state_to_calc]
  auction_estimate <- FCC_grant_estimates$auction_estimates[FCC_grant_estimates$state==state_to_calc]
  if(NROW(model_estimate)==1&NROW(auction_estimate)==1){
    states_column<-append(states_column,state_to_calc)
    actual_mean_column<-append(actual_mean_column,actual_mean)
    model_estimates_column<-append(model_estimates_column,model_estimate)
    auction_estimate_column<-append(auction_estimate_column,auction_estimate)
    total_observations <- nrow(state_program_grants[state_program_grants$state==state_to_calc,])
    total_observations_column<-append(total_observations_column,total_observations)
    state_data_frame<-state_program_grants[state_program_grants$state==state_to_calc,]
    above_model<- NROW(na.omit(state_data_frame$grant_amount_per[state_data_frame$grant_amount_per>model_estiamte]))
    above_model_column<-append(above_model_column,above_model)
    above_auction<- NROW(na.omit(state_data_frame$grant_amount_per[state_data_frame$grant_amount_per>auction_estimate]))
    above_auction_column<-append(above_auction_column,above_auction)
    above_model_percent<-above_model/total_observations
    above_model_percent_column<-append(above_model_percent_column,above_model_percent)
    above_auction_percent<-above_auction/total_observations
    above_auction_percent_column<-append(above_auction_percent_column,above_auction_percent)
    ttest<-t.test(state_program_grants$grant_amount_per[state_program_grants$state==state_to_calc],FCC_auction_results$GrantPerEstimate[FCC_auction_results$State==state_to_calc],alternative='g')
    print(ttest$statistic)
    print(ttest$p.value)
    t_statistic_column<-append(t_statistic_column,ttest$statistic)
    p_value_column<-append(p_value_column,ttest$p.value)
  }
}
state_FCC_comparison<-data.frame(states_column,actual_mean_column,model_estimates_column,auction_estimate_column,total_observations_column,above_model_column,above_auction_column,above_model_percent_column,above_auction_percent_column,t_statistic_column,p_value_column)
write.xlsx(state_FCC_comparison,"state_FCC_comparison.xlsx")