unit uModel.Abstraction.Service;

interface

uses
  System.Classes, System.Generics.Collections, System.JSON;

type
  IServiceStream<T: class> = interface
    ['{0B0F9A4E-6E42-4744-8713-87D1C616A45A}']
    function SavePhoto(const AEntity: T; const Value: TStream): Boolean;
    function GetPthoById(const AEntity: T): TMemoryStream;
  end;

  IService<T: class> = interface
    ['{859F5459-C3D3-44E7-AA5D-9FA4D8600977}']
    function ListAll(const AParams: TDictionary<string, string>): TObjectList<T>;
    function GetById(const AId: Integer): T;
    procedure ExecuteIsValid(const AEntity: T);
    function IsValid(const AEntity: T; out Error: String): Boolean;
    procedure BeforeSave(const AOldEntity: T; var ANewEntity: T);
    function Save(var AEntity: T): TJSONObject;
    function Merge(const AOldEntity: T; var ANewEntity: T): Boolean;
    function Remove(const AEntity: T): Boolean;
    function GetRecords(const AParams: TDictionary<string, string>): Int64;
  end;

implementation

end.
