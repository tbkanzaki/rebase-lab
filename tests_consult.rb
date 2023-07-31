require_relative './database'

module TestsConsult
  def self.all_test
    conn = Database.get_connection
    rows = conn.exec('SELECT t.token, t.date, p.cpf,
                             p.name, p.email, p.birthday,
                             p.address, p.city, p.state,
                             d.crm, d.crm_state, d.name AS doctor_name,
                             d.email AS doctor_email
                    FROM patients p
                    JOIN tests t ON p.id = t.id_patient
                    JOIN doctors d ON t.id_doctor = d.id
                    ORDER BY p.name, t.date, t.token')
    conn.close
    rows.to_a
  end

  def self.token_test(token)
    conn = Database.get_connection
    rows = conn.exec('SELECT t.token, t.date, p.cpf,
                             p.name, p.email, p.birthday,
                             p.address, p.city, p.state,
                             d.crm, d.crm_state, d.name AS doctor_name,
                             d.email AS doctor_email,
                             tr.type, tr.limits, tr.result
                      FROM patients p
                      JOIN tests t ON p.id = t.id_patient
                      JOIN test_results tr ON t.id = tr.id_test
                      JOIN doctors d ON t.id_doctor = d.id
                      WHERE LOWER(token) = LOWER($1)
                      ORDER BY tr.type' , [token.downcase])
    conn.close
    rows.to_a
  end

  def self.format_json(rows)
    conn = Database.get_connection
    rows.map do |row|
      {
        result_token: row['token'],
        result_date: row['date'],
        cpf: row['cpf'],
        name: row['name'],
        email: row['email'],
        birthday: row['birthday'],
        address: row['address'],
        city: row['city'],
        state: row['state'],
        doctor: {
          crm: row['crm'],
          crm_state: row['crm_state'],
          doctor_name: row['doctor_name'],
          doctor_email: row['doctor_email']
        },
        tests: conn.exec('SELECT tr.type AS test_type, tr.limits AS test_limits, tr.result AS test_result
                          FROM tests t
                          JOIN test_results tr ON t.id = tr.id_test
                          WHERE t.token = $1
                          ORDER BY tr.type',[row['token']]).to_a
      }
    end
  end
end