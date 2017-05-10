# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class LafourchetteItem(scrapy.Item):
    # define the fields for your item here like:
	website = scrapy.Field()   #par défaut
	type_activite= scrapy.Field()    #par défaut
	sous_type_activite = scrapy.Field()   #par défaut
	language = scrapy.Field()   #par défaut
	region = scrapy.Field()    #à définir
	activity_title = scrapy.Field()
	zipcode = scrapy.Field()
	city = scrapy.Field()
	nb_comments = scrapy.Field()
	content = scrapy.Field()
	positive_content = scrapy.Field()    #null par défaut
	negative_content = scrapy.Field()    #null par défaut
	date = scrapy.Field()
	note = scrapy.Field()
	note_cuisine = scrapy.Field()
	note_service = scrapy.Field()
	note_cadre = scrapy.Field()
	sous_sous_categorie = scrapy.Field()

