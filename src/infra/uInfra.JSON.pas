unit uInfra.JSON;

interface

uses
  System.JSON;

type
  TObjectToJSON = class
  public
    class procedure RemovePairJSONValueNull(AJsonObject: TJSONObject);
  end;

implementation

{ TObjectToJSON }

class procedure TObjectToJSON.RemovePairJSONValueNull(AJsonObject: TJSONObject);
var
  LPair: TJSONPair;
  i: Integer;
begin
  if Assigned(AJsonObject) then
  begin
    for i := AJsonObject.Count - 1 downto 0 do
    begin
      LPair := TJSONPair(AJsonObject.Pairs[i]);
      if LPair.JsonValue is TJSONObject then
        RemovePairJSONValueNull(TJSONObject(LPair.JsonValue))
      else
      begin
        if (LPair.JsonValue is TJsonNull ) then
          AJsonObject.RemovePair(LPair.JsonString.Value).DisposeOf;
      end;
    end;
  end;
end;

end.
