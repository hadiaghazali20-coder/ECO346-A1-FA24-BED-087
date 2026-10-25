
import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

# Folders
Path("figures").mkdir(exist_ok=True)

# Load datasets
persons = pd.read_csv("Data/pslm_person_subset.csv")
households = pd.read_csv("Data/pslm_hh_subset.csv")

# Join household information
data = persons.merge(
    households[["hhid", "hhweight", "prov_code", "urban_rural"]],
    on="hhid",
    how="left"
)

# Variant 7: Balochistan Urban
data = data[
    (data["prov_code"] == 4) &
    (data["urban_rural"] == 2) &
    (data["age"].between(15, 64)) &
    (data["earn_annual"] > 0) &
    (data["hhweight"].notna())
].copy()

# Create 5-year age bands
edges = list(range(15, 66, 5))
labels = [
    "15–19", "20–24", "25–29", "30–34", "35–39",
    "40–44", "45–49", "50–54", "55–59", "60–64"
]

data["age_band"] = pd.cut(
    data["age"],
    bins=edges,
    right=False,
    labels=labels
)

# Calculate weighted means independently
results = []

for band in labels:
    group = data[data["age_band"] == band]
    weighted_mean = (
        (group["earn_annual"] * group["hhweight"]).sum()
        / group["hhweight"].sum()
    )
    results.append({
        "age_band": band,
        "observations": len(group),
        "weighted_mean_earnings": weighted_mean
    })

table = pd.DataFrame(results)
print(table.round(2).to_string(index=False))

# Save table
table.to_csv("figures/Q5_age_band_means.csv", index=False)

# Create and save graph as SVG
plt.figure(figsize=(9, 6))
plt.plot(
    table["age_band"],
    table["weighted_mean_earnings"],
    marker="o"
)
plt.title("Weighted Mean Annual Earnings by Age Band — Balochistan Urban")
plt.xlabel("Age band (years)")
plt.ylabel("Weighted mean annual earnings (PKR)")
plt.xticks(rotation=45)
plt.grid(True, alpha=0.3)
plt.tight_layout()
plt.savefig("figures/Q5_age_band_means.svg", format="svg")
plt.close()

print("\nQ5 files saved in figures/")
