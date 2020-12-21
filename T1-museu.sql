CREATE TABLE Obras (
	codigo int not null primary key,
	titulo varchar(50) ,
	ano smallint,
	autor  int not null,
	salao int
);
CREATE TABLE Pinturas (
	codigo int not null primary key,
	estilo varchar(30),
	area int not null
);
CREATE TABLE Esculturas (
	codigo int not null primary key,
	altura decimal,
	peso decimal,
	material varchar(30)
);
CREATE TABLE Autores (
	codigoA int not null primary key,
	nome varchar(50),
	nacionalidade varchar(30)
);
CREATE TABLE Funcionarios (
	cpf numeric(11) unique not null, 
	nome varchar(50),
	salario decimal not null,
	turno char(1),
	funcao varchar(30)
);
CREATE TABLE Lotacoes (
	cpf numeric(11) not null,
	numero int,
    horaEntrada time,
    horaSaida time,
    primary key (cpf, numero, horaEntrada)
);
CREATE TABLE Saloes (
	numero int primary key,
	andar numeric(6) not null,
	area int not null
);

ALTER TABLE Obras ADD FOREIGN KEY (autor) REFERENCES Autores(codigoA);
ALTER TABLE Obras ADD FOREIGN KEY (salao) REFERENCES Saloes(numero);
ALTER TABLE Pinturas ADD FOREIGN KEY (codigo) REFERENCES Obras(codigo);
ALTER TABLE Esculturas ADD FOREIGN KEY (codigo) REFERENCES Obras(codigo);
ALTER TABLE Lotacoes ADD FOREIGN KEY (numero) REFERENCES Saloes(numero);
ALTER TABLE Lotacoes ADD FOREIGN KEY (cpf) REFERENCES Funcionarios(cpf);

-- 1 - Buscar todos os dados das obras produzidas entre 1965 e 1995 que estão no salão de número 36. Retornar o resultado ordenado pelo ano da obra de forma decrescente:

select * from Obras where ano between 1965 and 1995 and salao = 36 order by ano desc;

-- 2 - Buscar o CPF e o nome dos faxineiros que possuem Souza no sobrenome:

select cpf, nome from Funcionarios where nome like '% Souza%' and funcao = 'Faxineiro';

-- 3 - Buscar o código e o título das obras do autor Pablo Picasso que se encontram em salões do terceiro andar do museu: 

select codigo, titulo from Autores join Obras on nome = 'Pablo Picasso' and codigoA = autor join Saloes on andar = 3 and numero = salao;

-- 4 - Buscar o CPF e o nome de todos os funcionários do turno da noite e, para aqueles funcionários que estão lotados para trabalhar em salões, mostrar também o número e o andar destes salões:

select nome, F.cpf, L.numero, andar from funcionarios as F left join (select numero,cpf from lotacoes) as L on F.cpf = L.cpf left join (select numero,andar from saloes) as S on L.numero = S.numero where turno = 'N';

-- 5 - buscar o código e o título das obras cujo estilo é impressionista ou cujo material de fabricação é argila:

select codigo,titulo from obras where codigo in (select codigo from pinturas where estilo = 'impressionismo') or codigo in (select codigo from esculturas where material = 'argila');

-- 6 - Buscar o nome e a nacionalidade dos autores que possuem tanto pinturas quanto esculturas expostas no museu:
 
select nome, nacionalidade from Autores where codigoA in (select P.autor from (select autor from obras where codigo in (select codigo from pinturas)) as P join (select autor from obras where codigo in (select codigo from esculturas)) as E on P.autor = E.autor);

-- 7 - Gerar uma tabela que associa pares de nomes de seguranças diferentes que cuidam dos mesmos salões nos mesmos períodos: 

select F1.nome F1nome, F2.nome F2nome from Funcionarios as F1 join Funcionarios as F2 on F1.turno = F2.turno and F1.funcao = 'Segurança' and F2.funcao = F1.funcao and F1.cpf > F2.cpf join Lotacoes as L1 on F1.cpf = L1.cpf join Lotacoes as L2 on F2.cpf = L2.cpf and L1.horaEntrada = L2.horaEntrada and L1.horaSaida = L2.horaSaida;

-- 8 - Buscar o número dos salões onde estão expostas apenas esculturas:

select distinct salao from obras where salao not in (select salao from obras where codigo in (select codigo from pinturas)) and salao not in (select salao from obras where codigo not in (select codigo from esculturas) and codigo not in (select codigo from pinturas));

-- 9 - Buscar o número dos salões que possuem área superior às áreas dos salões do primeiro andar:

select numero from Saloes where area > all(select area from Saloes where andar = 1);

-- 10 - Buscar o nome e o CPF dos faxineiros que limpam todos os salões do quarto andar:

select nome, cpf from Funcionarios where funcao = 'Faxineiro' and cpf in (select cpf from Lotacoes where numero in (select numero from Saloes where andar = 4) group by cpf having count(*) = (select count(*) from Saloes where andar = 4 group by andar));

-- 11 - Buscar o número do salão de maior área no museu:

select numero from Saloes where area >= all(select area from Saloes);

-- 12 - Buscar o CPF e o nome dos funcionários e a média de horas trabalhadas nos salões:

select L.cpf, nome, avg(horaSaida - horaEntrada) media from (Lotacoes as L join Funcionarios as F on F.cpf = L.cpf) group by L.cpf, F.nome;

-- 13 - A funcionária Maria Campos (CPF: 101101101-10) foi contratada como faxineira do museu, recebendo um salário de R$ 2.500,00. Ela vai trabalhar no mesmo turno da faxineira com CPF 202202202-20. Realizar a inclusão de Maria no BD:

insert into Funcionarios values (10110110110, 'Maria Campos', 2500, null, 'Faxineiro')returning*;

update Funcionarios set turno = (select turno from Funcionarios where cpf = 20220220220) where cpf = 10110110110 returning*;

-- 14 - As obras de Salvador Dali que se encontravam nos salões 13 e 66 foram transferidas para o salão 54. Realizar esta alteração no BD:

update Obras set salao = 54 where (salao = 13 or salao = 66) and autor in (select codigoA from Autores where nome = 'Salvador Dali') returning*;

-- 15 - Excluir os autores que não possuem obras:

delete from Autores where codigoA not in (select autor from Obras)returning*;
