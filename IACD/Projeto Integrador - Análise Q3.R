# Realiza operações com banco de dados postgres
library(RPostgres)

# Realiza manipulação de dados
library(tidyverse)

# Realiza conexão com o banco de dados
con <- dbConnect(Postgres(),
                 user = "postgres",
                 password = "123456",
                 host = "localhost",
                 port = 5432,
                 dbname = "db_medicamento")

# Escreve o comando a ser executado no postgres, linca com os parâmetros e executa a query
principioAtivoSendQuery = dbSendQuery(con, "select * from medicamento m 
                                      inner join principio_ativo pa on pa.idprincipioativo = m.idprincipioativo")

principioAtivoFetch = dbFetch(principioAtivoSendQuery)

# Cria tibble de Princípio Ativo
principioAtivoTibble = tibble(ID = principioAtivoFetch$idprincipioativo,
                              NOME = principioAtivoFetch$nome..12,
                              VALOR = principioAtivoFetch$pf_0)

# Cria tibble para retornar a média de valor por princípio ativo
mediaValorPrincipioAtivo = principioAtivoTibble %>%
  group_by(ID, NOME) %>%
  summarise("VALOR MÉDIO" = round(mean(VALOR), 2), "ANO" = 2020) %>%
  arrange(desc(`VALOR MÉDIO`)) 

# Filtra os 10 primeiro valores, que são os maiores
mediaValorPrincipioAtivo <- head(mediaValorPrincipioAtivo, 10)

# Cria gráfico de barras para exibir o resultado da análise
mediaValorPrincipioAtivoPlot <- ggplot(data = mediaValorPrincipioAtivo) + 
  geom_bar(stat = "identity", position = position_dodge(),
           mapping = aes(x = as.factor(ANO), 
                         y = `VALOR MÉDIO`, 
                         fill = NOME, 
                         group = `VALOR MÉDIO`)) +
  
  scale_y_continuous(n.breaks = 8,
                     labels = scales::number_format(big.mark = ".", 
                                                    decimal.mark = ',')) +
  
  labs(x = "Ano", y = "Valor Médio (R$)") +
  theme(axis.title = element_text(size=10), 
        plot.title = element_text(size=12, face="bold")) +
  ggtitle("Valor Médio cobrado por Princípio Ativo - 2020 (Top 10)")

# Exibr gráfico de barras
mediaValorPrincipioAtivoPlot
