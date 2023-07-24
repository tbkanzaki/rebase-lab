require 'csv'
require 'pg'

db_config = {
  host: 'rebase-pg',
  user: 'admin',
  password: 'password'
}

def import_from_csv(db_config, file)
  data = read_from_csv(file)
  insert_data(db_config, data)
end

def read_from_csv(file)
  rows = CSV.read(file, col_sep: ';')
  columns = rows.shift
  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, acc), idx|
      column = columns[idx]
      acc[column] = cell
    end
  end
end

def insert_data(db_config, data)
  conn = PG.connect(db_config)

  conn.exec('DROP TABLE IF EXISTS resultados')

  conn.exec('CREATE TABLE resultados (
            cpf char(14),
            nome_paciente varchar(150),
            email_paciente varchar(150),
            data_nascimento_paciente date,
            endereco_paciente varchar(300),
            cidade_paciente varchar(150),
            estado_paciente varchar(100),
            crm_medico varchar(15),
            crm_medico_estado char(2),
            nome_medico varchar(150),
            email_medico varchar(150),
            token_resultado_exame varchar(14),
            data_exame date,
            tipo_exame varchar(150),
            limites_tipo_exame varchar(15),
            resultado_tipo_exame varchar(10))'
            )

  data.each do |row|
    conn.exec('INSERT INTO resultados (
              cpf,
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
              data_exame,
              tipo_exame,
              limites_tipo_exame,
              resultado_tipo_exame)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)',
            [ row['cpf'],
              row['nome paciente'],
              row['email paciente'],
              Date.parse(row['data nascimento paciente']),
              row['endereço/rua paciente'],
              row['cidade paciente'],
              row['estado patiente'],
              row['crm médico'],
              row['crm médico estado'],
              row['nome médico'],
              row['email médico'],
              row['token resultado exame'],
              Date.parse(row['data exame']),
              row['tipo exame'],
              row['limites tipo exame'],
              row['resultado tipo exame']
            ])
  end
  conn.close
end

import_from_csv(db_config, './data.csv')
