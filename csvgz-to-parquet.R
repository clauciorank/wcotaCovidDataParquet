### Download wcota
temp <- tempfile()

download.file('https://github.com/wcota/covid19br/raw/master/cases-brazil-cities-time_changesOnly.csv.gz', temp)

data <- readr::read_csv(temp) |>
                       mutate(city = case_when(
                              grepl(pattern = 'CASO SEM LOCALIZAÇÃO DEFINIDA', city) ~ 'Todas',
                              TRUE ~ city)) |>
                      mutate(state = case_when(
                              grepl(pattern = 'TOTAL', state) ~ 'Todos',
                              TRUE ~ state))

arrow::write_parquet(data, 'cases-brazil-cities-time-changesonly.parquet')
