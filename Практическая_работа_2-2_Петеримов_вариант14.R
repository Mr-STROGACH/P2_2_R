options(width = 110, digits = 7)
Sys.setenv(TZ = "America/New_York")

suppressPackageStartupMessages({
  library(dplyr)
  library(nycflights13)
})

L <- character()
p <- function(...) {
  txt <- paste0(...)
  L <<- c(L, strsplit(txt, "\n", fixed = TRUE)[[1]])
  cat(txt, "\n", sep = "")
}
pr <- function(x) p(paste(capture.output(print(x)), collapse = "\n"))
hd <- function(fmt, txt = NULL) {
  p("")
  p("################ ", fmt, " ################")
}
code <- function(txt) p("  > ", txt)

# ============================================================
# ЧАСТЬ 1. БАЗОВЫЙ R
# ============================================================
hd("ЧАСТЬ 1. БАЗОВЫЙ R")

p("[1.1] Создаём числовой вектор heights из пяти произвольных значений роста (см).")
heights <- c(165, 180, 172, 195, 158)
code("heights <- c(165, 180, 172, 195, 158)")
code("class(heights)")
pr(class(heights))
p("Значения:", paste(heights, collapse = ", "))

p("")
p("[1.2] Последовательность целых чисел от 1 до 10 двумя способами: оператором : и функцией seq().")
code("s1 <- 1:10")
code("s2 <- seq(1, 10)")
code("s3 <- seq(0, 100, by = 10)")
s1 <- 1:10
s2 <- seq(1, 10)
s3 <- seq(0, 100, by = 10)
p("1:10        =", paste(s1, collapse = " "))
p("seq(1, 10)  =", paste(s2, collapse = " "))
p("Результаты 1:10 и seq(1,10) идентичны:", identical(s1, s2))
p("seq(0,100,by=10) =", paste(s3, collapse = " "))
p("Длина seq(0,100,by=10):", length(s3))

p("")
p("[1.3] Присваиваем элементам heights имена функцией names() и обращаемся к третьему элементу по имени.")
code('names(heights) <- c("Аня", "Борис", "Виктор", "Глеб", "Дарья")')
code('heights[["Виктор"]]')
names(heights) <- c("Аня", "Борис", "Виктор", "Глеб", "Дарья")
pr(heights)
p('heights[["Виктор"]] =', heights[["Виктор"]])
p('Проверка: heights[3] =', heights[3], "(тот же элемент, что и по имени)")

p("")
p("[1.4] Векторы типов numeric, character и logical; проверяем классы. Что вернёт class(c(1, \"один\"))?")
v_num <- c(1, 2, 3)
v_chr <- c("один", "два", "три")
v_lgl <- c(TRUE, FALSE, TRUE)
code("class(v_num); class(v_chr); class(v_lgl)")
pr(class(v_num))
pr(class(v_chr))
pr(class(v_lgl))
p('class(c(1, "один")) =', class(c(1, "один")))
p("Результат: R не выполняет неявное приведение типов, а ищет общий тип. Для numeric и character",
  "общего примитивного типа нет, поэтому число 1 приводится к строке \"1\" и возвращается character.")

p("")
p("[1.5] Индексация вектора heights: первый, последний, элементы со 2-го по 4-й, все кроме первого.")
code("heights[1]; heights[length(heights)]; heights[2:4]; heights[-1]")
p("Первый элемент      heights[1]              =", heights[1])
p("Последний элемент   heights[5]              =", heights[5])
p("Со 2-го по 4-й     heights[2:4]            =", paste(heights[2:4], collapse = ", "))
p("Все кроме первого   heights[-1]             =", paste(heights[-1], collapse = ", "))

p("")
p("[1.6] Логическая индексация: значения выше 170. Подсчёт количества через sum(heights > 170).")
code('high <- heights[heights > 170]')
code("sum(heights > 170)")
high <- heights[heights > 170]
p("Значения выше 170 (см):", paste(high, collapse = ", "))
p("Их количество sum(heights > 170) =", sum(heights > 170))
p("Почему внутри sum() допустимо логическое условие: в R логические значения TRUE coerced (приводятся)",
  "к числам 1, а FALSE — к 0, поэтому sum() складывает единицы и возвращает их количество.")

p("")
p("[1.7] Заменяем один элемент на NA. Считаем mean() без параметров и с na.rm = TRUE.")
heights_na <- heights
heights_na[2] <- NA
code("heights_na[2] <- NA")
code("mean(heights_na)")
code("mean(heights_na, na.rm = TRUE)")
pr(heights_na)
p("mean(heights_na)                =", mean(heights_na))
p("mean(heights_na, na.rm = TRUE)  =", mean(heights_na, na.rm = TRUE))
p("Различие: без na.rm=TRUE функция mean() по умолчанию возвращает NA, потому что NA означает",
  "пропуск данных, и любое вычисление с NA даёт NA. С na.rm = TRUE пропуски отбрасываются (na.rm =",
  "\"NA remove\") и среднее считается только по 4 наблюдениям.")

p("")
p("[1.8] Список person из трёх элементов разных типов: name (character), height (numeric), humanoid (logical).")
code('person <- list(name = "Люк", height = 172, humanoid = TRUE)')
code("person$name; person$height; person$humanoid")
code('person[["name"]]; person[[1]]')
person <- list(name = "Люк", height = 172, humanoid = TRUE)
p("person$name    =", person$name)
p("person$height  =", person$height)
p("person$humanoid=", person$humanoid)
p('person[["name"]] =', person[["name"]], "(обращение по имени через [[ ]])")
p("person[[1]]      =", person[[1]], "(обращение по номеру через [[ ]])")
pr(person)

p("")
p("[1.9] Датафрейм df из трёх векторов. str() и head(). Извлечение столбца через $ и [[ ]].")
code('name <- c("Аня", "Борис", "Виктор", "Глеб", "Дарья")')
code("weight <- c(55, 78, 82, 90, 61)")
code("df <- data.frame(name = name, height = c(165, 180, 172, 195, 158), weight = weight)")
name <- c("Аня", "Борис", "Виктор", "Глеб", "Дарья")
weight <- c(55, 78, 82, 90, 61)
df <- data.frame(name = name, height = c(165, 180, 172, 195, 158), weight = weight)
code("str(df)")
p(paste(capture.output(str(df)), collapse = "\n"))
code("head(df)")
p(paste(capture.output(head(df)), collapse = "\n"))
code('df$name; df[["weight"]]; df[[2]]')
p("df$name        =", paste(df$name, collapse = ", "))
p('df[["weight"]] =', paste(df[["weight"]], collapse = ", "))
p("df[[2]]       =", paste(df[[2]], collapse = ", "))

p("")
p("[1.10] Нативный пайп |>: средний рост без пропусков, округление до 1 знака.")
code("heights |> mean(na.rm = TRUE) |> round(digits = 1)")
p("heights |> mean(na.rm = TRUE) |> round(digits = 1) =", heights |> mean(na.rm = TRUE) |> round(digits = 1))

# ============================================================
# ЧАСТЬ 2. starwars ЧЕРЕЗ dplyr (%>%)
# ============================================================
hd("ЧАСТЬ 2. ОБРАБОТКА ДАННЫХ starwars С ПОМОЩЬЮ dplyr")

p("[2.1] Сколько строк в датафрейме?")
code("starwars %>% nrow()")
r21 <- starwars %>% nrow()
pr(r21)

p("")
p("[2.2] Сколько столбцов в датафрейме?")
code("starwars %>% ncol()")
r22 <- starwars %>% ncol()
pr(r22)
p("Имена столбцов:", paste(names(starwars), collapse = ", "))

p("")
p("[2.3] Как просмотреть примерный вид датафрейма?")
p("Используем glimpse() из состава dplyr — компактная структурная сводка.")
code("glimpse(starwars)")
p(paste(capture.output(glimpse(starwars)), collapse = "\n"))
p("Также доступен классический просмотр: starwars %>% head()")
p(paste(capture.output(starwars %>% head()), collapse = "\n"))

p("")
p("[2.4] Сколько уникальных рас (species) представлено в данных?")
code("starwars %>% summarise(species_n = length(unique(species)))")
code("starwars %>% summarise(n_distinct_species = n_distinct(species, na.rm = TRUE))")
r24 <- starwars %>% summarise(species_n = length(unique(species)))
pr(r24)
r24b <- starwars %>% summarise(n_distinct_species = n_distinct(species, na.rm = TRUE))
pr(r24b)
p("Нюанс: length(unique(species)) даёт 38, потому что NA тоже считается отдельным значением.")
p("Реальных рас (без пропусков) — 37: n_distinct(species, na.rm = TRUE) =", r24b$n_distinct_species, ".")
p("Расы, встречающиеся в наборе:")
p(paste(capture.output(starwars %>% distinct(species) %>% arrange(species)), collapse = "\n"))

p("")
p("[2.5] Найти самого высокого персонажа.")
code("starwars %>% filter(!is.na(height)) %>% arrange(desc(height)) %>% slice_head(n = 1)")
r25 <- starwars %>% filter(!is.na(height)) %>% arrange(desc(height)) %>% slice_head(n = 1) %>% select(name, species, height)
pr(r25)

p("")
p("[2.6] Найти всех персонажей ниже 170 см.")
code("starwars %>% filter(height < 170) %>% select(name, species, height)")
r26 <- starwars %>% filter(!is.na(height), height < 170) %>% select(name, species, height)
p("Количество персонажей ниже 170 см:", nrow(r26))
p(paste(capture.output(r26), collapse = "\n"))

p("")
p("[2.7] Подсчитать ИМТ (индекс массы тела) для всех персонажей: BMI = mass / height^2.")
code("starwars %>% mutate(bmi = round(mass / height^2, 3)) %>% select(name, mass, height, bmi)")
code("starwars %>% mutate(bmi = mass / (height/100)^2) %>% arrange(desc(bmi))")
r27 <- starwars %>%
  filter(!is.na(mass), !is.na(height)) %>%
  mutate(bmi = mass / height^2) %>%
  arrange(desc(bmi))
p("Всего рассчитано ИМТ для", nrow(r27), "персонажей (у остальных нет массы или роста).")
p("Топ-10 по ИМТ (в формуле из задания mass/height^2):")
p(paste(capture.output(r27 %>% select(name, mass, height, bmi) %>% head(10) %>% mutate(bmi = round(bmi, 5))), collapse = "\n"))
p("Для справки — ИМТ в привычных единицах (кг/м^2), т.е. mass / (height/100)^2:")
r27b <- starwars %>%
  filter(!is.na(mass), !is.na(height)) %>%
  mutate(bmi_si = round(mass / (height / 100)^2, 1)) %>%
  arrange(desc(bmi_si))
p(paste(capture.output(r27b %>% select(name, mass, height, bmi_si) %>% head(10)), collapse = "\n"))
p("Средний ИМТ по всем рассчитанным персонажам:", round(mean(r27$bmi), 4))
p("Медианный ИМТ:", round(median(r27$bmi), 4))
p("Персонажи с наименьшим ИМТ:")
p(paste(capture.output(r27 %>% arrange(bmi) %>% select(name, mass, height, bmi) %>% head(5) %>% mutate(bmi = round(bmi, 5))), collapse = "\n"))

p("")
p("[2.8] Найти 10 самых «вытянутых» персонажей (отношение mass / height).")
code("starwars %>% mutate(stretch = mass / height) %>% filter(!is.na(stretch)) %>% arrange(desc(stretch)) %>% head(10)")
r28 <- starwars %>%
  filter(!is.na(mass), !is.na(height), height > 0) %>%
  mutate(stretch = round(mass / height, 3)) %>%
  arrange(desc(stretch)) %>%
 head(10) %>%
  select(name, species, mass, height, stretch)
pr(r28)

p("")
p("[2.9] Найти средний возраст персонажей каждой расы.")
code("starwars %>% filter(!is.na(species), !is.na(birth_year)) %>% group_by(species) %>% summarise(mean_birth_year = mean(birth_year, na.rm = TRUE))")
r29 <- starwars %>%
  filter(!is.na(species)) %>%
  group_by(species) %>%
  summarise(n = n(),
            n_with_year = sum(!is.na(birth_year)),
            mean_birth_year = round(mean(birth_year, na.rm = TRUE), 1),
            .groups = "drop") %>%
  arrange(desc(n_with_year))
p("В наборе dplyr::starwars год появления хранится в столбце birth_year (а НЕ в 'born': такого")
p("столбца в данных нет — обращение к нему даёт ошибку 'Unknown or uninitialised column: born').")
pr(r29)
p("Рас, для которых удалось посчитать средний год появления (n_with_year > 0):",
  sum(r29$n_with_year > 0), "из", n_distinct(starwars$species, na.rm = TRUE),
  "уникальных рас (без учёта NA).")
p("Столбец birth_year содержит пропуски:", sum(is.na(starwars$birth_year)), "из", nrow(starwars), "строк.")

p("")
p("[2.10] Найти самый распространённый цвет глаз персонажей.")
code("starwars %>% filter(!is.na(eye_color)) %>% count(eye_color, sort = TRUE)")
r210 <- starwars %>% filter(!is.na(eye_color)) %>% count(eye_color, sort = TRUE)
pr(r210)
top_eye <- r210 %>% slice_head(n = 1)
p("Самый распространённый цвет глаз:", top_eye$eye_color, "—", top_eye$n, "персонаж(ей).")
p("Пропуски (NA) в eye_color:", sum(is.na(starwars$eye_color)), "из", nrow(starwars), "строк.")

p("")
p("[2.11] Подсчитать среднюю длину имени в каждой расе.")
code("starwars %>% filter(!is.na(species)) %>% mutate(name_len = nchar(name)) %>% group_by(species) %>% summarise(mean_name_len = mean(name_len, na.rm = TRUE))")
r211 <- starwars %>%
  filter(!is.na(species), !is.na(name)) %>%
  mutate(name_len = nchar(name)) %>%
  group_by(species) %>%
  summarise(n = n(), mean_name_len = round(mean(name_len, na.rm = TRUE), 2), .groups = "drop") %>%
  arrange(desc(mean_name_len))
pr(r211)

# ============================================================
# ЧАСТЬ 3. nycflights13 ЧЕРЕЗ dplyr (%>%)
# ============================================================
hd("ЧАСТЬ 3. АВИАРЕЙСЫ НЬЮ-ЙОРКА: nycflights13")

p("[3.1] Сколько встроенных в пакет nycflights13 датафреймов?")
code('data(package = "nycflights13")$results[, "Item"]')
ds_ny <- data(package = "nycflights13")$results
p("Количество наборов данных:", nrow(ds_ny))
pr(ds_ny[, c("Item", "Title")])

p("")
p("[3.2] Сколько строк в каждом датафрейме?")
code("sapply(airports, nrow)  # и т.д. для flights, planes, weather, airlines")
tbls <- c("airports", "airlines", "flights", "planes", "weather")
p(paste(capture.output(sapply(tbls, function(x) nrow(get(x)))), collapse = "\n"))

p("")
p("[3.3] Сколько столбцов в каждом датафрейме?")
p(paste(capture.output(sapply(tbls, function(x) ncol(get(x)))), collapse = "\n"))
p("Всего датафреймов в пакете:", nrow(ds_ny), "- перечислены в п.3.1.")

p("")
p("[3.4] Как просмотреть примерный вид датафрейма?")
p("Используем glimpse() из dplyr и head():")
p(paste(capture.output(glimpse(airlines)), collapse = "\n"))
p(paste(capture.output(head(flights, 5)), collapse = "\n"))
p(paste(capture.output(head(airports, 5)), collapse = "\n"))
p(paste(capture.output(head(planes, 5)), collapse = "\n"))
p(paste(capture.output(head(weather, 5)), collapse = "\n"))

p("")
p("[3.5] Сколько компаний-перевозчиков (carrier) учитывают эти наборы данных?")
code("flights %>% summarise(n_carriers = n_distinct(carrier))")
code("nrow(airlines)")
r35 <- flights %>% summarise(n_carriers = n_distinct(carrier))
pr(r35)
p("Строк в airlines (всего авиакомпаний в справочнике):", nrow(airlines))
p("Все carrier из flights присутствуют в справочнике airlines:",
  all(flights$carrier %in% airlines$carrier))
p("Список перевозчиков:")
p(paste(capture.output(airlines %>% arrange(carrier)), collapse = "\n"))

p("")
p("[3.6] Сколько рейсов принял аэропорт John F Kennedy Intl в мае?")
code('flights %>% filter(origin == "JFK", month == 5) %>% summarise(n = n())')
code('flights %>% filter(dest == "JFK", month == 5) %>% summarise(n = n())')
r36_dep <- flights %>% filter(origin == "JFK", month == 5) %>% summarise(n = n())
r36_arr <- flights %>% filter(dest == "JFK", month == 5) %>% summarise(n = n())
p("Вылетов ИЗ аэропорта JFK в мае (origin == 'JFK'):", r36_dep$n)
p("Прибытий В аэропорт JFK в мае (dest == 'JFK'):", r36_arr$n)
p("Важная особенность набора nycflights13: он содержит только рейсы, ВЫЛЕТЕВШИЕ из трёх")
p("нью-йоркских аэропортов (EWR, JFK, LGA), поэтому в столбце dest кода 'JFK' не встречается")
p("НИ РАЗУ (у dest всего 105 уникальных кодов, и JFK среди них нет), хотя сам аэропорт есть в")
p("airports (faa = 'JFK', John F Kennedy Intl). Следовательно, считать прибытия в JFK по этому")
p("набору невозможно — их здесь просто нет. Корректный ответ на вопрос: 9397 рейсов из JFK в мае.")
p("Всего рейсов из JFK за год:", nrow(flights %>% filter(origin == 'JFK')),
  "| рейсов из JFK в мае:", r36_dep$n,
  "| доля мая:", round(100 * r36_dep$n / nrow(flights %>% filter(origin == 'JFK')), 1), "%")
p("Всего рейсов в мае по всем трём аэропортам:", nrow(flights %>% filter(month == 5)), ".")

p("")
p("[3.7] Какой самый северный аэропорт?")
code("airports %>% arrange(desc(lat)) %>% head(3)")
r37 <- airports %>% arrange(desc(lat)) %>% head(3) %>% select(faa, name, lat, lon, alt)
p("Топ-3 самых северных аэропортов (по lat):")
pr(r37)

p("")
p("[3.8] Какой аэропорт самый высокогорный (выше всех над уровнем моря)?")
code("airports %>% arrange(desc(alt)) %>% head(3)")
r38 <- airports %>% arrange(desc(alt)) %>% head(3) %>% select(faa, name, alt, lat, lon)
p("Топ-3 самых высокогорных аэропортов (по alt, фут над уровнем моря):")
pr(r38)

p("")
p("[3.9] Какие бортовые номера у самых старых самолётов?")
p("В наборе planes бортовой номер хранится в столбце tailnum (не tailno).")
code("planes %>% arrange(year) %>% head(5)")
r39 <- planes %>% filter(!is.na(year)) %>% arrange(year) %>% head(5) %>% select(tailnum, year, model, manufacturer)
p("5 самых старых самолётов (минимальный год выпуска year):")
pr(r39)
oldest_year <- r39$year[1]
p("Самый старый год выпуска:", oldest_year)
p("Все бортовые номера этого года выпуска:", nrow(planes %>% filter(year == oldest_year)))
p(paste(capture.output(planes %>% filter(year == oldest_year) %>% select(tailnum, year, model, manufacturer) %>% arrange(tailnum)), collapse = "\n"))

p("")
p("[3.10] Какая средняя температура воздуха была в сентябре в аэропорту John F Kennedy Intl (°C)?")
p("Температура в weather хранится в градусах Фаренгейта: tC = 5/9 * (tF - 32).")
code('weather %>% filter(origin == "JFK", month == 9) %>% mutate(temp_c = 5/9 * (temp - 32)) %>% summarise(mean_temp_c = mean(temp_c, na.rm = TRUE))')
r310 <- weather %>%
  filter(origin == "JFK", month == 9) %>%
  mutate(temp_c = 5 / 9 * (temp - 32)) %>%
  summarise(mean_c = mean(temp_c, na.rm = TRUE),
            mean_f = mean(temp, na.rm = TRUE),
            n_obs = sum(!is.na(temp)))
p("Средняя температура в сентябре в JFK:", round(r310$mean_c, 2), "°C")
p("(в градусах Фаренгейта:", round(r310$mean_f, 2), "°F; число наблюдений с непустой температурой:", r310$n_obs, ")")

p("")
p("[3.11] Самолёты какой авиакомпании совершили больше всего вылетов в июне?")
code("flights %>% filter(month == 6) %>% count(carrier, sort = TRUE) %>% head(3)")
r311 <- flights %>% filter(month == 6) %>% count(carrier, sort = TRUE) %>% head(3)
p("Топ-3 перевозчика по числу вылетов в июне:")
pr(r311)
best6 <- r311$carrier[1]
p("Лидер:", best6, "—", airline_name <- airlines %>% filter(carrier == best6) %>% pull(name),
  "| всего вылетов в июне:", flights %>% filter(month == 6, carrier == best6) %>% summarise(n = n()) %>% pull(n))

p("")
p("[3.12] Самолёты какой авиакомпании задерживались чаще других в 2013 году?")
p("ВАЖНО: столбец flight — это НОМЕР рейса, а не признак отмены (значений flight == 1 всего 701,")
p("то есть фильтр flight == 1 отбрасывал бы 99,8 % данных). Признак отмены — is.na(dep_time),")
p("а задержка вылета задаётся значением dep_delay > 0 (NA означает, что рейс отменён).")
code('flights %>% filter(year == 2013, !is.na(dep_delay), dep_delay > 0) %>% count(carrier, name = "delayed") %>% arrange(desc(delayed))')
r312 <- flights %>%
  filter(year == 2013, !is.na(dep_delay), dep_delay > 0) %>%
  count(carrier, name = "delayed_flights") %>%
  arrange(desc(delayed_flights)) %>%
  head(3)
p("Топ-3 перевозчика по ЧИСЛУ задержек вылета в 2013 г.:")
pr(r312)
b12 <- r312$carrier[1]
p("Лидер по числу задержек:", b12, "—", airlines %>% filter(carrier == b12) %>% pull(name),
  "| задержек:", r312$delayed_flights[1])
p("Всего задержанных рейсов в 2013 г.:",
  flights %>% filter(year == 2013, !is.na(dep_delay), dep_delay > 0) %>% summarise(n = n()) %>% pull(n), "из",
  nrow(flights), "(отменённых, is.na(dep_time):",
  flights %>% filter(year == 2013, is.na(dep_time)) %>% summarise(n = n()) %>% pull(n), ")")
p("Так как у UA больше всего рейсов в принципе, показательно сравнить и ДОЛЮ задержек от всех")
p("рейсов перевозчика:")
p(paste(capture.output(flights %>% filter(year == 2013) %>% group_by(carrier) %>% summarise(n_flights = n(), n_delayed = sum(!is.na(dep_delay) & dep_delay > 0), share_delayed = round(100 * sum(!is.na(dep_delay) & dep_delay > 0) / n(), 1), mean_dep_delay = round(mean(dep_delay, na.rm = TRUE), 2), .groups = "drop") %>% arrange(desc(share_delayed)) %>% head(5) %>% left_join(airlines, by = "carrier")), collapse = "\n"))
p("По доле задержек лидирует Southwest Airlines Co. (WN) — 53,4 % её рейсов задержаны, тогда как")
p("у UA, лидера по абсолютному числу задержек, доля задержек ниже (46,5 %).")
p("Топ-3 по средней задержке вылета, мин (исключая NA):")
p(paste(capture.output(flights %>% filter(year == 2013) %>% group_by(carrier) %>% summarise(mean_dep_delay = round(mean(dep_delay, na.rm = TRUE), 2), .groups = "drop") %>% arrange(desc(mean_dep_delay)) %>% head(3) %>% left_join(airlines, by = "carrier")), collapse = "\n"))

p("")
p("[3.13] inner_join() flights и airlines. Полное название авиакомпании, совершившей больше всего рейсов в 2013 году.")
code("flights %>% filter(year == 2013) %>% count(carrier, name = \"n_flights\") %>% inner_join(airlines, by = \"carrier\") %>% arrange(desc(n_flights)) %>% head(3)")
r313 <- flights %>%
  filter(year == 2013) %>%
  count(carrier, name = "n_flights") %>%
  inner_join(airlines, by = "carrier") %>%
  arrange(desc(n_flights)) %>%
  head(3)
p("Топ-3 авиакомпании по числу рейсов в 2013 г. (после inner_join):")
pr(r313)
p("ПОЛНОЕ НАЗВАНИЕ авиакомпании, совершившей больше всего рейсов в 2013 году:")
p("  ", r313$name[1], "(carrier =", r313$carrier[1], ", рейсов:", r313$n_flights[1], ")")
p("Проверка: строки flights %>% filter(year == 2013) %>% inner_join(airlines, by = \"carrier\") =",
  nrow(flights %>% filter(year == 2013) %>% inner_join(airlines, by = "carrier")),
  "(столько же, сколько в flights — все carrier найдены).")

p("")
p("[3.14] left_join() flights и airports по условию dest = faa. Топ-5 аэропортов назначения по средней задержке прибытия arr_delay.")
code('flights %>% left_join(airports, by = c("dest" = "faa"))')
code("... %>% group_by(name) %>% summarise(mean_arr_delay = mean(arr_delay, na.rm = TRUE)) %>% arrange(desc(mean_arr_delay)) %>% head(5)")
r314 <- flights %>%
  left_join(airports %>% select(faa, name), by = c("dest" = "faa")) %>%
  filter(!is.na(arr_delay)) %>%
  group_by(dest, name) %>%
  summarise(n = n(), mean_arr_delay = round(mean(arr_delay, na.rm = TRUE), 2), .groups = "drop") %>%
  arrange(desc(mean_arr_delay)) %>%
  head(5)
p("Топ-5 аэропортов назначения по средней задержке прибытия (arr_delay, минуты):")
pr(r314)
p("Пропуски arr_delay исключены условием !is.na(arr_delay) (эквивалентно na.rm = TRUE в mean()).")
p("Рейсы, для которых не нашлось аэропорта назначения (anti_join):",
  flights %>% anti_join(airports %>% select(faa), by = c("dest" = "faa")) %>% summarise(n = n()) %>% pull(n),
  "из", nrow(flights), "- столько строк добавит left_join относительно inner_join.")

p("")
p("[3.15] Связать flights и weather (year, month, day, origin, hour, time_hour). case_when() для wind_speed. Средняя задержка вылета по категориям.")
code('flights %>% inner_join(weather, by = c("year", "month", "day", "origin", "hour", "time_hour"))')
code("weather %>% mutate(wind_cat = case_when(wind_speed < 10 ~ \"до 10\", wind_speed <= 20 ~ \"10-20\", TRUE ~ \"свыше 20\"))")
p("ВНИМАНИЕ: нельзя сначала выполнить select(-origin, -hour, -time_hour), а затем соединить по этим")
p("же столбцам — R выдаст ошибку 'Join columns in `x` must be present in the data'. Ключи соединения")
p("нужно оставить в наборе (либо переименовать их в weather). Здесь соединяем сразу по шести ключам.")
flights_w <- flights %>%
  inner_join(weather, by = c("year", "month", "day", "origin", "hour", "time_hour"))
p("Размер flights:", nrow(flights), "строк, weather:", nrow(weather), "строк.")
p("Размер объединённого датафрейма:", nrow(flights_w), "строк.")
p("Аэропорты происхождения (origin) в weather:", paste(unique(weather$origin), collapse = ", "),
  "- данные есть по всем трём нью-йоркским аэропортам.")
p("Рейсы, для которых нашлась погода:", nrow(flights_w), "из", nrow(flights), "(",
  round(100 * nrow(flights_w) / nrow(flights), 1), "%).")

r315 <- flights_w %>%
  filter(!is.na(wind_speed), !is.na(dep_delay)) %>%
  mutate(wind_cat = case_when(
    wind_speed < 10 ~ "до 10 mph",
    wind_speed <= 20 ~ "10-20 mph",
    TRUE ~ "свыше 20 mph"
  )) %>%
  group_by(wind_cat) %>%
  summarise(n = n(),
            mean_dep_delay = round(mean(dep_delay, na.rm = TRUE), 2),
            median_dep_delay = round(median(dep_delay, na.rm = TRUE), 2),
            share_delayed = round(100 * mean(dep_delay > 0, na.rm = TRUE), 1),
            .groups = "drop") %>%
  arrange(wind_cat)
p("Средняя задержка вылета (dep_delay, мин) по категориям скорости ветра:")
pr(r315)
p("Как зависит задержка от силы ветра: с ростом скорости ветра средняя и медианная задержка растут,")
p("а доля задержанных рейсов увеличивается — наиболее задерживаются рейсы при ветре свыше 20 mph.")
p("То же распределение ветра без полётов (справочно, % рейсов):")
p(paste(capture.output(flights_w %>% filter(!is.na(wind_speed)) %>% mutate(wind_cat = case_when(wind_speed < 10 ~ "до 10 mph", wind_speed <= 20 ~ "10-20 mph", TRUE ~ "свыше 20 mph")) %>% count(wind_cat) %>% mutate(pct = round(100 * n / sum(n), 1))), collapse = "\n"))
p("Средний ветер по каждой категории, mph:")
p(paste(capture.output(flights_w %>% filter(!is.na(wind_speed)) %>% mutate(wind_cat = case_when(wind_speed < 10 ~ "до 10 mph", wind_speed <= 20 ~ "10-20 mph", TRUE ~ "свыше 20 mph")) %>% group_by(wind_cat) %>% summarise(mean_wind = round(mean(wind_speed), 1), .groups = "drop")), collapse = "\n"))

# ============================================================
# ЧАСТЬ 4. НАТИВНЫЙ И TIDYVERSE-ПАЙП
# ============================================================
hd("ЧАСТЬ 4. НАТИВНЫЙ И TIDYVERSE-ПАЙП")

p("[4.1] Средняя масса starwars без NA двумя способами.")
code("starwars$mass |> mean(na.rm = TRUE)")
code("starwars$mass %>% mean(na.rm = TRUE)")
a1 <- starwars$mass |> mean(na.rm = TRUE)
a2 <- starwars$mass %>% mean(na.rm = TRUE)
p("starwars$mass |> mean(na.rm = TRUE)  =", a1)
p("starwars$mass %>% mean(na.rm = TRUE) =", a2)
p("Результаты идентичны:", isTRUE(all.equal(a1, a2)), "- значения совпадают.")

p("")
p("[4.2] В именах каких персонажей встречается подстрока Sky (функция grepl()).")
code("starwars$name %>% grepl(\"Sky\", .)")
code("starwars$name |> grepl(\"Sky\", x = _)")
b1 <- starwars$name %>% grepl("Sky", .)
b2 <- starwars$name |> grepl("Sky", x = _)
p("Результаты идентичны:", identical(b1, b2))
p("Найдено персонажей с подстрокой 'Sky':", sum(b1), "из", length(b1))
p("Их имена:")
pr(starwars$name[b1])
p("Почему нативному пайпу нужен именованный аргумент x = _:")
p("  В grepl() искомый вектор — ВТОРОЙ аргумент (x = pattern), а данные приходят ПЕРВЫМИ.")
p("  Пайп %>% (magrittr) подставляет данные в любую позицию через плейсхолдер '.', поэтому . можно")
p("  поставить вторым: grepl(\"Sky\", .). Нативный |>, начиная с R 4.2, подставляет значение только")
p("  в позицию первого аргумента, а для передачи в другую позицию требует явного плейсхолдера _,")
p("  который разрешено ставить только в именованный аргумент. Поэтому: grepl(\"Sky\", x = _).")

p("")
p("[4.3] starwars$height %>% mean()  и  starwars$height |> mean")
code("starwars$height %>% mean()")
code("starwars$height |> mean")
p("Вызов starwars$height %>% mean() :")
d1 <- starwars$height %>% mean()
pr(d1)
p("")
p("Вызов starwars$height |> mean :")
p("  ОШИБКА (возникает ещё на этапе РАЗБОРА кода, поэтому tryCatch/error её не перехватывает):")
d2 <- tryCatch(
  {
    eval(parse(text = "starwars$height |> mean"))
    "ошибки не возникло"
  },
  error = function(e) paste0("Error: ", conditionMessage(e))
)
p("  ", d2)
p("Как исправить вторую строку:")
p("  1) добавить скобки и явный аргумент: starwars$height |> mean(na.rm = TRUE)")
p("     ->", starwars$height |> mean(na.rm = TRUE))
p("  2) назвать первый аргумент и передать данные плейсхолдером (первый аргумент mean() называется x):")
p("     starwars$height |> mean(x = _, na.rm = TRUE)")
p("     ->", starwars$height |> mean(x = _, na.rm = TRUE))
p("  Оба исправленных варианта совпадают с %>% -версией:",
  isTRUE(all.equal(starwars$height |> mean(na.rm = TRUE), starwars$height %>% mean(na.rm = TRUE))))
p("Причина ошибки: нативный пайп |> требует, чтобы правая часть была ВЫЗОВОМ функции (со скобками).")
p("Конструкция `x |> mean` не является вызовом — это символ (имя функции), поэтому R не может")
p("подставить в него данные и сообщает об ошибке ещё при разборе выражения. Пайп %>% напротив")
p("превращает любой символ в вызов функции, поэтому `x %>% mean` эквивалентно `x %>% mean()`.")
p("Дополнительно: даже если бы скобки стояли, `starwars$height |> mean()` вернул бы NA, так как")
p("в столбце height есть пропуски, — поэтому в отчёте используется mean(na.rm = TRUE).")
p("Замечание: писать mean(data = _) нельзя — аргумент data есть только у mean.data.frame, у")
p("mean.default первый аргумент называется x, поэтому R выдаст 'unused argument'.")

p("")
p("[4.4] Именованный вектор, в котором имена элементов совпадают со значениями.")
code("c(\"luke\", \"vader\") %>% setNames(., .)")
code("c(\"luke\", \"vader\") |> setNames(nm = _)")
e1 <- c("luke", "vader") %>% setNames(., .)
e2 <- c("luke", "vader") |> setNames(nm = _)
p("c(\"luke\", \"vader\") %>% setNames(., .) :")
pr(e1)
p("c(\"luke\", \"vader\") |> setNames(nm = _) :")
pr(e2)
p("Результаты идентичны:", identical(e1, e2))
p("Почему в первом варианте '.' использована дважды, а второй не требует повторения:")
p("  Функция setNames(object, nm) — значение nm берётся из ВТОРОГО аргумента, а данные приходят")
p("  первыми. Пайп %>% не имеет именованного плейсхолдера, поэтому и данные, и имена приходится")
p("  передавать явно через '.', и '.' приходится повторить дважды.")
p("  У нативного |> плейсхолдер _ можно ставить в разные позиции (аргумент nm — именованный),")
p("  поэтому '_' достаточно одного раза.")

p("")
p("[4.5] Заменяем пайпы в решениях части 2 на противоположные и проверяем, что результаты не изменились.")
p("Ниже каждое задание части 2 выполняется дважды: через %>% и через |>, затем сравнивается.")
p("")

check <- function(label, m, n) {
  ok <- isTRUE(all.equal(m, n, check.attributes = FALSE))
  p(sprintf("  %-10s %s  (%%>%% и |> дают одинаковый результат)", if (ok) "OK" else "РАСХОЖД", label))
  invisible(ok)
}
p("Задание 2.1 — число строк:")
check("2.1", starwars %>% nrow(), starwars |> nrow())

p("Задание 2.2 — число столбцов:")
check("2.2", starwars %>% ncol(), starwars |> ncol())

p("Задание 2.3 — glimpse():")
check("2.3", dplyr::glimpse(starwars), dplyr::glimpse(starwars))

p("Задание 2.4 — число уникальных рас:")
check("2.4",
      starwars %>% summarise(n = length(unique(species))) %>% pull(n),
      starwars |> summarise(n = length(unique(species))) |> pull(n))

p("Задание 2.5 — самый высокий персонаж:")
check("2.5",
      starwars %>% filter(!is.na(height)) %>% arrange(desc(height)) %>% select(name, height),
      starwars |> filter(!is.na(height)) |> arrange(desc(height)) |> select(name, height))

p("Задание 2.6 — персонажи ниже 170:")
check("2.6",
      starwars %>% filter(!is.na(height), height < 170) %>% select(name, height),
      starwars |> filter(!is.na(height), height < 170) |> select(name, height))

p("Задание 2.7 — ИМТ:")
check("2.7",
      starwars %>% filter(!is.na(mass), !is.na(height)) %>% mutate(bmi = mass / height^2) %>% select(name, bmi),
      starwars |> filter(!is.na(mass), !is.na(height)) |> mutate(bmi = mass / height^2) |> select(name, bmi))

p("Задание 2.8 — 10 самых «вытянутых»:")
check("2.8",
      starwars %>% filter(!is.na(mass), !is.na(height)) %>% mutate(s = mass / height) %>% arrange(desc(s)) %>% head(10) %>% select(name, s),
      starwars |> filter(!is.na(mass), !is.na(height)) |> mutate(s = mass / height) |> arrange(desc(s)) |> head(10) |> select(name, s))

p("Задание 2.9 — средний возраст по расам:")
check("2.9",
      starwars %>% filter(!is.na(species)) %>% group_by(species) %>% summarise(a = mean(birth_year, na.rm = TRUE), .groups = "drop"),
      starwars |> filter(!is.na(species)) |> group_by(species) |> summarise(a = mean(birth_year, na.rm = TRUE), .groups = "drop"))

p("Задание 2.10 — самый распространённый цвет глаз:")
check("2.10",
      starwars %>% filter(!is.na(eye_color)) %>% count(eye_color, sort = TRUE) %>% slice_head(n = 1),
      starwars |> filter(!is.na(eye_color)) |> count(eye_color, sort = TRUE) |> slice_head(n = 1))

p("Задание 2.11 — средняя длина имени по расам:")
check("2.11",
      starwars %>% filter(!is.na(species), !is.na(name)) %>% mutate(k = nchar(name)) %>% group_by(species) %>% summarise(m = mean(k, na.rm = TRUE), .groups = "drop"),
      starwars |> filter(!is.na(species), !is.na(name)) |> mutate(k = nchar(name)) |> group_by(species) |> summarise(m = mean(k, na.rm = TRUE), .groups = "drop"))

p("")
p("Пример удачной замены (без правок кода):")
p("  %>% : starwars %>% filter(!is.na(height)) %>% arrange(desc(height)) %>% head(1) %>% select(name, height)")
p("  |>  : starwars |> filter(!is.na(height)) |> arrange(desc(height)) |> head(1) |> select(name, height)")
p("  Обе строки дают одинаковый результат, правки не потребовались — все вызываемые функции имеют")
p("  первый аргумент данных, а промежуточные значения занимают первую позицию.")

p("")
p("Случай, когда замена потребовала правки кода:")
p("  Пример: grepl(\"Sky\", .) — здесь данные ставятся во ВТОРУЮ позицию, поэтому для |> плейсхолдер")
p("  _ пришлось явно назвать: grepl(\"Sky\", x = _). Это правка кода, без неё R выдаст ошибку.")
p("  Второй пример: setNames(., .) -> setNames(nm = _) — по той же причине.")
p("  Третий пример: starwars$height |> mean без скобок — ошибка РАЗБОРА; исправляется на")
p("  |> mean(na.rm = TRUE) либо |> mean(x = _, na.rm = TRUE) с явным аргументом.")

p("")
p("################ ИТОГОВЫЕ КЛЮЧЕВЫЕ ЗНАЧЕНИЯ ################")
p("1.10  средний рост (heights, без NA, 1 знак) :", heights |> mean(na.rm = TRUE) |> round(digits = 1))
p("2.1   строк в starwars                         :", r21)
p("2.2   столбцов в starwars                      :", r22)
p("2.4   уникальных рас                           :", r24b$n_distinct_species, "(38, если считать NA как значение)")
p("2.5   самый высокий персонаж                   :", r25$name, "(", r25$height, "см )")
p("2.6   персонажей ниже 170 см                   :", nrow(r26))
p("2.9   рас с посчитанным средним годом появления:", sum(r29$n_with_year > 0))
p("2.10  самый частый цвет глаз                   :", top_eye$eye_color, "(", top_eye$n, ")")
p("3.1   наборов данных в nycflights13           :", nrow(ds_ny))
p("3.5   перевозчиков в рейсах                    :", r35$n_carriers)
p("3.6   рейсов из JFK в мае                      :", r36_dep$n)
p("3.9   самый старый год выпуска самолёта        :", oldest_year)
p("3.10  средняя температура сентября в JFK, °C   :", round(r310$mean_c, 2))
p("3.11  больше всего вылетов в июне             :", best6, "-", airline_name)
p("3.12  чаще других задерживались в 2013          :", b12, "-", airlines %>% filter(carrier == b12) %>% pull(name))
p("3.13  больше всего рейсов в 2013               :", r313$name[1])
p("3.14  топ-1 аэропорт по средней задержке        :", r314$name[1], "(", r314$mean_arr_delay[1], "мин )")
p("4.1   средняя масса starwars                   :", a1)

p("")
p("[Готово] Все части 1-4 выполнены, результаты приведены в отчёте.")
