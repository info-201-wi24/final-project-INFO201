library(dplyr)
# first import both Minimum_Wage_Data and archive_2_
Minimum_Wage_Data <- read_csv("path/to/Minimum_Wage_Data.csv")
archive_2_ <- read_csv("path/to/archive_2_.csv")

# the crime rate dataset was collected during 1973
# so I filtered the minimum wage dataset to 1973

Minimum_Wage_Data_73 <- Minimum_Wage_Data %>%
  filter(Year == "1973")

# rename column name from ...1 to State for clarity
colnames(archive_2_) <- c('State', 'Murder', 'Assault', 'UrbanPop', 'Rape')

# rename archive_2_
crime_rate_State <- archive_2_

# joining the two datasets
crime_rate_vs_min_wage <- left_join(Minimum_Wage_Data_73, crime_rate_State)
 
# Must create at least one new categorical variable
crime_rate_vs_min_wage <- crime_rate_vs_min_wage %>%
  mutate(WageCategory = cut(MinWage,
                            breaks = quantile(MinWage, probs = c(0, .33, .67, 1), na.rm = TRUE),
                            labels = c("Low", "Medium", "High"),
                            include.lowest = TRUE))

# Must create at least one new continuous/numerical variable
crime_rate_vs_min_wage <- crime_rate_vs_min_wage %>%
  mutate(TotalCrimeRate = Murder + Assault + Rape)

# Must create at least one summarization data frame 
summary_df <- crime_rate_vs_min_wage %>%
  group_by(WageCategory) %>%
  summarise(AvgMinWage = mean(MinWage, na.rm = TRUE),
            AvgTotalCrimeRate = mean(TotalCrimeRate, na.rm = TRUE))

# Further cleaning to delete NA values that don't apply to the dataset
clean_data <- crime_rate_vs_min_wage %>%
  mutate(Footnote = NULL) %>%
  na.omit()


# Note - your summarization table does not need to be exported to a csv file, 
# you just need to have code that create this data frame. 
# Displaying summarization data frame
print(summary_df)



# export as csv file
write.csv(crime_rate_vs_min_wage, "C:\\Users\\mozza\\OneDrive\\Documents\\RstudioINFO201\\crime_rate_vs_min_wage.csv", row.names = FALSE)

