require 'sinatra'
require 'rack/handler/puma'
require 'pg'
require 'csv'

db_config = {
  host: 'rebase-pg',
  user: 'admin',
  password: 'password'
}

get '/results' do
  File.open('index.html').read
end

get '/hello' do
  'Hello world!'
end

get '/' do
  'Rebase Lab - Server 2'
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 4000,
  Host: '0.0.0.0'
)
