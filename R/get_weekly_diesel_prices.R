url = "https://ec.europa.eu/energy/observatory/reports/latest_prices_with_taxes.xlsx"
file = paste0(tempdir(), "/", "temp.xlsx")
download.file(url, file)
data = readxl::read_xlsx(file, sheet = 2)


# format data --------------------------------------------------------------
new_names = c("country", "price", "super95", "diesel", "heizöl")
data = data[,1:length(new_names)]
names(data) = new_names
data = data[!is.na(data$country) & !is.na(data$price), ]


# save data ---------------------------------------------------------------
today = as.Date(Sys.time())
tomorrow = today + 1

tdy = gsub("-", "_", today)
tmr = gsub("-","_", tomorrow)

fn = here(sprintf("output/weekly_fuel_prices/%s.csv", tdy))
dir = dirname(fn); if(!dir.exists(dir)) dir.create(dir)
write.csv(data, fn)
