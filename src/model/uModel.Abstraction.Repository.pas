unit uModel.Abstraction.Repository;

interface

uses
  System.Classes, Data.DB, System.Generics.Collections, uModel.Abstraction.Statement;

type
  IRepository<T: class> = interface
  ['{557CB439-8E45-4FAF-AEF4-1ADBE83590C6}']
    function Fields: TStrings;
    procedure SetStatement(Statement: IStatement; Entity: T);
    procedure SetProperty(Statement: IStatement; Entity: T);
    function GeneratedValue: Integer;
    function CurrentGeneratedValue: Integer;
    function Save(Entity: T): Boolean;
    procedure AfterSave(Entity: T);
    function Update(Entity: T): Boolean; overload;
    function Update(CommandSQL: String; Parameter: String; Entity: T): Boolean; overload;
    function DeleteById(Entity: T): Boolean;
    function FindById(Id: Integer): T;
    function FindExists: Boolean; overload;
    function FindExists(CommadSQL: String; Parameter: String;
      ParameterType: TFieldType; Value: Variant): IStatement; overload;
    function FindAll: TObjectList<T>; overload;
    function FindAll(CommadSQL: String): TObjectList<T>; overload;
    function FindAll(CommadSQL: String; Entity: T): TObjectList<T>; overload;
    function Frist: T;
    function Previous(Id: Integer): T;
    function Next(Id: Integer): T;
    function Last: T;
  end;

implementation

end.
