unit UnitClientREST.Model.Interfaces;

interface

uses
  UnitObserver.Model.Interfaces, System.JSON, System.Classes;

  type
    TClientResult = record
      StatusCode: integer;
      Content: string;
      Error: string;
    end;

    iClientREST = interface
      ['{E04FDD85-09B6-457C-9C72-7B848F33CEB0}']
      function AddHeader(Par, Valor: string): iClientREST;
      function AddBody(Value: string): iClientREST;overload;
      function AddBody(Value: TJSONObject): iClientREST;overload;
      function AddBody(Value: TStream): iClientREST;overload;
      function AddUserPassword(User, Pass: string): iClientREST;
      function Put(Value: string = ''): TClientResult;
      function Get(Value: string = ''): TClientResult;
      function Post(Value: string = ''): TClientResult;overload;
      function Post(Value: string; Body: TJSONObject): TClientResult;overload;
      function Post(Value: string; Body: string): TClientResult;overload;
      function Delete(Value: string = ''): TClientResult;
      function InscreverObservador(Value: iObservador): iClientREST;
    end;

implementation

end.
