
program ComercialAPI;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  Horse,
  uModel.Abstraction.DataManager in 'src\model\uModel.Abstraction.DataManager.pas',
  uModel.Abstraction.Statement in 'src\model\uModel.Abstraction.Statement.pas',
  uModel.Abstraction.Repository in 'src\model\uModel.Abstraction.Repository.pas',
  uModel.FireDACEngineException in 'src\model\uModel.FireDACEngineException.pas',
  uLibary in 'src\uLibary.pas',
  uModel.FireDAC in 'src\model\uModel.FireDAC.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
