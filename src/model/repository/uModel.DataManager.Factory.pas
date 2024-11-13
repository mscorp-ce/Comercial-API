unit uModel.DataManager.Factory;

interface

uses
  uModel.Abstraction.DataManager, uModel.FireDac;

type
  TDataManagerFactory = class
  public
    class function GetDataManager(): TModelFireDAC;
  end;

implementation

{ TDataManagerFactory }

class function TDataManagerFactory.GetDataManager(): TModelFireDAC;
begin
  Result:= TModelFireDAC.Create();
end;

end.
