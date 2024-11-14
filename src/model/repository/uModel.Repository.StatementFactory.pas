unit uModel.Repository.StatementFactory;

interface

uses
  FireDAC.Comp.Client, uModel.Abstraction.DataManager, uModel.Repository.Statement;

type
  TStatementFactory = class
  public
    class function GetStatement(DataManager: IDataManager): TStatement;
  end;

implementation

{ TStatementFactory }

class function TStatementFactory.GetStatement(DataManager: IDataManager): TStatement;
begin
  Result:= TStatement.Create(DataManager);
end;

end.
