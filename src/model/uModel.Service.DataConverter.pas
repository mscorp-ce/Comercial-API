unit uModel.Service.DataConverter;

interface

uses
  System.Generics.Collections, uModel.Abstraction.DataConverter, System.JSON;

type
  TDataConverter<T: class> = class(TInterfacedObject, IDataConverter<T>)
  public
    function Execute(const List: TObjectList<T>; const ExcludeProperties: array of string): TJSONArray; overload;
    function Execute(const Entity: T; const ExcludeProperties: array of string): TJSONObject; overload;
  end;

implementation

uses
  REST.Json, Data.DBXJSONReflect, uInfra.ManagerSerializer;

{ TDataConverter<T> }

function TDataConverter<T>.Execute(const List: TObjectList<T>; const ExcludeProperties: array of string): TJSONArray;
var
  Item: T;
  JSONObj: TJSONObject;
begin
  Result := TJSONArray.Create();
  try
    for Item in List do
    begin
      JSONObj := nil;
      try
        JSONObj := TManagerSerializer.Serialize(Item, ExcludeProperties);
        if Assigned(JSONObj) then
          Result.AddElement(JSONObj);
      except
        if Assigned(JSONObj) then
          JSONObj.Free();
        raise;
      end;
    end;
  except
    Result.Free();
    raise;
  end;
end;

function TDataConverter<T>.Execute(const Entity: T; const ExcludeProperties: array of string): TJSONObject;
var
  JSONObj: TJSONObject;
begin
  JSONObj := nil;
  try
    try
      JSONObj := TManagerSerializer.Serialize(Entity, ExcludeProperties);
      Result := JSONObj;
    except
      if Assigned(JSONObj) then
        JSONObj.Free();
      raise;
    end;
  except
    raise;
  end;
end;

end.
