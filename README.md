# Основы обработки данных в R: базовый R и Tidyverse
И. И. Иванов, группа ГРУППА-00

## Цель

1.  Развить практические навыки использования языка программирования R
    для обработки данных.
2.  Закрепить знания базовых типов данных языка R и базовых структур —
    векторов, списков, датафреймов.
3.  Освоить индексацию и векторизованные операции базового R.
4.  Развить практические навыки использования функций обработки данных
    пакета **dplyr** — `select()`, `filter()`, `mutate()`, `arrange()`,
    `group_by()`, `summarise()`.
5.  Освоить соединение таблиц (joins) и оба стиля конвейеров: нативный
    пайп `|>` и пайп Tidyverse `%>%`.
6.  Развить навыки подготовки воспроизводимого отчёта в Quarto.

## Исходные данные

Работа выполнена в R и среде разработки RStudio IDE.

- Версия R — 4.6.1 (ucrt), платформа x86_64-w64-mingw32, ОС Windows 11
  x64.
- Используемые пакеты: `dplyr` (встроенный набор данных `starwars`) и
  `nycflights13` (наборы `flights`, `airlines`, `airports`, `planes`,
  `weather`).
- Отчёт подготовлен в формате Quarto (`.qmd`); весь код выполняется при
  рендеринге, результаты вставляются автоматически.

## Варианты решения задачи

**Вариант 1 — средствами базового R.** Применяется в части 1: векторы,
списки, датафреймы, индексация, векторизованные операции и нативный пайп
`|>`. Достоинство — не требует дополнительных пакетов.

**Вариант 2 — средствами экосистемы Tidyverse (пакет dplyr).**
Применяется в частях 2–4: конвейер `%>%`, глаголы `filter()`,
`mutate()`, `arrange()`, `group_by()`, `summarise()`, соединения
`*_join()`. Достоинство — читаемость и единообразие кода при обработке
таблиц.

В части 4 оба варианта сравниваются на одних и тех же задачах.

## Общий план выполнения

1.  Повторить базовые типы и структуры данных R, выполнить задания 1–10
    части 1.
2.  Проанализировать встроенный набор `starwars` глаголами dplyr (часть
    2, задания 1–12).
3.  Проанализировать наборы пакета `nycflights13`, включая соединения
    таблиц и `case_when()` (часть 3, задания 1–16).
4.  Сравнить нативный пайп `|>` и пайп Tidyverse `%>%` (часть 4, задания
    1–5).
5.  Оформить воспроизводимый отчёт в Quarto и сделать выводы.

## Содержание ЛР

### Часть 1. Базовый R

Задания 1–9 выполняются средствами базового R без загрузки
дополнительных пакетов, в задании 10 используется нативный пайп `|>`.

#### Задание 1. Числовой вектор `heights` и его класс

``` r
heights <- c(172, 168, 181, 165, 190)
heights
```

    [1] 172 168 181 165 190

``` r
class(heights)
```

    [1] "numeric"

Функция `c()` объединяет значения в вектор; все значения целые, поэтому
`class()` возвращает `"numeric"`.

#### Задание 2. Последовательности: оператор `:` и функция `seq()`

``` r
1:10
```

     [1]  1  2  3  4  5  6  7  8  9 10

``` r
seq(1, 10)
```

     [1]  1  2  3  4  5  6  7  8  9 10

``` r
seq(0, 100, by = 10)
```

     [1]   0  10  20  30  40  50  60  70  80  90 100

``` r
identical(1:10, seq(1, 10))
```

    [1] TRUE

Оператор `:` создаёт последовательность с шагом 1, `seq()` позволяет
задать шаг параметром `by`. Первые два результата идентичны, что
подтверждает `identical()`.

#### Задание 3. Имена элементов и обращение по имени

``` r
names(heights) <- c("Анна", "Борис", "Вера", "Гриша", "Дина")
heights
```

     Анна Борис  Вера Гриша  Дина 
      172   168   181   165   190 

``` r
heights[["Вера"]]
```

    [1] 181

Функция `names()` присваивает элементам имена, после чего доступ по
имени возможен через `["имя"]` или `[["имя"]]`.

#### Задание 4. Векторы трёх типов и приведение типов

``` r
v_num <- c(1.5, 2.5, 3.5)
v_chr <- c("один", "два", "три")
v_lgl <- c(TRUE, FALSE, TRUE)
class(v_num); class(v_chr); class(v_lgl)
```

    [1] "numeric"

    [1] "character"

    [1] "logical"

``` r
class(c(1, "один"))
```

    [1] "character"

``` r
c(1, "один")
```

    [1] "1"    "один"

`class(c(1, "один"))` возвращает `"character"`: вектор в R атомарен,
поэтому все его элементы приводятся к одному типу. Иерархия типов
`logical < integer < double < character`, и побеждает «старший» —
символьный, поэтому число `1` превращается в строку `"1"`.

#### Задание 5. Индексация вектора

``` r
heights[1]
```

    Анна 
     172 

``` r
heights[length(heights)]
```

    Дина 
     190 

``` r
heights[2:4]
```

    Борис  Вера Гриша 
      168   181   165 

``` r
heights[-1]
```

    Борис  Вера Гриша  Дина 
      168   181   165   190 

Квадратные скобки принимают вектор индексов: положительные выбирают
элементы, отрицательные — исключают их.

#### Задание 6. Логическая индексация

``` r
heights > 170
```

     Анна Борис  Вера Гриша  Дина 
     TRUE FALSE  TRUE FALSE  TRUE 

``` r
heights[heights > 170]
```

    Анна Вера Дина 
     172  181  190 

``` r
sum(heights > 170)
```

    [1] 3

Сравнение возвращает логический вектор. Внутри `sum()` допустимо
логическое условие, потому что `sum()` приводит `TRUE`/`FALSE` к
`1`/`0`, то есть считает количество истинных значений.

#### Задание 7. Пропуск `NA` и среднее значение

``` r
heights["Борис"] <- NA
heights
```

     Анна Борис  Вера Гриша  Дина 
      172    NA   181   165   190 

``` r
mean(heights)
```

    [1] NA

``` r
mean(heights, na.rm = TRUE)
```

    [1] 177

Первое среднее равно `NA`: любая арифметическая операция с пропуском
даёт пропуск. Параметр `na.rm = TRUE` удаляет пропуски перед
вычислением, поэтому второе среднее — `177`.

#### Задание 8. Список `person`

``` r
person <- list(name = "Анна", height = 172, humanoid = TRUE)
str(person)
```

    List of 3
     $ name    : chr "Анна"
     $ height  : num 172
     $ humanoid: logi TRUE

``` r
person$name
```

    [1] "Анна"

``` r
person[["height"]]
```

    [1] 172

``` r
person[[3]]
```

    [1] TRUE

Список, в отличие от вектора, хранит элементы разных типов. Обращение по
имени — через `$` или `[["имя"]]`, по номеру — через `[[3]]`.

#### Задание 9. Датафрейм `df`

``` r
df <- data.frame(
  name   = c("Анна", "Борис", "Вера"),
  height = c(172, 168, 181),
  mass   = c(62, 74, 58)
)
str(df)
```

    'data.frame':   3 obs. of  3 variables:
     $ name  : chr  "Анна" "Борис" "Вера"
     $ height: num  172 168 181
     $ mass  : num  62 74 58

``` r
head(df)
```

       name height mass
    1  Анна    172   62
    2 Борис    168   74
    3  Вера    181   58

``` r
df$height
```

    [1] 172 168 181

``` r
df[["mass"]]
```

    [1] 62 74 58

Датафрейм — список векторов одинаковой длины. Структуру показывает
`str()`, первые строки — `head()`; столбец извлекается через `$` или
`[["имя"]]`.

#### Задание 10. Нативный пайп

``` r
heights |> mean(na.rm = TRUE) |> round(digits = 1)
```

    [1] 177

Оператор `|>` передаёт результат слева в первый аргумент функции справа,
поэтому цепочка читается сверху вниз: среднее, затем округление.

### Часть 2. Обработка данных `starwars` с помощью dplyr

Все преобразования выполняются через конвейер `%>%`.

#### Задание 1. Сколько строк в датафрейме?

``` r
starwars %>% nrow()
```

    [1] 87

#### Задание 2. Сколько столбцов в датафрейме?

``` r
starwars %>% ncol()
```

    [1] 14

``` r
starwars %>% names()
```

     [1] "name"       "height"     "mass"       "hair_color" "skin_color" "eye_color"  "birth_year" "sex"       
     [9] "gender"     "homeworld"  "species"    "films"      "vehicles"   "starships" 

#### Задание 3. Как просмотреть примерный вид датафрейма?

``` r
starwars %>% glimpse()
```

    Rows: 87
    Columns: 14
    $ name       <chr> "Luke Skywalker", "C-3PO", "R2-D2", "Darth Vader", "Leia Organa", "Owen Lars", "Beru Whit…
    $ height     <int> 172, 167, 96, 202, 150, 178, 165, 97, 183, 182, 188, 180, 228, 180, 173, 175, 170, 180, 6…
    $ mass       <dbl> 77.0, 75.0, 32.0, 136.0, 49.0, 120.0, 75.0, 32.0, 84.0, 77.0, 84.0, NA, 112.0, 80.0, 74.0…
    $ hair_color <chr> "blond", NA, NA, "none", "brown", "brown, grey", "brown", NA, "black", "auburn, white", "…
    $ skin_color <chr> "fair", "gold", "white, blue", "white", "light", "light", "light", "white, red", "light",…
    $ eye_color  <chr> "blue", "yellow", "red", "yellow", "brown", "blue", "blue", "red", "brown", "blue-gray", …
    $ birth_year <dbl> 19.0, 112.0, 33.0, 41.9, 19.0, 52.0, 47.0, NA, 24.0, 57.0, 41.9, 64.0, 200.0, 29.0, 44.0,…
    $ sex        <chr> "male", "none", "none", "male", "female", "male", "female", "none", "male", "male", "male…
    $ gender     <chr> "masculine", "masculine", "masculine", "masculine", "feminine", "masculine", "feminine", …
    $ homeworld  <chr> "Tatooine", "Tatooine", "Naboo", "Tatooine", "Alderaan", "Tatooine", "Tatooine", "Tatooin…
    $ species    <chr> "Human", "Droid", "Droid", "Human", "Human", "Human", "Human", "Droid", "Human", "Human",…
    $ films      <list> <"A New Hope", "The Empire Strikes Back", "Return of the Jedi", "Revenge of the Sith", "…
    $ vehicles   <list> <"Snowspeeder", "Imperial Speeder Bike">, <>, <>, <>, "Imperial Speeder Bike", <>, <>, <…
    $ starships  <list> <"X-wing", "Imperial shuttle">, <>, <>, "TIE Advanced x1", <>, <>, <>, <>, "X-wing", <"J…

`glimpse()` из пакета dplyr показывает размеры, типы и первые значения
каждого столбца — это компактная альтернатива `str()`; для нескольких
первых строк используется `head()`.

#### Задание 4. Сколько уникальных рас представлено в данных?

``` r
starwars %>% distinct(species) %>% nrow()
```

    [1] 38

``` r
starwars %>% filter(!is.na(species)) %>% distinct(species) %>% nrow()
```

    [1] 37

``` r
starwars %>% count(species, sort = TRUE) %>% head(5)
```

    # A tibble: 5 × 2
      species      n
      <chr>    <int>
    1 Human       35
    2 Droid        6
    3 <NA>         4
    4 Gungan       3
    5 Kaminoan     2

В данных 38 уникальных значений `species`, из них 37 — реальные расы, а
одно значение — пропуск `NA` (4 персонажа). Самая многочисленная раса —
люди (`Human`, 35 персонажей).

#### Задание 5. Самый высокий персонаж

``` r
starwars %>% filter(height == max(height, na.rm = TRUE)) %>% select(name, height, mass, species)
```

    # A tibble: 1 × 4
      name        height  mass species 
      <chr>        <int> <dbl> <chr>   
    1 Yarael Poof    264    NA Quermian

Самый высокий — **Yarael Poof**, 264 см, раса Quermian. Параметр
`na.rm = TRUE` нужен, так как в столбце `height` есть пропуски.

#### Задание 6. Все персонажи ниже 170 см

``` r
starwars %>% filter(height < 170) %>% select(name, height) %>% print(n = 30)
```

    # A tibble: 22 × 2
       name                  height
       <chr>                  <int>
     1 C-3PO                    167
     2 R2-D2                     96
     3 Leia Organa              150
     4 Beru Whitesun Lars       165
     5 R5-D4                     97
     6 Yoda                      66
     7 Mon Mothma               150
     8 Wicket Systri Warrick     88
     9 Nien Nunb                160
    10 Watto                    137
    11 Sebulba                  112
    12 Shmi Skywalker           163
    13 Ratts Tyerel              79
    14 Dud Bolt                  94
    15 Gasgano                  122
    16 Ben Quadinaros           163
    17 Cordé                    157
    18 Barriss Offee            166
    19 Dormé                    165
    20 Zam Wesell               168
    21 Jocasta Nu               167
    22 R4-P17                    96

``` r
starwars %>% filter(height < 170) %>% nrow()
```

    [1] 22

Таких персонажей 22, самый низкий — Yoda (66 см).

#### Задание 7. ИМТ персонажей

Индекс массы тела считается по формуле $I = \frac{m}{h^2}$, где *m* —
масса (`mass`) в килограммах, а *h* — рост (`height`) в метрах, поэтому
рост переводится из сантиметров делением на 100.

``` r
starwars %>%
  mutate(bmi = mass / (height / 100)^2) %>%
  select(name, height, mass, bmi) %>%
  arrange(desc(bmi)) %>%
  head(10)
```

    # A tibble: 10 × 4
       name                  height  mass   bmi
       <chr>                  <int> <dbl> <dbl>
     1 Jabba Desilijic Tiure    175  1358 443. 
     2 Dud Bolt                  94    45  50.9
     3 Yoda                      66    17  39.0
     4 Owen Lars                178   120  37.9
     5 IG-88                    200   140  35  
     6 R2-D2                     96    32  34.7
     7 Grievous                 216   159  34.1
     8 R5-D4                     97    32  34.0
     9 Jek Tono Porkins         180   110  34.0
    10 Darth Vader              202   136  33.3

Максимальный ИМТ — у Джаббы Хатта (443): при росте 175 см его масса
составляет 1358 кг. Для остальных персонажей значения сопоставимы с
человеческими (17–51).

#### Задание 8. 10 самых «вытянутых» персонажей

«Вытянутость» оценивается отношением массы к росту.

``` r
starwars %>%
  mutate(stretch = mass / height) %>%
  arrange(desc(stretch)) %>%
  select(name, mass, height, stretch) %>%
  head(10)
```

    # A tibble: 10 × 4
       name                   mass height stretch
       <chr>                 <dbl>  <int>   <dbl>
     1 Jabba Desilijic Tiure  1358    175   7.76 
     2 Grievous                159    216   0.736
     3 IG-88                   140    200   0.7  
     4 Owen Lars               120    178   0.674
     5 Darth Vader             136    202   0.673
     6 Jek Tono Porkins        110    180   0.611
     7 Bossk                   113    190   0.595
     8 Tarfful                 136    234   0.581
     9 Dexter Jettster         102    198   0.515
    10 Chewbacca               112    228   0.491

Первое место с большим отрывом занимает Джабба Хатт (7.76 кг/см), далее
идут Grievous (0.74) и IG-88 (0.70) — то есть персонажи с большой массой
при небольшом росте.

#### Задание 9. Средний возраст персонажей каждой расы

Возраст персонажа оценивается по столбцу `birth_year` (год рождения, лет
до битвы при Явине).

``` r
starwars %>%
  filter(!is.na(species)) %>%
  group_by(species) %>%
  summarise(mean_birth_year = mean(birth_year, na.rm = TRUE), n = n()) %>%
  arrange(mean_birth_year) %>%
  print(n = 40)
```

    # A tibble: 37 × 3
       species        mean_birth_year     n
       <chr>                    <dbl> <int>
     1 Ewok                       8       1
     2 Kel Dor                   22       1
     3 Mon Calamari              41       1
     4 Rodian                    44       1
     5 Twi'lek                   48       2
     6 Mirialan                  49       2
     7 Gungan                    52       3
     8 Trandoshan                53       1
     9 Droid                     53.3     6
    10 Human                     53.7    35
    11 Zabrak                    54       2
    12 Cerean                    92       1
    13 Wookiee                  200       2
    14 Hutt                     600       1
    15 Yoda's species           896       1
    16 Aleena                   NaN       1
    17 Besalisk                 NaN       1
    18 Chagrian                 NaN       1
    19 Clawdite                 NaN       1
    20 Dug                      NaN       1
    21 Geonosian                NaN       1
    22 Iktotchi                 NaN       1
    23 Kaleesh                  NaN       1
    24 Kaminoan                 NaN       2
    25 Muun                     NaN       1
    26 Nautolan                 NaN       1
    27 Neimodian                NaN       1
    28 Pau'an                   NaN       1
    29 Quermian                 NaN       1
    30 Skakoan                  NaN       1
    31 Sullustan                NaN       1
    32 Tholothian               NaN       1
    33 Togruta                  NaN       1
    34 Toong                    NaN       1
    35 Toydarian                NaN       1
    36 Vulptereen               NaN       1
    37 Xexto                    NaN       1

Для 22 рас результат равен `NaN`: в этих расах ни у одного персонажа не
заполнен `birth_year`, а среднее по пустому набору после удаления
пропусков не определено. Самая «молодая» раса с данными — Ewok (8 лет),
самая «старая» — раса Йоды (896 лет).

#### Задание 10. Самый распространённый цвет глаз

``` r
starwars %>% count(eye_color, sort = TRUE) %>% head(5)
```

    # A tibble: 5 × 2
      eye_color     n
      <chr>     <int>
    1 brown        21
    2 blue         19
    3 yellow       11
    4 black        10
    5 orange        8

``` r
starwars %>% count(eye_color, sort = TRUE) %>% slice(1) %>% pull(eye_color)
```

    [1] "brown"

Самый распространённый цвет глаз — **brown** (карий), 21 персонаж; на
втором месте `blue` (19).

#### Задание 11. Средняя длина имени в каждой расе

``` r
starwars %>%
  filter(!is.na(species)) %>%
  mutate(name_len = nchar(name)) %>%
  group_by(species) %>%
  summarise(mean_name_len = mean(name_len), n = n()) %>%
  arrange(desc(mean_name_len)) %>%
  print(n = 40)
```

    # A tibble: 37 × 3
       species        mean_name_len     n
       <chr>                  <dbl> <int>
     1 Ewok                   21        1
     2 Hutt                   21        1
     3 Geonosian              17        1
     4 Besalisk               15        1
     5 Mirialan               14        2
     6 Toong                  14        1
     7 Aleena                 12        1
     8 Cerean                 12        1
     9 Gungan                 11.7      3
    10 Human                  11.3     35
    11 Iktotchi               11        1
    12 Neimodian              11        1
    13 Quermian               11        1
    14 Twi'lek                11        2
    15 Chagrian               10        1
    16 Clawdite               10        1
    17 Pau'an                 10        1
    18 Skakoan                10        1
    19 Tholothian             10        1
    20 Zabrak                  9.5      2
    21 Nautolan                9        1
    22 Sullustan               9        1
    23 Kaleesh                 8        1
    24 Kel Dor                 8        1
    25 Muun                    8        1
    26 Togruta                 8        1
    27 Vulptereen              8        1
    28 Wookiee                 8        2
    29 Dug                     7        1
    30 Kaminoan                7        2
    31 Xexto                   7        1
    32 Mon Calamari            6        1
    33 Rodian                  6        1
    34 Toydarian               5        1
    35 Trandoshan              5        1
    36 Droid                   4.83     6
    37 Yoda's species          4        1

Длину имени считает `nchar()`. Самые длинные имена — у Ewok и Hutt (21
символ), самые короткие — у расы Йоды (4 символа) и дроидов (4.83,
например `R2-D2`, `IG-88`).

#### Задание 12. Отчёт

Отчёт оформлен в настоящем документе Quarto, который при рендеринге
автоматически формирует `README.md`.

### Часть 3. Авиарейсы Нью-Йорка: `nycflights13`

Все преобразования выполняются через конвейер `%>%`.

#### Задание 1. Сколько встроенных в пакет датафреймов?

``` r
ds <- data(package = "nycflights13")$results[, "Item"]
ds <- base::sub(" .*$", "", ds)
ds
```

    [1] "airlines" "airports" "flights"  "planes"   "weather" 

``` r
length(ds)
```

    [1] 5

В пакете 5 наборов данных: `airlines`, `airports`, `flights`, `planes`,
`weather`.

#### Задания 2–3. Сколько строк и столбцов в каждом датафрейме?

``` r
for (nm in ds) {
  d <- get(nm)
  cat(sprintf("%-10s : rows = %7d , cols = %2d\n", nm, nrow(d), ncol(d)))
}
```

    airlines   : rows =      16 , cols =  2
    airports   : rows =    1458 , cols =  8
    flights    : rows =  336776 , cols = 19
    planes     : rows =    3322 , cols =  9
    weather    : rows =   26115 , cols = 15

#### Задание 4. Как просмотреть примерный вид датафрейма?

``` r
flights %>% glimpse()
```

    Rows: 336,776
    Columns: 19
    $ year           <int> 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2…
    $ month          <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    $ day            <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    $ dep_time       <int> 517, 533, 542, 544, 554, 554, 555, 557, 557, 558, 558, 558, 558, 558, 559, 559, 559, …
    $ sched_dep_time <int> 515, 529, 540, 545, 600, 558, 600, 600, 600, 600, 600, 600, 600, 600, 600, 559, 600, …
    $ dep_delay      <dbl> 2, 4, 2, -1, -6, -4, -5, -3, -3, -2, -2, -2, -2, -2, -1, 0, -1, 0, 0, 1, -8, -3, -4, …
    $ arr_time       <int> 830, 850, 923, 1004, 812, 740, 913, 709, 838, 753, 849, 853, 924, 923, 941, 702, 854,…
    $ sched_arr_time <int> 819, 830, 850, 1022, 837, 728, 854, 723, 846, 745, 851, 856, 917, 937, 910, 706, 902,…
    $ arr_delay      <dbl> 11, 20, 33, -18, -25, 12, 19, -14, -8, 8, -2, -3, 7, -14, 31, -4, -8, -7, 12, -6, -8,…
    $ carrier        <chr> "UA", "UA", "AA", "B6", "DL", "UA", "B6", "EV", "B6", "AA", "B6", "B6", "UA", "UA", "…
    $ flight         <int> 1545, 1714, 1141, 725, 461, 1696, 507, 5708, 79, 301, 49, 71, 194, 1124, 707, 1806, 1…
    $ tailnum        <chr> "N14228", "N24211", "N619AA", "N804JB", "N668DN", "N39463", "N516JB", "N829AS", "N593…
    $ origin         <chr> "EWR", "LGA", "JFK", "JFK", "LGA", "EWR", "EWR", "LGA", "JFK", "LGA", "JFK", "JFK", "…
    $ dest           <chr> "IAH", "IAH", "MIA", "BQN", "ATL", "ORD", "FLL", "IAD", "MCO", "ORD", "PBI", "TPA", "…
    $ air_time       <dbl> 227, 227, 160, 183, 116, 150, 158, 53, 140, 138, 149, 158, 345, 361, 257, 44, 337, 15…
    $ distance       <dbl> 1400, 1416, 1089, 1576, 762, 719, 1065, 229, 944, 733, 1028, 1005, 2475, 2565, 1389, …
    $ hour           <dbl> 5, 5, 5, 5, 6, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6…
    $ minute         <dbl> 15, 29, 40, 45, 0, 58, 0, 0, 0, 0, 0, 0, 0, 0, 0, 59, 0, 0, 0, 0, 10, 5, 10, 10, 7, 0…
    $ time_hour      <dttm> 2013-01-01 05:00:00, 2013-01-01 05:00:00, 2013-01-01 05:00:00, 2013-01-01 05:00:00, …

`glimpse()` показывает структуру и первые значения всех 19 столбцов
`flights`.

#### Задание 5. Сколько компаний-перевозчиков учитывают наборы данных?

``` r
airlines %>% nrow()
```

    [1] 16

``` r
flights %>% distinct(carrier) %>% nrow()
```

    [1] 16

И в справочнике `airlines`, и в таблице рейсов представлено 16
компаний-перевозчиков.

#### Задание 6. Сколько рейсов принял аэропорт John F Kennedy Intl в мае?

``` r
flights %>% filter(dest == "JFK") %>% nrow()
```

    [1] 0

``` r
flights %>% distinct(origin)
```

    # A tibble: 3 × 1
      origin
      <chr> 
    1 EWR   
    2 LGA   
    3 JFK   

``` r
flights %>% filter(origin == "JFK", month == 5) %>% nrow()
```

    [1] 9397

В наборе `flights` собраны рейсы, **вылетающие** из Нью-Йорка, поэтому
JFK встречается только в столбце `origin`, а в `dest` его нет вовсе
(фильтр по `dest == "JFK"` даёт 0 строк). В мае аэропорт JFK обслужил
**9397** рейсов (вылетов).

#### Задание 7. Какой самый северный аэропорт?

``` r
airports %>% arrange(desc(lat)) %>% select(faa, name, lat, lon) %>% head(3)
```

    # A tibble: 3 × 4
      faa   name                         lat    lon
      <chr> <chr>                      <dbl>  <dbl>
    1 EEN   Dillant Hopkins Airport     72.3   42.9
    2 BRW   Wiley Post Will Rogers Mem  71.3 -157. 
    3 AIN   Wainwright Airport          70.6 -160. 

``` r
airports %>% filter(lon > 0) %>% select(faa, name, lat, lon)
```

    # A tibble: 4 × 4
      faa   name                            lat   lon
      <chr> <chr>                         <dbl> <dbl>
    1 DVT   Deer Valley Municipal Airport  33.4 112. 
    2 EEN   Dillant Hopkins Airport        72.3  42.9
    3 MYF   Montgomery Field               32.5 118. 
    4 SYA   Eareckson As                   52.7 174. 

Формально максимальная широта — у аэропорта EEN (Dillant Hopkins
Airport, 72.3°). Однако при проверке видно, что у этой записи перепутаны
местами широта и долгота: аэропорт находится в городе Кин, Нью-Гэмпшир,
то есть его координаты — 42.9° с. ш., 72.3° з. д. С учётом этой ошибки
данных самый северный аэропорт — **BRW, Wiley Post Will Rogers Memorial
(Уткиагвик, Аляска), 71.3° с. ш.**

#### Задание 8. Какой аэропорт самый высокогорный?

``` r
airports %>% arrange(desc(alt)) %>% select(faa, name, alt) %>% head(3)
```

    # A tibble: 3 × 3
      faa   name                              alt
      <chr> <chr>                           <dbl>
    1 TEX   Telluride                        9078
    2 TVL   Lake Tahoe Airport               8544
    3 ASE   Aspen Pitkin County Sardy Field  7820

Самый высокогорный — **TEX, Telluride** (9078 футов над уровнем моря),
далее TVL (Lake Tahoe, 8544) и ASE (Aspen, 7820).

#### Задание 9. Какие бортовые номера у самых старых самолётов?

``` r
planes %>% filter(year == min(year, na.rm = TRUE)) %>% select(tailnum, year, manufacturer, model)
```

    # A tibble: 1 × 4
      tailnum  year manufacturer model 
      <chr>   <int> <chr>        <chr> 
    1 N381AA   1956 DOUGLAS      DC-7BF

``` r
cat("пропусков в planes$year:", planes %>% filter(is.na(year)) %>% nrow(), "\n")
```

    пропусков в planes$year: 70 

Самый старый самолёт — **N381AA**, 1956 год выпуска (DOUGLAS DC-7BF). В
столбце `year` 70 пропусков, поэтому при поиске минимума указан
`na.rm = TRUE`.

#### Задание 10. Средняя температура воздуха в сентябре в аэропорту JFK

``` r
weather %>%
  filter(origin == "JFK", month == 9) %>%
  summarise(mean_temp_F = mean(temp, na.rm = TRUE),
            mean_temp_C = mean((temp - 32) * 5 / 9, na.rm = TRUE),
            n_obs = n())
```

    # A tibble: 1 × 3
      mean_temp_F mean_temp_C n_obs
            <dbl>       <dbl> <int>
    1        66.9        19.4   720

Температура в наборе хранится в градусах Фаренгейта, перевод выполнен по
формуле $t_C = \frac{5}{9}(t_F - 32)$. Средняя температура сентября в
JFK — **19.4 °C** (66.9 °F) по 720 наблюдениям.

#### Задание 11. Самолёты какой авиакомпании совершили больше всего вылетов в июне?

``` r
flights %>%
  filter(month == 6) %>%
  count(carrier, sort = TRUE) %>%
  left_join(airlines, by = "carrier") %>%
  head(5)
```

    # A tibble: 5 × 3
      carrier     n name                    
      <chr>   <int> <chr>                   
    1 UA       4975 United Air Lines Inc.   
    2 B6       4622 JetBlue Airways         
    3 EV       4456 ExpressJet Airlines Inc.
    4 DL       4126 Delta Air Lines Inc.    
    5 AA       2757 American Airlines Inc.  

Больше всего вылетов в июне — у **United Air Lines Inc.** (код `UA`,
4975 рейсов).

#### Задание 12. Самолёты какой авиакомпании задерживались чаще других в 2013 году?

``` r
flights %>%
  filter(!is.na(dep_delay), dep_delay > 0) %>%
  count(carrier, sort = TRUE) %>%
  left_join(airlines, by = "carrier") %>%
  head(5)
```

    # A tibble: 5 × 3
      carrier     n name                    
      <chr>   <int> <chr>                   
    1 UA      27261 United Air Lines Inc.   
    2 EV      23139 ExpressJet Airlines Inc.
    3 B6      21445 JetBlue Airways         
    4 DL      15241 Delta Air Lines Inc.    
    5 AA      10162 American Airlines Inc.  

``` r
flights %>%
  group_by(carrier) %>%
  summarise(mean_dep_delay = mean(dep_delay, na.rm = TRUE),
            n_delayed = sum(dep_delay > 0, na.rm = TRUE)) %>%
  left_join(airlines, by = "carrier") %>%
  arrange(desc(mean_dep_delay)) %>%
  head(5)
```

    # A tibble: 5 × 4
      carrier mean_dep_delay n_delayed name                       
      <chr>            <dbl>     <int> <chr>                      
    1 F9                20.2       341 Frontier Airlines Inc.     
    2 EV                20.0     23139 ExpressJet Airlines Inc.   
    3 YV                19.0       233 Mesa Airlines Inc.         
    4 FL                18.7      1654 AirTran Airways Corporation
    5 WN                17.7      6558 Southwest Airlines Co.     

Ответ зависит от того, что считать «чаще». По **абсолютному числу**
задержанных рейсов лидирует United Air Lines Inc. (27261 рейс), но она
же выполняет больше всего рейсов вообще. По **средней величине**
задержки первое место занимает Frontier Airlines Inc. (`F9`, 20.2
минуты). Корректнее опираться на среднюю задержку: она не зависит от
размера компании.

#### Задание 13. `inner_join()` для `flights` и `airlines`

``` r
flights %>%
  inner_join(airlines, by = "carrier") %>%
  count(name, sort = TRUE) %>%
  head(5)
```

    # A tibble: 5 × 2
      name                         n
      <chr>                    <int>
    1 United Air Lines Inc.    58665
    2 JetBlue Airways          54635
    3 ExpressJet Airlines Inc. 54173
    4 Delta Air Lines Inc.     48110
    5 American Airlines Inc.   32729

Больше всего рейсов в 2013 году выполнила **United Air Lines Inc.** —
58665 рейсов.

#### Задание 14. `left_join()` для `flights` и `airports`: топ-5 по средней задержке прибытия

``` r
flights %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  filter(!is.na(arr_delay)) %>%
  group_by(dest, name) %>%
  summarise(mean_arr_delay = mean(arr_delay), n = n(), .groups = "drop") %>%
  arrange(desc(mean_arr_delay)) %>%
  head(5)
```

    # A tibble: 5 × 4
      dest  name                  mean_arr_delay     n
      <chr> <chr>                          <dbl> <int>
    1 CAE   Columbia Metropolitan           41.8   106
    2 TUL   Tulsa Intl                      33.7   294
    3 OKC   Will Rogers World               30.6   315
    4 JAC   Jackson Hole Airport            28.1    21
    5 TYS   Mc Ghee Tyson                   24.1   578

Соединение выполняется по условию `dest = faa`. Пропуски `arr_delay`
исключены. Наибольшая средняя задержка прибытия — у рейсов в **Columbia
Metropolitan** (`CAE`, 41.8 минуты).

#### Задание 15. `flights` + `weather` и `case_when()` по скорости ветра

``` r
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
```

    # A tibble: 4 × 3
      wind_cat        mean_dep_delay      n
      <chr>                    <dbl>  <int>
    1 10-20 миль/ч             13.6  164770
    2 до 10 миль/ч             11.0  149178
    3 нет данных                5.13     78
    4 свыше 20 миль/ч          16.9   21194

Задержка вылета растёт вместе с силой ветра: 11.0 минуты при ветре до 10
миль/ч, 13.6 минуты при 10–20 миль/ч и 16.9 минуты при ветре свыше 20
миль/ч. Категория «нет данных» объединяет 4 наблюдения с пропуском
`wind_speed` (78 строк после соединения).

#### Задание 16. Отчёт

Отчёт оформлен в настоящем документе Quarto.

### Часть 4. Нативный и Tidyverse-пайп

Каждое задание выполнено двумя способами: с нативным пайпом `|>` и с
пайпом `%>%`.

#### Задание 1. Средняя масса персонажей `starwars`

``` r
starwars$mass |> mean(na.rm = TRUE) |> round(2)
```

    [1] 97.31

``` r
starwars$mass %>% mean(na.rm = TRUE) %>% round(2)
```

    [1] 97.31

Оба варианта дают одинаковый результат — 97.31 кг.

#### Задание 2. Имена, содержащие подстроку `Sky`

``` r
starwars$name %>% grepl("Sky", .) %>% sum()
```

    [1] 3

``` r
starwars$name |> grepl("Sky", x = _) |> sum()
```

    [1] 3

``` r
starwars %>% filter(grepl("Sky", name)) %>% select(name)
```

    # A tibble: 3 × 1
      name            
      <chr>           
    1 Luke Skywalker  
    2 Anakin Skywalker
    3 Shmi Skywalker  

В `grepl()` искомый вектор — второй аргумент, а пайп подставляет
значение первым аргументом. Поэтому Tidyverse-пайпу нужен плейсхолдер
`.` на втором месте, а нативному пайпу — именованный аргумент `x = _`:
нативный плейсхолдер `_` допускается только как именованный аргумент.
Подстрока `Sky` встречается в именах трёх персонажей.

#### Задание 3. Вызов функции без скобок

``` r
starwars$height %>% mean()
```

    [1] NA

``` r
native_pipe_code <- "starwars$height |> mean"
tryCatch(eval(parse(text = native_pipe_code)),
         error = function(e) cat("ОШИБКА:", conditionMessage(e), "\n"))
```

    ОШИБКА: С правой стороны оператора конвейера должен быть вызов функции (<input>:1:20) 

``` r
starwars$height |> mean()
```

    [1] NA

``` r
starwars$height |> mean(na.rm = TRUE)
```

    [1] 174.6049

Сообщение об ошибке: **«С правой стороны оператора конвейера должен быть
вызов функции»**. Нативный пайп требует именно вызов функции справа,
причём это проверяется на этапе разбора кода, а не выполнения, поэтому
ошибку нельзя перехватить обычным `tryCatch()` — в примере она
воспроизведена через `eval(parse(text = ...))`. Магритт-пайп `%>%`
допускает передачу имени функции без скобок. Исправление второй строки —
добавить скобки: `starwars$height |> mean()`.

#### Задание 4. Именованный вектор, в котором имена совпадают со значениями

``` r
c("luke", "vader") %>% setNames(., .)
```

       luke   vader 
     "luke" "vader" 

``` r
c("luke", "vader") |> setNames(nm = _)
```

       luke   vader 
     "luke" "vader" 

В первом варианте `.` используется дважды, потому что функция
`setNames()` принимает два аргумента (объект и имена), и в магритт-пайпе
плейсхолдер можно ставить в любую позицию, в том числе повторно.
Нативный пайп повторный плейсхолдер не разрешает и всегда подставляет
значение первым аргументом, поэтому имя вектора указывать не нужно —
достаточно назвать второй аргумент: `nm = _`.

#### Задание 5. Замена пайпов на противоположные

``` r
starwars |> subset(!is.na(height)) |> with(mean(height)) |> round(1)
```

    [1] 174.6

``` r
starwars %>% filter(!is.na(height)) %>% summarise(m = round(mean(height), 1)) %>% pull(m)
```

    [1] 174.6

Обе записи дают 174.6 — замена прошла удачно, так как в этих вызовах
значение подставляется первым аргументом.

Пример, где замена потребовала правки кода:

``` r
c("Luke Skywalker", "Darth Vader") %>% grepl("Sky", .)
```

    [1]  TRUE FALSE

``` r
c("Luke Skywalker", "Darth Vader") |> grepl("Sky", x = _)
```

    [1]  TRUE FALSE

При переходе с `%>%` на `|>` плейсхолдер `.` пришлось заменить на
именованный аргумент `x = _`, иначе значение подставилось бы первым
аргументом (`pattern`) и результат был бы неверным.

## Оценка результата

Все задания частей 1–4 выполнены, код воспроизводим: документ целиком
рендерится одной командой, результаты вставляются автоматически.

Сравнение операторов конвейера:

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr>
<th>Критерий</th>
<th>Нативный пайп (base R, с 4.1)</th>
<th>Пайп Tidyverse (magrittr)</th>
</tr>
</thead>
<tbody>
<tr>
<td>Подстановка значения первым аргументом</td>
<td>автоматически</td>
<td>автоматически</td>
</tr>
<tr>
<td>Плейсхолдер</td>
<td><code>_</code> (с R 4.2), только именованный аргумент</td>
<td><code>.</code>, любая позиция выражения</td>
</tr>
<tr>
<td>Повторный плейсхолдер</td>
<td>нельзя</td>
<td>можно</td>
</tr>
<tr>
<td>Вызов функции без скобок</td>
<td>нужны скобки: <code>mean()</code></td>
<td>допустимо: <code>x %&gt;% mean</code></td>
</tr>
</tbody>
</table>

Дополнительные наблюдения по данным:

- в наборе `starwars` много пропусков: 22 расы вообще не имеют
  заполненного `birth_year`, поэтому среднее по ним равно `NaN`, а не
  `0`;
- в `nycflights13::airports` обнаружены ошибки координат: у EEN широта и
  долгота перепутаны местами, у DVT и MYF потерян знак долготы. Это
  меняет формальный ответ в задании 7 части 3;
- в наборе `flights` нет рейсов с пунктом назначения JFK, так как все
  рейсы вылетают из Нью-Йорка; вопрос задания 6 части 3 корректно решать
  по столбцу `origin`.

## Вывод

В ходе работы освоены базовые структуры данных языка R: числовые,
символьные и логические векторы, списки и датафреймы, а также индексация
— положительная, отрицательная и логическая. Подтверждено, что R
приводит элементы вектора к общему типу, а пропуски `NA`
распространяются на результат вычислений, если не указан `na.rm = TRUE`.

Изучены глаголы пакета dplyr: `filter()`, `mutate()`, `arrange()`,
`group_by()`, `summarise()`, `count()` и соединения `inner_join()` и
`left_join()`. Показано, что соединение таблиц позволяет обогащать
данные справочниками (`airlines`, `airports`, `weather`) и отвечать на
вопросы, которые по одной таблице решить нельзя.

Сравнение пайпов показало, что нативный `|>` и магритт-пайп `%>%` в
большинстве случаев взаимозаменяемы, но различаются в деталях: нативный
пайп требует вызова функции справа и допускает только именованный
плейсхолдер `_`, тогда как `%>%` поддерживает плейсхолдер `.` в любой
позиции и повторное его использование.

Отчёт подготовлен в Quarto: весь код выполняется при рендеринге, что
обеспечивает воспроизводимость результатов.
