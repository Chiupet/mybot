require "net/http"
require "uri"
require "json"

class Hokkaido
  attr_accessor :name
  attr_accessor :id
  def initialize(name:,id:)
    self.name = name
    self.id = id
  end
end

area01=Hokkaido.new(name:"稚内", id:"011000")
area02=Hokkaido.new(name:"旭川", id:"012010")
area03=Hokkaido.new(name:"留萌", id:"012020")
area04=Hokkaido.new(name:"札幌", id:"016010")
area05=Hokkaido.new(name:"岩見沢", id:"016020")
area06=Hokkaido.new(name:"倶知安", id:"016030")
area07=Hokkaido.new(name:"網走", id:"013010")
area08=Hokkaido.new(name:"北見", id:"013020")
area09=Hokkaido.new(name:"紋別", id:"013030")
area10=Hokkaido.new(name:"根室", id:"014010")
area11=Hokkaido.new(name:"釧路", id:"014020")
area12=Hokkaido.new(name:"帯広", id:"014030")
area13=Hokkaido.new(name:"室蘭", id:"015010")
area14=Hokkaido.new(name:"浦河", id:"015020")
area15=Hokkaido.new(name:"函館", id:"017010")
area16=Hokkaido.new(name:"江差", id:"017020")


@areas = [area01,area02,area03,area04,area05,area06,area07,area08,
        area09,area10,area11,area12,area13,area14,area15,area16,]

@city_name = ""
@city_id = ""
@url1 = "http://weather.livedoor.com/forecast/webservice/json/v1?city="
