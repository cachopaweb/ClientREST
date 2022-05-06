unit UnitClienteREST.Model.Interfaces;

interface

uses
  UnitObserver.Model.Interfaces, System.JSON, System.Classes;

  type
    iClienteREST = interface
      ['{E04FDD85-09B6-457C-9C72-7B848F33CEB0}']
      function AddHeader(Par, Valor: string): iClienteREST;
      function AddBody(Value: string): iClienteREST;overload;
      function AddBody(Value: TJSONObject): iClienteREST;overload;
      function AddBody(Value: TStream): iClienteREST;overload;
      function Put(Value: string = ''): string;
      function Get(Value: string = ''): string;
      function Post(Value: string = ''): string;overload;
      function Post(Value: string; Body: TJSONObject): string;overload;
      function Post(Value: string; Body: string): string;overload;
      function Delete(Value: string = ''): iClienteREST;
      function InscreverObservador(Value: iObservador): iClienteREST;
    end;

implementation

end.
