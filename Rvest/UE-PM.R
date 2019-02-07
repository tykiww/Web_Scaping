install.packages("rvest")
install.packages("ggrepel")
library(rvest)
library(stringr)
library(dplyr)

url <- "https://en.wikipedia.org/wiki/List_of_Prime_Ministers_of_Japan"

PrimM <- url %>% 
  read_html() %>% 
  html_table(fill = TRUE)

showa_era <- PrimM %>% .[[4]]    # table for Prime Ministers in Showa Era
heisei_era <- PrimM %>% .[[5]]   # table for Prime Ministers in Heisei Era


prime_ministers <- data.frame(
  name <- c("Tetsu Katayama", "Hitoshi Ashida", "Shigeru Yoshida", "Ichiro Hatoyama", "Tanzan Ishibashi",
           "Nobusuke Kishi", "Hayato Ikeda", "Eisaku Sato", "Kakuei Tanaka", "Takeo Miki",
           "Takeo Fukuda", "Masayoshi Ohira", "Zenko Suzuki", "Yasuhiro Nakasone", "Noboru Takeshita",
           "Sosuke Uno", "Toshiki Kaifu", "Kiichi Miyazawa", "Morihiro Hosokawa", "Tsutomu Hata",
           "Tomiichi Murayama", "Ryutaro Hashimoto", "Keizo Obuchi", "Yoshiro Mori", "Junichiro Koizumi",
           "Shinzo Abe (1)", "Yasuo Fukuda", "Taro Aso", "Yukio Hatoyama", "Naoto Kan",
           "Yoshihiko Noda", "Shinzo Abe (2)"),
  
  start <- as.Date(c("1947-05-24", "1948-03-10", "1948-10-15", "1954-12-10", "1956-12-23",
                    "1957-02-25", "1960-07-19", "1964-11-09", "1972-07-07", "1974-12-09",
                    "1976-12-24", "1978-12-07", "1980-07-17", "1982-11-27", "1987-11-06",
                    "1989-06-03", "1989-08-10", "1991-11-05", "1993-08-09", "1994-04-28",
                    "1994-06-30", "1996-01-11", "1998-06-30", "2000-04-05", "2001-04-26",
                    "2006-09-26", "2007-09-26", "2008-09-24", "2009-09-16", "2010-06-08",
                    "2011-09-02", "2012-12-26")),
  
  end <- as.Date(c("1948-03-10", "1948-10-15", "1954-12-10", "1956-12-23", "1957-02-25",
                  "1960-07-19", "1964-11-09", "1972-07-07", "1974-12-09", "1976-12-24",
                  "1978-12-07", "1980-07-17", "1982-11-27", "1987-11-06", "1989-06-03",
                  "1989-08-10", "1991-11-05", "1993-08-09", "1994-04-28", "1994-06-30",
                  "1996-01-11", "1998-06-30", "2000-04-05", "2001-04-26", "2006-09-26",
                  "2007-09-26", "2008-09-24", "2009-09-16", "2010-06-08", "2011-09-02",
                  "2012-12-26", "2017-01-01")),
  stringsAsFactors = FALSE
)

# clean columns
length(colnames(prime_ministers))
colnames(prime_ministers) <- c("name", "start", "end")

# download data from url2
url2 <- "https://fred.stlouisfed.org/series/LRHUTTTTJPM156S"

japan_unemploy <- read.csv("~/Dropbox/R working directory/LRHUTTTTJPM156S.csv", 
                           header = TRUE, stringsAsFactors = FALSE)
library(tibble)
glimpse(japan_unemploy)   # glimpse() is similar to using str() but tidier
japan_unemploy$DATE <-as.Date(japan_unemploy$DATE, format="%Y-%m-%d")

#colnames(japan_unemploy) <- japan_unemploy %>% 
#  colnames() %>% 
#  str_to_lower()

##OR##

colnames(japan_unemploy) <- c("date","unemployed")
  
library(ggrepel)  # to help with overlapping labels
library(scales)   # to help format scales and labels
library(ggplot2)

japan_unemploy %>% 
  ggplot() +
  geom_line(
    aes(date, unemployed/100)
  ) +
  geom_vline(
    data = prime_ministers, 
    aes(xintercept = as.numeric(start)),
    color = "blue", alpha = 0.5
  ) +
  geom_text_repel(
    data = prime_ministers %>% filter(start > japan_unemploy$date[1]),
    aes(x = start, y = 0.015, label = name)
  ) +
  scale_y_continuous(
    labels = percent_format()
  ) +
  geom_hline(
    yintercept = mean(japan_unemploy$unemployed/100), color = "red", alpha = 0.5
  ) +
  labs(
    x = "Year", y = "Unemployment Rate (%)"
  ) +
  theme_bw()

(prime_ministers$end - prime_ministers$start) %>% head(8)   # only show results from first 8 rows
prime_ministers <- prime_ministers %>% mutate(pm_term = (end - start))

japan_unemploy %>% 
  ggplot() +
  geom_line(
    aes(date, unemployed/100)) +
  geom_vline(
    data = prime_ministers, 
    aes(xintercept = as.numeric(start)),
    color = "blue", alpha = 0.5) +
  scale_x_date(
    limits = as.Date(c("1960-01-01", "2020-01-01")),
    date_labels = "%Y"
  ) +
  geom_text_repel(
    data = prime_ministers %>% filter(start > japan_unemploy$date[1], pm_term > 730),
    aes(x = start, y = 0.06, label = name), 
    force = 15, arrow = arrow(length = unit(0.01, 'npc'))
  ) +
  scale_y_continuous(
    labels = percent_format(), 
    limits = c(0.0, 0.07),
    expand = c(0, 0)) +
  geom_hline(
    yintercept = median(japan_unemploy$unemployed/100), color = "red") +
  labs(
    x = "Year", y = "Unemployment Rate (%)") +
  theme_bw()
