unit UnitClienteREST.Model.Interfaces;

interface

uses
  UnitObserver.Model.Interfaces, System.JSON, System.Classes;

  type
    TClientResult = record
      StatusCode: integer;
      Content: string;
      Error: string;
    end;

    iClienteREST = interface
      ['{E04FDD85-09B6-457C-9C72-7B848F33CEB0}']
      function AddHeader(Par, Valor: string): iClienteREST;
      function AddBody(Value: string): iClienteREST;overload;
      function AddBody(Value: TJSONObject): iClienteREST;overload;
      function AddBody(Value: TStream): iClienteREST;overload;
      function Put(Value: string = ''): TClientResult;
      function Get(Value: string = ''): TClientResult;
      function Post(Value: string = ''): TClientResult;overload;
      function Post(Value: string; Body: TJSONObject): TClientResult;overload;
      function Post(Value: string; Body: string): TClientResult;overload;
      function Delete(Value: string = ''): iClienteREST;
      function InscreverObservador(Value: iObservador): iClienteREST;
    end;

implementation

end.
