url = "https://ec.europa.eu/energy/observatory/reports/latest_prices_with_taxes.xlsx"
file = paste0(tempdir(), "/", "temp.xlsx")
download.file(url, file)
data = readxl::read_xlsx(file, sheet = 2)


# format data --------------------------------------------------------------
new_names = c("country", "price", "super95", "diesel", "heizöl")
data = data[,1:length(new_names)]
names(data) = new_names
data = data[!is.na(data$country) & !is.na(data$price), ]

new_data = lapply(seq_along(data), function(i){
  if(i != 1){
    ret = as.numeric(gsub(",", "", data[[i]]))
  }else{
    ret = data[[i]]
  }
  ret
})

new_data = as.data.frame(new_data)
new_data = setNames(new_data, names(data))
new_data = new_data[1:27, ]


# save data ---------------------------------------------------------------
today = as.Date(Sys.time())
tomorrow = today + 1

tdy = gsub("-", "_", today)
tmr = gsub("-","_", tomorrow)

fn = sprintf("output/weekly_fuel_prices/%s.csv", tdy)
dir = dirname(fn); if(!dir.exists(dir)) dir.create(dir)
write.csv(new_data, fn)
