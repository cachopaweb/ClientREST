unit UnitObserver.Model.Interfaces;

interface

uses
  System.Classes, System.Generics.Collections;

type
  iSujeito = interface;

  TNotificacao = record
    Evento: string;
    Permissoes: TStringList;
    RefazerMenu: boolean;
    Codigo: integer;
    Valor: Currency;
    Nome: string;
    ListaCodigos: TList<Integer>;
    Descricao: string;
    NumeroNF: string;
    Quantidade: Double;
    Produto: integer;
    TipoNF: string;
  end;

  iObservador = interface
    ['{E1EC3ED0-1472-46E2-B4D2-BCED3964CDFD}']
    function Atualizar(Notificacao: TNotificacao): iObservador;
  end;

  iLimparObservadores = interface
    ['{EF717E0A-3B8B-441B-8ACF-4CD9A320FD76}']
    function RemoveObservador(Value: iObservador): iSujeito;
  end;

  iSujeito = interface
    ['{5FEFF93B-E8E2-4F59-BBAF-5571DF66A777}']
    function AddObservador(Value: iObservador): iSujeito;
    function Notificar(Value: TNotificacao): iSujeito;
  end;

implementation

end.
