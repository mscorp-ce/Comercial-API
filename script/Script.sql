CREATE DATABASE Comercial;

use Comercial;


CREATE TABLE Usuarios (
    IdUsuario INT IDENTITY(1,1) NOT NULL,
    Nome VARCHAR(120) NOT NULL,
    Login VARCHAR(80) NOT NULL,
    Senha VARCHAR(255) NOT NULL,
    Foto VARBINARY(MAX),
    Status CHAR(1),
    Sexo CHAR(1),
    Telefone VARCHAR(13),
	Email VARCHAR(100) NOT NULL,
	Credito numeric(15,2),
	DtCadastro DateTime,
    CONSTRAINT PK_Usuarios PRIMARY KEY (IdUsuario)
);


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

INSERT INTO Permissoes VALUES('Criar Produtos', 'Cadastrar os produtos');
INSERT INTO Permissoes VALUES('Alerar Produtos', 'Alerar o cadastro os produtos');
INSERT INTO Permissoes VALUES('Listar Produtos', 'Pesquisar todos os produtos');
INSERT INTO Permissoes VALUES('Listar Produtos por id', 'Pesquisar produtos pelo seu id');
INSERT INTO Permissoes VALUES('Remover Produtos', 'Deletar um cadastro os produtos');




SELECT *
  FROM Permissoes

alter TABLE Usuarios add Credito numeric(15,2);
alter TABLE Usuarios add DtCadastro DateTime;


INSERT INTO Usuarios (Nome, Login, Senha, Foto, Status, Sexo, Telefone, Email, DtCadastro)
VALUES ('Admininistrador2', 'admin2', '{#-94B57C1F-BA6D-4963-A3FF-061BA6BCA905-@}', NULL, 'A', 'M', '12987211482', 'admin@prismatechnologies.com.br', GETDATE());

update Usuarios  
   set Credito = 25000.00,
	   DtCadastro = '1980-12-01 10:45:00'
where IdUsuario = 1;


delete from Usuarios where IdUsuario = 5

CREATE TABLE ROLES(IdRole, Nome, Descricao)

SELECT IdUsuario, 
       Nome,
	   Login,
	   Senha,
	   Status,
	   Sexo,
       Telefone,
	   Foto,
	   Email,
	   Credito,
	   DtCadastro  --$2a$10$8kesp3.eXW.j4T7cG0NhA.g/QeYV46/3dvK/F8.mdVKoClBzGhseK
	               --$2a$10$CfUZFJHTFPuAb1Su3bqwzuwHMy2FyWfAQn50jSHyEQQ6ZIbPf46Ae
  FROM Usuarios
where 1=1

update Usuarios
   SET Senha = '123'
where IdUsuario = 3

ALTER TABLE Usuarios
ALTER COLUMN Senha Varchar(256)

SELECT COUNT(IdUsuario) AS RECORDS 
  FROM Usuarios 
 WHERE 1 = 1 
AND IdUsuario = 2
ORDER BY RECORDS
'AND id = :id'#$D#$A'SELECT COUNT(IdUsuario) AS RECORDS '#$D#$A'  FROM Usuarios '#$D#$A' WHERE 1 = 1 '#$D#$A'AND id = :id'


SELECT * FROM Usuarios

SELECT COUNT(IdUsuario) AS RECORDS 
  FROM Usuarios


INSERT INTO Usuarios VALUES(NEXT VALUE FOR SEQ_Usuarios, 'Marcio', '{7B3602CD-6130-454A-9357-B1911440EAD2}')

SELECT 'INSERT INTO Usuarios(Nome, Senha) VALUES(' + ', ''' + Nome, + ''',''' + Senha +''')'  FROM Usuarios

SELECT 
    'INSERT INTO Usuarios(Nome, Senha) VALUES(' + 
    '''' + Nome + ''', ''' + Senha + ''');' AS InsertStatement
FROM Usuarios;













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

CREATE TABLE Vendedores(
IdVendedor INT NOT NULL,
Nome VARCHAR(80) NOT NULL,
Status SMALLINT NOT NULL,
CONSTRAINT PK_Vendedores PRIMARY KEY(IdVendedor)
);

 CREATE SEQUENCE SEQ_Vendedores
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
