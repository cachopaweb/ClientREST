unit UnitPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFrmPrincipal = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

uses
  UnitClientREST.Model.Interfaces,
  UnitClientREST.Model;

procedure TFrmPrincipal.Button1Click(Sender: TObject);
var
  LResult: TClientResult;
begin
  LResult := TClientREST.New('sua-api.com.br').Get();
  if LResult.StatusCode = 200 then
  begin
    showMessage(LResult.Content);
  end;
end;

end.
