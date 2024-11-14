unit uModel.Repository.Resources.Usuario;

interface

uses
  uConstants;

const
  SQL_CONSULTAR_USUARIOS =
    'SELECT IdUsuario, ' + ENTER +
    '       Nome, ' + ENTER +
	  '       Login, ' + ENTER +
    '       Senha, ' + ENTER +
	  '       Status, ' + ENTER +
	  '       Sexo, ' + ENTER +
    '       Telefone, ' + ENTER +
    '       Credito, ' + ENTER +
    '       DtCadastro, ' + ENTER +
    '       Email ' + ENTER +
    '  FROM Usuarios ' + ENTER +
    ' WHERE 1 = 1 ';

  SQL_CONSULTAR_USUARIO =
    'SELECT IdUsuario, ' + ENTER +
    '       Nome, ' + ENTER +
	  '       Login, ' + ENTER +
    '       Senha, ' + ENTER +
	  '       Status, ' + ENTER +
	  '       Sexo, ' + ENTER +
    '       Telefone, ' + ENTER +
    '       Foto, ' + ENTER +
    '       Credito, ' +ENTER +
    '       DtCadastro, ' + ENTER +
    '       Email ' + ENTER +
    '  FROM Usuarios ' + ENTER +
    ' WHERE IdUsuario = :id ';

  SQL_CONSULTAR_USUARIOS_RECORDS =
    'SELECT COUNT(IdUsuario) AS RECORDS ' + ENTER +
    '  FROM Usuarios ' + ENTER +
    ' WHERE 1 = 1 ';

  SQL_PERSISTIR_USUARIO =
    'INSERT INTO Usuarios ' + ENTER +
    '       (Nome, ' + ENTER +
    '        Login, ' + ENTER +
    '        Senha, ' + ENTER +
    '        Status, ' + ENTER +
    '        Sexo, ' + ENTER +
    '        Telefone, ' + ENTER +
    '        Email, ' + ENTER +
    '        Credito, ' + ENTER +
    '        DtCadastro ' + ENTER +
		'	) ' + ENTER +
    '    OUTPUT INSERTED.IdUsuario ' + ENTER +
    ' VALUES ' + ENTER +
    '       (:Nome, ' + ENTER +
    '        :Login, ' + ENTER +
    '        :Senha, ' + ENTER +
    '        :Status, ' + ENTER +
    '        :Sexo, ' + ENTER +
    '        :Telefone, ' + ENTER +
    '        :Email, ' + ENTER +
    '        :Credito, ' + ENTER +
    '        :DtCadastro ' + ENTER +
		'	       )';

  SQL_ATUALIZAR_USUARIO =
    'UPDATE Usuarios ' + ENTER +
    '   SET Nome = :Nome, ' + ENTER +
	  '       Login = :Login, ' + ENTER +
    '       Senha = :Senha, ' + ENTER +
	  '       Status = :Status, ' + ENTER +
	  '       Sexo = :Sexo, ' + ENTER +
    '       Telefone = :Telefone, ' + ENTER +
    '       Credito = :Credito, ' + ENTER +
    '       DtCadastro = :DtCadastro, ' + ENTER +
    '       Email = :Email ' + ENTER +
    ' WHERE IdUsuario = :IdUsuario ';

  SQL_REMOVER_USUARIO =
    'DELETE ' + ENTER +
    '  FROM Usuarios ' + ENTER +
    ' WHERE IdUsuario = :IdUsuario ';

  SQL_ATUALIZAR_FOTO_USUARIO =
    'UPDATE Usuarios ' + ENTER +
    '   SET Foto = :Foto ' + ENTER +
    ' WHERE IdUsuario = :IdUsuario ';

  SQL_CONSULTAR_FOTO_USUARIO =
    'SELECT Foto ' + ENTER +
    '  FROM Usuarios ' + ENTER +
    ' WHERE IdUsuario = :IdUsuario ';


implementation

end.
