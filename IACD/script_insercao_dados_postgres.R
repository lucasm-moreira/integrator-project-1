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
                 dbname = "<nome do banco de dados>")

# Realiza a leitura das tabelas
print(dbListTables(con))
classe <- dbReadTable(con, 'classe')
medicamento <- dbReadTable(con, 'medicamento')
tarja <- dbReadTable(con, 'tarja')
tipo <- dbReadTable(con, 'tipo')
principio_ativo <- dbReadTable(con, 'principio_ativo')
laboratorio <- dbReadTable(con, 'laboratorio')
medicamento_estado <- dbReadTable(con, 'medicamento_estado')
estado <- dbReadTable(con, 'estado')

# Carrega o csv de medicamentos
dados  <- read_csv2('<caminho do arquivo>', 
                    locale = locale(encoding = "UTF-8"))

# Realiza a conversão de números em base científica para decimal
dados$`CÓDIGO GGREM` = format(dados$`CÓDIGO GGREM`, scientific = FALSE)
dados$REGISTRO = format(dados$REGISTRO, scientific = FALSE)
dados$`EAN 1` = format(dados$`EAN 1`, scientific = FALSE)

# Realizando formatação na coluna cnpj
dados$CNPJ <- str_replace(dados$CNPJ, '\\.', '')
dados$CNPJ <- str_replace(dados$CNPJ, '\\.', '')
dados$CNPJ <- str_replace(dados$CNPJ, '-', '')
dados$CNPJ <- str_replace(dados$CNPJ, '/', '')

# Realiza formatação das colunas:
names(dados)[names(dados) == 'CÓDIGO GGREM'] <- 'CÓDIGO_GGREM'
names(dados)[names(dados) == 'PF 0%'] <- 'PF_0'
names(dados)[names(dados) == 'CLASSE TERAPÊUTICA'] <- 'CLASSE_TERAPÊUTICA'
names(dados)[names(dados) == 'TIPO DE PRODUTO (STATUS DO PRODUTO)'] <- 'TIPO_PRODUTO'

## DATA FRAMES ##

estado  <- data.frame(sigla = c('AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO',
                                'MA','MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 
                                'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'), 
                      aliquota = c(0.17, 0.17, 0.18, 0.18, 0.18, 0.18, 0.17, 0.17, 0.17, 0.20,
                                   0.17, 0.17, 0.20, 0.17, 0.20, 0.18, 0.20, 0.18, 0.20, 0.20, 
                                   0.175,0.175, 0.17, 0.17, 0.17, 0.18, 0.18))

# Unique faz com que os cnpjs não se repitam
laboratorio <- data.frame(cnpj = unique(dados$CNPJ), nome = unique(dados$LABORATÓRIO))

# Realizando formatação na coluna cnpj
laboratorio$cnpj <- str_replace(laboratorio$cnpj, '\\.', '')
laboratorio$cnpj <- str_replace(laboratorio$cnpj, '\\.', '')
laboratorio$cnpj <- str_replace(laboratorio$cnpj, '-', '')
laboratorio$cnpj <- str_replace(laboratorio$cnpj, '/', '')

# DF de classes
df_classe_terapeutica <- unique(dados$CLASSE_TERAPÊUTICA)
classe <- data.frame(idclasse = c(1:length(df_classe_terapeutica)), descricao = df_classe_terapeutica)

# DF de principio ativo
df_principio_ativo <- unique(dados$SUBSTÂNCIA)
principio_ativo <- data.frame(idprincipioativo = c(1:length(df_principio_ativo)), nome = df_principio_ativo)

# DF de tipo de produto
df_tipo_produto <- unique(dados$TIPO_PRODUTO)
tipo  <- data.frame(idtipo = c(1:length(df_tipo_produto)), descricao = df_tipo_produto)

# DF de tarja
df_tarja <- unique(dados$TARJA)
tarja <- data.frame(idtarja = c(1:length(df_tarja)), descricao = df_tarja)

# Remove os DFs temporários
rm(df_classe_terapeutica)
rm(df_principio_ativo)
rm(df_tipo_produto)
rm(df_tarja)

# Persistindo dados no banco de dados
dbWriteTable(con, 'classe', classe, append=TRUE)
dbWriteTable(con, 'estado', estado, append=TRUE)
dbWriteTable(con, 'laboratorio', laboratorio, append=TRUE)
dbWriteTable(con, 'principio_ativo', principio_ativo, append=TRUE)
dbWriteTable(con, 'tipo', tipo, append=TRUE)
dbWriteTable(con, 'tarja', tarja, append=TRUE)

# Escreve o comando a ser executado no postgres, linca com os parâmetros e executa a query
classeSendQuery = dbSendQuery(con, "select idclasse as classeterapeutica from classe where descricao = $1")
classeBind = dbBind(classeSendQuery, list(dados$CLASSE_TERAPÊUTICA))
classeFetch = dbFetch(classeBind)

tarjaSendQuery = dbSendQuery(con, "select idtarja from tarja where descricao = $1")
tarjaBind = dbBind(tarjaSendQuery, list(dados$TARJA))
tarjaFetch = dbFetch(tarjaBind)

tipoSendQuery = dbSendQuery(con, "select idtipo from tipo where descricao = $1")
tipoBind = dbBind(tipoSendQuery, list(dados$TIPO_PRODUTO))
tipoFetch = dbFetch(tipoBind)

principioAtivoSendQuery = dbSendQuery(con, "select idprincipioativo from principio_ativo where nome = $1")
principioAtivoBind = dbBind(principioAtivoSendQuery, list(dados$SUBSTÂNCIA))
principioAtivoFetch = dbFetch(principioAtivoBind)

laboratorioSendQuery = dbSendQuery(con, "select cnpj as cnpjlaboratorio from laboratorio where nome = $1")
laboratorioBind = dbBind(laboratorioSendQuery, list(dados$LABORATÓRIO))
laboratorioFetch = dbFetch(laboratorioBind)

estadoSendQuery = dbSendQuery(con, "select sigla from estado where sigla = $1")
estadoBind = dbBind(estadoSendQuery, list(estado$sigla))
estadoFetch = dbFetch(estadoBind)

medicamento <- data.frame(idmedicamento = c(1:length(dados$CÓDIGO_GGREM)),
                          ggrem = dados$CÓDIGO_GGREM, 
                          nome = dados$PRODUTO, 
                          apresentacao = dados$APRESENTAÇÃO,
                          pf_0 = dados$PF_0,
                          classeterapeutica = classeFetch,
                          idtarja = tarjaFetch,
                          idtipo = tipoFetch,
                          idprincipioativo = principioAtivoFetch,
                          cnpjlaboratorio = laboratorioFetch
)

# Persistindo dados no banco de dados
dbWriteTable(con, 'medicamento', medicamento, append=TRUE)

# Escreve o comando a ser executado no postgres, linca com os parâmetros e executa a query
medicamentoSendQuery = dbSendQuery(con, "select idmedicamento from medicamento where ggrem = $1 and nome = $2 and apresentacao = $3 and cnpjlaboratorio = $4 and pf_0 = $5")
medicamentoBind = dbBind(medicamentoSendQuery, list(dados$CÓDIGO_GGREM, dados$PRODUTO, dados$APRESENTAÇÃO, dados$CNPJ, dados$PF_0))
medicamentoFetch = dbFetch(medicamentoBind)

# Cria tibble/data frame de medicamento_estado
medicamento_estado_df <- tibble(idmedicamento = 0, sigla = "")

# Itera sobre os ids de medicamentos e as siglas de estado e insere em medicamento_estado
for(i in c(1:nrow(medicamentoFetch))) {
  for(j in c(1:nrow(estadoFetch))) {
    
    medicamento_estado_df <- tibble(idmedicamento = medicamentoFetch$idmedicamento[i],
                                    sigla = estadoFetch$sigla[j])
    
    dbWriteTable(con, 'medicamento_estado', medicamento_estado_df, append=TRUE)
  }
}