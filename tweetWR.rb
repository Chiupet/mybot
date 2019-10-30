require 'twitter'
require "net/http"
require "uri"
require "json"

#----------ついった様　権限----------
#@client = Twitter::REST::Client.new do |config|
#  config.consumer_key        = ENV['CONS_KEY']
#  config.consumer_secret     = ENV['CONS_SEC']
#  config.access_token        = ENV['ACCE_KEY']
#  config.access_token_secret = ENV['ACCE_SEC']
#end
@client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "VxoeaLEH3RxpAOf3BsnWoVTSe"
  config.consumer_secret     = "kmDxNyt9pkXAjzTxMF8O5CKt0hiTey0ZhH4n00g88yN9yLlrhC"
  config.access_token        = "1188592721167970305-OVjoVMsyIh40lHtMHgfdN6qiV4x7yR"
  config.access_token_secret = "NBSvXs29l05dlRsOBeIWdYMRiyYKfcphmNfRZSz1GAbgK"
end
#----------お天気ゾーン--------------------
time = Time.now
message = "@chiupet\n風邪ひくなよ\n\n#{time}"
puts message

@client.update(message)
