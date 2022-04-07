#add libraries and set the directory
library(readxl)
library(dplyr)
original_working_directory<-getwd()
setwd("/Users/matthewgrossman/Documents/Thesis/ThesisSync/GrantData")

#import and clean the FCC Auction Data (old data by county switched to by state method below)
FCC_auction_results<-read_excel("FCC_auction_results.xlsx")
FCC_auction_results<-data.frame(FCC_auction_results)
FCC_auction_results<-na.omit(FCC_auction_results)
FCC_auction_results$GrantPerEstimate<-FCC_auction_results$Total_Support_Over_10_Years/FCC_auction_results$Locations
FCC_auction_results<-group_by(FCC_auction_results,State)

#import and clean the FCC Auction Data by state
#FCC_auction_results<-read.csv("FCC_auction_results_by_state.csv")
#FCC_auction_results<-data.frame(FCC_auction_results)

#import the state by state information
alabama_grants<-read_excel("AlabamaSummaryCosts.xlsx")
california_grants<-read_excel("CaliforniaSummaryCosts.xlsx")
colorado_grants<-read_excel("ColoradoSummaryCosts.xlsx")
idaho_grants<-read_excel("IdahoSummaryCosts.xlsx")
illinois_grants<-read_excel("IllinoisSummaryCosts.xlsx")
indiana_grants<-read_excel("IndianaSummaryCosts.xlsx")
iowa_grants<-read_excel("IowaSummaryCosts.xlsx")
maine_grants<-read_excel("MaineSummaryCosts.xlsx")
massachusetts_grants<-read_excel("MassachusettsSummaryCosts.xlsx")
michigan_grants<-read_excel("MichiganSummaryCosts.xlsx")
minnesota_grants<-read_excel("MinnesotaSummaryCosts.xlsx")
missouri_grants<-read_excel("MissouriSummaryCosts.xlsx")
new_york_grants<-read_excel("NewYorkSummaryCosts.xlsx")
south_carolina_grants<-read_excel("SouthCarolinaSummaryCosts.xlsx")
south_dakota_grants<-read_excel("SouthDakotaSummaryCosts.xlsx")
vermont_grants<-read_excel("VermontSummaryCosts.xlsx")
virginia_grants<-read_excel("VirginiaSummaryCosts.xlsx")
washington_grants<-read_excel("WashingtonSummaryCosts.xlsx",sheet=2)
wisconsin_grants<-read_excel("WisconsinSummaryCosts.xlsx")

state_program_grants<-bind_rows(alabama_grants,california_grants,colorado_grants,idaho_grants,illinois_grants,indiana_grants,iowa_grants,maine_grants,massachusetts_grants,michigan_grants,minnesota_grants,missouri_grants,new_york_grants,south_carolina_grants,south_dakota_grants,vermont_grants,virginia_grants,washington_grants,wisconsin_grants)

#fill columns for the amount spent per premises
state_program_grants$match_amount<-state_program_grants$total_amount-state_program_grants$grant_amount
state_program_grants$grant_amount_per<-state_program_grants$grant_amount/state_program_grants$premises
state_program_grants$match_amount_per<-state_program_grants$match_amount/state_program_grants$premises
state_program_grants$total_amount_per<-state_program_grants$total_amount/state_program_grants$premises


#import and clean FCC Model Data
FCC_model_results<-read_excel("FCC_model_results.xlsx")
FCC_model_results<-data.frame(FCC_model_results)
FCC_model_results$GrantPerEstimate<-FCC_model_results$Support/FCC_model_results$Premises
FCC_model_results<-group_by(FCC_model_results,State)

#create data frame that generates grant estimates for each state based on model and auction
FCC_grant_estimates<-data.frame(FCC_model_results$State)
names(FCC_grant_estimates)[1]<-"State"
FCC_grant_estimates$model_estimates<-FCC_model_results$GrantPerEstimate
FCC_auction_estimates_by_state<-data.frame(summarize(FCC_auction_results, mean=mean(GrantPerEstimate,na.rm=TRUE)))
FCC_grant_estimates<-merge(FCC_grant_estimates,FCC_auction_estimates_by_state,by="State")
names(FCC_grant_estimates)[3]<-"auction_estimates"
names(FCC_grant_estimates)[1]<-"state"

#clean up
setwd(original_working_directory)
