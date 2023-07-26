require 'sinatra'
require 'rack/handler/puma'
require 'pg'
require 'csv'
require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :options]
  end
end

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

  { results: rows.to_a }.to_json
end

get '/results' do
  conn = PG.connect(db_config)
  rows = conn.exec('SELECT DISTINCT cpf,
                                    nome_paciente,
                                    email_paciente,
                                    data_nascimento_paciente,
                                    endereco_paciente,
                                    cidade_paciente,
                                    estado_paciente,
                                    crm_medico,
                                    crm_medico_estado,
                                    nome_medico,
                                    email_medico,
                                    token_resultado_exame,
                                    data_exame
                    FROM resultados
                    ORDER BY nome_paciente, data_exame')
  conn.close

  { results: rows.to_a }.to_json
end

get '/results/:token' do
  token_resultado_exame = params[:token]
  conn = PG.connect(db_config)
  rows = conn.exec("SELECT DISTINCT tipo_exame, limites_tipo_exame, resultado_tipo_exame
                    FROM resultados
                    WHERE token_resultado_exame = '#{token_resultado_exame}'
                    ORDER BY tipo_exame")
  conn.close

  rows.to_a.to_json
end

get '/hello' do
  'Hello world!'
end

get '/' do
  'Rebase Lab - Server 1'
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
