
library(tidyverse)
library(mc2d)

n_sample <- 50

set.seed(2605)
dummy_data <- tibble(kpi1 = rnorm(n_sample, mean = 4, sd = 0.5),
                     kpi2 = rlnorm(n_sample, meanlog = log(10), sdlog = log(2)),
                     kpi3 = runif(n_sample, min = 2, max = 11),
                     kpi4 = rpert(n_sample, min = 3, mode = 4, max = 6))

write_rds(dummy_data, "dummy-data.rds")

write_rds(list(kpi1 = 4, kpi2 = 7, kpi3 = 5, kpi4 = 3.5), "dummy-user-data.rds")
