require 'pg'
require 'csv'

module Database
  def self.get_connection
    db_config = {
      host: 'rebase-pg',
      user: 'admin',
      password: 'password'
    }
    PG.connect(db_config)
  end

  # def connect_db_test
  #   db_config = {
  #     host: 'rebase-pg',
  #     user: 'admin',
  #     password: 'password',
  #     dbname: 'rebase-db-test'
  #   }
  #   PG.connect(db_config)
  # end


  def self.delete_data(conn)
    conn.exec("DELETE FROM test_results;")
    conn.exec("DELETE FROM tests;")
    conn.exec("DELETE FROM doctors;")
    conn.exec("DELETE FROM patients;")
    conn.close
  end

  def self.drop_tables(conn)
    conn.exec("DROP TABLE test_results;")
    conn.exec("DROP TABLE tests;")
    conn.exec("DROP TABLE doctors;")
    conn.exec("DROP TABLE patients;")
    conn.close
  end

  def self.create_tables(conn)
    conn.exec('CREATE TABLE IF NOT EXISTS patients (id SERIAL PRIMARY KEY,
                                                    cpf CHAR(14) UNIQUE NOT NULL,
                                                    name VARCHAR(150),
                                                    email VARCHAR(150),
                                                    birthday DATE,
                                                    address VARCHAR(300),
                                                    city VARCHAR(150),
                                                    state VARCHAR(100)
                                                   )')

    conn.exec('CREATE TABLE IF NOT EXISTS doctors (id SERIAL PRIMARY KEY,
                                                  crm VARCHAR(15) UNIQUE NOT NULL,
                                                  crm_state CHAR(2),
                                                  name VARCHAR(150),
                                                  email VARCHAR(150)
                                                  )')

    conn.exec('CREATE TABLE IF NOT EXISTS tests (id SERIAL PRIMARY KEY,
                                                id_patient INTEGER REFERENCES patients (id),
                                                id_doctor INTEGER REFERENCES doctors (id),
                                                token VARCHAR(14) UNIQUE NOT NULL,
                                                date DATE
                                                )')

    conn.exec('CREATE TABLE IF NOT EXISTS test_results (id SERIAL PRIMARY KEY,
                                                        id_test INTEGER REFERENCES tests (id),
                                                        type VARCHAR(150),
                                                        limits VARCHAR(15),
                                                        result VARCHAR(10),
                                                        UNIQUE (id_test, type)
                                                      )')
  conn.close
  end

  def self.insert_data(data,conn)
    data.each do |row|
      patient_not_exists = conn.exec_params('SELECT * FROM patients WHERE cpf = $1 LIMIT 1', [row['cpf']]).num_tuples.zero?
      if patient_not_exists
        conn.exec_params('INSERT INTO patients (cpf,
                                                name,
                                                email,
                                                birthday,
                                                address,
                                                city,
                                                state)
                                                VALUES ($1, $2, $3, $4, $5, $6, $7)',
                                                [ row['cpf'],
                                                  row['nome paciente'],
                                                  row['email paciente'],
                                                  Date.parse(row['data nascimento paciente']),
                                                  row['endereço/rua paciente'],
                                                  row['cidade paciente'],
                                                  row['estado patiente']
                                                ])
      end

      doctor_not_exists = conn.exec_params('SELECT * FROM doctors WHERE crm = $1 LIMIT 1', [row['crm médico']]).num_tuples.zero?
      if doctor_not_exists
        conn.exec_params('INSERT INTO doctors (crm,
                                              crm_state,
                                              name,
                                              email)
                                              VALUES ($1, $2, $3, $4)',
                                              [row['crm médico'],
                                                row['crm médico estado'],
                                                row['nome médico'],
                                                row['email médico']
                                              ])
      end

      token_not_exists = conn.exec_params('SELECT * FROM tests WHERE token = $1 LIMIT 1', [row['token resultado exame']]).num_tuples.zero?
      if token_not_exists
        conn.exec_params('INSERT INTO tests (id_patient,
                                            id_doctor,
                                            token,
                                            date)
                                            VALUES (
                                                (SELECT id FROM patients WHERE cpf = $1),
                                                (SELECT id FROM doctors WHERE crm = $2),
                                                $3,
                                                $4
                                              )',
                                              [
                                                row['cpf'],
                                                row['crm médico'],
                                                row['token resultado exame'],
                                                Date.parse(row['data exame'])
                                              ])
      end

      id_test = conn.exec_params('SELECT id FROM tests
                                  WHERE token = $1 LIMIT 1', [row['token resultado exame']])[0]['id'].to_i

      test_result_exists = conn.exec_params('SELECT * FROM test_results
                                             WHERE id_test = $1 AND type = $2 LIMIT 1', [id_test, row['tipo exame']]).num_tuples.zero?
      if test_result_exists
        conn.exec_params('INSERT INTO test_results (id_test,
                                                    type,
                                                    limits,
                                                    result)
                                                  VALUES (
                                                    (SELECT id FROM tests WHERE token = $1),
                                                    $2,
                                                    $3,
                                                    $4
                                                  )',
                                                  [
                                                    row['token resultado exame'],
                                                    row['tipo exame'],
                                                    row['limites tipo exame'],
                                                    row['resultado tipo exame']
                                                  ])
      end
    end
    conn.close
  end

  def self.read_from_csv(file)
    rows = CSV.parse(file, col_sep: ';')
    columns = rows.shift
    rows.map do |row|
      row.each_with_object({}).with_index do |(cell, acc), idx|
        column = columns[idx]
        acc[column] = cell
      end
    end
  end

  def self.process_csv_file(csv_file)
    data = read_from_csv(csv_file)
    conn = get_connection
    insert_data(data, conn)
  end

end