library(dplyr)

### Download wcota
temp <- tempfile()

download.file('https://github.com/wcota/covid19br/raw/master/cases-brazil-cities-time_changesOnly.csv.gz', temp)

data <- readr::read_csv(temp)



data <- data |> filter(!grepl(pattern = 'CASO SEM LOCALIZAÇÃO DEFINIDA', city)) |>
                      mutate(state = case_when(
                              grepl(pattern = 'TOTAL', state) ~ 'Todos',
                              TRUE ~ state)) |>
                      mutate(city = case_when(
                              city == 'TOTAL' ~ 'Todas',
                              TRUE ~ city
                      )) |> select(date, state, city, newDeaths, deaths, newCases, totalCases)

data_todes <-
data |> group_by(date, state) |>
        summarise(newDeaths = sum(newDeaths),
                  deaths = sum(deaths),
                  newCases = sum(newCases),
                  totalCases = sum(totalCases)) |>
        filter(state != 'Todos') |>
        mutate(city = 'Todas')


data <- data |> bind_rows(data_todes)

arrow::write_parquet(data, 'cases-brazil-cities-time-changesonly.parquet')
