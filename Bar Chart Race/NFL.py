#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jun 25 09:14:04 2019

@author: gather3
"""

from urllib.request import urlopen
from urllib.error import HTTPError
from bs4 import BeautifulSoup
import re
import pandas as pd
import datetime
import argparse



class NFLScrapper:
    def __init__(self, initial_year = 1966, final_year = (datetime.datetime.today()).year, attribute = 'Passing', season_type = 'REG'):
        self.initial_year = initial_year
        self.final_year = final_year
        self.attribute = attribute
        self.season_type = season_type
        
    def SaveData(self, data):
        data.to_csv(f'{self.attribute}_from_{self.initial_year}to{self.final_year}.csv')
        return 1
        
    def getNFLData(self):
        data = pd.DataFrame()
        try:
            self.attribute = self.attribute.upper()
            
        except AttributeError:
            print('Please insert a valid attribute such as "Passing", "Rushing", etc')
            return('AttributeError')
        
        try:
            self.season_type = self.season_type.upper()
            
        except AttributeError:
            print('Please insert a valid season type such as "REG" for regular season and "POST" for postseason')
            return('AttributeError')
          
        for year in range(self.initial_year, self.final_year): 
            try:
                connection = urlopen(f'http://www.nfl.com/stats/categorystats?archive=false&conference=null&statisticCategory={self.attribute}&season={year}&seasonType={self.season_type}&experience=&tabSeq=0&qualified=false&Submit=Go')
            except HTTPError:
                print(f'The season of {year} was not collected')
                pass
            
            bs = BeautifulSoup(connection, 'html.parser')
        
            players_info = [re.sub('(\\n|\\t)', ',', col.get_text()) for col in bs.find_all('tr')]
        
            players_info = [re.sub(',{2,}', ', ', player) for player in players_info]
    
            players_info = [re.sub(r'([0-9]{1}),([0-9]{1})', r'\1.\2', player) for player in players_info]
    
            players_info = [re.sub(', ', ',', player) for player in players_info]
    
            players_info = [re.sub('(^,|,$)', '', player) for player in players_info]
            
            players = [players.split(',') for players in players_info]
    
            players = pd.DataFrame(data = players[1:], columns = players[0])
            
            #print(players)
    
            players['Year'] = year
            
            data = data.append(players)
            
        self.SaveData(data)
        
        return data
    

if(__name__ == "__main__"):
    
    parser = argparse.ArgumentParser(description= 'NFL Web Scrapper')
    parser.add_argument('-iy', '--initial_year', required = False, help = 'Year to start collecting NFL data', default = 1966)
    parser.add_argument('-fy', '--final_year', required = False, help = 'Year to stop collecting NFL data', default = (datetime.datetime.today()).year)
    parser.add_argument('-a', '--attribute', required = False, help = 'Spreadsheet status that you want to collect', default = 'Rushing' )
    parser.add_argument('-st', '--seasontype', required = False, help = 'Part of the season that you want to collect', default = 'REG')
    
    args = parser.parse_args()
    
    NFL = NFLScrapper(args.initial_year, args.final_year, args.attribute, args.seasontype)
    NFL.getNFLData()
    