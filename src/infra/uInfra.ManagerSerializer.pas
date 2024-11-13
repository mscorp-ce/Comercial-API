unit uInfra.ManagerSerializer;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Rtti;

type
  TManagerSerializer = class
  public
    class function Serialize(AObject: TObject; const ExcludeProperties: array of string): TJSONObject;
    class function Deserialize(const AJson: string; AObject: TObject): Boolean;
  end;

implementation

uses
  System.Generics.Collections, System.TypInfo;

{ TManagerSerializer }

function DateToISO8601(AValue: TDate): string;
begin
  Result := FormatDateTime('yyyy-mm-dd', AValue);
end;

function DateTimeToISO8601(AValue: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', AValue);
end;

class function TManagerSerializer.Serialize(AObject: TObject; const ExcludeProperties: array of string): TJSONObject;
var
  Context: TRttiContext;
  Instance: TRttiInstanceType;
  JSONObj: TJSONObject;
  Propertie: TRttiProperty;
  ExcludeSet: TDictionary<string, Boolean>;
  Value: TValue;
begin
  Context := TRttiContext.Create;
  Instance := Context.GetType(AObject.ClassType) as TRttiInstanceType;
  JSONObj := TJSONObject.Create;

  ExcludeSet := TDictionary<string, Boolean>.Create;
  try
    for var PropName in ExcludeProperties do
      ExcludeSet.Add(PropName, True);

    for Propertie in Instance.GetProperties do
      begin
        if Propertie.IsReadable and not ExcludeSet.ContainsKey(Propertie.Name) then
          begin
            Value := Propertie.GetValue(AObject);

            case Propertie.PropertyType.TypeKind of
              tkInteger:
                JSONObj.AddPair(Propertie.Name, TJSONNumber.Create(Value.AsInteger));

              tkFloat:
                begin
                  if (Value.TypeInfo = TypeInfo(TDate)) then
                    JSONObj.AddPair(Propertie.Name, DateTimeToISO8601(Value.AsType<TDate>))
                  else if (Value.TypeInfo = TypeInfo(TTimeStamp)) then
                    JSONObj.AddPair(Propertie.Name, DateTimeToISO8601(Value.AsType<TDateTime>))
                  else if (Value.TypeInfo = TypeInfo(TDateTime)) then
                    JSONObj.AddPair(Propertie.Name, DateTimeToISO8601(Value.AsType<TDateTime>))
                  else
                    JSONObj.AddPair(Propertie.Name, TJSONNumber.Create(Value.AsExtended));
                end;

              tkString, tkWString:
                JSONObj.AddPair(Propertie.Name, Value.AsString);

              tkEnumeration:
                JSONObj.AddPair(Propertie.Name, Value.AsString);
            else
              // Para outros tipos, você pode optar por não incluir ou tratá-los de outra forma
              JSONObj.AddPair(Propertie.Name, Value.AsString);
            end;
          end;
      end;

    Result := JSONObj;

  finally
    ExcludeSet.Free;
  end;
end;

class function TManagerSerializer.Deserialize(const AJson: string; AObject: TObject): Boolean;
var
  Context: TRttiContext;
  Instance: TRttiInstanceType;
  JSONObj: TJSONObject;
  DataArray: TJSONArray;
  Item: TJSONObject;
  Propertie: TRttiProperty;
  Value: TValue;
begin
  Result := False;
  if (AJson = '') or not Assigned(AObject) then
    Exit;

  Context := TRttiContext.Create;
  Instance := Context.GetType(AObject.ClassType) as TRttiInstanceType;

  JSONObj := TJSONObject.ParseJSONValue(AJson) as TJSONObject;
  try
    if Assigned(JSONObj) then
    begin
      if JSONObj.TryGetValue<TJSONArray>('data', DataArray) then
        begin
          if DataArray.Count > 0 then
            begin
              Item := DataArray.Items[0] as TJSONObject;
              for Propertie in Instance.GetProperties do
                begin
                  if Propertie.IsWritable and Item.TryGetValue(Propertie.Name, Value) then
                    begin
                      Propertie.SetValue(AObject, Value);
                    end;
                end;
              Result := True;
            end;
        end;
    end;

  finally
    JSONObj.Free;
  end;
end;

end.

