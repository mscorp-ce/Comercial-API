CREATE DATABASE Comercial;

use Comercial;


CREATE TABLE Usuarios (
    IdUsuario INT IDENTITY(1,1) NOT NULL,
    Nome VARCHAR(120) NOT NULL,
    Login VARCHAR(80) NOT NULL,
    Senha VARCHAR(256) NOT NULL,
    Foto VARBINARY(MAX),
    Status CHAR(1),
    Sexo CHAR(1),
    Telefone VARCHAR(13),
	Email VARCHAR(100) NOT NULL,
	Credito numeric(15,2),
	DtCadastro DateTime,
    CONSTRAINT PK_Usuarios PRIMARY KEY (IdUsuario)
);

INSERT INTO Usuarios (Nome, Login, Senha, Foto, Status, Sexo, Telefone, Email, DtCadastro)
VALUES ('Admininistrador', 'admin', '{#-94B57C1F-BA6D-4963-A3FF-061BA6BCA905-@}', NULL, 'A', 'M', '12987211482', 'admin@prismatechnologies.com.br', GETDATE());

CREATE TABLE Papeis(
  IdPapel INT IDENTITY(1,1) NOT NULL,
  Nome VARCHAR(50) UNIQUE NOT NULL,
  Descricao VARCHAR(255) NOT NULL,
  CONSTRAINT PK_Papeis PRIMARY KEY (IdPapel)
);

CREATE TABLE Permissoes(
  IdPermissao INT IDENTITY(1,1) NOT NULL,
  Nome VARCHAR(50) UNIQUE NOT NULL,
  Descricao VARCHAR(255) NOT NULL,
  CONSTRAINT PK_Permissaoes PRIMARY KEY (IdPermissao)
);

CREATE SEQUENCE SEQ_Usuarios
 AS NUMERIC
 START WITH 1
 INCREMENT BY 1;

CREATE TABLE Clientes(
IdCliente INT NOT NULL,
Nome VARCHAR(80) NOT NULL,
Status SMALLINT NOT NULL,
CONSTRAINT PK_Clientes PRIMARY KEY(IdCliente)
);

CREATE SEQUENCE SEQ_Clientes
 AS NUMERIC
 START WITH 1
 INCREMENT BY 1;

CREATE TABLE Produtos(
IdProduto INT NOT NULL,
Nome VARCHAR(80) NOT NULL,
Valor NUMERIC(15,2),
Saldo  NUMERIC(15,2),
Status SMALLINT NOT NULL,
CONSTRAINT PK_Produtos PRIMARY KEY(IdProduto)
);

CREATE SEQUENCE SEQ_Produtos
 AS NUMERIC
 START WITH 1
 INCREMENT BY 1;

CREATE TABLE PedidoVendas(
  IdPedidoVenda INT NOT NULL,
  Data_Venda VARCHAR(80) NOT NULL,
  IdUsuario INT,
  Total NUMERIC(15,2),
  Status SMALLINT NOT NULL,
  CONSTRAINT PK_PedidoVendas PRIMARY KEY(IdPedidoVenda),
  CONSTRAINT FK_IdUsuarioPEV FOREIGN KEY(IdUsuario) REFERENCES Usuarios(IdUsuario)
);

CREATE SEQUENCE SEQ_PedidoVendas
 AS NUMERIC
 START WITH 1
 INCREMENT BY 1;
 
CREATE TABLE PedidoVendaItens(
  IdPedidoVenda INT NOT NULL,
  Item INT NOT NULL,
  IdProduto INT NOT NULL,
  Quantidade NUMERIC(15,2) NOT NULL,
  Valor NUMERIC(15,2) NOT NULL,
  Total NUMERIC(15,2) NOT NULL,
  Status SMALLINT NOT NULL,
  CONSTRAINT PK_PedidoVendaItens PRIMARY KEY(IdPedidoVenda, Item),
  CONSTRAINT FK_IdPedidoVendaPVI FOREIGN KEY(IdPedidoVenda) REFERENCES PedidoVendas(IdPedidoVenda),
  CONSTRAINT FK_IdProdutoPVI FOREIGN KEY(IdProduto) REFERENCES Produtos(IdProduto)
);

CREATE SEQUENCE SEQ_PedidoVendaItens
 AS NUMERIC
 START WITH 1
 INCREMENT BY 1;
