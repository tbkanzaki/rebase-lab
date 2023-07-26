# Rebase Lab

Projeto que faz parte do conteúdo extra da Turma 10 do TreinaDev, oferecido pela Rebase, empresa parceira do treinamento da Campus Code.
<br />
Uma app web para listagem de exames médicos.
<br />
As informações abaixo foram dadas pela Rebase como escopo e premissas para o desenvolvimento do projeto. Alguns trechos foram retirados e outros ajustados para o meu projeto.
<br />
Um dos objetivos do treinamento é aprender os comandos Docker, então inicialmente usarei scripts bash para criar e executar os containers docker.

Na Feature 2, seguindo a linha de treinamento, a maior parte do HTML foi criada dinamicamente com javascript, assim como o estilo.
Na tabela renderizada, há links para mostrar as informações do paciente e do médico em um modal. E outro link no token que exibe ao lado da tabela, as informações do paciente, do médico e os resultados dos exames.

---

## Tecnologias

* Docker
* PostgreSQL
* Sinatra
* Ruby
* Javascript
* HTML
* CSS

---

### Premissa

A premissa principal do laboratório é que a app **não seja feita em Rails**, devendo seguir o padrão **Sinatra** que estava no projeto original dado como exemplo.

---

### Laboratório

Abaixo estão listados os 4 principais objetivos do laboratório.

---

### Feature 1: Importar os dados do CSV para um database SQL

A primeira versão original da API deverá ter apenas um endpoint, que lê os dados de um arquivo CSV e renderiza no formato JSON. Devemos _modificar_ este endpoint para que, ao invés de ler do CSV, faça a leitura **diretamente de uma base de dados SQL**.

---

### Feature 2: Exibir listagem de exames no navegador Web
Agora vamos exibir as mesmas informações da etapa anterior, mas desta vez de uma forma mais amigável ao usuário. Para isto, devemos criar uma nova aplicação, que conterá todo o código necessário para a web - HTML, CSS e Javascript.

---

### Feature 3: Exibir detalhes de um exame em formato HTML a partir do token do resultado
Nesta etapa vamos implementar uma nova funcionalidade: pesquisar os resultados com base em um token de exame.

---

### Feature 4: Importar resultados de exames em formato CSV de forma assíncrona
Neste momento fazemos o import através de um script. Mas este script tem que ser executado por alguém developer ou admin do sistema.
<br />
Para melhorar isto, idealmente qualquer usuário da API poderia chamar um endpoint para atualizar os dados. Assim, o endpoint deveria aceitar um arquivo CSV dinâmico e importar os dados para o PostgreSQL.

---

## Rodando o projeto

### Pré-requisitos
Certifique-se de ter o Docker instalado em sua máquina e o serviço iniciado.
<br />

No terminal, clonar o projeto:
```
git clone git@github.com:tbkanzaki/rebase-lab.git
```

Navegue para o diretório da aplicação:
```
cd rebase-lab
```

Suba o container do servidor de banco de dados (PostgreSQL):
```
bash run_postgres
```

Suba o container responsável por importar os dados de um arquivo CSV para o banco de dados PostgreSQL:
```
bash run_import_data
```
---

1 - Para continuar a executar a Feature 1:
<br />
1.1 Suba o container do servidor da aplicação:
```
bash run_server
```
1.2 Abra o navegador com o endereço para visualizar o json com todos os campos:
```
http://localhost:3000/results-db
```
---
2 -  Para continuar a executar a Feature 2:
<br />
2.1 Suba o container do servidor da aplicação 1 em uma janela do terminal:
```
bash run_server-1
```
2.2 Abra o navegador com o endereço - porta 3000 - para visualizar o json com os campos que serão mostrados na tabela:
```
http://localhost:3000/results
```

2.3 Suba o container do servidor da aplicação 2 em outra janela do terminal:
```
bash run_server-2
```
2.4 Abra o navegador com o endereço - porta 4000 - para visualizar os dados em uma tabela, com links:
```
http://localhost:4000/results
```
---

Endpoint para visualizar todos os campos retornados do banco de dados, em formato JSON:
```
http://localhost:3000/results-db
```

Endpoint para visualizar os dados de um determinado exames (informando o token X58OZ4), retornados do banco de dados, em formato JSON:
```
http://localhost:3000/results/X58OZ4
```

Do projeto original: endpoint para visualizar os dados importados do arquivo CSV, em formato JSON:
```
http://localhost:3000/results-csv
```

Parar o servidor de banco de dados:
```
docker stop rebase-pg
```

Parar os servidores das aplicações em suas respectivas janelas:
```
pressione "CTRL + C" duas vezes
```

## Status o projeto
- Em desenvolvimento:
  - Finalizada: Feature 1 e Feature 2
  - Em andamento: Feature 3
  - Pendente: Feature 4