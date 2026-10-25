
# ECO346 Assignment 1
# Registration: FA24-BED-087
# Variant 7: Balochistan Urban

library(tidyverse)

# Read both datasets
persons <- read_csv(
  "Data/pslm_person_subset.csv",
  show_col_types = FALSE
)

households <- read_csv(
  "Data/pslm_hh_subset.csv",
  show_col_types = FALSE
)

# Check dataset sizes
cat("Person file rows:", nrow(persons), "\n")
cat("Household file rows:", nrow(households), "\n")

# Display column names
cat("\nPerson file columns:\n")
print(names(persons))

cat("\nHousehold file columns:\n")
print(names(households))


# Join person data with household information
combined <- persons %>%
  left_join(
    households %>%
      select(hhid, hhweight, prov_code, urban_rural),
    by = "hhid"
  )

# Keep Variant 7: Balochistan Urban
# Keep ages 15–64 and positive annual earnings
analysis_data <- combined %>%
  filter(
    prov_code == 4,
    urban_rural == 2,
    age >= 15,
    age <= 64,
    earn_annual > 0,
    !is.na(hhweight)
  )

# Check the filtered sample
cat("\nRows after filtering:", nrow(analysis_data), "\n")
cat("Unique households:", n_distinct(analysis_data$hhid), "\n")
cat("Age range:", min(analysis_data$age), "to",
    max(analysis_data$age), "\n")
cat("Missing weights:", sum(is.na(analysis_data$hhweight)), "\n")

# Check earnings and weights
summary(analysis_data$earn_annual)
summary(analysis_data$hhweight)


# Q2: Weighted histogram of annual earnings

dir.create("figures", showWarnings = FALSE)

# Calculate weighted frequency in each earnings bin
breaks <- pretty(analysis_data$earn_annual, n = 20)

bin_id <- cut(
  analysis_data$earn_annual,
  breaks = breaks,
  include.lowest = TRUE,
  right = TRUE
)

weighted_counts <- tapply(
  analysis_data$hhweight,
  bin_id,
  sum
)

# Save weighted histogram as SVG

# Q2: Improved weighted histogram

svg(
  filename = "figures/Q2_weighted_histogram.svg",
  width = 10,
  height = 6
)

par(mar = c(8, 5, 4, 2))

barplot(
  weighted_counts,
  main = "Annual Earnings — Balochistan Urban",
  xlab = "",
  ylab = "Weighted frequency",
  col = "lightblue",
  border = "white",
  las = 2,
  cex.names = 0.65,
  cex.axis = 0.8
)

mtext(
  "Annual earnings (PKR)",
  side = 1,
  line = 6
)

dev.off()




# Convert the graph to a PNG image for viewing
install.packages("rsvg")


rsvg::rsvg_png(
  "figures/Q2_weighted_histogram.svg",
  "figures/Q2_weighted_histogram.png",
  width = 1000
)


# Q3: Earnings versus Age

# Calculate weighted mean earnings for each age
age_means <- analysis_data %>%
  group_by(age) %>%
  summarise(
    weighted_mean_earnings =
      weighted.mean(earn_annual, hhweight, na.rm = TRUE),
    .groups = "drop"
  )

# Save graph as SVG
svg(
  "figures/Q3_earnings_vs_age.svg",
  width = 9,
  height = 6
)

plot(
  age_means$age,
  age_means$weighted_mean_earnings,
  type = "b",
  pch = 19,
  col = "darkgreen",
  main = "Annual Earnings versus Age — Balochistan Urban",
  xlab = "Age (years)",
  ylab = "Weighted mean annual earnings (PKR)",
  cex.axis = 0.8
)

dev.off()

# Display age-band weighted means
age_band_means <- analysis_data %>%
  mutate(
    age_band = cut(
      age,
      breaks = seq(15, 65, by = 5),
      right = FALSE,
      include.lowest = TRUE,
      labels = paste(
        seq(15, 60, by = 5),
        seq(19, 64, by = 5),
        sep = "–"
      )
    )
  ) %>%
  group_by(age_band) %>%
  summarise(
    observations = n(),
    weighted_mean_earnings =
      weighted.mean(earn_annual, hhweight, na.rm = TRUE),
    .groups = "drop"
  )

print(age_band_means)


# Q4: Default plot and redesigned plot

# Default plot
svg("figures/Q4_default_plot.svg", width = 8, height = 5)

plot(
  age_means$age,
  age_means$weighted_mean_earnings
)

dev.off()

# Redesigned plot
svg("figures/Q4_redesigned_plot.svg", width = 9, height = 6)

par(mar = c(5, 5, 4, 2))

plot(
  age_means$age,
  age_means$weighted_mean_earnings,
  type = "b",
  pch = 19,
  lwd = 2,
  col = "darkgreen",
  main = "Annual Earnings Increase with Age, but Not Consistently",
  xlab = "Age (years)",
  ylab = "Weighted mean annual earnings (PKR)",
  cex.axis = 0.8
)

grid(col = "grey85")

dev.off()

# Display Q4 default plot

plot(age_means$age,
     age_means$weighted_mean_earnings)

# Display Q4 redesigned plot

par(mar = c(5, 5, 4, 2))

plot(age_means$age,
     age_means$weighted_mean_earnings,
     type = "b",
     pch = 19,
     lwd = 2,
     col = "darkgreen",
     main = "Annual Earnings Increase with Age, but Not Consistently",
     xlab = "Age (years)",
     ylab = "Weighted mean annual earnings (PKR)",
     cex.axis = 0.8)

grid(col = "grey85")

