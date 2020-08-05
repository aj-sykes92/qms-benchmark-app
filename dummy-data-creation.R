
library(tidyverse)
library(mc2d)

# dummy data for app
n_sample <- 50

# actual kpi (only one that's not fake) -- calves reared per 100 cows
calf_rear_pc <- rpert(n = n_sample, mode = 87, min = 72, max = 110, shape = 30)

# add in min and max to make it realistic
calf_rear_pc[1:2] <- c(72, 101)

set.seed(2605)
dummy_data <- tibble(`Calves reared per 100 cows` = calf_rear_pc,
                     kpi2 = rlnorm(n_sample, meanlog = log(10), sdlog = log(2)),
                     kpi3 = runif(n_sample, min = 2, max = 11),
                     kpi4 = rpert(n_sample, min = 3, mode = 4, max = 6))

write_rds(dummy_data, "dummy-data.rds")

# dummy data to show SAC
dummy_data_example <- tibble(farm_id = paste0("farm_", rep(1:10)),
                             type_id = c(rep("lfa_upland_suckler_wean", 3), 
                                         rep("rear_finish", 3),
                                         rep("lfa_hill_ewe", 4)),
                             kpi_id = rep("kpi1", 10),
                             kpi_units = rep("kpi_unit", 10),
                             kpi_value = rnorm(10, 10, 2))

write_csv(dummy_data_example, "example-data.csv")
