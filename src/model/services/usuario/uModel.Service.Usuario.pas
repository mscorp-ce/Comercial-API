unit uModel.Service.Usuario;

interface

uses
  System.Classes, System.Generics.Collections, uModel.Abstraction.Service, uModel.Entities.Usuario,
  uModel.Abstraction.Repository, System.JSON;

type
  TUsuarioService = class(TInterfacedObject, IService<TUsuario>, IServiceStream<TUsuario>)
  private
    Repository: IRepository<TUsuario>;
    procedure ExecuteIsValid(const AEntity: TUsuario);
    function IsValid(const AEntity: TUsuario; out Error: String): Boolean;
  public
    constructor Create(); reintroduce;

    function ListAll(const AParams: TDictionary<string, string>): TObjectList<TUsuario>;
    function GetById(const AId: Integer): TUsuario;
    procedure BeforeSave(const AOldEntity: TUsuario; var ANewEntity: TUsuario);
    function Save(var AEntity: TUsuario): TJSONObject;
    function Merge(const AOldEntity: TUsuario; var ANewEntity: TUsuario): Boolean;
    function Remove(const AEntity: TUsuario): Boolean;
    function SavePhoto(const AEntity: TUsuario; const Value: TStream): Boolean;
    function GetPthoById(const AEntity: TUsuario): TMemoryStream;
    function GetRecords(const AParams: TDictionary<string, string>): Int64;
  end;

implementation

uses
  System.SysUtils, Horse, BCrypt, uModel.Repository.Usuario, uModel.Abstraction.DataConverter, uModel.Service.DataConverter;

{ TUsuarioService }

procedure TUsuarioService.BeforeSave(const AOldEntity: TUsuario; var ANewEntity: TUsuario);
begin
  if not Assigned(AOldEntity) then
    ANewEntity.Senha := TBCrypt.GenerateHash(ANewEntity.Senha)
  else
    begin
      ANewEntity.IdUsuario := AOldEntity.IdUsuario;

      if not TBCrypt.CompareHash(ANewEntity.Senha, AOldEntity.Senha) then
        ANewEntity.Senha := TBCrypt.GenerateHash(ANewEntity.Senha.Trim())
      else
        ANewEntity.Senha := AOldEntity.Senha
    end;
  end;

constructor TUsuarioService.Create();
begin
  inherited Create();

  Repository := TUsuarioRepository.Create();
end;

function TUsuarioService.GetById(const AId: Integer): TUsuario;
begin
  Result := Repository.GetById(AId);
end;

function TUsuarioService.GetRecords(const AParams: TDictionary<string, string>): Int64;
begin
  Result := Repository.GetRecords(AParams);
end;

function TUsuarioService.IsValid(const AEntity: TUsuario; out Error: String): Boolean;
begin
  Result := False;

  if AEntity.Nome.IsEmpty() then
    begin
      Error := 'Informe o nome do usuario.';
      Exit();
    end;

  if AEntity.Login.IsEmpty() then
    begin
      Error := 'Informe o login do usuario.';
      Exit();
    end;

  if AEntity.Senha.IsEmpty() then
    begin
      Error := 'Informe a senha do usuario.';
      Exit();
    end;

  if AEntity.Senha.IsEmpty() then
    begin
      Error := 'Informe a senha do usuario.';
      Exit();
    end;

  if AEntity.Email.IsEmpty() then
    begin
      Error := 'Informe o e-mail do usuario.';
      Exit();
    end;

  Result := True;
end;

function TUsuarioService.ListAll(const AParams: TDictionary<string, string>): TObjectList<TUsuario>;
begin
  Result := Repository.ListAll(AParams);
end;

function TUsuarioService.Remove(const AEntity: TUsuario): Boolean;
begin
  try
    Result := Repository.Remove(AEntity);
  except
    on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
  end;
end;

function TUsuarioService.Save(var AEntity: TUsuario): TJSONObject;
begin
  ExecuteIsValid(AEntity);

  try
    Self.BeforeSave(nil, AEntity);

    Result := Repository.Save(AEntity);
  except
    on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
  end;
end;

function TUsuarioService.SavePhoto(const AEntity: TUsuario; const Value: TStream): Boolean;
begin
  try
    var UsuarioRepository := TUsuarioRepository.Create();
    try
      Result := UsuarioRepository.SavePhoto(AEntity, Value);

    finally
      UsuarioRepository.Free();
    end;

  except
    on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
  end;
end;

function TUsuarioService.GetPthoById(const AEntity: TUsuario): TMemoryStream;
begin
  try
    var UsuarioRepository := TUsuarioRepository.Create();
    try
      Result := UsuarioRepository.GetPthoById(AEntity);

    finally
      UsuarioRepository.Free();
    end;

  except
    on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
  end;
end;

procedure TUsuarioService.ExecuteIsValid(const AEntity: TUsuario);
begin
  var Error: String;

  if not IsValid(AEntity, Error) then
    raise Exception.Create(Error);
end;

function TUsuarioService.Merge(const AOldEntity: TUsuario; var ANewEntity: TUsuario): Boolean;
begin
  ExecuteIsValid(ANewEntity);

  try
    BeforeSave(AOldEntity, ANewEntity);

    Result := Repository.Merge(ANewEntity);

  except
    on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
  end;
end;

end.
