const fragmentCol = new DocumentFragment();
const fragmentRow = new DocumentFragment();
const fragmentPatient = new DocumentFragment();
const fragmentDoctor = new DocumentFragment();
const fragmentExam = new DocumentFragment();
const url = 'http://localhost:3000/api/index';

function fetchAndDisplayData() {
  fetch(url).
    then(response => response.json()).
    then((data) => {
      const table = document.getElementById('examesTable');
      const tbody = document.getElementById('bodyTable');
      const headerTable = {
        cpf: "CPF",
        name: "Paciente",
        email: "E-mail",
        birthday: "Data de Nascimento",
        address: "Endereço",
        city: "Cidade",
        state: "Estado",
        crm: "CRM",
        crm_state: "Estado do CRM",
        doctor_name: "Médico",
        doctor_email: "Email",
        result_token: "Token",
        result_date: "Data do Exame"
      };

      const headersShowTable = ['cpf', 'name', 'crm', 'doctor_name', 'result_token', 'result_date'];
      if (data.error) {
        const errorRow = document.createElement('tr');
        const errorCol = document.createElement('td');
        errorCol.textContent = `${data.error}`;
        errorCol.colSpan = headersShowTable.length;
        errorCol.classList.add('error-cell');
        errorRow.appendChild(errorCol);
        fragmentRow.appendChild(errorRow);
      } else {
        data.forEach(function(exame) {
        const bodyRow = document.createElement('tr');
        headersShowTable.forEach(function(header) {
          const bodyCol = document.createElement('td');
          switch (header) {
            case 'cpf':
              bodyCol.textContent = exame[header];
              bodyCol.classList.add('column-clickable');
              bodyCol.addEventListener('click', function () {
                displayData(exame, headerTable, 'cpf');
              });
              break;
            case 'crm':
              bodyCol.textContent = exame.doctor[header];
              bodyCol.classList.add('column-clickable');
              bodyCol.addEventListener('click', function () {
                displayData(exame, headerTable, 'crm');
              });
              break;
            case 'doctor_name':
              bodyCol.textContent = exame.doctor.doctor_name;
              break;
            case 'result_token':
              const link = document.createElement('a');
              link.textContent = exame[header];
              link.href = `http://localhost:3000/web/show/${exame[header]}`;
              link.style.color = 'black';
              bodyCol.appendChild(link);
              break;
              case 'result_date':
                bodyCol.textContent = formatDate(exame[header]);
                break;
            default:
              bodyCol.textContent = exame[header];
          };
          fragmentCol.appendChild(bodyCol);
        });
        bodyRow.appendChild(fragmentCol);
        fragmentRow.appendChild(bodyRow);
        });
      };
      tbody.appendChild(fragmentRow);
      table.appendChild(tbody);
      document.querySelector('.table-div').appendChild(table);
    }).
    catch(function(error) {
      console.log(error);
    });
};

function displayData(exame, headerTable, params) {
  const exameDiv = document.getElementById('exameDiv');
  exameDiv.innerHTML = '';
  const infoDiv = document.getElementById('infoDiv');
  infoDiv.innerHTML = '';
  infoDiv.style.lineHeight = '0.5';

  let fields;
  if (params == 'cpf'){
    fields = ['cpf', 'name', 'email', 'birthday', 'address', 'city', 'state'];
    fields.forEach(function (field) {
      const p = document.createElement('p');
      if (field === 'birthday') {
        p.textContent = `${headerTable[field]}: ${formatDate(exame[field])}`;
      } else {
        p.textContent = `${headerTable[field]}: ${exame[field]}`;
      }
      fragmentPatient.appendChild(p);
    });
    infoDiv.appendChild(fragmentPatient);
  }
  else{
    fields = ['crm', 'doctor_name', 'crm_state', 'doctor_email'];
    fields.forEach(function (field) {
      const p = document.createElement('p');
      p.textContent = `${headerTable[field]}: ${exame.doctor[field]}`;
      fragmentDoctor.appendChild(p);
    });
  }
  infoDiv.appendChild(fragmentDoctor);
  infoCard.style.display = 'block';
};

function formatDate(dataString) {
  const partesData = dataString.split('-');
  const dia = partesData[2];
  const mes = partesData[1];
  const ano = partesData[0];
  return `${dia}/${mes}/${ano}`;
};

document.addEventListener('DOMContentLoaded', function() {
  fetchAndDisplayData();
});
