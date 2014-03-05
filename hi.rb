require 'sinatra'
set :server, 'webrick'

get '/hi' do
  "Hello World!"
end