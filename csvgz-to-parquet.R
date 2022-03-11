### Download wcota
temp <- tempfile()

download.file('https://github.com/wcota/covid19br/raw/master/cases-brazil-cities-time_changesOnly.csv.gz', temp)

data <- readr::read_csv(temp)

arrow::write_parquet(data, 'cases-brazil-cities-time-changesonly.parquet')
