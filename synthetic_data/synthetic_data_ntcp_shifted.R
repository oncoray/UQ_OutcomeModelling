n_samples <- 50L
csv_file <- r"(N:\fs1-MBRO\WORK\_LukasD\phIRO\example\synthetic_data\synthetic_data_shifted.csv)"

# In this problem, we predict radiopneumonitis (RP), which occurs in ca. 25% of
# patients. The data resembles those presented in Yakar et al. (2021)
# https://doi.org/10.1177/15330338211016373.
#
# Important features reported in that work are:
#
# - Max dose to 5% of lung volume (45 (8-66) Gy), i.e. when ordering voxels in
# a dose map by ascending dose, this is the least dose received by 5% of voxels
# with the highest dose. We assume that risk of RP increases with increasing D5.
#
# - Number of chemotherapy cycles prior to RT (3 (0-6) cycles). We assume that
# higher number of chemotherapy cycles corresponds to higher risk of RP (see
# 10.1097/COC.0b013e3181d6b40f). Concomitant chemotherapy was absent in ca. 40%
# of patients.
#
# - Gross tumour volume (90 (0-540) cc). We assume that risk of RP increases with
# larger GTV because of an increase in irradiated volume.
#
# Values are median plus min-max range. We will also assume interactions:
#
# - Higher GTV is positively correlated with higher max dose to 5% of lung volume.
#
# - Higher GTV is positively correlated with the number of chemotherapy cycles,
# with patients with lower GTV more likely to not receive concomitant
# chemotherapy.


# Generator functions ----------------------------------------------------------

# Define generator functions for features and outcome so that we can simply
# generate these values based on quantiles.

dose_fun <- function(x) {
  dose_y <- c(8,   45,  67)
  dose_q <- c(0.0, 0.5, 1.0)
  fun <- stats::splinefun(x = dose_q, y = dose_y, method = "hyman")
  
  # Add uncertainty to input for generating the dose: GTV ~ N(0, 0.05).
  x <- x + stats::rnorm(length(x), mean = 0.2, sd = 0.25)
  x[x < 0.0] <- 0.0
  x[x > 1.0] <- 1.0
  
  return(round(fun(x)))
}



gtv_fun <- function(x) {
  gtv_y <- c(10, 30, 90, 180, 550)
  gtv_q <- c(0.0, 0.25, 0.5, 0.75, 1.0)
  fun <- stats::splinefun(x = gtv_q, y = gtv_y, method = "hyman")
  
  # Add uncertainty to input for generating the GTV ~ N(0, 0.10).
  # Uncertainty is relatively large because of high interobserver variability in
  # segmenting GTV.
  x <- x + stats::rnorm(length(x), mean = -0.2, sd = 0.25)
  x[x < 0.0] <- 0.0
  x[x > 1.0] <- 1.0
  
  return(round(fun(x)))
}



n_cct_fun <- function(x) {
  n_cct_y <- c(0, 0,   3,   6.49)
  n_cct_q <- c(0, 0.4, 0.5, 1.0)
  fun <- stats::splinefun(x = n_cct_q, y = n_cct_y, method = "hyman")
  
  # Add uncertainty to input for generating the number of cycles ~ N(0, 0.05)
  x <- x + stats::rnorm(length(x), mean = 0.5, sd = 0.2)
  x[x < 0.0] <- 0.0
  x[x > 1.0] <- 1.0
  
  # Round to nearest integer.
  return(round(fun(x)))
}



rp_fun <- function(x) {
  rp_y <- c(0.0, 0.5, 1.0)
  rp_q <- c(0.0, 0.7, 1.0)
  fun <- stats::splinefun(x = rp_q, y = rp_y, method = "hyman")
  
  # Add uncertainty to radiopneumonitis -- this is both due to uncertainty in
  # measuring RP and variability in underlying processes giving rise to RP.
  x <- x + stats::rnorm(length(x), mean = 0.4, sd = 0.4)
  x[x < 0.0] <- 0.0
  x[x > 1.0] <- 1.0
  
  # Round to nearest integer.
  return(round(fun(x)))
}


# Experiment -------------------------------------------------------------------

# Set seed for reproducibility.
set.seed(9L)

# Draw quantiles for each sample based on a uniform distribution.
x <- stats::runif(n = n_samples)

data <- data.table::data.table(
  "dose_to_5_percent_of_lung_volume" = dose_fun(x),
  "gross_tumour_volume" = gtv_fun(x),
  "n_chemotherapy_cycles" = n_cct_fun(x),
  "radiopneumonitis" = rp_fun(x) 
)

data.table::fwrite(
  data,
  file = csv_file,
  sep = ";",
  dec = "."
)

