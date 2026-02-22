# Part 1: Load data (past 3 Olympics + current year if included)
olympics <- read.csv("3years.csv", stringsAsFactors = FALSE)

# Quick checks
head(olympics)
str(olympics)

##CREATE WINTER MEASURES
# High winter: > 45
olympics$high_winter <- ifelse(olympics$latitude > 45, 1, 0)
# Low winter: between 35 and 45
olympics$low_winter <- ifelse(olympics$latitude > 35 & olympics$latitude <= 45,1,0)

# Create logged variables
olympics$log_population <- log(olympics$population)
olympics$log_gdp_cap <- log(olympics$gdp_cap)

# Quick check
summary(olympics$log_population)
summary(olympics$log_gdp_cap)
summary(olympics$low_winter)
summary(olympics$high_winter)

# Load package (if not already loaded)
library(AER)


# Estimate Tobit model using past Olympics
tobit_model <- tobit(medals ~ log_population + log_gdp_cap + host + high_winter + low_winter,
  left = 0,
  data = olympics)

summary(tobit_model)

##Prediction
olympics_2026 <- read.csv("olympics_2026.csv", stringsAsFactors = FALSE)
head(olympics_2026)
str(olympics_2026)

##Logged variables for prediction file
olympics_2026$log_population <- log(olympics_2026$population)
olympics_2026$log_gdp_cap <- log(olympics_2026$gdp_per_cap)
olympics_2026$high_winter <- ifelse(olympics_2026$latitude > 45, 1, 0)
olympics_2026$low_winter <- ifelse(olympics_2026$latitude > 35 & olympics_2026$latitude <= 45, 1, 0)

# Generate Predictions
olympics_2026$predicted_medals <- predict(tobit_model, newdata = olympics_2026)

#SET NEGATIVE PREDICTIONS TO ZERO
olympics_2026$predicted_medals <- ifelse(olympics_2026$predicted_medals < 0,0,olympics_2026$predicted_medals)

##COMPUTE TOTAL
total_predicted <- sum(olympics_2026$predicted_medals)

# Rescale to total medals available
olympics_2026$predicted_medals_scaled <- olympics_2026$predicted_medals * (348 / total_predicted)

# Check total BEFORE rounding (should be 348, up to floating point noise)
sum(olympics_2026$predicted_medals_scaled)

# Create a display column (rounded) without overwriting the scaled values
olympics_2026$predicted_medals_display <- round(olympics_2026$predicted_medals_scaled, 1)

# Medal Gap = actual - predicted (use scaled, unrounded predictions)
olympics_2026$gap <- olympics_2026$medals - olympics_2026$predicted_medals_scaled

##Rank by Gap (Overachievers)
olympics_2026 <- olympics_2026[order(-olympics_2026$gap), ]
head(olympics_2026, 10)

##Rank by Gap (Underachievers)
olympics_2026_under <- olympics_2026[order(olympics_2026$gap), ]
head(olympics_2026_under, 10)

#EXPORT RESULTS
library(openxlsx)
write.xlsx(olympics_2026, "olympic_predictions_2026.xlsx")
