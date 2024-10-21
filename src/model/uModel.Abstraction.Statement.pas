unit uModel.Abstraction.Statement;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  IStatement = interface
  ['{A144C1E6-259E-4C9E-8043-9D642E39A6D2}']
    function GetQuery: TFDQuery;
    function SQL(Value: String): IStatement;
    function Open: IStatement;
    property Query: TFDQuery read GetQuery;
  end;

implementation

end.
