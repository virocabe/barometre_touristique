import os
import csv
import re
from nltk.corpus import stopwords
from nltk.stem import SnowballStemmer
from collections import Counter
import numpy as np
import scipy as sp
import pandas as pd
from copy import deepcopy
import string


def change_date(mydata):
	for data in mydata:
		temp = data['date']
		if len(temp) == 10:
			data['date'] = temp[6:10] + '-' + temp[3:5]
		else:
			data['date'] = temp[5:9] + '-' + temp[2:4]
	return mydata

def add_count_variable(mydata):

	for data in mydata:
		data['nb_note'] = 1
		if data['website'] == 'la fourchette':
			data['nb_note_resto'] = 1
		else:
			data['nb_note_resto'] = 0
	return mydata




def create_dataframe(mydata):
	mydataset = pd.DataFrame(mydata)
	mydataset1 = mydataset[['website','date','region','type_activite','sous_type_activite','sous_sous_categorie','note', 'nb_note','note_cuisine','note_service','note_cadre','nb_note_resto','language']]
	return mydataset1

def calcul_sum_notes(mydataframe):
	mynewdataframe = mydataframe.groupby(['website','date','region','type_activite','sous_type_activite','sous_sous_categorie','language']).agg({'note':sum,'nb_note':sum,'note_cuisine':sum,'note_service':sum,'note_cadre':sum,'nb_note_resto':sum})[['note','nb_note','note_cuisine','note_service','note_cadre','nb_note_resto']].reset_index()
	return mynewdataframe

