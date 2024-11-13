unit uModel.Entities.Usuario;

interface

uses classes, System.SysUtils;

type
  TUsuario = class
  private
    FIdUsuario: Integer;
    FStatus: String;
    FSenha: String;
    FLogin: String;
    FSexo: String;
    FNome: String;
    FTelefone: String;
    FEmail: String;
    FFoto: TBytes;
    FCredito: Double;
    FDtCadastro: TDateTime;

    procedure SetIdUsuario(const Value: Integer);
    procedure SetLogin(const Value: String);
    procedure SetNome(const Value: string);
    procedure SetSenha(const Value: string);
    procedure SetSexo(const Value: String);
    procedure SetStatus(const Value: String);
    procedure SetTelefone(const Value: String);
    procedure SetEmail(const Value: String);
    procedure SetFoto(const Value: TBytes);
    procedure SetCredito(const Value: Double);
    procedure SetDtCadastro(const Value: TDateTime);
  public
    property IdUsuario: Integer read FIdUsuario write SetIdUsuario;
    property Nome: String read FNome write SetNome;
    property Login: String read FLogin write SetLogin;
    property Senha: String read FSenha write SetSenha;
	  property Status: String read FStatus write SetStatus;
    property Sexo: String read FSexo write SetSexo;
    property Telefone: String read FTelefone write SetTelefone;
    property Foto: TBytes read FFoto write SetFoto;
    property Credito: Double read FCredito write SetCredito;
    property DtCadastro: TDateTime read FDtCadastro write SetDtCadastro;
    property Email: String read FEmail write SetEmail;
  end;

implementation

{ TUsuario }

procedure TUsuario.SetCredito(const Value: Double);
begin
  FCredito := Value;
end;

procedure TUsuario.SetDtCadastro(const Value: TDateTime);
begin
  FDtCadastro := Value;
end;

procedure TUsuario.SetEmail(const Value: String);
begin
  FEmail := Value;
end;

procedure TUsuario.SetFoto(const Value: TBytes);
begin
  FFoto := Value;
end;

procedure TUsuario.SetIdUsuario(const Value: Integer);
begin
  FIdUsuario := Value;
end;

procedure TUsuario.SetLogin(const Value: String);
begin
  FLogin := Value;
end;

procedure TUsuario.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TUsuario.SetSenha(const Value: string);
begin
  FSenha := Value;
end;

procedure TUsuario.SetSexo(const Value: String);
begin
  FSexo := Value;
end;

procedure TUsuario.SetStatus(const Value: String);
begin
  FStatus := Value;
end;

procedure TUsuario.SetTelefone(const Value: String);
begin
  FTelefone := Value;
end;

end.
