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

uses
  System.Generics.Collections;

class procedure TObjectToJSON.RemovePairJSONValueNull(AJsonObject: TJSONObject);
var
  Pair: TJSONPair;
  i: Integer;
begin
  if Assigned(AJsonObject) then
    begin
      for i := AJsonObject.Count - 1 downto 0 do
        begin
          Pair := TJSONPair(AJsonObject.Pairs[i]);
          if Pair.JsonValue is TJSONObject then
            RemovePairJSONValueNull(TJSONObject(Pair.JsonValue))
          else
            begin
              if (Pair.JsonValue is TJsonNull ) then
                AJsonObject.RemovePair(Pair.JsonString.Value).Free();
            end;
        end;
    end;
end;

end.
