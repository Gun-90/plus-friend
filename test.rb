require 'nokogiri'
require 'rest-client'

@url = 'https://pubg.op.gg/user/ZonnaBoTinDa?server=pc-kakao'
@cat_xml = RestClient.get(@url)
@cat_doc =  Nokogiri::HTML(@cat_xml)
@cat_url = @cat_doc.css('div.recent-matches__avg-rank').text.strip.chomp

puts @cat_url