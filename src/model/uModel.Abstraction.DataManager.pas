unit uModel.Abstraction.DataManager;

interface

uses
  System.Classes, Data.DB;

type
  IDataManager = interface
  ['{EFF5B803-DF01-480E-9681-79E85A0FFF69}']

    function GetConnection: TCustomConnection;
    function GetStartTransaction: IDataManager;
    function GetCommit: IDataManager;
    function GetRollback: IDataManager;
    function GetEtity(EtitName: String): IDataManager;
    function GetFieldNames: TStrings;
    property Connection: TCustomConnection read GetConnection;

    property StartTransaction: IDataManager read GetStartTransaction;
    property Commit: IDataManager read GetCommit;
    property Rollback: IDataManager read GetRollback;
  end;

implementation

end.
