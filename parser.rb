require 'nokogiri'
require 'open-uri'

base_uri = "https://www.storeparser.com/en-GB/xbox-one/deals"

current_page = 1
max_page = 2
deals = []

def endpoint(current_page=1)
  "" if current_page.nil? || current_page == 1
  "/page-#{current_page}"
end

while current_page <= max_page
  doc = Nokogiri::HTML(open("#{base_uri}#{endpoint(current_page)}"))
  ul = doc.at_css('ul#sp_pagination')
  links = ul.css('li')
  items = doc.css('div.sp_product')
  matches = /[0-9]+/.match(links.text)
  max_page = matches.to_s.split("").map(&:to_i).max

  deals.push(items)

  current_page += 1
end

deals.each { |d| p d.length }
