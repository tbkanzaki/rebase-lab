
document.addEventListener('DOMContentLoaded', function() {

  function searchToken() {
    const token = document.getElementById('search').value;
    if (token) {
      window.location.href = `http://localhost:3000/web/show/${token}`;
    }
  }

  const searchInput = document.getElementById('search');
  searchInput.addEventListener('keypress', function(event) {
    if (event.key === 'Enter') {
      event.preventDefault();
      searchToken();
    }
  });

  const searchParams = new URLSearchParams(window.location.search);
  const errorMessage = searchParams.get('error');

  if (errorMessage === 'token_not_found') {
    const hMessage = document.getElementById('message');
    hMessage.textContent = 'Token não encontrado!';
  }

  document.getElementById('csvForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const fileInput = document.getElementById('csvFile');
    const file = fileInput.files[0];
    if (file) {
      const formData = new FormData();
      formData.append('csvFile', file);

      fetch('http://localhost:3000/import', {
        method: 'POST',
        body: formData
      })
      .then(response => response.json())
      .then(data => {
        console.log(data);
        document.getElementById('status').textContent = 'Upload realizado com sucesso!';
      })
      .catch(error => {
        console.error('Erro ao enviar arquivo:', error);
        document.getElementById('status').textContent = 'Erro ao enviar arquivo.';
      });
    } else {
      document.getElementById('status').textContent = 'Nenhum arquivo selecionado.';
    }
  });
});
