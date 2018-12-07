require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open('https://www.storeparser.com/en-GB/xbox-one/deals/'))

ul = doc.at_css('ul#sp_pagination')
links = ul.css('li')

matches = /[0-9]+/.match(links.text)

max_page = matches.to_s.split("").map(&:to_i).max
