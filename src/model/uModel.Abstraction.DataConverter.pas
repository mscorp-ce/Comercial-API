unit uModel.Abstraction.DataConverter;

interface

uses
  System.Generics.Collections, System.JSON;

type
  IDataConverter<T: class> = interface
  ['{6C5C2E54-821C-412C-8828-E5F545C87B9D}']
    function Execute(const List: TObjectList<T>; const ExcludeProperties: array of string): TJSONArray; overload;
    function Execute(const Entity: T; const ExcludeProperties: array of string): TJSONObject; overload;
  end;

implementation

end.
