unit uModel.Abstraction.Repository;

interface

uses
  System.Classes, Data.DB, System.Generics.Collections, uModel.Abstraction.Statement,
  System.JSON;

type
  IStreamRepository<T: class> = interface
    ['{7268709A-3C28-4C25-9048-16554B626A26}']
    function SavePhoto(const AEntity: T; const Value: TStream): Boolean;
    function GetPthoById(const AEntity: T): TMemoryStream;
  end;

  IRepository<T: class> = interface
  ['{557CB439-8E45-4FAF-AEF4-1ADBE83590C6}']
    procedure GetProperties(var AEntity: T; const AStatement: IStatement);
    procedure SetProperties(var AStatement: IStatement; const AEntity: T);
    function ListAll(const AParams: TDictionary<string, string>): TObjectList<T>;
    function GetById(const AId: Integer): T;
    function Save(var AEntity: T): TJSONObject;
    function Merge(var AEntity: T): Boolean;
    function Remove(const AEntity: T): Boolean;
    function GetRecords(const AParams: TDictionary<string, string>): Int64;
  end;

implementation

end.
