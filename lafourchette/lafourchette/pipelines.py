# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html
import re

def change_date(mydate):
	mydatebis = mydate.replace(' ','-')
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

class LafourchettePipeline(object):
	def process_item(self, item, spider):
		item.setdefault('website','la fourchette')
		item.setdefault('type_activite','offre de services')
		item.setdefault('sous_type_activite','restauration')
		item.setdefault('language','fr')
		item.setdefault('positive_content','')
		item.setdefault('negative_content','')
		item.setdefault('sous_sous_categorie','')
		#A CHANGER EN FONCTION DE LA REGION
		item.setdefault('region','')
		item['activity_title'] = item['activity_title'].lower()
		item['zipcode'] = re.sub('[^0-9]', '', ((re.sub('\s+',' ',item['zipcode'])).split(", ",1)[1]))
		item['city'] = re.sub('\s+','',str(item['city'])).lower()
		item['nb_comments'] = int(re.sub('[^0-9]','',(str(item['nb_comments'])).split("/",1)[1]))
		item['date'] = change_date((re.sub('\s+',' ',str(item['date']))).split(": ",1)[1])
		item['note']= float(item['note']) / 2
		item['note_cuisine'] = float(item['note_cuisine']) / 2
		item['note_service'] = float(item['note_service']) / 2
		item['note_cadre'] = float(item['note_cadre']) / 2

		return item
