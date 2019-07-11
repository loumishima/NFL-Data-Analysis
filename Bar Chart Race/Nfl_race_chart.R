library(ggplot2)
library(tidyverse)
library(data.table)
library(gganimate)
library(hrbrthemes)
library(fastDummies)

#Hint - Try to replicate this on Python (Just to learn :D )

setwd('/Users/gather3/Documents/General Coding/Web Scraping')


automargin <- function(attribute){
  if(max(attribute) / 10000 >= 1){
    return(1000)
  } else if(max(attribute) / 100 >= 1){
    return(10)
  } else {
    return(0)
  }
}

organize_data <- function(data = 'nfl.csv', attribute = 'TD') {

  data <- read_csv(data, na = '--' )

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
    arrange(desc(!!as.name(attribute))) %>% 
    mutate(rank=row_number()) %>%
    filter(rank<=10) %>% 
    ungroup()
  
  return(data)
  
}

create_visualisation <- function(data, attribute = 'TD'){
  
  margin <- automargin(attribute = data[attribute])
  p <- data %>%
    ggplot(aes(x = -rank,y = !!as.name(attribute), group = Player)) + 
    geom_tile(aes(y = !!as.name(attribute) / 2, height = !!as.name(attribute), fill = Team, color = Team), size = 1, width = 0.9) +
    geom_text(aes(label = Player), hjust = "right", colour = "white", fontface = "bold", nudge_y = -margin) +
    geom_text(aes(label = scales::comma(!!as.name(attribute))), hjust = "left", nudge_y = margin, colour = "grey30") +
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
    labs(title=paste("NFL Cumulative", attribute, "Leaders"),
         subtitle=paste(attribute, 'leader in {round(frame_time,0)}'),
         caption='Source: NFL
         Luiz Henrique Rodrigues / twitter: @LHRO_')
  
  # NFL Colors ----
  p <- p + scale_fill_manual(values=c(" RETIRED " = "#c2c3c4", # Retired
                                      "ARI" = "#97233F", # Arizona
                                      "ATL" = "#A71930", # Atlanta
                                      "BAL" = "#241773", # Baltimore
                                      "BOS" = "#002244", # New England
                                      "BUF" = "#00338D", # Buffalo
                                      "CAR" = "#0085CA", # Carolina
                                      "CHI" = "#0B162A", # Chicago
                                      "CIN" = "#FB4F14", # Cincinnati
                                      "CLE" = "#311D00", # Cleveland
                                      "DAL" = "#003594", # Dallas
                                      "DEN" = "#FB4F14", # Denver
                                      "DET" = "#0076B6", # Detroit
                                      "GB" = "#203731", # Green Bay
                                      "HOU" = "#03202F", # Houston
                                      "IND" = "#003087", # Indianapolis
                                      "JAC" = "#006778", # Jacksonville
                                      "JAX" = "#006778", # Jacksonville
                                      "KC" = "#E31837", # Kansas City
                                      "LA" = "#002244", # LAR
                                      "LAC" = "#0080C6", # LAC
                                      "MIA" = "#008E97", # Miami
                                      "MIN" = "#4F2683", # Minnesota
                                      "NE" = "#002244", # New England
                                      "NO" = "#D3BC8D", # New Orleans
                                      "NYG" = "#0B2265", # NYG
                                      "NYJ" = "#125740", # NYJ
                                      "OAK" = "#000000", # Oakland
                                      "PHI" = "#004C54", # Philadelphia
                                      "PHO" = "#97233F", # Phoenix
                                      "PIT" = "#FFB612", # Pittsburgh
                                      "RAI" = "#000000", # LA Raiders
                                      "RAM" = "#002244", # LA Rams (PAST)
                                      "SD" = "#0080C6", # San Diego
                                      "SEA" = "#002244", # Seattle
                                      "SF" = "#AA0000", # San Francisco
                                      "STL" = "#002244", # LAR
                                      "TB" = "#D50A0A", # Tampa
                                      "TEN" = "#0C2340", # Tenessee
                                      "WAS" = "#773141" # Washington
  ))
  # Scatter plot
  
  p <- p + scale_color_manual(values=c(" RETIRED " =  "#c2c3c4", # RETIRED
                                       "ARI" = "#FFB612", # Arizona
                                       "ATL" = "#000000", # Atlanta
                                       "BAL" = "#000000", # Baltimore
                                       "BOS" = "#C60C30", # New England
                                       "BUF" = "#C60C30", # Buffalo
                                       "CAR" = "#101820", # Carolina
                                       "CHI" = "#C83803", # Chicago
                                       "CIN" = "#000000", # Cincinnati
                                       "CLE"  = "#FF3C00", # Cleveland
                                       "DAL" = "#869397", # Dallas
                                       "DEN" = "#002244", # Denver
                                       "DET" = "#B0B7BC", # Detroit
                                       "GB" = "#FFB612", # Green Bay
                                       "HOU" = "#A71930", # Houston
                                       "IND" = "#003087", # Indianapolis
                                       "JAC" = "#9F792C", # Jacksonville
                                       "JAX" = "#9F792C", # Jacksonville
                                       "KC" = "#FFB81C", # Kansas City
                                       "LA" = "#866D4B", # LAR
                                       "LAC" = "#FFC20E", # LAC
                                       "MIA" = "#FC4C02", # Miami
                                       "MIN" = "#FFC62F", # Minnesota
                                       "NE" = "#C60C30", # New England
                                       "NO" = "#101820", # New Orleans
                                       "NYG" = "#A71930", # NYG
                                       "NYJ" = "#125740", # NYJ
                                       "OAK" = "#A5ACAF", # Oakland
                                       "PHI" = "#A5ACAF", # Philadelphia
                                       "PHO" = "#FFB612", # Phoenix
                                       "PIT"= "#101820", # Pittsburgh
                                       "RAI" = "#A5ACAF", # LA Raiders
                                       "RAM" = "#866D4B", # LA Rams (PAST)
                                       "SD" = "#FFC20E", # LAC
                                       "SEA" = "#69BE28", # Seattle
                                       "SF" = "#B3995D", # San Francisco
                                       "STL"  = "#866D4B", # LAR
                                       "TB" = "#0A0A08", # Tampa
                                       "TEN" = "#418FDE", # Tenessee
                                        "WAS" = "#FFB612" # Washington
  ))
  
  # Animation ----
  animate(p, nframes = 1000, fps = 25, end_pause = 50, width = 1200, height = 900)
  
  anim_save(paste0('race_',attribute,'.gif'), animation = last_animation())
  
  #teams' colors - Fill = Main Colour / Colour = Secondary Colour
  #Color reference: https://teamcolorcodes.com/nfl-team-color-codes/
  #Example: NE(Fill = Blue, Colour = Red)
}

# Main ----

x <- organize_data()
create_visualisation(x)