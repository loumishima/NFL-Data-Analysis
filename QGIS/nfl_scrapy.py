#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jul  8 10:25:48 2019

@author: gather3
"""

import scrapy
import datetime
from scrapy.shell import inspect_response


class NFLSpider(scrapy.Spider): 
    
    name = 'nfl'
    
    def start_requests(self):
        urls = (f'http://www.nfl.com/stats/categorystats?tabSeq=0&statisticCategory=PASSING&conference=null&season={year}&seasonType=POST&d-447263-s=PASSING_YARDS&d-447263-o=2&d-447263-n=1'
            for year in range(1933, datetime.datetime.now().year))
        
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)
        
    def parse_playerInfo(self,response):
        # player_info = response.xpath('//div[@class="player-info"]//p/text()').getall()
        # born = //div[@class="player-info"]//p[contains(.,"Born")]
        yield {
                    'Name' : response.xpath('//div[@class="player-info"]//span[1]/text()').get(default='NA'),
                    'Bornplace': response.xpath('//div[@class="player-info"]//p[contains(.,"Born")]/text()[2]').get(default='NA'),
                    'College':response.xpath('//div[@class="player-info"]//p[contains(.,"College")]/text()').get(default='NA'),
                    'Experience': response.xpath('//div[@class="player-info"]//p[contains(.,"Experience")]/text()').get(default='NA'),
                    'HS':response.xpath('//div[@class="player-info"]//p[contains(.,"School")]/text()').get(default='NA'),
                    'HOF':response.xpath('//div[@class="player-info"]//p[contains(.,"Fame")]/text()').get(default='NA')
                    
                    }
        
    def parse(self, response):
        
        # Extracting all Player links
        Player_links = response.xpath('//table[@id="result"]//tbody[1]//tr//td[2]/a/@href').extract()  
        for player in Player_links:
            info = response.urljoin(player)
            yield scrapy.Request(info, callback=self.parse_playerInfo)

