# Realiza opera��es com banco de dados postgres
library(RPostgres)

# Realiza manipula��o de dados
library(tidyverse)

# Realiza conex�o com o banco de dados
con <- dbConnect(Postgres(),
                 user = "postgres",
                 password = "123456",
                 host = "localhost",
                 port = 5432,
                 dbname = "db_medicamento")

# Escreve o comando a ser executado no postgres, linca com os par�metros e executa a query
principioAtivoSendQuery = dbSendQuery(con, "select * from medicamento m 
                                      inner join principio_ativo pa on pa.idprincipioativo = m.idprincipioativo")

principioAtivoFetch = dbFetch(principioAtivoSendQuery)

# Cria tibble de Princ�pio Ativo
principioAtivoTibble = tibble(ID = principioAtivoFetch$idprincipioativo,
                              NOME = principioAtivoFetch$nome..12,
                              VALOR = principioAtivoFetch$pf_0)

# Cria tibble para retornar a m�dia de valor por princ�pio ativo
mediaValorPrincipioAtivo = principioAtivoTibble %>%
  group_by(ID, NOME) %>%
  summarise("VALOR M�NIMO" = round(min(VALOR), 2),
            "VALOR M�DIO" = round(mean(VALOR), 2),
            "VALOR M�XIMO" = round(max(VALOR), 2),
            "ANO" = 2020) %>%
  arrange(desc(`VALOR M�DIO`))

minValorPrincipioAtivo = mediaValorPrincipioAtivo %>%
  arrange(`VALOR M�NIMO`)

maxValorPrincipioAtivo = mediaValorPrincipioAtivo %>%
  arrange(desc(`VALOR M�XIMO`))

# Filtra os 10 primeiro valores, que s�o os maiores
mediaValorPrincipioAtivo <- head(mediaValorPrincipioAtivo, 10)
minValorPrincipioAtivo <- head(minValorPrincipioAtivo, 10)
maxValorPrincipioAtivo <- head(maxValorPrincipioAtivo, 10)

# Cria gr�fico de barras para exibir o resultado da an�lise
mediaValorPrincipioAtivoPlot <- ggplot(data = mediaValorPrincipioAtivo) + 
  geom_bar(stat = "identity", position = position_dodge(),
           mapping = aes(x = as.factor(ANO), 
                         y = `VALOR M�DIO`, 
                         fill = NOME, 
                         group = `VALOR M�DIO`)) +
  
  scale_y_continuous(n.breaks = 8,
                     labels = scales::number_format(big.mark = ".", 
                                                    decimal.mark = ',')) +
  
  labs(x = "Ano", y = "Valor M�dio (R$)") +
  theme(axis.title = element_text(size=10), 
        plot.title = element_text(size=12, face="bold")) +
  ggtitle("Valor M�dio cobrado por Princ�pio Ativo - 2020 (Top 10)")

minValorPrincipioAtivoPlot <- ggplot(data = minValorPrincipioAtivo) + 
  geom_bar(stat = "identity", position = position_dodge(),
           mapping = aes(x = as.factor(ANO), 
                         y = `VALOR M�NIMO`, 
                         fill = NOME, 
                         group = `VALOR M�NIMO`)) +
  
  scale_y_continuous(n.breaks = 8,
                     labels = scales::number_format(big.mark = ".", 
                                                    decimal.mark = ',')) +
  
  labs(x = "Ano", y = "Valor M�nimo (R$)") +
  theme(axis.title = element_text(size=10), 
        plot.title = element_text(size=12, face="bold")) +
  ggtitle("Valor M�nimo cobrado por Princ�pio Ativo - 2020 (Top 10)")

maxValorPrincipioAtivoPlot <- ggplot(data = maxValorPrincipioAtivo) + 
  geom_bar(stat = "identity", position = position_dodge(),
           mapping = aes(x = as.factor(ANO), 
                         y = `VALOR M�XIMO`, 
                         fill = NOME, 
                         group = `VALOR M�XIMO`)) +
  
  scale_y_continuous(n.breaks = 8,
                     labels = scales::number_format(big.mark = ".", 
                                                    decimal.mark = ',')) +
  
  labs(x = "Ano", y = "Valor M�ximo (R$)") +
  theme(axis.title = element_text(size=10), 
        plot.title = element_text(size=12, face="bold")) +
  ggtitle("Valor M�ximo cobrado por Princ�pio Ativo - 2020 (Top 10)")

# Exibr gr�fico de barras
mediaValorPrincipioAtivoPlot
minValorPrincipioAtivoPlot
maxValorPrincipioAtivoPlot
