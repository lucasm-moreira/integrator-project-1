# Chamando as bibliotecas necessárias para conexão com o Postgres e 
# Manipulação/Análise dos Gráficos
library(RPostgres)
library(tidyverse)

# Conectando à base de dados
con <- dbConnect(Postgres(),
                 user = "user",
                 password = "passwd",
                 host = "localhost",
                 port = 5432,
                 dbname = "pi_1")

# Comando para o postgres juntar parâmetros 
laboratorioSendQuery = dbSendQuery(con, "select * from medicamento m 
                                      inner join laboratorio lab on
                                      lab.cnpj = m.cnpjlaboratorio")

laboratorioFetch = dbFetch(laboratorioSendQuery)

# Aqui criamos um tibble com os dados pertinentes ao nosso propósito
laboratorioTibble = tibble(ID = laboratorioFetch$cnpj,
                              NOME = laboratorioFetch$nome..12,
                              VALOR = laboratorioFetch$pf_0)

# A partir do tibble anterior, calculamos as médias e organizamos os dados
# usando o número de vezes que cada laboratório aparece no tibble
mediaLab = laboratorioTibble %>%
  group_by(ID, NOME) %>%
  summarise("VALOR MÉDIO" = round(mean(VALOR), 2), "ANO" = 2020, n = n()) %>%
  arrange(desc(n)) 

# Para o gráfico não ficar muito poluído, utilizaremos somente os 10
# laboratórios que mais aparecem no tibble
mediaLab_tops <- head(mediaLab, 10)

# Pegando apenas a primeira palavra de cada nome:
mediaLab_tops$NOME <- word(mediaLab_tops$NOME, 1, 1)

# Graficamos nossos dados
ggplot(data = mediaLab_tops) + 
  geom_point(size = 5, stat = "identity",
           mapping = aes(x = NOME,
                         y = `VALOR MÉDIO`, 
                         color = NOME, 
                         group = `VALOR MÉDIO`)) +
  labs(x = "Ano 2020", y = "Valor Médio (R$)") +
  theme(axis.title = element_text(size=10), 
        plot.title = element_text(size=10, face="bold"),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),) +
 ggtitle("Valor médio cobrado pelos 10 laboratórios que produzem mais remédios - 2020")

# Salvar o gráfico
png('q2.png')
