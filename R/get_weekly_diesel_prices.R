url = "https://ec.europa.eu/energy/observatory/reports/latest_prices_with_taxes.xlsx"
file = paste0(tempdir(), "/", "temp.xlsx")
download.file(url, file)
data = readxl::read_xlsx(file, sheet = 2)


# format data --------------------------------------------------------------
new_names = c("country", "price", "super95", "diesel", "heizöl")
data = data[,1:length(new_names)]
names(data) = new_names
data = data[!is.na(data$country) & !is.na(data$price), ]
print(data)
