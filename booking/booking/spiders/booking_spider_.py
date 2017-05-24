# -*- coding: utf-8 -*-
"""
Created on Sun Mar 19 12:22:11 2017

@author: Vincent Henric
"""


#scrapy "C:/Users/Vincent Henric/python" tutorial

from ..items import BookingItem
import xlrd


import scrapy
import requests
import re
import pandas as pd
import numpy as np
import time
import csv
import urllib
from urllib.parse import urlencode
from scrapy.contrib.linkextractors import LinkExtractor
from scrapy.contrib.spiders import CrawlSpider, Rule
from scrapy.selector import Selector
from scrapy.http import HtmlResponse

from bs4 import BeautifulSoup


wb = xlrd.open_workbook('regions-villes.xlsx') #Name of the file
sh = wb.sheet_by_name('Regions-Villes') #Name of the sheet

liste = []

for rownum in range(69,79): #CHANGE RANGE DEPENDING ON REGION
    liste.append(sh.row_values(rownum)[2])
    print(sh.row_values(rownum)[2])

selected_language = "fr"
Region = "ile-de-france"
    
class BookingSpider(scrapy.Spider):
    name = "booking"
    
    
    
    LANGUAGE_LIST = ["fr","en"]
    REGION_LIST   = ["auvergne-rhone-alpes","bourgogne-franche-comte","bretagne","centre-val de loire","corse","grand est","hauts-de-france","ile-de-france","normandie","nouvelle-aquitaine","occitanie","pays de la loire","provence-alpes-cotes d'azur"]
    REGIONS = ["Auvergne-Rhône-Alpes","Bourgogne-Franche-Comté","Bretagne","Centre-Val de Loire","Corse","Grand Est","Hauts-de-France","Ile-de-France","Normandie","Nouvelle-Aquitaine","Occitanie","Pays de la Loire","Provence-Alpes-Côtes d'Azur"]
    
    #activity = ["restaurants"]  #,"hotels"
        #location = ["Lille"]

    """
    start_urls = [
        "https://www.booking.com"
    ]"""
    
    start_urls = ['https://www.booking.com/searchresults.fr.html?ss=+%s' %(city) for city in liste]
       
    
    
        #https://www.yelp.fr/search?find_loc=Paris&start=0&sortby=review_count&cflt=restaurants
        #return [scrapy.FormRequest("http://www.example.com/login",
        #                          formdata={'user': 'john', 'pass': 'secret'},
        #                         callback=self.logged_in)]
    

    #CLOSESPIDER_ITEMCOUNT = 10
    

    def parse_review(self, response):
        #how to handle a review page
        global selected_language
        
        website             = 'booking'
        type_activite       = 'offre de services'
        sous_type_activite  = 'hotels'
        language            = selected_language
        #region              = 'bourgogne-franche-comte' 
        activity_title      = response.xpath('.//div[@class="standalone_reviews_hotel_header"]//h1[@class="item hotel_name"]/a/text()').extract_first() 
        address             = response.xpath('.//div[@class="standalone_reviews_hotel_header"]//p[@class="hotel_address"]/text()').extract_first()
        zipcode             = re.findall('\d{5}|$',address)[0]
        city                = re.findall('\w+|$',re.findall(',+ *[0-9]{5} *\w*|$',address)[0]+' vide')[1]
        nb_comments         = response.xpath('.//div[@id="review_list_score"]//p[@class="review_list_score_count"]/text()').extract_first(default='0')
        
        for review in response.xpath('//div[@id="review_list_page_container"]//li[@class="review_item clearfix "]'):

            content             = review.xpath('.//div[@class="review_item_header_content_container"]/a[@class="review_item_header_content"]/span/text()').extract_first(default='')
            positive_content    = review.xpath('.//p[@class="review_pos"]/span[@itemprop="reviewBody"]/text()').extract_first(default='')
            negative_content    = review.xpath('.//p[@class="review_neg"]/span[@itemprop="reviewBody"]/text()').extract_first(default='')
            date                = review.xpath('.//p[@class="review_item_date"]/text()').extract_first(default='31 décembre 9999')
            note                = review.xpath('.//div[@class="\nreview_item_header_score_container\n"]/div[1]/text()').extract_first(default='-2')

            #yield scrapy.Request(url, self.parse_activity)
            
            item = BookingItem()
            item['website'] = website
            item['type_activite'] = type_activite
            item['sous_type_activite'] = sous_type_activite
            item['language'] = language
            item['activity_title'] = activity_title
            item['zipcode'] = zipcode
            item['city'] = city
            item['nb_comments'] = nb_comments
            item['content'] = content
            item['positive_content'] = positive_content
            item['negative_content'] = negative_content
            item['date'] = date
            item['note'] = note

            yield item
            
            
    
    def parse_select_language(self, response):
        url = response.url
        global selected_language
        if selected_language == "fr":
            request = scrapy.Request(url=url + urlencode({'r_lang': 'fr'}),
                            method = 'GET',
                        callback=self.parse_review)
        else :
            request = scrapy.Request(url=url+urlencode({'r_lang': 'en'}),
                            method = 'GET',
                        callback=self.parse_review)
        yield request

    def parse_activity(self, response):
        #scraping on a review page
        
        review_page = response.xpath('.//*[@id="hotelTmpl"]//a[@class="show_all_reviews_btn"]/@href').extract()
        if review_page:
            url = response.urljoin(review_page[0])
            yield(scrapy.Request(url, self.parse_review))

    def parse(self, response):
        
        #scraping on a result page
        for the_activity in response.xpath('.//div[@id="hotellist_inner"]/div[@data-hotelid]'):
            href = the_activity.xpath('.//a[@class="hotel_name_link url"]/@href').extract()
            url = response.urljoin(href[0])
            yield scrapy.Request(url, self.parse_activity)

        next_page = response.xpath('.//*[@id="search_results_table"]/div[@class="results-paging"]/a[text()="Page suivante"]/@href')
        if next_page:
            url = response.urljoin(next_page[0].extract())
            yield scrapy.Request(url, self.parse)

    '''def parse__(self, response):
        global Region
        #global the_city
        #print(Region)
        the_city = response.meta['the_city']
        print(the_city)
        
        url = response.url
        print(url)
        data = {'ss': the_city}
        request = scrapy.Request(url=url+"/searchresults.fr.html?" + urlencode(data),
                        method = 'GET',
                    callback=self.parse_results)
        yield request'''
        
#scrapy crawl booking -o booking-provence-alpes-cote-d-azur.json
#scrapy shell https://www.yelp.fr/search?find_loc=lille&start=0&sortby=review_count&find_desc=Restaurants