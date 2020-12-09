CREATE TABLE Funcionarios (
  codf int not null primary key,
  CPF numeric(11) not null,
  nome varchar(64) not null,
  fone numeric(11),
  CEP numeric(8),
  rua varchar(32),
  numero int,
  cidade varchar(32)
);

CREATE TABLE Gerentes(
  codg int not null primary key,
  codf int not null, -- funcionario a ser supervisionado
  login varchar(32),
  senha varchar(32)
);

CREATE TABLE Atendentes(
  coda int not null primary key,
  -- codf int not null,
  numeroDeVendas int
);

CREATE TABLE Clientes (
  codc int not null primary key,
  CPF numeric(11) not null,
  nome varchar(64) not null,
  fone numeric(11),
  CEP numeric(8),
  rua varchar(32),
  numero int,
  cidade varchar(32)
);


CREATE TABLE Vendas(
  codVenda int not null primary key,
  coda int not null,
  codc int not null,
  codProduto int not null,
  valor int not null
);

CREATE TABLE TrocasEdevolucoes(
  codTroca int not null primary key,
  codc int not null,
  produtoDevolvido int not null,
  novoProduto int,
  saldo float
);

CREATE TABLE Produtos(
  codp int not null primary key,
  codm int not null,
  code int not null
);

CREATE TABLE Modelos(
  codm int not null primary key,
  marca varchar(32),
  categoria varchar(32),
  descricao varchar(64),
  preco float
);

CREATE TABLE Estoques (
  code int not null primary key,
  codg int not null,
  codp int not null,
  quantidade int
);

CREATE TABLE Encomendas (
  codEncomenda int not null primary key,
  codg int not null,
  code int not null,
  CNPJ numeric(14) not null,
  -- codProduto int not null,
  valor float not null
);

CREATE TABLE Fornecedores(
  CNPJ numeric(14) not null primary key,
  fone numeric(11),
  CEP numeric(8),
  rua varchar(32),
  numero int,
  cidade varchar(32)
);

ALTER TABLE Gerentes 
  ADD CONSTRAINT Supervisao FOREIGN KEY (codf) REFERENCES Funcionarios(codf),
  ADD CONSTRAINT Especializacao_Gerente FOREIGN KEY (codg) REFERENCES Funcionarios(codf);

ALTER TABLE Atendentes 
  ADD CONSTRAINT Especializacao_Atendentes FOREIGN KEY (coda) REFERENCES Funcionarios(codf);

ALTER TABLE Estoques
  ADD CONSTRAINT Gerenciamento FOREIGN KEY (codg) REFERENCES Gerentes(codg);
  
ALTER TABLE Encomendas
  ADD CONSTRAINT Realizacao FOREIGN KEY (codg) REFERENCES Gerentes(codg),
  ADD CONSTRAINT Destino FOREIGN KEY (code) REFERENCES Estoques(code),
  ADD CONSTRAINT Remetente FOREIGN KEY (CNPJ) REFERENCES Fornecedores(CNPJ);
  
ALTER TABLE Vendas
  ADD CONSTRAINT Registro FOREIGN KEY (coda) REFERENCES Atendentes(coda),
  ADD CONSTRAINT Cliente FOREIGN KEY (codc) REFERENCES Clientes(codc),
  ADD CONSTRAINT Produto FOREIGN KEY (codProduto) REFERENCES Produtos(codp);
  
ALTER TABLE Produtos
  ADD CONSTRAINT Modelo FOREIGN KEY (codm) REFERENCES Modelos(codm),
  ADD CONSTRAINT Fornecimento FOREIGN KEY (code) REFERENCES Estoques(code);
  
ALTER TABLE TrocasEdevolucoes 
  ADD CONSTRAINT Efetuacao FOREIGN KEY (codc) REFERENCES Clientes(codc),
  ADD CONSTRAINT SubstituiEntra FOREIGN KEY (produtoDevolvido) REFERENCES Produtos(codp),
  ADD CONSTRAINT SubstituiSai FOREIGN KEY (novoProduto) REFERENCES Produtos(codp);
  
