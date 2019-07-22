# Cervejeira API

API responsável por listar, cadastrar, deletar e atualizar nossos estilos de cerveja e
suas temperaturas(C.R.U.D), usando JSON para comunicação.

### Requerimentos:

* Ruby -v 2.1.10
* Rails -v 4.2.6
* Postgres

### Rodando localmente

* Faça o fork desse repositório
* Entre no diretório `cervejeira_api/` e execute o comando `bundle install`
* Configure seu banco de dados no arquivo `config/database.yml` segundo suas configurações locais.
* Execute o comando `rake db:create db:migrate db:seed` para criar o banco de dados e popular com alguns dados.
* Execute o comando `rails s -p 3001` para rodar o servidor local.
* Pronto! Agora que já temos a API rodando você pode acessar o `Postman` e fazer as requisições para a API.


### Documentação da API

`GET    /api/v1/cervejas/cerveja/:temperatura` – Passe a `:temperatura` e receba o estilo de cerveja mais indicado para tal `:temperatura`

`GET    /api/v1/cervejas` – Retorna todos estilos de cerveja cadastrados no banco

`POST   /api/v1/cervejas` – Crie um novo estilo de cervejas

```
Exemplo de body:

{ "estilo": "Novo Estilo", "temperatura_max": 3, "temperatura_min": -4 }
```

`GET    /api/v1/cervejas/:id` – Obtém o estilo de cerveja com id igual à `:id`

`PUT    /api/v1/cervejas/:id` – Atualiza os dados da cerveja com id igual à `:id`

```
Exemplo de body:

{ "estilo": "Estilo Atualizado" }
```

`DELETE  /api/v1/cervejas/:id` – Deleta estilo de cerveja com o id igual à `:id`



### Como rodar os testes

Crie sua base de dados de teste com o seguinte comando: `RAILS_ENV=test rake db:create db:migrate db:seed`

Basta executar o comando `rspec` no terminal

