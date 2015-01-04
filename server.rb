#!/usr/bin/env ruby
#-*- coding: utf-8 -*-

require "sinatra"
#require "active_record"
require "mysql2"
#require "tweetstream"
require "twitter"
#require "uri"
set :server, 'webrick'

#ActiveRecord::Base.establish_connection(
#    "adapter" => "sqlite3",
#    "database" => "./bbs.db"
#)
#class Comment < ActiveRecord::Base
#end

# configure do
#   DB = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "54135413", :database => "twbase")
# end

client = Twitter::REST::Client.new do |cnf|
  cnf.consumer_key = 'V4jF6B6AiAGhMVQkGfvX0Q'
  cnf.consumer_secret = 'KFYtEGL8Fv6flHCFSd6aWav5FwHbS3zwudS8QZsbf4'
  cnf.access_token = '42029664-x1BgZ7SsBElknfbhNcJxfbTNBBsHiAZBMbhvTgqtZ'
  cnf.access_token_secret = 'YoMnSwLgJzwUfv15nVRFkZluSr2ZuBjKlpZWG9Qnfgg3D'
end

#TweetStream.configure do |cnf|
#  cnf.consumer_key = 'V4jF6B6AiAGhMVQkGfvX0Q'
#  cnf.consumer_secret = 'KFYtEGL8Fv6flHCFSd6aWav5FwHbS3zwudS8QZsbf4'
#  cnf.oauth_token = '42029664-x1BgZ7SsBElknfbhNcJxfbTNBBsHiAZBMbhvTgqtZ'
#  cnf.oauth_token_secret = 'YoMnSwLgJzwUfv15nVRFkZluSr2ZuBjKlpZWG9Qnfgg3D'
#  cnf.auth_method = :oauth
#end

# get "/:name" do
# #新たなデータの取得
# count = 0
# @db = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "54135413", :database => "twbase")
# @db.query("delete from twbase")
#   #client = TweetStream::Client.new
#   #client.search("#グラドル自画撮り部", {:result_type => "recent",:lang => "ja"}).each do |obj|
# client.search("#{params[:name]}",:result_type => "recent").each do |obj|
#     break if count > 500
#     #URLデータの取得
#     obj.media.each do |o|
#       @db.query("insert ignore twbase (url,display_url) values ('#{o.media_url}','#{o.display_url}');")
#       count += 1
#     end
# end
# 
#   @data = []
#   DB.query("select * from twbase ORDER BY id ASC;").each do |obj|
#      @data << obj
#   end
#   erb :index
# end

get "/notdb" do 
  count = 0
  client.search("#グラドル自画撮り部", {:result_type => "recent", :include_entities => true}).each do |obj|
  break if count > 10
    if obj.is_a?(Twitter::Tweet)
      @data = obj.media
      ##URLデータの取得
      #obj.media.each do |o|
      #@mediaurl = o.media_url
      #@displayurl = o.display_url
      #count += 1
      #end
    end
  end
  erb :notdb
end

get "/time" do
    Time.now.to_s
end

get "/bbs" do
    @comments = Comment.order("id desc").all
    erb :index
end

post "/new" do
    Comment.create({:body => params[:body]})
    redirect "/bbs"
end
