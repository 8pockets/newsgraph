require 'sinatra'
#! /usr/bin/ruby
#-*- coding: utf-8 -*-

require 'tweetstream'

KEY   = "V4jF6B6AiAGhMVQkGfvX0Q"
SEC   = "KFYtEGL8Fv6flHCFSd6aWav5FwHbS3zwudS8QZsbf4"
TOKEN = "42029664-x1BgZ7SsBElknfbhNcJxfbTNBBsHiAZBMbhvTgqtZ"
TSEC  = "YoMnSwLgJzwUfv15nVRFkZluSr2ZuBjKlpZWG9Qnfgg3D"

TweetStream.configure do |config|
  config.consumer_key       = KEY
  config.consumer_secret    = SEC
  config.oauth_token        = TOKEN
  config.oauth_token_secret = TSEC
  config.auth_method        = :oauth
end

count = 0
TweetStream::Client.new.track('miranda') do |status|
  break if count > 500
  status.each do |i|
    puts "#{i.user.screen_name}: #{i.text}"
    count += 1
  end
end
