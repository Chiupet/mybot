require 'twitter'
require "net/http"
require "uri"
require "json"

----------ついった様　権限----------
@client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['CONS_KEY']
  config.consumer_secret     = ENV['CONS_SEC']
  config.access_token        = ENV['ACCE_KEY']
  config.access_token_secret = ENV['ACCE_SEC']
end
----------お天気ゾーン--------------------
time = Time.now
message = "@chiupet\n風邪ひくなよ\n\n#{time}"
puts message

@client.update(message)
