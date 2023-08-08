require_relative 'spec_helper'
require_relative '../server'
require 'sinatra'

describe 'POST /import' do
  it 'Faz o post sem o arquivo CSV e retorna status 400' do
    post '/import'

    expect(last_response.status).to eq(400)
    expect(last_response.body).to include('Nenhum arquivo enviado.')
  end

  it 'Simula um erro e retorna status 500' do
    allow(CSV).to receive(:read).and_raise(StandardError.new('Erro ao processar o arquivo'))
    file_csv = './spec/support/test_file.csv'

    post '/import', csvFile: Rack::Test::UploadedFile.new(file_csv, 'text/csv')

    expect(last_response.status).to eq(500)
    expect(last_response.body).to include('Erro interno no servidor: Erro ao processar o arquivo')
  end
end
