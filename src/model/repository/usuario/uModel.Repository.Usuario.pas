unit uModel.Repository.Usuario;

interface

uses
  System.Classes, System.Generics.Collections, System.JSON, uModel.Abstraction.Repository, uModel.Entities.Usuario,
  uModel.Abstraction.DataManager, uModel.Abstraction.Statement, uModel.Abstraction.DataConverter,
  uModel.Service.DataConverter, FireDAC.Stan.Intf;

type
  TUsuarioRepository = class(TInterfacedObject, IRepository<TUsuario>, IStreamRepository<TUsuario>)
  private
    DataManager: IDataManager;
    Statement: IStatement;
    Records: IStatement;

    procedure MountParams(AStatement: IStatement; const AParams: TDictionary<string, string>);
  public
    constructor Create(); reintroduce;

    procedure GetProperties(var AEntity: TUsuario; const AStatement: IStatement);
    procedure SetProperties(var AStatement: IStatement; const AEntity: TUsuario);
    function ListAll(const AParams: TDictionary<string, string>): TObjectList<TUsuario>;
    function GetById(const AId: Integer): TUsuario;
    function Save(var AEntity: TUsuario): TJSONObject;
    function Merge(var AEntity: TUsuario): Boolean;
    function Remove(const AEntity: TUsuario): Boolean;
    function SavePhoto(const AEntity: TUsuario; const Value: TStream): Boolean;
    function GetPthoById(const AEntity: TUsuario): TMemoryStream;
    function GetRecords(const AParams: TDictionary<string, string>): Int64;
  end;

implementation

uses
  System.SysUtils, Data.DB, FireDAC.Stan.Param, uModel.DataManager.Factory, uModel.Repository.StatementFactory,
  uModel.Repository.Resources.Usuario, DataSet.Serialize, uConstants, BCrypt;

{ TUsuarioRepository }

constructor TUsuarioRepository.Create();
begin
  inherited Create();

  DataManager := TDataManagerFactory.GetDataManager();

  Statement := TStatementFactory.GetStatement(DataManager);

  Records := TStatementFactory.GetStatement(DataManager);
end;

function TUsuarioRepository.GetById(const AId: Integer): TUsuario;
begin
  Statement.Query.SQL.Clear();
  Statement.Query.SQL.Add(SQL_CONSULTAR_USUARIO);
  Statement.Query.SQL.Add('AND IdUsuario = :id');
  Statement.Query.ParamByName('id').AsLargeInt := AId;
  Statement.Query.Open();

  if not Statement.Query.IsEmpty() then
    begin
      var Usuario := TUsuario.Create();

      GetProperties(Usuario, Statement);

      Result := Usuario;
    end
  else Result := nil;
end;

procedure TUsuarioRepository.GetProperties(var AEntity: TUsuario; const AStatement: IStatement);
begin
  AEntity.IdUsuario := AStatement.Query.FieldByName('IdUsuario').AsInteger;
  AEntity.Nome := AStatement.Query.FieldByName('Nome').AsString;
  AEntity.Login := AStatement.Query.FieldByName('Login').AsString;
  AEntity.Senha := AStatement.Query.FieldByName('Senha').AsString;
  AEntity.Status := AStatement.Query.FieldByName('Status').AsString;
  AEntity.Sexo := AStatement.Query.FieldByName('Sexo').AsString;
  AEntity.Telefone := AStatement.Query.FieldByName('Telefone').AsString;

  if AStatement.Query.FieldDefs.IndexOf('Foto') <> -1 then
    AEntity.Foto := AStatement.Query.FieldByName('Foto').AsBytes;

  AEntity.Credito := AStatement.Query.FieldByName('Credito').AsFloat;
  AEntity.DtCadastro := AStatement.Query.FieldByName('DtCadastro').AsDateTime;
  AEntity.Email := AStatement.Query.FieldByName('Email').AsString;
end;

function TUsuarioRepository.GetRecords(const AParams: TDictionary<string, string>): Int64;
begin
  Records.Query.SQL.Clear();
  Records.Query.SQL.Add(SQL_CONSULTAR_USUARIOS_RECORDS);

  MountParams(Records, AParams);

  Records.Query.Open();

  Result := Records.Query.FieldByName('RECORDS').AsLargeInt;
end;

function TUsuarioRepository.ListAll(const AParams: TDictionary<string, string>): TObjectList<TUsuario>;
begin
  Statement.Query.SQL.Clear();
  Statement.Query.SQL.Add(SQL_CONSULTAR_USUARIOS);

  MountParams(Statement, AParams);

  Statement.Query.SQL.Add('ORDER BY IdUsuario');

  if AParams.ContainsKey('limit') then
    begin
      Statement.Query.FetchOptions.RecsMax := StrToIntDef(AParams.Items['limit'], 50);
      Statement.Query.FetchOptions.RowsetSize := StrToIntDef(AParams.Items['limit'], 50);
    end;

  if AParams.ContainsKey('offset') then
    Statement.Query.FetchOptions.RecsSkip := StrToIntDef(AParams.Items['offset'], 0);

  Statement.Query.Open();

  if not Statement.Query.IsEmpty() then
    begin
      Result := TObjectList<TUsuario>.Create(True);

      Statement.Query.First();

      while not Statement.Query.Eof do
        begin
          var Ususario := TUsuario.Create();

          GetProperties(Ususario, Statement);

          Result.Add(Ususario);

          Statement.Query.Next();
        end;
    end
  else
    Result := TObjectList<TUsuario>.Create(True);
end;

procedure TUsuarioRepository.MountParams(AStatement: IStatement; const AParams: TDictionary<string, string>);
begin
  if AParams.ContainsKey('id') then
    begin
      AStatement.Query.SQL.Add('AND IdUsuario = :id');
      AStatement.Query.ParamByName('id').AsLargeInt := AParams.Items['id'].ToInt64;
    end;

  if AParams.ContainsKey('nome') then
    begin
      AStatement.Query.SQL.Add('AND lower(Nome) like :nome');
      AStatement.Query.ParamByName('nome').AsString := '%' + AParams.Items['nome'].ToLower + '%';
    end;

  if AParams.ContainsKey('login') then
    begin
      AStatement.Query.SQL.Add('AND Login = :login');
      AStatement.Query.ParamByName('login').AsString := AParams.Items['login'];
    end;
end;

function TUsuarioRepository.Remove(const AEntity: TUsuario): Boolean;
begin
  Self.DataManager.StartTransaction;
  try
    Statement.Query.SQL.Clear();
    Statement.Query.SQL.Add(SQL_REMOVER_USUARIO);
    Statement.Query.ParamByName('IdUsuario').AsInteger := AEntity.IdUsuario;

    Statement.Query.ExecSQL();

    Self.DataManager.Commit;

    Result :=  Statement.Query.RowsAffected >= ROWS_AFFECTED;

  except
    on E: Exception do
      begin
        Self.DataManager.Rollback;

        raise Exception.Create(E.Message);
      end;
  end;
end;

function TUsuarioRepository.Merge(var AEntity: TUsuario): Boolean;
begin
  Self.DataManager.StartTransaction;
  try
    Statement.Query.SQL.Clear();
    Statement.Query.SQL.Add(SQL_ATUALIZAR_USUARIO);

    Statement.Query.ParamByName('IdUsuario').AsInteger:= AEntity.IdUsuario;
    SetProperties(Statement, AEntity);

    Statement.Query.ExecSQL();

    Self.DataManager.Commit;

    Result :=  Statement.Query.RowsAffected >= ROWS_AFFECTED;

  except
    on E: Exception do
      begin
        Self.DataManager.Rollback;

        raise Exception.Create(E.Message);
      end;
  end;
end;

function TUsuarioRepository.Save(var AEntity: TUsuario): TJSONObject;
begin
  Result := nil;

  Self.DataManager.StartTransaction;
  try
    Statement.Query.SQL.Add(SQL_PERSISTIR_USUARIO);

    SetProperties(Statement, AEntity);

    Statement.Query.Open();

    Self.DataManager.Commit;

    if Statement.Query.RowsAffected >= ROWS_AFFECTED then
      begin
        AEntity.IdUsuario := Statement.Query.Fields[0].AsString.ToInteger();

        var DataConverter: IDataConverter<TUsuario>;

        DataConverter := TDataConverter<TUsuario>.Create();

        Result :=  DataConverter.Execute(AEntity, ['Senha', 'Foto']);
      end;

  except
    on E: Exception do
      begin
        Self.DataManager.Rollback;

        raise Exception.Create(E.Message);
      end;
  end;
end;

function TUsuarioRepository.SavePhoto(const AEntity: TUsuario; const Value: TStream): Boolean;
begin
  Self.DataManager.StartTransaction;
  try
    Statement.Query.SQL.Clear();
    Statement.Query.SQL.Add(SQL_ATUALIZAR_FOTO_USUARIO);
    Statement.Query.ParamByName('IdUsuario').AsInteger:= AEntity.IdUsuario;
    Statement.Query.ParamByName('Foto').LoadFromStream(Value, ftBlob);

    Statement.Query.ExecSQL();

    Self.DataManager.Commit;

    Result :=  Statement.Query.RowsAffected >= ROWS_AFFECTED;

  except
    on E: Exception do
      begin
        Self.DataManager.Rollback;

        raise Exception.Create(E.Message);
      end;
  end;
end;

function TUsuarioRepository.GetPthoById(const AEntity: TUsuario): TMemoryStream;
begin
  Result := nil;

  try
    Statement.Query.SQL.Clear();
    Statement.Query.SQL.Add(SQL_CONSULTAR_FOTO_USUARIO);
    Statement.Query.ParamByName('IdUsuario').AsInteger:= AEntity.IdUsuario;

    Statement.Query.Open();

    if (not Statement.Query.IsEmpty()) and (not Statement.Query.FieldByName('Foto').IsNull) then
      begin
        var BlobStream := Statement.Query.CreateBlobStream(Statement.Query.FieldByName('Foto'), bmRead);
        try
          var Photo := TMemoryStream.Create();

          Photo.CopyFrom(BlobStream, BlobStream.Size);

          Photo.Position := 0;

          Result := Photo;

        finally
          BlobStream.Free();
        end;
      end;

  except
    on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
  end;
end;

procedure TUsuarioRepository.SetProperties(var AStatement: IStatement; const AEntity: TUsuario);
begin
  AStatement.Query.ParamByName('Nome').AsString:= AEntity.Nome;
  AStatement.Query.ParamByName('Login').AsString:= AEntity.Login;
  AStatement.Query.ParamByName('Senha').AsString:= AEntity.Senha;
  AStatement.Query.ParamByName('Status').AsString:= AEntity.Status;
  AStatement.Query.ParamByName('Sexo').AsString:= AEntity.Sexo;
  AStatement.Query.ParamByName('Telefone').AsString:= AEntity.Telefone;
  AStatement.Query.ParamByName('Credito').AsFloat := AEntity.Credito;
  AStatement.Query.ParamByName('DtCadastro').AsDateTime := AEntity.DtCadastro;
  AStatement.Query.ParamByName('Email').AsString := AEntity.Email;
end;

end.
