library(tidyverse)
library(here)
library(glue)


# paths -------------------------------------------------------------------
out_path = here("output/aggm/graphs");
if(!dir.exists(out_path)){
  dir.create(out_path, recursive = T)
}

# get data ----------------------------------------------------------------
path = here("data/aggm/Timeseries_Export_2022-07-25T08-58-27.xlsx")
formatted = read_aggm_excel_export(path)


# remove cols with state --------------------------------------------------
data = formatted %>%
  select(!matches("state"))

data_long = data %>%
  pivot_longer(cols = 2:ncol(.),
               names_to = "variable",
               values_to = "values")


# plot it -----------------------------------------------------------------

ggplot(data_long) +
  geom_line(aes(x = date,
                y = values,
                group = variable)) +
  facet_wrap( ~ variable, ncol = 1, scales = "free_y") +
  theme_minimal() -> pl

out_path = here(out_path, "variables_2021_2022.png")
ggsave(out_path, pl, width=12, height=20)
