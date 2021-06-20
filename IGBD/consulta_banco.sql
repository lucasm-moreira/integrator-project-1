-- Retorna as proje��es de ggrem, nome, classe terap�utica e pre�o final, na sele��o de medicamento
select m.ggrem, m.nome, m.classeterapeutica, m.pf_0 from medicamento m 

-- Retorna o nome e a tarja do medicamento, por meio de uma jun��o dos dados que existem
-- tanto na tabela medicamento quanto na tabela de tarja
select m.nome, t.descricao from medicamento m 
inner join tarja t on t.idtarja = m.idtarja 

-- Retorna todos os dados da tabela classe unindo com o retorno de todos os dados da tabela tarja
select * from classe c 
union
select * from tarja t 

-- Faz query de divis�o relacional buscando por todas as classes que j� estiveram contidas em todos os medicamentos
select * from classe c  
where not exists 
(
(select distinct m.classeterapeutica from medicamento m)
except
(select m.classeterapeutica from medicamento m 
where c.idclasse = m.classeterapeutica)
)

-- Retorna o nome e a m�dia do pre�o final do medicamento,
-- usando agrega��o avg() e agrupamento group by
select m.nome, avg(m.pf_0) from medicamento m 
group by m.nome 