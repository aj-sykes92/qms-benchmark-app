
# benchmark violin plots with you-are-here
build_violin_plot <- function(user_benchmark, base_data) {
  
  nrow <- ncol(base_data)
  
  base_data <- base_data %>%
    gather(key = "kpi", value = "value")
  
  user_benchmark <- user_benchmark %>%
    enframe(name = "kpi", value = "value") %>%
    mutate(value = as.numeric(value))
  
  ggplot() +
    geom_violin(data = base_data,
                aes(x = kpi, y = value, fill = kpi)) +
    geom_point(data = user_benchmark,
               aes(x = kpi, y = value), colour = "black", size = 5) +
    facet_wrap(~kpi, nrow = nrow, scales = "free") +
    labs(x = "",
         y = "",
         fill = "") +
    theme_classic() +
    theme(axis.title.y = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          legend.position = "none") +
    coord_flip()
}

# mapped function to pull percentiles for user data
get_kpi_pctile <- function(user_benchmark, base_data) {
  
  base_data <- base_data %>%
    gather(key = "kpi", value = "value")
  
  user_benchmark <- user_benchmark %>%
    enframe(name = "kpi", value = "value") %>%
    mutate(value = as.numeric(value))
  
  map(user_benchmark, ~.x)
  
  pctiles <- map2_dbl(user_benchmark$kpi, user_benchmark$value, function(user_kpi, user_value) {
    raw <- base_data %>%
      filter(kpi == user_kpi) %>%
      pull(value)
    
    return(ecdf(raw)(user_value))
  })
  
  return(pctiles)
}

# build stats table for base data and user
build_stats <- function(user_benchmark, base_data) {
  
  summ <- base_data %>%
    gather(key = "KPI", value = "value") %>%
    group_by(KPI) %>%
    mutate(top = ifelse(value >= quantile(value, 0.66), value, NA),
           bottom = ifelse(value <= quantile(value, 0.33), value, NA)) %>%
    summarise(Average = mean(value),
              Minimum = min(value),
              Maximum = max(value),
              `Bottom Third` = mean(bottom, na.rm = T),
              `Top Third` = mean(top, na.rm = T),
              .groups = "drop") %>%
    mutate_at(vars(-KPI), ~round(., 2))
  
  user_summ <- user_benchmark %>%
    enframe(name = "KPI", value = "Your Value") %>%
    mutate(`Your Value` = as.numeric(`Your Value`)) %>%
    mutate(`Your Percentile` = get_kpi_pctile(user_benchmark, base_data))
  
  summ <- summ %>%
    left_join(user_summ, by = "KPI")
  
  return(summ)
}
