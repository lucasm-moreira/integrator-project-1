-- Retorna as projeções de ggrem, nome, classe terapêutica e preço final, na seleção de medicamento
select m.ggrem, m.nome, m.classeterapeutica, m.pf_0 from medicamento m 

-- Retorna o nome e a tarja do medicamento, por meio de uma junção dos dados que existem
-- tanto na tabela medicamento quanto na tabela de tarja
select m.nome, t.descricao from medicamento m 
inner join tarja t on t.idtarja = m.idtarja 

-- Retorna todos os dados da tabela classe unindo com o retorno de todos os dados da tabela tarja
select * from classe c 
union
select * from tarja t 

-- Faz query de divisão relacional buscando por todas as classes que já estiveram contidas em todos os medicamentos
select * from classe c  
where not exists 
(
(select distinct m.classeterapeutica from medicamento m)
except
(select m.classeterapeutica from medicamento m 
where c.idclasse = m.classeterapeutica)
)

-- Retorna o nome e a média do preço final do medicamento,
-- usando agregação avg() e agrupamento group by
select m.nome, avg(m.pf_0) from medicamento m 
group by m.nome 