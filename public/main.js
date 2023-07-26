const url = 'http://localhost:3000/results';

function changeText(element) {
  element.textContent = 'Exames do Laboratório Rebase';
};

fetch(url).
  then(response => response.json()).
  then((data) => {
    const table = document.createElement('table');
    const thead = document.createElement('thead');
    const tbody = document.createElement('tbody');
    const headerTable = {
      cpf: "CPF",
      nome_paciente: "Paciente",
      email_paciente: "E-mail",
      data_nascimento_paciente: "Data de Nascimento",
      endereco_paciente: "Endereço",
      cidade_paciente: "Cidade",
      estado_paciente: "Estado",
      crm_medico: "CRM",
      crm_medico_estado: "Estado do CRM",
      nome_medico: "Médico(a)",
      email_medico: "Email",
      token_resultado_exame: "Token",
      data_exame: "Data do Exame",
      tipo_exame: "Exame",
      limites_tipo_exame: "Limites",
      resultado_tipo_exame: "Resultado"
    };

    const headers = Object.keys(data.results[0]);
    const headersShowTable = ['cpf', 'nome_paciente', 'crm_medico', 'nome_medico', 'token_resultado_exame', 'data_exame'];

    const headRow = document.createElement('tr');
    headersShowTable.forEach(function(headerText) {
      const headCol = document.createElement('th');
      headCol.textContent = headerTable[headerText];
      headCol.style.border = '1px solid #778899';
      headCol.style.color = '#708090'
      headRow.appendChild(headCol);
    });
    thead.appendChild(headRow);
    table.appendChild(thead);

    data.results.forEach(function(exame) {
      const bodyRow = document.createElement('tr');
      headersShowTable.forEach(function(header) {
        const bodyCol = document.createElement('td');
        bodyCol.style.border = '1px solid #778899';
        bodyCol.style.color = '#708090';
        switch (header) {
          case 'cpf':
            bodyCol.textContent = exame[header];
            bodyCol.classList.add('column-clickable');
            bodyCol.addEventListener('click', function () {
              openModal(exame, headerTable, 'cpf');
            });
            break;
          case 'crm_medico':
            bodyCol.textContent = exame[header];
            bodyCol.classList.add('column-clickable');
            bodyCol.addEventListener('click', function () {
              openModal(exame, headerTable, 'crm');
            });
            break;
          case 'token_resultado_exame':
            bodyCol.textContent = exame[header];
            bodyCol.classList.add('column-clickable');
            bodyCol.addEventListener('click', function () {
              displayExames(exame, headerTable);
            });
            break;
          default:
            bodyCol.textContent = exame[header];
        }
        bodyRow.appendChild(bodyCol);
      });
      tbody.appendChild(bodyRow);
    });
    table.appendChild(tbody);
    table.style.overflowX = 'auto';
    table.style.borderCollapse = 'collapse';
    table.style.border = '1px solid #778899';
    document.querySelector('.table-div').appendChild(table);

  }).
  catch(function(error) {
    console.log(error);
  });

  function openModal(exame, headerTable, params) {
    const modal = document.getElementById('myModal');
    modal.style.display = 'block';
    const infoModal = document.getElementById('infoModal');
    infoModal.innerHTML = '';
    let fields;

    if (params == 'cpf'){
      fields = ['cpf', 'nome_paciente', 'email_paciente', 'data_nascimento_paciente', 'endereco_paciente', 'cidade_paciente', 'estado_paciente'];
    }
    else{
      fields = ['crm_medico', 'nome_medico', 'crm_medico_estado', 'email_medico'];
    }

    fields.forEach(function (field) {
      const li = document.createElement('li');
      if (field === 'data_nascimento_paciente') {
        li.textContent = `${headerTable[field]}: ${formatData(exame[field])}`;
      } else {
        li.textContent = `${headerTable[field]}: ${exame[field]}`;
      }
      infoModal.appendChild(li);
    });
  }

  function closeModal() {
    const modal = document.getElementById('myModal');
    modal.style.display = 'none';
  }

  function displayExames(exame, headerTable) {
    const url_2 = `http://localhost:3000/results/${exame['token_resultado_exame']}`;

    const exameDiv = document.getElementById('exameDiv');
    exameDiv.innerHTML = '';
    const infoDiv = document.getElementById('infoDiv');
    infoDiv.innerHTML = '';
    infoDiv.style.lineHeight = '0.5';

    fields = ['cpf', 'nome_paciente', 'email_paciente', 'data_nascimento_paciente', 'endereco_paciente', 'cidade_paciente', 'estado_paciente','crm_medico', 'nome_medico'];
    fields.forEach(function (field) {
      const p = document.createElement('p');
      if (field === 'data_nascimento_paciente') {
        p.textContent = `${headerTable[field]}: ${formatData(exame[field])}`;
      } else {
        p.textContent = `${headerTable[field]}: ${exame[field]}`;
      }

      infoDiv.appendChild(p);
    });

    fetch(url_2)
      .then(response => response.json())
      .then(result_exames => {
        const table = document.createElement('table');
        const thead = document.createElement('thead');
        const tbody = document.createElement('tbody');
        const headers = ['Exame', 'Limites', 'Resultado'];

        const headRow = document.createElement('tr');
        headers.forEach(headerText => {
          const headerCol = document.createElement('th');
          headerCol.textContent = headerText;
          headerCol.style.textAlign = 'left';
          headRow.appendChild(headerCol);
        });
        thead.appendChild(headRow);
        table.appendChild(thead);

        result_exames.forEach(exame => {
          const bodyRow = document.createElement('tr');
          const results = [exame.tipo_exame, exame.limites_tipo_exame, exame.resultado_tipo_exame];
          results.forEach(resultText => {
            const bodyCol = document.createElement('td');
            bodyCol.textContent = resultText;
            bodyCol.style.padding = '2px';
            bodyRow.appendChild(bodyCol);
          });
          tbody.appendChild(bodyRow);
        });
        table.appendChild(tbody);
        table.style.width = '60%';
        table.style.borderCollapse = 'collapse';
        table.style.border = '1px solid #778899';
        exameDiv.appendChild(table);
      })
      .catch(error => console.log(error));
  }

  function formatData(dataString) {
    const partesData = dataString.split('-');
    const dia = partesData[2];
    const mes = partesData[1];
    const ano = partesData[0];
    return `${dia}/${mes}/${ano}`;
  }
