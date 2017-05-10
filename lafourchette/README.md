# README


* * example of a scrapy project for scraping on lafourchette.com


- Some items have a default value, and the rest is scraped from the website.

- The start_urls method builds its urls by taking values from a excel spreadsheet regions-villes.xlsx

- For each region you want to scrape, make sure you write the name of the region in the pipeline.py