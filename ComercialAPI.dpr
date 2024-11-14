program ComercialAPI;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  FastMM4,
  FastMM4Messages,
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  Horse,
  Horse.JWT,
  Horse.Jhonson,
  Horse.OctetStream,
  Horse.HandleException,
  uModel.Abstraction.DataManager in 'src\model\uModel.Abstraction.DataManager.pas',
  uModel.Abstraction.Statement in 'src\model\uModel.Abstraction.Statement.pas',
  uModel.Abstraction.Service in 'src\model\uModel.Abstraction.Service.pas',
  uModel.Abstraction.Repository in 'src\model\uModel.Abstraction.Repository.pas',
  uModel.FireDACEngineException in 'src\model\uModel.FireDACEngineException.pas',
  uLibary in 'src\uLibary.pas',
  uModel.FireDAC in 'src\model\uModel.FireDAC.pas',
  uModel.Entities.Usuario in 'src\model\entities\uModel.Entities.Usuario.pas',
  uModel.Repository.StatementFactory in 'src\model\repository\uModel.Repository.StatementFactory.pas',
  uModel.DataManager.Factory in 'src\model\repository\uModel.DataManager.Factory.pas',
  uModel.Repository.Statement in 'src\model\repository\uModel.Repository.Statement.pas',
  uController.Usuario in 'src\controller\usuario\uController.Usuario.pas',
  uModel.Service.Usuario in 'src\model\services\usuario\uModel.Service.Usuario.pas',
  uModel.Repository.Usuario in 'src\model\repository\usuario\uModel.Repository.Usuario.pas',
  uModel.Repository.Resources.Usuario in 'src\model\repository\resources\usuario\uModel.Repository.Resources.Usuario.pas',
  uConstants in 'src\uConstants.pas',
  uModel.Abstraction.DataConverter in 'src\model\uModel.Abstraction.DataConverter.pas',
  uModel.Service.DataConverter in 'src\model\uModel.Service.DataConverter.pas',
  uInfra.ManagerSerializer in 'src\infra\uInfra.ManagerSerializer.pas',
  uInfra.Secret.Key in 'src\infra\secret\uInfra.Secret.Key.pas',
  uController.HandleException in 'src\controller\uController.HandleException.pas',
  uInfra.JSON in 'src\infra\uInfra.JSON.pas',
  uController.HandleException.Factory in 'src\controller\uController.HandleException.Factory.pas';

function GetConsoleWindow: HWND; stdcall; external kernel32 name 'GetConsoleWindow';

procedure SetConsoleWindowPosition();
var
  ConsoleHwnd: HWND;
  R: TRect;
begin
  ConsoleHwnd := GetConsoleWindow;
  // Center the console window
  GetWindowRect(ConsoleHwnd, R);
  SetWindowPos(ConsoleHwnd, 0,
    (GetSystemMetrics(SM_CXVIRTUALSCREEN) - (R.Right - R.Left)) div 2,
    (GetSystemMetrics(SM_CYVIRTUALSCREEN) - (R.Bottom - R.Top)) div 2,
    0, 0, SWP_NOSIZE);
end;

begin
  SetConsoleWindowPosition();

  try
    { TODO -oUser -cConsole Main : Insert code here }

    THorse
      .Use(Jhonson())
      .Use(HandleException)
      .Use(OctetStream);
      //.Use(HorseJWT(SECRET_KEY)); Removido temporariamente enquanto subo a API de segurança!

    THorse.Get('/status',
      procedure(Request: THorseRequest; Response: THorseResponse; Next: TProc)
      begin
        Response.Send('Server ON').Status(THTTPStatus.OK);
      end);

    TUsuarioController.EndPoints();

    ReportMemoryLeaksOnShutdown := True;

    THorse.Listen(9301);

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
