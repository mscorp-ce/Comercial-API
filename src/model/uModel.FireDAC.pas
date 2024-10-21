unit uModel.FireDAC;

interface

uses
  System.Classes, System.SysUtils, FireDAC.Stan.Option, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSSQL, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Moni.RemoteClient, FireDAC.Moni.FlatFile, FireDAC.Moni.Base, FireDAC.Moni.Custom, uModel.Abstraction.DataManager;

type
  TModelFireDAC = class(TInterfacedObject, IDataManager)
  private
    FConexao : TFDConnection;

    FMSSQLDriver: TFDPhysMSSQLDriverLink;

    FEntitieName: String;
  public
    constructor Create;
    destructor Destroy; override;

    function GetStartTransaction: IDataManager;
    function GetCommit: IDataManager;
    function GetRollback: IDataManager;
    function GetEtity(EntitieName: String): IDataManager;
    function GetFieldNames: TStrings;

    function GetConnection: TCustomConnection;
    property Connection: TCustomConnection read GetConnection;
    property StartTransaction: IDataManager read GetStartTransaction;
    property Commit: IDataManager read GetCommit;
    property Rollback: IDataManager read GetRollback;
  end;

implementation

uses
  uLibary, Vcl.Dialogs, Vcl.Controls, System.UITypes, FireDAC.Stan.Intf,
  FireDAC.Stan.Error, uModel.FireDACEngineException;

{ TModelFireDAC }

constructor TModelFireDAC.Create;
begin
  inherited Create;
  try

    FConexao := TFDConnection.Create(nil);
    FConexao.DriverName                := TLibary.GetINI('DATA_MSSMQL', 'DriverName');
    FConexao.Params.Values['Server']   := TLibary.GetINI('DATA_MSSMQL', 'Server');
    FConexao.Params.Values['Database'] := TLibary.GetINI('DATA_MSSMQL', 'Database');
    FConexao.Params.Values['User_Name']:= TLibary.GetINI('DATA_MSSMQL', 'User_Name');
    FConexao.Params.Values['Password'] := TLibary.GetINI('DATA_MSSMQL', 'Password');

    FMSSQLDriver:= TFDPhysMSSQLDriverLink.Create(nil);

    FConexao.Open;

  except
    on E: EFDDBEngineException do
      raise Exception.Create(TFireDACEngineException.GetMessage(E));
  end;
end;

destructor TModelFireDAC.Destroy;
begin
  FConexao.Close();
  FreeAndNil( FConexao );
  FreeAndNil( FMSSQLDriver );

  inherited Destroy();
end;

function TModelFireDAC.GetEtity(EntitieName: String): IDataManager;
begin
  FEntitieName := EntitieName;
  Result:= Self;
end;

function TModelFireDAC.GetCommit: IDataManager;
begin
  FConexao.Commit;
  Result:= Self;
end;

function TModelFireDAC.GetConnection: TCustomConnection;
begin
  Result:= FConexao;
end;

function TModelFireDAC.GetFieldNames: TStrings;
var
  Items: TStrings;
begin
  Items:= TStringList.Create;
  try
    FConexao.GetFieldNames('', '', FEntitieName, '', Items);

    Result:= Items;
 except
    on E: EFDDBEngineException do
      begin
        raise Exception.Create(TFireDACEngineException.GetMessage(E));
      end;
  end;
end;

function TModelFireDAC.GetRollback: IDataManager;
begin
  FConexao.Rollback;
  Result:= Self;
end;

function TModelFireDAC.GetStartTransaction: IDataManager;
begin
  FConexao.StartTransaction;
  Result:= Self;
end;

end.
