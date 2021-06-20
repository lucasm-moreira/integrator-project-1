# Realiza operações com banco de dados postgres
library(RPostgres)

# Realiza manipulação de dados
library(tidyverse)

# Realiza conexão com o banco de dados
con <- dbConnect(Postgres(),
                 user = "postgres",
                 password = "admin",
                 host = "localhost",
                 port = 5432,
                 dbname = "pi1")
#Comando a ser executado no postgres
ctMedicamentosTarjaQuery = dbSendQuery(con , 
                                                "SELECT COUNT(*) as quantidade, t.descricao
FROM medicamento m, tarja t
WHERE t.idtarja = m.idtarja
GROUP BY t.descricao
ORDER BY quantidade DESC;")
ctMedicamentosTarjaoFetch = dbFetch(ctMedicamentosTarjaQuery)
#Cria o tible
ctMedicamentosTarja = tibble(
  Quantidade = ctMedicamentosTarjaoFetch$quantidade,
  Descricao = ctMedicamentosTarjaoFetch$descricao
)
ctMedicamentosTarja

