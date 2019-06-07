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
  geom_tile(aes(y = Yds / 2, height = Yds, fill = Team, color = Team), size = 1, width = 0.9) +
  geom_text(aes(label = Player), hjust = "right", colour = "white", fontface = "bold", nudge_y = -1000) +
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

# NFL Colors ----
p <- p + scale_fill_manual(values=c("#c2c3c4", # Retired
                                    "#97233F", # Arizona
                                    "#A71930", # Atlanta
                                    "#241773", # Baltimore
                                    "#002244", # New England
                                    "#00338D", # Buffalo
                                    "#0085CA", # Carolina
                                    "#0B162A", # Chicago
                                    "#FB4F14", # Cincinnati
                                    "#311D00", # Cleveland
                                    "#003594", # Dallas
                                    "#FB4F14", # Denver
                                    "#0076B6", # Detroit
                                    "#203731", # Green Bay
                                    "#03202F", # Houston
                                    "#003087", # Indianapolis
                                    "#E31837", # Kansas City
                                    "#002244", # LAR
                                    "#0080C6", # LAC
                                    "#008E97", # Miami
                                    "#4F2683", # Minnesota
                                    "#002244", # New England
                                    "#D3BC8D", # New Orleans
                                    "#0B2265", # NYG
                                    "#125740", # NYJ
                                    "#000000", # Oakland
                                    "#004C54", # Philadelphia
                                    "#FFB612", # Pittsburgh
                                    "#0080C6", # San Diego
                                    "#002244", # Seattle
                                    "#AA0000", # San Francisco
                                    "#002244", # LAR
                                    "#D50A0A", # Tampa
                                    "#773141" # Washington
))
# Scatter plot

p <- p + scale_color_manual(values=c("#c2c3c4", # RETIRED
                                     "#FFB612", # Arizona
                                     "#000000", # Atlanta
                                     "#000000", # Baltimore
                                     "#C60C30", # New England
                                     "#C60C30", # Buffalo
                                     "#101820", # Carolina
                                     "#C83803", # Chicago
                                     "#000000", # Cincinnati
                                     "#FF3C00", # Cleveland
                                     "#869397", # Dallas
                                     "#002244", # Denver
                                     "#B0B7BC", # Detroit
                                     "#FFB612", # Green Bay
                                     "#A71930", # Houston
                                     "#003087", # Indianapolis
                                     "#FFB81C", # Kansas City
                                     "#866D4B", # LAR
                                     "#FFC20E", # LAC
                                     "#FC4C02", # Miami
                                     "#FFC62F", # Minnesota
                                     "#C60C30", # New England
                                     "#101820", # New Orleans
                                     "#A71930", # NYG
                                     "#125740", # NYJ
                                     "#A5ACAF", # Oakland
                                     "#A5ACAF", # Philadelphia
                                     "#101820", # Pittsburgh
                                     "#FFC20E", # LAC
                                     "#69BE28", # Seattle
                                     "#B3995D", # San Francisco
                                     "#866D4B", # LAR
                                     "#0A0A08", # Tampa
                                     "#FFB612" # Washington
))

# Animation ----
animate(p, nframes = 1000, fps = 25, end_pause = 50, width = 1200, height = 900)

anim_save('race.gif', animation = last_animation())

#Change the colors to the teams - Fill = Main Colour / Colour = Secondary Colour
#Color reference: https://teamcolorcodes.com/nfl-team-color-codes/
# Example: NE(Fill = Blue, Colour = Red)
