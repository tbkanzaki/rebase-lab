document.addEventListener('DOMContentLoaded', function() {
    const navContent = `
    <nav class="navbar navbar-expand-lg" style="background-color: #e3f2fd;">
    <div class="container-fluid">
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarTogglerDemo03" aria-controls="navbarTogglerDemo03" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <a class="navbar-brand" href="http://localhost:3000">RebaseLab</a>
      <div class="collapse navbar-collapse" id="navbarTogglerDemo03">
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
          <li class="nav-item">
            <a class="nav-link active" aria-current="page" href="http://localhost:3000">Home</a>
          </li>
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
              JSON
            </a>
            <ul class="dropdown-menu">
              <li><a class="dropdown-item" href="http://localhost:3000/api/index">Todos</a></li>
              <li><a class="dropdown-item" href="http://localhost:3000/api/show/BCMUXJ">Um Token</a></li>
            </ul>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="http://localhost:3000/index">Todos os Exames</a>
          </li>
        </ul>
      </div>
    </div>
    </nav>
    `;

    const navDiv = document.getElementById('navDiv');
    navDiv.innerHTML = navContent;
});
