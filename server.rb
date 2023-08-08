require 'sinatra'
require 'rack/handler/puma'
require 'pg'
require 'csv'
require 'json'
require 'redis'
require_relative 'app/database'
require_relative 'app/tests_consult'
require_relative 'app/worker'


#API
post '/import' do
  content_type :json
  begin
    if params[:csvFile]
      file = CSV.read(params[:csvFile][:tempfile]).flatten.join("\n")
      Worker.perform_async(file)
      status 200
      { message: 'Arquivo CSV importado com sucesso!' }.to_json
    else
      status 400
      { error: 'Nenhum arquivo enviado.' }.to_json
    end
  rescue StandardError => error
    status 500
    { error: "Erro interno no servidor: #{error.message}" }.to_json
  end
end

get '/api/index' do
  content_type :json
  begin
    rows = TestsConsult.all_test
    if rows.any?
      TestsConsult.format_json(rows).to_json
    else
      status 404
      { error: 'Nenhum registro encontrado. Para visualizar exames, faça o Upload do arquivo CSV em Home' }.to_json
    end
  rescue PG::Error => error
    status 503
    { error: "Erro no banco de dados: #{error}" }.to_json
  rescue StandardError => error
    status 500
    { error: "Erro interno no servidor: #{error}" }.to_json
  end
end

get '/api/show/:token' do
  content_type :json
  begin
    rows = TestsConsult.token_test(params[:token])
    if rows.any?
      TestsConsult.format_json(rows).to_json
    else
      status 404
      { error: 'Nenhum registro encontrado para a consulta ou talvez precise primeiro fazer o Upload do arquivo CSV em Home' }.to_json
    end
  rescue PG::Error => error
    status 503
    { error: "Erro no banco de dados: #{error}" }.to_json
  rescue StandardError => error
    status 500
    { error: "Erro interno no servidor: #{error}" }.to_json
  end
end

get '/api/csv-json' do
  content_type :json
  rows = CSV.read("./data.csv", col_sep: ';')
  columns = rows.shift
  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, acc), idx|
      column = columns[idx]
      acc[column] = cell
    end
  end.to_json
end

#web
get '/' do
  content_type :html
  begin
    File.open('web/home.html')
  rescue Errno::ENOENT
    'Página não encontrada'
  end
end

get '/index' do
  content_type :html
  begin
    File.open('web/index.html')
  rescue Errno::ENOENT
    'Página não encontrada'
  end
end

get '/web/show/:token' do
  token = params[:token]
  content_type :html
  rows = TestsConsult.token_test(token)
  if rows.any?
    template = File.open('web/show.html').read
    template.gsub('{{token}}', rows[0]['token'])
            .gsub('{{date}}', rows[0]['date'])
            .gsub('{{cpf}}', rows[0]['cpf'])
            .gsub('{{name}}', rows[0]['name'])
            .gsub('{{email}}', rows[0]['email'])
            .gsub('{{birthday}}', rows[0]['birthday'])
            .gsub('{{address}}', rows[0]['address'])
            .gsub('{{city}}', rows[0]['city'])
            .gsub('{{state}}', rows[0]['state'])
            .gsub('{{crm}}', rows[0]['crm'])
            .gsub('{{doctor_name}}', rows[0]['doctor_name'])
            .gsub('{{acido_urico.limits}}', rows[0]['limits'])
            .gsub('{{acido_urico.result}}', rows[0]['result'])
            .gsub('{{eletrolitos.limits}}', rows[1]['limits'])
            .gsub('{{eletrolitos.result}}', rows[1]['result'])
            .gsub('{{glicemia.limits}}', rows[2]['limits'])
            .gsub('{{glicemia.result}}', rows[2]['result'])
            .gsub('{{hdl.limits}}', rows[3]['limits'])
            .gsub('{{hdl.result}}', rows[3]['result'])
            .gsub('{{hemacias.limits}}', rows[4]['limits'])
            .gsub('{{hemacias.result}}', rows[4]['result'])
            .gsub('{{ldl.limits}}', rows[5]['limits'])
            .gsub('{{ldl.result}}', rows[5]['result'])
            .gsub('{{leucocitos.limits}}', rows[6]['limits'])
            .gsub('{{leucocitos.result}}', rows[6]['result'])
            .gsub('{{plaquetas.limits}}', rows[7]['limits'])
            .gsub('{{plaquetas.result}}', rows[7]['result'])
            .gsub('{{t4.limits}}', rows[8]['limits'])
            .gsub('{{t4.result}}', rows[8]['result'])
            .gsub('{{tgo.limits}}', rows[9]['limits'])
            .gsub('{{tgo.result}}', rows[9]['result'])
            .gsub('{{tgp.limits}}', rows[10]['limits'])
            .gsub('{{tgp.result}}', rows[10]['result'])
            .gsub('{{tsh.limits}}', rows[11]['limits'])
            .gsub('{{tsh.result}}', rows[11]['result'])
            .gsub('{{vldl.limits}}', rows[12]['limits'])
            .gsub('{{vldl.result}}', rows[12]['result'])
  else
    redirect '/?error=token_not_found'
  end
end

if ENV['APP_ENV'] == 'test'
  puts "Ambiente de teste!"
else
  puts "Ambiente de produção!"

  conn = Database.get_connection
  Database.create_tables(conn)

  Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
  )
end
