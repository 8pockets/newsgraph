#coding: utf-8
require "sinatra"
require "sinatra/reloader"
require "active_record"
require "mysql2"
require "twitter"
set :server, 'webrick'

ActiveRecord::Base.establish_connection(
    "adapter" => "sqlite3",
    "database" => "./bbs.db"
)
class Comment < ActiveRecord::Base
end
configure do
  DB = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "54135413", :database => "twbase")
end
client = Twitter::REST::Client.new do |cnf|
  cnf.consumer_key = 'V4jF6B6AiAGhMVQkGfvX0Q'
  cnf.consumer_secret = 'KFYtEGL8Fv6flHCFSd6aWav5FwHbS3zwudS8QZsbf4'
  cnf.access_token = '42029664-CAwsuiinkrtG8p47XUU960PryGooKG7diB2raRguS'
  cnf.access_token_secret = '7vU75wyNPZBy5OwHwTebQ2Y7fg67EOIMG7gD2JVCwinVh'
end

get "/" do 
  count = 0
  client.search("#グラドル自画撮り部", {:result_type => "recent", :include_entities => true}).each do |obj|
  break if count > 100
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
  erb :index
end

get"/db" do
  @data = []
  DB.query("select * from twbase ORDER BY created_at DESC;").each do |obj|
     @data << obj
  end
  erb :twbase
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
