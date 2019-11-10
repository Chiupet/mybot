require "twitter"
require "./winfo"
require "dotenv"
Dotenv.load

#----------ついった様　権限----------
@client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONS_KEY"]
  config.consumer_secret     = ENV["CONS_SEC"]
  config.access_token        = ENV["ACCE_KEY"]
  config.access_token_secret = ENV["ACCE_SEC"]
end
#----------お天気ゾーン--------------------

  @username = "wrjpbot"
  @mention_1stid = ""
  @mention_2ndid = ""
  @loop_cash = false

loop do #//////////////////////////////////////////////////////////////////////
  @cnt = 0
  @favorited = false  #過去にふぁぼったか

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
            @favorited = true #ふぁぼりました
          end
        end

        if @favorited == false && tweet.text =~ /天気/ #************************
  #puts  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  #puts  "      !!未アクション発見!!"
  #puts  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  #print "【#{tweet.user.name}】 @#{tweet.user.screen_name}\n"
  #puts  "#{tweet.text}"
  #puts  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
          @areas.each do|area|
            if tweet.text =~ /#{area.name}/
              @city_name = area.name
              @city_id = area.id
            end
          end
          @weather_url = @url1 + @city_id
          uri = URI.parse("#{@weather_url}")
          json = Net::HTTP.get(uri)
          @result = JSON.parse(json)
  #puts  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  #puts  "   !!上記からエリアネーム発見!!"
  #puts  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  #puts "場所:#{@city_name}"
  #puts " I D:#{@city_id}"
  #puts "Get URL:#{@weather_url}"
  #puts  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
          #--------------メッセージ作成----------------
          hd1 = "@#{tweet.user.screen_name}\n"
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

          @client.update(message, {:in_reply_to_status_id => tweet.id}) #相手に返信
          puts "   ************"
#puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
#puts "      !!以下を送信しました!!"
#puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
#puts "#{message}"
#puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
          @client.favorite(tweet.id) #相手にふぁぼ
        end #******************************************************************
        @favorited = false
      end
    end
  end

  sleep_time = 3
  sleep(sleep_time)
  print "\n\n","   ***#{sleep_time}s経過***","\n\n"
  @loop_cash = true
end #///////////////////////////////////////////////////////////////////////////
