require 'mysql2'
require 'twitter'

consumer_key = 'V4jF6B6AiAGhMVQkGfvX0Q'
consumer_secret = 'KFYtEGL8Fv6flHCFSd6aWav5FwHbS3zwudS8QZsbf4'
oauth_token = '42029664-CAwsuiinkrtG8p47XUU960PryGooKG7diB2raRguS'
oauth_token_secret = '7vU75wyNPZBy5OwHwTebQ2Y7fg67EOIMG7gD2JVCwinVh'

# Oauthの設定
client = Twitter::REST::Client.new do |cnf|
  cnf.consumer_key = consumer_key
  cnf.consumer_secret = consumer_secret
  cnf.access_token = oauth_token
  cnf.access_token_secret = oauth_token_secret
end

#新たなデータの取得
count = 0
@db = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "54135413", :database => "twbase")
client.search("#グラドル自画撮り部", {:result_type => "recent", :include_entities => true}).each do |obj|
  break if count > 100
  if obj.is_a?(Twitter::Tweet)
    #URLデータの取得
    obj.media.each do |o|
      @db.query("insert ignore twbase (url,display_url) values ('#{o.media_url}','#{o.display_url}');")
      count += 1
    end
  end
end
