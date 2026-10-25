# ECO346-A1-FA24-BED-087

## ECO346 Assignment 1 — Data Visualization Techniques for Economists

**Registration Number:** FA24-BED-087

### Project Overview
This project analyzes annual earnings by age for the urban population of Balochistan using PSLM survey data. It demonstrates data cleaning, weighted descriptive statistics, data visualization, and reproducibility using R and Python.

### Research Tasks
- **Task 1:** Set up a public GitHub repository and organize project files.
- **Task 2:** Create a weighted histogram of annual earnings.
- **Task 3:** Analyze annual earnings by age and calculate weighted mean earnings for age bands.
- **Task 4:** Compare a default plot with a redesigned visualization.
- **Task 5:** Reproduce the age-band table and visualization independently in Python.

### Repository Structure
- `Data/` — PSLM person and household datasets.
- `scripts/` — Analysis and Python reproduction scripts.
- `figures/` — Generated plots and the age-band results table.
- `slides/` — Final presentation slides.

### Data and Method
The person-level and household-level PSLM datasets are joined using `hhid`. The analysis focuses on urban Balochistan (`prov_code = 4`, `urban_rural = 2`), individuals aged 15–64, and positive annual earnings. Household weights (`hhweight`) are used to calculate weighted statistics.

### Reproducibility
The R analysis uses the `tidyverse` package. The independent Python reproduction uses `pandas` and `matplotlib`. Required input datasets are stored in the `Data/` directory, scripts in `scripts/`, and output figures in `figures/`.

### Author
Registration Number: FA24-BED-087
