require 'sinatra'
require 'rack/handler/puma'
require 'pg'
require 'csv'

db_config = {
  host: 'rebase-pg',
  user: 'admin',
  password: 'password'
}

get '/results-csv' do
  rows = CSV.read("./data.csv", col_sep: ';')

  columns = rows.shift

  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, acc), idx|
      column = columns[idx]
      acc[column] = cell
    end
  end.to_json
end

get '/results-db' do
  conn = PG.connect(db_config)
  rows = conn.exec('SELECT * FROM resultados')
  conn.close

  rows.to_a.to_json
end

get '/hello' do
  'Hello world!'
end

get '/' do
  'Rebase Lab'
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
