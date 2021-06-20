/*
Executar os comandos abaixo para apagar as tabelas já criadas
DROP TABLE medicamento CASCADE;
DROP TABLE estado CASCADE;
DROP TABLE classe;
DROP TABLE tipo;
DROP TABLE tarja;
DROP TABLE principio_ativo;
DROP TABLE laboratorio;
DROP TABLE medicamento_estado;
*/
DROP TABLE medicamento CASCADE;
DROP TABLE estado CASCADE;
DROP TABLE classe;
DROP TABLE tipo;
DROP TABLE tarja;
DROP TABLE principio_ativo;
DROP TABLE laboratorio;
DROP TABLE medicamento_estado;
--Criação da tabela classe
CREATE TABLE IF NOT EXISTS classe(
	idClasse SERIAL,
	descricao VARCHAR(255) NOT NULL,
	CONSTRAINT classe_pk PRIMARY KEY(idClasse)
);
--Criação da tabela tipo
CREATE TABLE IF NOT EXISTS tipo(
	idTipo SERIAL,
	descricao VARCHAR(255) NOT NULL,
	CONSTRAINT tipo_pk PRIMARY KEY(idTipo)
);
--Criação da tabela tarja
CREATE TABLE IF NOT EXISTS tarja(
	idTarja SERIAL,
	descricao VARCHAR(255) NOT NULL,
	CONSTRAINT tarja_pk PRIMARY KEY(idTarja)
);
--Criação da tabela principio_ativo
CREATE TABLE IF NOT EXISTS principio_ativo(
	idPrincipioAtivo SERIAL,
	nome TEXT NOT NULL,
	CONSTRAINT principio_ativo_pk PRIMARY KEY(idPrincipioAtivo)
);
--Criação da tabela estado
CREATE TABLE IF NOT EXISTS estado(
	sigla CHAR(2),
	aliquota REAL NOT NULL,
	CONSTRAINT estado_pk PRIMARY KEY(sigla)
);
--Criação da tabela laboratorio
CREATE TABLE IF NOT EXISTS laboratorio(
	cnpj CHAR(14),
	nome VARCHAR(255) NOT NULL,
	CONSTRAINT laboratorio_pk PRIMARY KEY(cnpj)
);
--Criação da tabela medicamento
CREATE TABLE IF NOT EXISTS medicamento(
	idMedicamento SERIAL,
	ggrem CHAR(15),
	nome VARCHAR(255) NOT NULL,
	apresentacao TEXT,
	pf_0 REAL NOT NULL,
	classeTerapeutica INTEGER,
	idTarja INTEGER,
	idTipo INTEGER,
	idPrincipioAtivo INTEGER,
	cnpjLaboratorio CHAR(14),
	CONSTRAINT medicamento_pk PRIMARY KEY(idMedicamento),
	CONSTRAINT classe_terapeutica_fk FOREIGN KEY(classeTerapeutica)
	REFERENCES classe(idClasse),
	CONSTRAINT tarja_fk FOREIGN KEY(idTarja)
	REFERENCES tarja(idTarja),
	CONSTRAINT tipo_fk FOREIGN KEY(idTipo)
	REFERENCES tipo(idTipo),
	CONSTRAINT principio_ativo_fk FOREIGN KEY(idPrincipioAtivo)
	REFERENCES principio_ativo(idPrincipioAtivo),
	CONSTRAINT cnpj_laboratorio_fk FOREIGN KEY(cnpjLaboratorio)
	REFERENCES laboratorio(cnpj)
);
--Criação da tabela medicamento_estado
CREATE TABLE IF NOT EXISTS medicamento_estado(
	idMedicamento INTEGER,
	sigla CHAR(2) NOT NULL,
	CONSTRAINT medicamento_estado_pk PRIMARY KEY(idMedicamento, sigla),
	CONSTRAINT medicamento_fk FOREIGN KEY(idMedicamento) 
	REFERENCES medicamento(idMedicamento),
	CONSTRAINT sigla_fk FOREIGN KEY(sigla)
	REFERENCES estado(sigla)
);
