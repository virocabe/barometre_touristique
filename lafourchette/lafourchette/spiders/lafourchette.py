import scrapy
from ..items import LafourchetteItem
import xlrd

wb = xlrd.open_workbook('regions-villes.xlsx') #Name of the file
sh = wb.sheet_by_name(u'Regions-Villes') #Name of the sheet


#Creating a list with all the urls
liste = []

for rownum in range(0,10): #CHANGE RANGE DEPENDING ON REGION
    liste.append(sh.row_values(rownum)[2])


class LafourchetteSpider(scrapy.Spider):
    name = 'lafourchette'
    
    start_urls = ['http://www.lafourchette.com/restaurant+%s' %(city) for city in liste]
    
    def parse(self, response):
        for href in response.xpath('.//div[@class="resultItem-information"]/h3[@class="resultItem-name"]/a/@href'):
            url = response.urljoin(href.extract() + '#reviews')
            yield scrapy.Request(url, self.parse_item)
            
        next_page = response.xpath('.//div[@class="pagerfanta"]/div[@class="pagination"]/ul/li[@class="next"]/a/@href').extract_first()
        if next_page:
            url = response.urljoin(next_page + '#reviews')
            yield(scrapy.Request(url, self.parse))
    
    def parse_item(self, response):
        activity_title = response.xpath('.//div[@class="restaurantSummary-summaryWrapper col-xs-9"]/h1[@class="restaurantSummary-name"]/text()').extract_first()
        zipcode = response.xpath('.//span[@class="restaurantSummary-address"]/text()').extract_first()
        city = response.xpath('.//div[@class="header-citySelectorBg icon-city-white"]/a/text()').extract_first()
        nb_comments = response.xpath('.//div[@class="reviews-counter"]/text()').extract_first()
        for rev in response.xpath('.//div[@class="reviewItem reviewItem--mainCustomer"]'):
            item = LafourchetteItem()
            item['activity_title'] = activity_title
            item['zipcode'] = zipcode
            item['city'] = city
            item['nb_comments'] = nb_comments
            item['content'] = rev.xpath('.//div[@class="reviewItem-customerComment"]/text()').extract_first()
            item['date'] = rev.xpath('.//ul[@class="clearfix reviewItem-bookingInfo"]/li[@class="reviewItem-date"]/text()').extract_first()
            item['note'] = rev.xpath('.//div[@class="reviewItem-ribbon rating"]/span[@class="rating-ratingValue"]/text()').extract_first()
            item['note_cuisine'] = rev.xpath('.//span[@class="reviewItem-scoreText"]/text()').extract()[0]
            item['note_service'] = rev.xpath('.//span[@class="reviewItem-scoreText"]/text()').extract()[1]
            item['note_cadre'] = rev.xpath('.//span[@class="reviewItem-scoreText"]/text()').extract()[2]
            yield item
        
        last_page = response.xpath('.//ul[@class="pagination oneline text_right"]/li[@class=""]/a/text()')[-1].extract()
        last_page_num = int(last_page)

        for i in range(2,last_page_num):
            url = response.urljoin('?page=' + str(i))
            yield(scrapy.Request(url, self.parse_item))