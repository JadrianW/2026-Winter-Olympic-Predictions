# Olympic Medal Predictions (Winter)
This project estimates expected medal counts for the 2026 Winter Olympics using country-level economic and geographic characteristics as described in Bernard & Busse (2004). The goal is to identify which countries over- and under-performed relative to expectations.

## Methodology
I estimate a Tobit regression model using data from the 2014, 2018, and 2022 Winter Olympics. A Tobit model is appropriate because most countries win zero medals, which creates a natural lower bound in the data. 

The model predicts medal counts based on population, income, winter climate exposure, and host country status. The estimated relationships are then applied to 2026 country data to generate out-of-sample predictions.

## Variables

| Variable | Description | Measurement | Source |
|----------|------------|------------|--------|
| Medals | Total medals won | Count | IOC |
| Population | Country population | Millions (logged in model) | IMF World Economic Outlook |
| GDP per capita | Income per person in current prices | USD (logged in model) | IMF World Economic Outlook |
| High Winter | Strong winter climate | Latitude > 45° | Author calculation |
| Low Winter | Moderate winter climate | 30° < Latitude ≤ 45° | Author calculation |
| Host | Host country indicator | 1 if host, 0 otherwise | IOC |

## Empirical Results



| Variable | Coefficient | Std. Error | Significance |
|----------|------------|------------|--------------|
| Log Population | 5.47 | 0.548 | *** |
| Log GDP per capita | 8.07 | 0.97 | *** |
| High Winter | 22.18 | 2.86 | *** |
| Low Winter | 11.81 | 2.92 | *** |
| Host | 11.91 | 5.05 | * |

Notes: *** p < 0.01, ** p < 0.05, * p < 0.10

## Interpretation

The results highlight three key drivers of Olympic success:

- Larger countries win more medals due to a deeper talent pool
- Wealthier countries perform better due to greater investment in sport
- Geography plays a major role: countries in high-latitude regions win substantially more medals, reflecting structural advantages in winter sports

Host countries also experience a measurable boost in performance.

## Prediction Approach

Predicted medal counts are generated using 2026 country characteristics. Negative predictions are set to zero, and results are proportionally scaled to match the total number of medals awarded at the Games. The difference between actual and predicted medals is used to identify over- and under-performing countries.

## How to Run

1. Open `run_olympic_predictions.R` in RStudio
2. Ensure the CSV files are in the same directory
3. Run the script from top to bottom

The script will:
- Estimate the model
- Generate predictions
- Rescale totals
- Compute performance gaps
