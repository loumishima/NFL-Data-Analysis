#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 10 13:56:39 2019

@author: gather3
"""

import scrapy
import datetime
from scrapy.shell import inspect_response


class NFLSpider(scrapy.Spider): 
    
    name = 'stadiums'
    
    def start_requests(self):
        url = 'https://sportleaguemaps.com/football/nfl/'
        
        yield scrapy.Request(url=url, callback=self.parse)
        
        
    def parse(self, response):
        
        # Extracting all Player links
        stadium_names = response.xpath('//table//tr[not(contains(., "Logo"))]//text()').getall()
        
        for i in range(0, len(stadium_names) - 1, 3):
            yield {
                    'Team' : stadium_names[i],
                    'Name': stadium_names[i+1],
                    'Location':stadium_names[i+2]
                    }