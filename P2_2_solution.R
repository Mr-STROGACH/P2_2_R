# =============================================================================
#  Практическая работа P2_2
#  «Основы обработки данных в R: базовый R и Tidyverse»
#  Курс: Информационно-аналитические технологии поиска угроз ИБ (i2z1.ddslab.ru)
#
#  Скрипт содержит решения всех четырёх частей работы.
#  Запуск:  Rscript P2_2_solution.R
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(nycflights13)
})

options(width = 160, tibble.print_max = 15, tibble.width = 160)

hr  <- function(title) cat("\n", strrep("=", 76), "\n", title, "\n", strrep("=", 76), "\n", sep = "")
sect <- function(title) cat("\n--- ", title, " ",
                            strrep("-", max(0, 58 - nchar(title))), "\n", sep = "")

# =============================================================================
# ЧАСТЬ 1. Базовый R
# Задания 1-9 — только базовый R, задание 10 — нативный пайп |>
# =============================================================================
hr("ЧАСТЬ 1. Базовый R")

## --- Задание 1 ---------------------------------------------------------------
sect("Задание 1: вектор heights и его класс")
heights <- c(172, 168, 181, 165, 190)
print(heights)
cat("class(heights):", class(heights), "\n")

## --- Задание 2 ---------------------------------------------------------------
sect("Задание 2: последовательности")
cat("оператор :        1:10            ->", 1:10, "\n")
cat("функция seq()     seq(1, 10)      ->", seq(1, 10), "\n")
cat("функция seq()     seq(0, 100, 10) ->", seq(0, 100, by = 10), "\n")
cat("identical(1:10, seq(1, 10)):", identical(1:10, seq(1, 10)), "\n")

## --- Задание 3 ---------------------------------------------------------------
sect("Задание 3: names() и обращение по имени")
names(heights) <- c("Анна", "Борис", "Вера", "Гриша", "Дина")
print(heights)
cat("heights[['Вера']] ->", heights[["Вера"]], "\n")

## --- Задание 4 ---------------------------------------------------------------
sect("Задание 4: три типа векторов и приведение типов")
v_num <- c(1.5, 2.5, 3.5)
v_chr <- c("один", "два", "три")
v_lgl <- c(TRUE, FALSE, TRUE)
cat("class(v_num) =", class(v_num), "| class(v_chr) =", class(v_chr),
    "| class(v_lgl) =", class(v_lgl), "\n")
cat("class(c(1, 'один')) ->", class(c(1, "один")), "\n")
print(c(1, "один"))

## --- Задание 5 ---------------------------------------------------------------
sect("Задание 5: индексация вектора")
cat("первый элемент            heights[1]              ->", heights[1], "\n")
cat("последний элемент         heights[length(heights)]->", heights[length(heights)], "\n")
cat("элементы со 2-го по 4-й   heights[2:4]            ->", heights[2:4], "\n")
cat("все, кроме первого        heights[-1]             ->", heights[-1], "\n")

## --- Задание 6 ---------------------------------------------------------------
sect("Задание 6: логическая индексация")
cat("heights > 170            ->", heights > 170, "\n")
cat("heights[heights > 170]   ->", heights[heights > 170], "\n")
cat("sum(heights > 170)       ->", sum(heights > 170), "\n")

## --- Задание 7 ---------------------------------------------------------------
sect("Задание 7: NA и среднее значение")
heights["Борис"] <- NA
print(heights)
cat("mean(heights)               ->", mean(heights), "\n")
cat("mean(heights, na.rm = TRUE) ->", mean(heights, na.rm = TRUE), "\n")

## --- Задание 8 ---------------------------------------------------------------
sect("Задание 8: список person")
person <- list(name = "Анна", height = 172, humanoid = TRUE)
str(person)
cat("через $        person$name        ->", person$name, "\n")
cat("по имени       person[['height']] ->", person[["height"]], "\n")
cat("по номеру      person[[3]]        ->", person[[3]], "\n")

## --- Задание 9 ---------------------------------------------------------------
sect("Задание 9: датафрейм df")
df <- data.frame(
  name   = c("Анна", "Борис", "Вера"),
  height = c(172, 168, 181),
  mass   = c(62, 74, 58)
)
str(df)
print(head(df))
cat("df$height    ->", df$height, "\n")
cat("df[['mass']] ->", df[["mass"]], "\n")

## --- Задание 10 --------------------------------------------------------------
sect("Задание 10: нативный пайп")
heights |> mean(na.rm = TRUE) |> round(digits = 1)

# =============================================================================
# ЧАСТЬ 2. Обработка данных starwars с помощью dplyr (конвейер %>%)
# =============================================================================
hr("ЧАСТЬ 2. starwars + dplyr")

## --- Задание 1 ---------------------------------------------------------------
sect("Задание 1: сколько строк в датафрейме")
starwars %>% nrow()

## --- Задание 2 ---------------------------------------------------------------
sect("Задание 2: сколько столбцов в датафрейме")
starwars %>% ncol()
starwars %>% names()

## --- Задание 3 ---------------------------------------------------------------
sect("Задание 3: примерный вид датафрейма")
starwars %>% glimpse()
starwars %>% head(4)

## --- Задание 4 ---------------------------------------------------------------
sect("Задание 4: сколько уникальных рас (species)")
starwars %>% distinct(species) %>% nrow()
starwars %>% filter(!is.na(species)) %>% distinct(species) %>% nrow()
starwars %>% count(species, sort = TRUE) %>% head(6)

## --- Задание 5 ---------------------------------------------------------------
sect("Задание 5: самый высокий персонаж")
starwars %>% filter(height == max(height, na.rm = TRUE)) %>% select(name, height, mass, species)

## --- Задание 6 ---------------------------------------------------------------
sect("Задание 6: все персонажи ниже 170 см")
starwars %>% filter(height < 170) %>% select(name, height) %>% print(n = 30)
starwars %>% filter(height < 170) %>% nrow()

## --- Задание 7 ---------------------------------------------------------------
sect("Задание 7: ИМТ = mass / (height / 100)^2")
starwars %>%
  mutate(bmi = mass / (height / 100)^2) %>%
  select(name, height, mass, bmi) %>%
  arrange(desc(bmi)) %>%
  head(10)

## --- Задание 8 ---------------------------------------------------------------
sect("Задание 8: 10 самых «вытянутых» (mass / height)")
starwars %>%
  mutate(stretch = mass / height) %>%
  arrange(desc(stretch)) %>%
  select(name, mass, height, stretch) %>%
  head(10)

## --- Задание 9 ---------------------------------------------------------------
sect("Задание 9: средний возраст (birth_year) по расам")
starwars %>%
  filter(!is.na(species)) %>%
  group_by(species) %>%
  summarise(mean_birth_year = mean(birth_year, na.rm = TRUE), n = n()) %>%
  arrange(mean_birth_year) %>%
  print(n = 40)

## --- Задание 10 --------------------------------------------------------------
sect("Задание 10: самый распространённый цвет глаз")
starwars %>% count(eye_color, sort = TRUE) %>% head(5)
starwars %>% count(eye_color, sort = TRUE) %>% slice(1) %>% pull(eye_color) %>%
  cat("Самый частый цвет глаз:", ., "\n")

## --- Задание 11 --------------------------------------------------------------
sect("Задание 11: средняя длина имени в каждой расе")
starwars %>%
  filter(!is.na(species)) %>%
  mutate(name_len = nchar(name)) %>%
  group_by(species) %>%
  summarise(mean_name_len = mean(name_len), n = n()) %>%
  arrange(desc(mean_name_len)) %>%
  print(n = 40)

# =============================================================================
# ЧАСТЬ 3. Авиарейсы Нью-Йорка: nycflights13 (конвейер %>%)
# =============================================================================
hr("ЧАСТЬ 3. nycflights13")

## --- Задание 1 ---------------------------------------------------------------
sect("Задание 1: сколько датафреймов в пакете nycflights13")
ds <- data(package = "nycflights13")$results[, "Item"]
ds <- base::sub(" .*$", "", ds)
print(ds)
length(ds)

## --- Задания 2-3 -------------------------------------------------------------
sect("Задания 2-3: строки и столбцы каждого датафрейма")
for (nm in ds) {
  d <- get(nm)
  cat(sprintf("%-10s : rows = %7d , cols = %2d\n", nm, nrow(d), ncol(d)))
}

## --- Задание 4 ---------------------------------------------------------------
sect("Задание 4: примерный вид датафрейма")
flights %>% glimpse()

## --- Задание 5 ---------------------------------------------------------------
sect("Задание 5: компании-перевозчики (carrier)")
airlines %>% nrow()
flights %>% distinct(carrier) %>% nrow()
airlines

## --- Задание 6 ---------------------------------------------------------------
sect("Задание 6: сколько рейсов принял JFK в мае")
# В nycflights13 собраны рейсы, ВЫЛЕТАЮЩИЕ из Нью-Йорка (origin = EWR/JFK/LGA),
# поэтому JFK встречается только в столбце origin, а в dest его нет вовсе:
flights %>% filter(dest == "JFK") %>% nrow()
flights %>% distinct(origin)
# «Принял» в смысле «обслужил» — считаем рейсы с origin = JFK за май:
flights %>% filter(origin == "JFK", month == 5) %>% nrow()

## --- Задание 7 ---------------------------------------------------------------
sect("Задание 7: самый северный аэропорт")
airports %>% arrange(desc(lat)) %>% select(faa, name, lat, lon) %>% head(3)
# Проверка аномалии: у некоторых аэропортов широта и долгота перепутаны местами.
airports %>% filter(lon > 0) %>% select(faa, name, lat, lon)
# EEN (Dillant Hopkins, Кин, Нью-Гэмпшир) в действительности 42.9N 72.3W,
# поэтому реально самый северный — BRW (Уткиагвик, Аляска), 71.3N:
airports %>% filter(faa %in% c("EEN", "BRW")) %>% select(faa, name, lat, lon)

## --- Задание 8 ---------------------------------------------------------------
sect("Задание 8: самый высокогорный аэропорт")
airports %>% arrange(desc(alt)) %>% select(faa, name, alt) %>% head(3)

## --- Задание 9 ---------------------------------------------------------------
sect("Задание 9: бортовые номера самых старых самолётов")
planes %>% filter(year == min(year, na.rm = TRUE)) %>% select(tailnum, year, manufacturer, model)
cat("пропусков в planes$year:", planes %>% filter(is.na(year)) %>% nrow(), "\n")
planes %>% filter(!is.na(year)) %>% count(year) %>% arrange(year) %>% head(4)

## --- Задание 10 --------------------------------------------------------------
sect("Задание 10: средняя температура сентября в JFK, °C")
weather %>%
  filter(origin == "JFK", month == 9) %>%
  summarise(mean_temp_F = mean(temp, na.rm = TRUE),
            mean_temp_C = mean((temp - 32) * 5 / 9, na.rm = TRUE),
            n_obs = n())

## --- Задание 11 --------------------------------------------------------------
sect("Задание 11: больше всего вылетов в июне")
flights %>%
  filter(month == 6) %>%
  count(carrier, sort = TRUE) %>%
  left_join(airlines, by = "carrier") %>%
  head(5)

## --- Задание 12 --------------------------------------------------------------
sect("Задание 12: кто задерживался чаще других в 2013 году")
flights %>%
  filter(!is.na(dep_delay), dep_delay > 0) %>%
  count(carrier, sort = TRUE) %>%
  left_join(airlines, by = "carrier") %>%
  head(5)

flights %>%
  group_by(carrier) %>%
  summarise(mean_dep_delay = mean(dep_delay, na.rm = TRUE),
            n_delayed = sum(dep_delay > 0, na.rm = TRUE)) %>%
  left_join(airlines, by = "carrier") %>%
  arrange(desc(mean_dep_delay)) %>%
  head(5)

## --- Задание 13 --------------------------------------------------------------
sect("Задание 13: inner_join flights + airlines")
flights %>%
  inner_join(airlines, by = "carrier") %>%
  count(name, sort = TRUE) %>%
  head(5)

## --- Задание 14 --------------------------------------------------------------
sect("Задание 14: топ-5 аэропортов по средней задержке прибытия")
flights %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  filter(!is.na(arr_delay)) %>%
  group_by(dest, name) %>%
  summarise(mean_arr_delay = mean(arr_delay), n = n(), .groups = "drop") %>%
  arrange(desc(mean_arr_delay)) %>%
  head(5)

## --- Задание 15 --------------------------------------------------------------
sect("Задание 15: задержка вылета в зависимости от силы ветра")
flights %>%
  inner_join(weather, by = c("year", "month", "day", "origin", "hour", "time_hour")) %>%
  mutate(wind_cat = case_when(
    wind_speed < 10  ~ "до 10 миль/ч",
    wind_speed <= 20 ~ "10-20 миль/ч",
    wind_speed > 20  ~ "свыше 20 миль/ч",
    TRUE             ~ "нет данных"
  )) %>%
  group_by(wind_cat) %>%
  summarise(mean_dep_delay = mean(dep_delay, na.rm = TRUE), n = n(), .groups = "drop")

# =============================================================================
# ЧАСТЬ 4. Нативный пайп |> и пайп Tidyverse %>%
# =============================================================================
hr("ЧАСТЬ 4. Сравнение пайпов")

## --- Задание 1 ---------------------------------------------------------------
sect("Задание 1: средняя масса персонажей двумя способами")
mass_native <- starwars$mass |> mean(na.rm = TRUE) |> round(2)
mass_magrittr <- starwars$mass %>% mean(na.rm = TRUE) %>% round(2)
cat("нативный пайп  |> :", mass_native, "\n")
cat("пайп Tidyverse %>%:", mass_magrittr, "\n")
cat("результаты совпадают:", identical(mass_native, mass_magrittr), "\n")

## --- Задание 2 ---------------------------------------------------------------
sect("Задание 2: имена, содержащие подстроку Sky")
starwars$name %>% grepl("Sky", .) %>% sum()
starwars$name |> grepl("Sky", x = _) |> sum()
starwars %>% filter(grepl("Sky", name)) %>% select(name)

## --- Задание 3 ---------------------------------------------------------------
sect("Задание 3: вызов функции без скобок")
starwars$height %>% mean()          # magrittr: функция без скобок допустима

# Нативный пайп требует именно ВЫЗОВ функции справа, причём это проверяется
# на этапе разбора кода, поэтому ошибку нельзя поймать обычным tryCatch():
native_pipe_code <- "starwars$height |> mean"
err <- tryCatch(eval(parse(text = native_pipe_code)),
                error = function(e) conditionMessage(e))
cat("starwars$height |> mean  ->  ОШИБКА:", err, "\n")
starwars$height |> mean()
starwars$height |> mean(na.rm = TRUE)

## --- Задание 4 ---------------------------------------------------------------
sect("Задание 4: именованный вектор через setNames")
c("luke", "vader") %>% setNames(., .)
c("luke", "vader") |> setNames(nm = _)

## --- Задание 5 ---------------------------------------------------------------
sect("Задание 5: одна и та же задача, записанная двумя пайпами")
starwars |> subset(!is.na(height)) |> with(mean(height)) |> round(1)
starwars %>% filter(!is.na(height)) %>% summarise(m = round(mean(height), 1)) %>% pull(m)
c("Luke Skywalker", "Darth Vader") %>% grepl("Sky", .)
c("Luke Skywalker", "Darth Vader") |> grepl("Sky", x = _)

hr("ГОТОВО")
sessionInfo()
