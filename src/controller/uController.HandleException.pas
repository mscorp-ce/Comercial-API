unit uController.HandleException;

interface

uses
  Horse;

type
  IHandleException<T: class> = interface
    ['{4843DED8-9506-4020-83A7-DE8707AC684D}']

    procedure Messagem(const Error: T; const Response: THorseResponse);
  end;

  THandleException<T: class> = class(TInterfacedObject, IHandleException<T>)
  public
    procedure Messagem(const Error: T; const Response: THorseResponse);

    destructor Destroy(); override;
  end;

  THandleHorseException<T: class> = class(TInterfacedObject, IHandleException<T>)
  public
    procedure Messagem(const Error: T; const Response: THorseResponse);

    destructor Destroy(); override;
  end;

implementation

uses
  System.SysUtils, System.JSON;

{ THandleException<T> }

destructor THandleException<T>.Destroy();
begin
  inherited Destroy();
end;

procedure THandleException<T>.Messagem(const Error: T; const Response: THorseResponse);
begin
  var JSONError := TJSONObject.Create();

  JSONError.AddPair('error', Error.ClassName);

  if Error is Exception then
    begin
      JSONError.AddPair('description', Exception(Error).Message);
      Response.Send(JSONError).Status(THTTPStatus.BadRequest);
    end;
end;

{ THandleHorseExceptionn<T> }

destructor THandleHorseException<T>.Destroy();
begin
  inherited Destroy();
end;

procedure THandleHorseException<T>.Messagem(const Error: T; const Response: THorseResponse);
begin
  var JSONError := TJSONObject.Create();

  JSONError.AddPair('error', Error.ClassName);

  if Error is EHorseException then
    begin
      JSONError.AddPair('description', EHorseException(Error).Error);
      Response.Send(JSONError).Status(THTTPStatus.NotFound);
    end;
end;

end.
