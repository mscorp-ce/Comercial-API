unit uController.HandleException.Factory;

interface

uses
  uController.HandleException;

type
  TExceptionType = (etUnknown, etException, etHorseException);

  THandleExceptionFactory<T: class> = class
  public
    class function New(const ExceptionType: TExceptionType): IHandleException<T>;
  end;

implementation

uses
  System.SysUtils;

{ TIHandleExceptionFactory<T> }

class function THandleExceptionFactory<T>.New(const ExceptionType: TExceptionType): IHandleException<T>;
begin
  case ExceptionType of
    etException:
      begin
        Result := THandleException<T>.Create;
      end;

    etHorseException:
      begin
        Result := THandleHorseException<T>.Create;
      end
  else
    raise Exception.Create('Tipo de exceção desconhecida.');
  end;
end;

end.
