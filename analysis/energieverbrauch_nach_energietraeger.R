library(tidyverse)
library(here)
library(glue)

# paths -------------------------------------------------------------------
path_data = here("data/mxqZdITUJnJTaI5f-donut-energiebilanz-1970-2020.csv")


# load data ---------------------------------------------------------------
data = read_delim(path_data, delim = ";") %>%
  janitor::clean_names()


# transform ---------------------------------------------------------------
data_wide = data %>%
  pivot_wider(
    names_from = text_1,
    values_from = wert
  )

data_wide_tj = data_wide %>%
  filter(
    kategorie == "Terajoule"
  )

data_wide_prozent = data_wide %>%
  filter(
    kategorie == "Prozent"
  )


data_wide_prozent %>%
  rowwise() %>%
  mutate(
   sum = sum(
     c_across(
       !matches("time|kategorie")
     )
   )
  ) %>% glimpse


j# path out ----------------------------------------------------------------
path_out_tj = here("output/energieverbrauch_nach_energietraeger/energieverbrauch_nach_energietraeger_tj.csv")
path_out_pro = here("output/energieverbrauch_nach_energietraeger/energieverbrauch_nach_energietraeger_pro.csv")
if(!dir.exists(dirname(path_out))){
  dir.create(dirname(path_out), recursive = T)
}

write_csv(data_wide_tj, path_out_tj)
write_csv(data_wide_prozent, path_out_pro)



# graph -------------------------------------------------------------------
ggplot(data %>% filter(kategorie=="Terajoule")) +
  geom_path(
    aes(
      x = time,
      y = wert,
      color = text_1
    )
  )

