# Comercial-API

Comercial-API é uma RESTful API voltada para o controle de pedidos utilizando a framework Horse.

## Instalação de Dependências

Este projeto utiliza o Boss para gerenciar dependências. Para instalar as dependências do projeto, siga os passos abaixo:

### Pré-requisitos

- Certifique-se de ter o [Boss](https://github.com/HashLoad/boss) instalado no seu ambiente Delphi.

### Passos para Instalação

1. **Clone o repositório**:
   Abra o git bash dentro da sua pasta de projetos e no git bash digite o comando a seguir: 

   git clone https://github.com/mscorp-ce/Comercial-API.git
   
   no git bash execute o comando: cd Comercial-API

2. **Instale as dependências**: Execute o comando abaixo na raiz do projeto, onde o arquivo boss.json
   
   boss install

3. **Compile o projeto**: Abra o arquivo .dpr no Delphi e compile o projeto.

4. **Antes de exucutar o projeto**: Abra o SQL Server Management Studio e rode o arquivo Script.sql que se encontra no diretório \script

5. **Substituas as suas configurações locias do MSSQL**: Abra o diretório \bin e modifique os seguintes valores: 

    ***Server=*** Sua intancia do MSMSQL

    ***Database=Comercial*** pode ficar com o nome que esta no Script.sql, caso você informar outro nome deve modificar o valor da chave.
    
    ***User_Name=sa*** Foi utiliado o usuario padrão do MSSQL, ou seja, "sa", caso for usar outro usuario modificque o valor da chave
    
    ***Password=sua senha de usuario no MSSQL:*** Modifique para sua senha do MSSQL