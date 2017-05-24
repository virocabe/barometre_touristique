# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html

import re

def change_date(mydate):
	mydatebis = mydate.strip().replace(' ','-')
	dates = re.split('-',mydatebis)
	if dates[1] == 'janv.':
		dates[1] = '01'
	elif dates[1] == 'févr.':
		dates[1] = '02'
	elif dates[1] == 'mars':
		dates[1] = '03'
	elif dates[1] == 'avr.':
		dates[1] = '04'
	elif dates[1] == 'mai':
		dates[1] = '05'
	elif dates[1] == 'juin':
		dates[1] = '06'
	elif dates[1] == 'juil.':
		dates[1] = '07'
	elif dates[1] == 'août':
		dates[1] = '08'
	elif dates[1] == 'sept.':
		dates[1] = '09'
	elif dates[1] == 'oct.':
		dates[1] = '10'
	elif dates[1] == 'nov.':
		dates[1] = '11'
	elif dates[1] == 'déc.':
		dates[1] = '12'
	
	newdate = dates[0] + '/' + dates[1] + '/' + dates[2]
	return newdate

class BookingPipeline(object):
	def process_item(self, item, spider):
		item.setdefault('website','booking')
		item.setdefault('type_activite','offre de services')
		item.setdefault('sous_type_activite','hotels')
		#item.setdefault('language','fr')
		item.setdefault('positive_content','')
		item.setdefault('negative_content','')
		item.setdefault('sous_sous_categorie','')

		#A CHANGER EN FONCTION DE LA REGION
		item.setdefault('region',"ile-de-france")
		item['activity_title'] = item['activity_title'].lower()
		item['zipcode'] = item['zipcode']
		item['city'] = str(item['city']).lower()
		item['nb_comments'] = int((re.findall('[0-9]+|$',item['nb_comments'])[0]).replace(' ','0'))
		item['date'] = change_date(item['date'])
		item['note']= float(item['note'].replace(',', '.'))/2
		item['note_cuisine'] = float(0)
		item['note_service'] = float(0)
		item['note_cadre'] = float(0)

		return item
    