import json
from functions import *
import csv

website = 'lafourchette'



dir_name = 'C:\\Users\\cdevaux\\Documents\\BAROMETRE TOURISME\\barometre_touristique\\' + website + '\\data\\'
regions = ['auvergne-rhone-alpes','bourgogne-franche-comte','bretagne','centre-val-de-loire','corse','grand-est','hauts-de-france','ile-de-france','normandie','nouvelle-aquitaine','occitanie','pays-de-la-loire','provence-alpes-cote-d-azur']

dataframefinal = pd.DataFrame()

for region in regions:

	file = website + '-' + region + '.json'

	with open(dir_name + file) as json_data:
		d = json.load(json_data)
		print(d[1])
		print(len(d[1]))

	dataset = change_date(d)
	print(dataset[1])

	dataset = add_count_variable(dataset)
	print(dataset[1])

	dataframe = create_dataframe(dataset)
	print(dataframe.iloc[0])

	dataframebis = calcul_sum_notes(dataframe)
	print(dataframebis.iloc[55])

	dataframefinal = dataframefinal.append(dataframebis, ignore_index=True)

csvtitle = 'data_' + website
dataframefinal.to_csv(csvtitle, encoding='utf-8')

