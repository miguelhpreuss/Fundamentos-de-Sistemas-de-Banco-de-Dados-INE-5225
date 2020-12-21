-- Fundamentos de Sistemas de Banco de Dados INE5225-08220
-- Banco de Dados - Loja de Roupa - Trabalho 2
-- Equipe: Augusto Hideki, Miguel Hellmann Preuss, Thiago Cunha, Tomas Drews 

CREATE TABLE Modelos(
  CodM int not null primary key,
  marca varchar(32),
  categoria varchar(32),
  descricao varchar(64),
  preco float
);
CREATE TABLE Produtos(
  CodP int not null primary key,
  CodM int not null,
  CodE int not null
);
CREATE TABLE Vendas(
  CodVenda int not null primary key,
  CodA int not null,
  CodC int not null,
  CodP int not null,
  Valor float not null
);
CREATE TABLE Clientes(
  CodC int not null primary key,
  CPF numeric(11) not null unique,
  Nome varchar(64) not null,
  CodFone int not null,
  CEP int not null  
);
CREATE TABLE Enderecos (
  CEP int not null primary key,
  rua varchar(32) not null,
  cidade varchar(32) not null,
  bairro varchar(32) not null
);
CREATE TABLE Fones(
  CodFone int not null primary key,
  fone_1 numeric(11),
  fone_2 numeric(11),
  fone_3 numeric(11)
);
CREATE TABLE TrocasDevolucoes(
  CodDevolucao int not null primary key,
  CodC int not null,
  CodP int not null,
  ProdutoDevolvido int,
  ProdutoRetirado int,
  Saldo float,
  FOREIGN KEY (CodC) REFERENCES Clientes (CodC),
  FOREIGN KEY (CodP) REFERENCES Produtos (CodP)
);
CREATE TABLE Atendentes(
  CodA int not null primary key,
  CodF int not null,
  jovemAprendiz bool
);
CREATE TABLE Funcionarios(
  CodF int not null primary key,
  CPF numeric(11) not null unique,
  nome varchar(64) not null,
  CodFone int not null,
  CEP int not null
);
CREATE TABLE Gerentes(
  CodG int not null primary key,
  CodE int not null,
  CodF int not null unique,
  login varchar(32) unique,
  senha varchar(32),
  FOREIGN KEY(CodF) REFERENCES Funcionarios(CodF)
);
CREATE TABLE Estoques(
  CodE int not null primary key,
  CodP int not null,
  QuantidadeProduto int
);
CREATE TABLE Encomendas(
  codEncomenda int not null primary key,
  CodG int not null,
  CodE int not null,
  CodP int not null,
  CNPJ numeric(14) not null unique,
  quantidade int,
  valor float not null
);
CREATE TABLE Fornecedores(
  CNPJ numeric(14) not null unique primary key,
  CodFone int not null,
  CEP int not null,
  CodE int not null
);

ALTER TABLE Produtos
  ADD CONSTRAINT Modelos FOREIGN KEY (CodM) REFERENCES Modelos(CodM),
  ADD CONSTRAINT Estoques FOREIGN KEY (CodE) REFERENCES Estoques(CodE);

ALTER TABLE Vendas
  ADD CONSTRAINT Registro FOREIGN KEY (CodA) REFERENCES Atendentes(CodA),
  ADD CONSTRAINT Cliente FOREIGN KEY (CodC) REFERENCES Clientes(CodC),
  ADD CONSTRAINT Produto FOREIGN KEY (CodP) REFERENCES Produtos(CodP);

ALTER TABLE Clientes 
  ADD CONSTRAINT Endereco2 FOREIGN KEY (CEP) REFERENCES Enderecos(CEP),
  ADD CONSTRAINT Telefones FOREIGN KEY (CodFone) REFERENCES Fones(CodFone);

ALTER TABLE TrocasDevolucoes
  ADD CONSTRAINT SubstituiEntra FOREIGN KEY (ProdutoDevolvido) REFERENCES Produtos(CodP),
  ADD CONSTRAINT SubstituiSai FOREIGN KEY (ProdutoRetirado) REFERENCES Produtos(CodP);

ALTER TABLE Atendentes
  ADD CONSTRAINT Funcionario FOREIGN KEY (CodF) REFERENCES  Funcionarios(CodF);

ALTER TABLE Funcionarios
  ADD CONSTRAINT Telefone FOREIGN KEY (CodFone) REFERENCES  Fones(CodFone),
 ADD CONSTRAINT Endereco FOREIGN KEY (CEP) REFERENCES Enderecos(CEP);

ALTER TABLE Estoques
  ADD CONSTRAINT Fornecimento FOREIGN KEY (CodP) REFERENCES Produtos(CodP);

ALTER TABLE Encomendas
  ADD CONSTRAINT Realizacao FOREIGN KEY (CodG) REFERENCES Gerentes(CodG),
  ADD CONSTRAINT Destino FOREIGN KEY (CodE) REFERENCES Estoques(CodE),
  ADD CONSTRAINT Produtos FOREIGN KEY (CodP) REFERENCES Produtos(CodP),
  ADD CONSTRAINT Remetente FOREIGN KEY (CNPJ) REFERENCES Fornecedores(CNPJ);

ALTER TABLE Fornecedores 
  ADD CONSTRAINT Endereco3 FOREIGN KEY (CEP) REFERENCES Enderecos(CEP),
  ADD CONSTRAINT Encomenda FOREIGN KEY (CodE) REFERENCES Estoques(CodE),
  ADD CONSTRAINT Telefones FOREIGN KEY (CodFone) REFERENCES Fones(CodFone);
