library(ggplot2)
library(tidyverse)
library(data.table)
library(gganimate)
library(hrbrthemes)
library(fastDummies)

#Hint - Try to replicate this on Python (Just to learn :D )

setwd('/Users/gather3/Documents/General Coding/Web Scraping')


data <- read_csv('nfl.csv', na = '--' )

data <- data %>% mutate(Yds = as.numeric(gsub("\\.", "", as.character(Yds))))

data <- select(data, -c(X1,Lng))

data <- dummy_rows(data, select_columns = c('Player', 'Year'), dummy_value = 0)

data <- data %>% mutate(Team = if_else(Team == '0', ' RETIRED ', Team))

players_cumulative <- data %>% 
  select(c(Rk,Player,Team,Comp,Att,Yds,TD, Int, `1st`, `20+`:Sck, Year)) %>%
  group_by(Player) %>% 
  arrange(Year) %>% 
  mutate_at(vars(-Year,-Player,-Team,-Rk), cumsum) %>% 
  ungroup()
  
data <- players_cumulative %>%
  group_by(Year) %>%
  arrange(desc(Yds)) %>%
  mutate(rank=row_number()) %>%
  filter(rank<=10) %>% 
  ungroup()

p <- data %>%
  ggplot(aes(x = -rank,y = Yds, group = Player)) +
  geom_tile(aes(y = Yds / 2, height = Yds, fill = Team), width = 0.9) +
  geom_text(aes(label = Player), hjust = "right", colour = "black", fontface = "bold", nudge_y = -1000) +
  geom_text(aes(label = scales::comma(Yds)), hjust = "left", nudge_y = 1000, colour = "grey30") +
  coord_flip(clip="off") +
  scale_x_discrete("") +
  scale_y_continuous("",labels=scales::comma) +
  hrbrthemes::theme_ipsum(plot_title_size = 32, subtitle_size = 24, caption_size = 20, base_size = 20) +
  theme(panel.grid.major.y=element_blank(),
        panel.grid.minor.x=element_blank(),
        legend.position = 'right',
        plot.margin = margin(1,1,1,2,"cm"),
        axis.text.y=element_blank()) +
  # gganimate code to transition by year:
  transition_time(Year) +
  ease_aes('cubic-in-out') +
  labs(title="NFL Cumulative Yard Leaders",
       subtitle='Yards leader in {round(frame_time,0)}',
       caption='Source: NFL
       Luiz Henrique Rodrigues / twitter: @LHRO_')

animate(p, nframes = 1000, fps = 25, end_pause = 50, width = 1200, height = 900)

anim_save('race2.gif', animation = last_animation())

#Change the colors to the teams - Fill = Main Colour / Colour = Secondary Colour
#Color reference: https://teamcolorcodes.com/nfl-team-color-codes/
# Example: NE(Fill = Blue, Colour = Red)
