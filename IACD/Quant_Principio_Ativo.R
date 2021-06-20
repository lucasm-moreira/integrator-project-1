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
ctMedicamentosPrincipioAtivoQuery = dbSendQuery(con , 
"SELECT COUNT(*) as quantidade, p.nome
FROM medicamento m, principio_ativo p
WHERE p.idprincipioativo = m.idprincipioativo
GROUP BY p.nome
ORDER BY quantidade DESC;")
ctMedicamentosPrincipioAtivoFetch = dbFetch(ctMedicamentosPrincipioAtivoQuery)
#Cria o tible
ctMedicamentosPrincipioAtivo = tibble(
  Quantidade = ctMedicamentosPrincipioAtivoFetch$quantidade,
  PrincipioAtivo = ctMedicamentosPrincipioAtivoFetch$nome
)
#Filtra os 10 primeiros valores
ctMedicamentosPrincipioAtivo <- head(ctMedicamentosPrincipioAtivo, 10)

