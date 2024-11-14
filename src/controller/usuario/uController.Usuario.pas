unit uController.Usuario;

interface

uses
  System.SysUtils, System.JSON, uModel.Entities.Usuario, Horse;

type
  TUsuarioController = class
  private
    class procedure List(Request: THorseRequest; Response: THorseResponse; Next: TProc); static;
    class procedure GetById(Request: THorseRequest; Response: THorseResponse; Next: TProc); static;
    class procedure Save(Request: THorseRequest; Response: THorseResponse; Next: TProc); static;
    class procedure Merge(Request: THorseRequest; Response: THorseResponse; Next: TProc); static;
    class procedure Remove(Request: THorseRequest; Response: THorseResponse; Next: TProc); static;
    class procedure SavePhoto(Request: THorseRequest; Response: THorseResponse; Next: TProc); static;
    class procedure GetPhotoById(Request: THorseRequest; Response: THorseResponse; Next: TProc); static;
  public
    class procedure EndPoints();
  end;

implementation

uses
  System.Classes, System.Generics.Collections, uModel.Abstraction.Service, uModel.Service.Usuario,
  uModel.Abstraction.DataConverter, uModel.Service.DataConverter, System.Rtti, REST.Json,
  uController.HandleException, uController.HandleException.Factory;

class procedure TUsuarioController.List(Request: THorseRequest; Response: THorseResponse; Next: TProc);
begin
  var Retorno := TJSONObject.Create();

  var Service: IService<TUsuario>;

  var DataConverter: IDataConverter<TUsuario>;

  DataConverter := TDataConverter<TUsuario>.Create();

  Service := TUsuarioService.Create();

  var List := Service.ListAll(Request.Query);
  try
    Retorno.AddPair('data', DataConverter.Execute(List, ['Senha', 'Foto']));
    Retorno.AddPair('records', TJSONNumber.Create(Service.GetRecords(Request.Query)));

  finally
    List.Free();
  end;

  Response.Send(Retorno).Status(THTTPStatus.OK);
end;

class procedure TUsuarioController.Merge(Request: THorseRequest; Response: THorseResponse; Next: TProc);
begin
  var IdUsuario := Request.Params.Items['id'].ToInteger();

  var Service: IService<TUsuario>;

  Service := TUsuarioService.Create();

  try
    var Usuario := Service.GetById(IdUsuario);

    if not Assigned(Usuario) then
      raise EHorseException.Create(THTTPStatus.NotFound, 'Usuário não cadastrado');

    try
      var JSONObj := Request.Body<TJSONObject>;

      var UsuarioMerge :=  TJson.JsonToObject<TUsuario>(JSONObj.ToString);
      try

        if Service.Merge(Usuario, UsuarioMerge) then
          Response.Status(THTTPStatus.NoContent);

      finally
        UsuarioMerge.Free();
      end;

    finally
      Usuario.Free();
    end;

  except
    on E: EHorseException do
      begin
        THandleExceptionFactory<EHorseException>.New(etHorseException).Messagem(E, Response);
      end;

    on E: Exception do
      THandleExceptionFactory<Exception>.New(etException).Messagem(E, Response);
  end;
end;

class procedure TUsuarioController.Remove(Request: THorseRequest; Response: THorseResponse; Next: TProc);
begin
  var IdUsuario := Request.Params.Items['id'].ToInteger();

  var Service: IService<TUsuario>;

  Service := TUsuarioService.Create();

  var Usuario := Service.GetById(IdUsuario);
  try
    try
      if not Assigned(Usuario) then
         raise EHorseException.Create(THTTPStatus.NotFound, 'Usuário não encontrado.');

      if Service.Remove(Usuario) then
        Response.Status(THTTPStatus.NoContent);

    except
      on E: EHorseException do
        begin
          THandleExceptionFactory<EHorseException>.New(etHorseException).Messagem(E, Response);
        end;

      on E: Exception do
        THandleExceptionFactory<Exception>.New(etException).Messagem(E, Response);
    end;

  finally
    Usuario.Free();
  end;
end;

class procedure TUsuarioController.GetById(Request: THorseRequest; Response: THorseResponse; Next: TProc);
begin
  var Service: IService<TUsuario>;

  var DataConverter: IDataConverter<TUsuario>;

  DataConverter := TDataConverter<TUsuario>.Create();

  Service := TUsuarioService.Create();

  var IdUsuario := Request.Params.Items['id'].ToInteger();

  var Usuario := Service.GetById(IdUsuario);
  try
    if not Assigned(Usuario) then
       raise EHorseException.Create(THTTPStatus.NotFound, 'Usuário não encontrado.');

    var Retorno := DataConverter.Execute(Usuario, ['Senha', 'Foto']);

    Response.Send(Retorno).Status(THTTPStatus.OK);

  finally
    Usuario.Free();
  end;
end;

class procedure TUsuarioController.Save(Request: THorseRequest; Response: THorseResponse; Next: TProc);
begin
  var JSONObj := Request.Body<TJSONObject>;

  var  Usuario :=  TJson.JsonToObject<TUsuario>(JSONObj.ToString);
  try
    var Service: IService<TUsuario>;

    Service := TUsuarioService.Create();

    try
      var UsuarioCriado := Service.Save(Usuario);

      if Assigned(UsuarioCriado) then
        Response.Send(UsuarioCriado).Status(THTTPStatus.Created)

    except
      on E: Exception do
        begin
          var JSONError := TJSONObject.Create();

          JSONError.AddPair('error', E.ClassName);
          JSONError.AddPair('description', E.Message);

          Response.Send(JSONError).Status(THTTPStatus.BadRequest);
        end;
    end;

  finally
    Usuario.Free();
  end;
end;

class procedure TUsuarioController.SavePhoto(Request: THorseRequest; Response: THorseResponse; Next: TProc);
begin
  var IdUsuario := Request.Params.Items['id'].ToInteger();

  var Service := TUsuarioService.Create();
  try
    var Usuario := Service.GetById(IdUsuario);
    try
      if not Assigned(Usuario) then
         raise EHorseException.Create(THTTPStatus.NotFound, 'Usuário não encontrado.');

      var Photo := Request.Body<TMemoryStream>;

      if not Assigned(Photo) then
        raise EHorseException.Create(THTTPStatus.BadRequest, 'Foto inválida.');

      if Service.SavePhoto(Usuario, Photo) then
        Response.Status(THTTPStatus.NoContent);

    finally
      Usuario.Free();
    end;

  finally
    Service.Free();
  end;
end;

class procedure TUsuarioController.GetPhotoById(Request: THorseRequest; Response: THorseResponse; Next: TProc);
begin
  var IdUsuario := Request.Params.Items['id'].ToInteger();

  var Service := TUsuarioService.Create();
  try
    var Usuario := Service.GetById(IdUsuario);
    try
      if not Assigned(Usuario) then
         raise EHorseException.Create(THTTPStatus.NotFound, 'Usuário não encontrado.');

      var Photo := Service.GetPthoById(Usuario);

      if not Assigned(Photo) then
        raise EHorseException.Create(THTTPStatus.NotFound, 'Foto não cadastrada.');

      Response.Send(Photo).Status(THTTPStatus.OK);

    finally
      Usuario.Free();
    end;

  finally
    Service.Free();
  end;
end;

{ TUsuarioController }

class procedure TUsuarioController.EndPoints();
begin
  THorse.Get('/usuarios', List);
  THorse.Get('/usuarios/:id', GetById);
  THorse.Post('/usuarios', Save);
  THorse.Put('/usuarios/:id', Merge);
  THorse.Delete('/usuarios/:id', Remove);
  THorse.Post('/usuarios/:id/foto', SavePhoto);
  THorse.Get('/usuarios/:id/foto', GetPhotoById);
end;

end.
