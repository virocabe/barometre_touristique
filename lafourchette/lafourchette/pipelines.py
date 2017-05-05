# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html


class LafourchettePipeline(object):
	def process_item(self, item, spider):
		item.setdefault('website','la fourchette')
		item.setdefault('type_activite','offre de services')
		item.setdefault('sous_type_activite','restauration')
		item.setdefault('language','fr')
		item.setdefault('positive_content','')
		item.setdefault('negative_content','')

		item['region'] = item['zipcode']
    	#item['zipcode']
    	#item['city']
    	#item['nb_comments']
    	#item['date']

		item['note']= float(item['note']) / 2
		item['note_cuisine'] = float(item['note_cuisine']) / 2
		item['note_service'] = float(item['note_service']) / 2
		item['note_cadre'] = float(item['note_cadre']) / 2

		return item
