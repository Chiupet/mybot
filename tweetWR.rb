require 'twitter'
require "net/http"
require "uri"
require "json"

#----------ついった様　権限----------
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['CONS_KEY']
  config.consumer_secret     = ENV['CONS_SEC']
  config.access_token        = ENV['ACCE_KEY']
  config.access_token_secret = ENV['ACCE_SEC']
end

#----------お天気ゾーン--------------------
class Hokkaido
  attr_accessor :name
  attr_accessor :id
  def initialize(name:,id:)
    self.name = name
    self.id = id
  end
end

@area01=Hokkaido.new(name:"稚内", id:"011000")
@area02=Hokkaido.new(name:"旭川", id:"012010")
@area03=Hokkaido.new(name:"留萌", id:"012020")
@area04=Hokkaido.new(name:"札幌", id:"016010")
@area05=Hokkaido.new(name:"岩見沢", id:"016020")
@area06=Hokkaido.new(name:"倶知安", id:"016030")
@area07=Hokkaido.new(name:"網走", id:"013010")
@area08=Hokkaido.new(name:"北見", id:"013020")
@area09=Hokkaido.new(name:"紋別", id:"013030")
@area10=Hokkaido.new(name:"根室", id:"014010")
@area11=Hokkaido.new(name:"釧路", id:"014020")
@area12=Hokkaido.new(name:"帯広", id:"014030")
@area13=Hokkaido.new(name:"室蘭", id:"015010")
@area14=Hokkaido.new(name:"浦河", id:"015020")
@area15=Hokkaido.new(name:"函館", id:"017010")
@area16=Hokkaido.new(name:"江差", id:"017020")

@areas = [@area01,@area02,@area03,@area04,@area05,@area06,@area07,@area08,
        @area09,@area10,@area11,@area12,@area13,@area14,@area15,@area16,]
@city_name = ""
@city_id = ""
@url1 = "http://weather.livedoor.com/forecast/webservice/json/v1?city="




  @username = "wrjpbot"
  @mention_1stid = ""
  @mention_2ndid = ""
  @loop_cash = false
loop do #//////////////////////////////////////////////////////////////////////
  @cnt = 0
  @replied = false

  @client.mentions(:count => 1).each do |tw|
    if @loop_cash == true
      @mention_2ndid = @mention_1stid
    end
    if @mention_1stid != tw.id
      @mention_1stid = tw.id
      @client.mentions(:count => 50).each do |tweet|
        if tweet.id == @mention_2ndid
          break
        end
        @client.favorites(:count => 50).each do |fav_tw|
          if tweet.id == fav_tw.id
            @replied = true
          end
        end

if @replied == false
  puts "-----------------------------------"
  puts "【#{tweet.user.name}】 #{tweet.user.screen_name}"
  puts "#{tweet.text}"
  puts "-----------------------------------"
end


        if @replied == false && tweet.text =~ /天気/ #************************
          rep_message = tweet.text
          @areas.each do|area|
            if rep_message =~ /#{area.name}/
              @city_name = area.name
              @city_id = area.id
            end
          end
          #puts "場所:#{@city_name}"
          #puts " I D:#{@city_id}"
          #puts "Get URL:#{@weather_url}"
          @weather_url = @url1 + @city_id
          uri = URI.parse("#{@weather_url}")
          json = Net::HTTP.get(uri)
          @result = JSON.parse(json)

          #--------------メッセージ作成----------------
          hd1 = "@chiupet\n"
          hd2 = "～ #{@result["location"]["city"]} の お天気情報～\n"
          hd3 = "\n"
          message = hd1 + hd2 + hd3
          @result['forecasts'].each do |forecast|
            pg1 = "【#{forecast["dateLabel"]}】\n"
            pg2 = "天気:#{forecast['telop']}\n"
            if forecast["temperature"]["min"] == nil
              pg3 = "最低気温:情報なし\n"
            else
              pg3 = "最低気温:#{forecast["temperature"]["min"]["celsius"]}度\n"
            end
            if forecast["temperature"]["max"] == nil
              pg4 = "最高気温:情報なし\n"
            else
              pg4 = "最高気温:#{forecast["temperature"]["max"]["celsius"]}度\n"
            end
            pg5 = "\n"
            message = message + pg1 + pg2 + pg3 + pg4 + pg5
          end
          pub_year = @result["publicTime"][0,4]
          pub_month = @result["publicTime"][5,2]
          pub_day = @result["publicTime"][8,2]
          pub_hour = @result["publicTime"][11,2]
          pub_minute = @result["publicTime"][14,2]
          ft1 = "#{pub_year}年#{pub_month}月#{pub_day}日 #{pub_hour}時#{pub_minute}分 発表現在"
          message = message + ft1

          @client.update(message) #相手に返信
          @client.favorite(tweet.id) #相手にふぁぼ
        end #******************************************************************
        @replied = false
      end
    end
  end

  sleep_time = 3
  sleep(sleep_time)
  print "\n\n","   ***#{sleep_time}s経過***","\n\n"
  @loop_cash = true
end #///////////////////////////////////////////////////////////////////////////
