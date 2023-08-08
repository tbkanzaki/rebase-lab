# Rebase Lab

Projeto que faz parte do conteúdo extra da Turma 10 do TreinaDev, oferecido pela Rebase, empresa parceira do treinamento da Campus Code.
<br />
Uma app web para listagem de exames médicos.
<br />
As informações abaixo foram dadas pela Rebase como escopo e premissas para o desenvolvimento do projeto. Alguns trechos foram retirados e outros ajustados para o meu projeto.
<br />
Um dos objetivos do treinamento é aprender os comandos Docker, então inicialmente usarei scripts bash para criar e executar os containers docker.

---

## Tecnologias

* Docker
* PostgreSQL
* Sinatra
* Ruby
* Javascript
* HTML
* CSS
* Rspec
* Rack-Test

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
Certifique-se de ter o Docker instalado em sua máquina e o serviço iniciado. ( https://www.docker.com/ )
<br />

No terminal, clonar o projeto:
```
git clone https://github.com/tbkanzaki/rebase-lab.git
```

Navegue para o diretório da aplicação:
```
cd rebase-lab
```

Suba os container para iniciar a aplicação:
```
bash bin/up_app

Ou

bin/up_app
```

Abra o navegador para visualizar a aplicação:
```
http://localhost:3000
```

Obs.: Para visualizar os exames, deve-se primeiro fazer o upload do arquivo CSV na página inicial.

---
### Endpoints da aplicação (API)

Endpoint para visualizar todos os campos retornados do banco de dados, em formato JSON:
```
http://localhost:3000/api/index
```

Endpoint para visualizar os dados de um determinado exames (informando o token X58OZ4), retornados do banco de dados, em formato JSON:
```
http://localhost:3000/api/show/X58OZ4
```

Do projeto original: endpoint para visualizar os dados importados do arquivo CSV, em formato JSON:
```
http://localhost:3000/api/csv-json
```

Endpoint que importa arquivo CSV e insere no banco de dados:
```
POST /import
```
---
### Rodando os testes

Abra uma outra janela do terminal, e vá para o diretório da aplicação e rode o comando:
<br/>
Obs.: Para rodar os testes, a aplicação deve estar rodando.
```
bash bin/rspec

Ou

bin/rspec
```

---
### Finalizando a aplicação
Parar parar a aplicação:
```
pressione CTRL + C
```

Parar remover os containers e os volumes:
```
bash bin/down_app

Ou

bin/down_app
```

## Status o projeto
- Finalizado
- Iniciados os testes automatizados (ainda irei implementar mais testes)