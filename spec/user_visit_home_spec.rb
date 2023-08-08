require_relative 'spec_helper'

describe 'Usuário visita home' do
  it 'com sucesso e retorna status 200 OK' do
    get '/'

    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Upload do CSV')
    expect(last_response.body).to include('Exames')
    expect(last_response.body).to include('Busca por Token')
  end
end
