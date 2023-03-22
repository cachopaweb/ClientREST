unit UnitClientREST.Model;

interface

uses
  REST.Client,
  REST.Authenticator.Basic,
  REST.Types,
  System.Json,
  IpPeerClient,
  System.Generics.Collections,
  UnitClientREST.Model.Interfaces,
  UnitObserver.Model.Interfaces, System.Classes;

type
  TClientREST = class(TInterfacedObject, iClientREST, iSujeito)
  private
    FRestClient       : TRESTClient;
    FRestRequest      : TRESTRequest;
    FRestResponse     : TRESTResponse;
    FListaObservers   : TList<iObservador>;
    FListaHeaders     : TDictionary<string, string>;
    FBasicAtentication: THTTPBasicAuthenticator;
  public
    constructor Create(URL: string);
    destructor Destroy; override;
    class function New(URL: string): iClientREST;
    function Put(Value: string = ''): TClientResult;
    function Get(Value: string = ''): TClientResult;
    function Post(Value: string = ''): TClientResult; overload;
		function Post(Value: string; Body: TJSONObject): TClientResult; overload;
		function Post(Value: string; Body: TJSONArray): TClientResult;overload;
		function Post(Value: string; Body: string): TClientResult; overload;
		function Delete(Value: string = ''): TClientResult;
		function AddObservador(Value: iObservador): iSujeito;
		function RemoveObservador(Value: iObservador): iSujeito;
		function Notificar(Value: TNotificacao): iSujeito;
		function InscreverObservador(Value: iObservador): iClientREST;
		function AddHeader(Par, Valor: string): iClientREST;
		function AddBody(Value: string): iClientREST; overload;
		function AddBody(Value: TJSONObject): iClientREST; overload;
		function AddBody(Value: TJSONArray): iClientREST; overload;
		function AddBody(Value: TStream): iClientREST; overload;
    function AddUserPassword(User: string; Pass: string): iClientREST;
  end;

implementation

uses
  System.SysUtils;

{ TClienteREST }

function TClientREST.AddObservador(Value: iObservador): iSujeito;
begin
  Result := Self;
  FListaObservers.Add(Value);
end;

function TClientREST.AddUserPassword(User, Pass: string): iClientREST;
begin
  Result                    := Self;
  FBasicAtentication        := THTTPBasicAuthenticator.Create(User, Pass);
  FRestClient.Authenticator := FBasicAtentication;
end;

function TClientREST.AddBody(Value: string): iClientREST;
begin
  Result := Self;
  FRestRequest.ClearBody;
  FRestRequest.AddBody(Value);
end;

function TClientREST.AddBody(Value: TJSONObject): iClientREST;
begin
	Result := Self;
	FRestRequest.ClearBody;
	FRestRequest.AddBody(Value);
end;

function TClientREST.AddBody(Value: TStream): iClientREST;
begin
	Result := Self;
	FRestRequest.ClearBody;
	FRestRequest.AddBody(Value, ctAPPLICATION_OCTET_STREAM);
end;

function TClientREST.AddBody(Value: TJSONArray): iClientREST;
begin
	Result := Self;
	FRestRequest.ClearBody;
	FRestRequest.AddBody<TJSONArray>(Value);
end;

function TClientREST.AddHeader(Par, Valor: string): iClientREST;
begin
  Result := Self;
  if not Assigned(FListaHeaders) then
    FListaHeaders := TDictionary<string, string>.Create;
  FListaHeaders.Add(Par, Valor);
end;

constructor TClientREST.Create(URL: string);
begin
  FListaObservers       := TList<iObservador>.Create;
  FListaHeaders         := TDictionary<string, string>.Create;
  FRestClient           := TRESTClient.Create(URL);
  FRestRequest          := TRESTRequest.Create(nil);
  FRestResponse         := TRESTResponse.Create(nil);
  FRestRequest.Client   := FRestClient;
  FRestRequest.Response := FRestResponse;
end;

function TClientREST.Delete(Value: string = ''): TClientResult;
var
  Jo: TJSONObject;
begin
  try
    FRestRequest.Method := rmDELETE;
    FRestRequest.Execute;
    Result.Content    := FRestResponse.Content;
    Result.StatusCode := FRestResponse.StatusCode;
  except
    on E: Exception do
    begin
      Result.Content := FRestResponse.Content;
      Result.Error   := E.Message;
      Result.StatusCode := FRestResponse.StatusCode;
    end;
  end;
end;

destructor TClientREST.Destroy;
begin
  FreeAndNil(FRestClient);
  FreeAndNil(FRestRequest);
  FreeAndNil(FRestResponse);
  FreeAndNil(FListaObservers);
  if Assigned(FListaHeaders) then
    FreeAndNil(FListaHeaders);
  if Assigned(FBasicAtentication) then
    FBasicAtentication.DisposeOf;
  inherited;
end;

function TClientREST.Get(Value: string = ''): TClientResult;
var
  chave: string;
  Valor: string;
begin
  try
    if Value <> '' then
      FRestClient.BaseURL := Value;
    FRestRequest.Method   := rmGET;
    for chave in FListaHeaders.Keys do
    begin
      FListaHeaders.TryGetValue(chave, Valor);
      FRestRequest.Params.AddHeader(chave, Valor);
      FRestRequest.Params.ParameterByName(chave).Options := [poDoNotEncode];
    end;
    FRestRequest.Execute;
    Result.Content    := FRestResponse.Content;
    Result.StatusCode := FRestResponse.StatusCode;
  except
    on E: Exception do
    begin
      Result.Content    := FRestResponse.Content;
      Result.Error      := E.Message;
      Result.StatusCode := FRestResponse.StatusCode;
    end;
  end;
end;

function TClientREST.InscreverObservador(Value: iObservador): iClientREST;
begin
  Result := Self;
  AddObservador(Value);
end;

class function TClientREST.New(URL: string): iClientREST;
begin
  Result := Self.Create(URL);
end;

function TClientREST.Notificar(Value: TNotificacao): iSujeito;
var
  i: Integer;
begin
  for i := 0 to Pred(FListaObservers.Count) do
    FListaObservers[i].Atualizar(Value);
end;

function TClientREST.Post(Value: string = ''): TClientResult;
var
  Jo   : TJSONObject;
  chave: string;
  Valor: string;
begin
  try
    if Value <> '' then
      FRestClient.BaseURL := Value;
    FRestRequest.Method   := rmPOST;
    for chave in FListaHeaders.Keys do
    begin
      FListaHeaders.TryGetValue(chave, Valor);
      FRestRequest.Params.AddHeader(chave, Valor);
      FRestRequest.Params.ParameterByName(chave).Options := [poDoNotEncode];
    end;
    FRestRequest.Execute;
    FListaHeaders.Clear;
    Result.Content    := FRestResponse.Content;
    Result.StatusCode := FRestResponse.StatusCode;
  except
    on E: Exception do
    begin
      Result.Content := FRestResponse.Content;
      Result.Error   := E.Message;
      Result.StatusCode := FRestResponse.StatusCode;
    end;
  end;
end;

function TClientREST.Post(Value: string; Body: TJSONObject): TClientResult;
var
  Jo   : TJSONObject;
  chave: string;
  Valor: string;
begin
  try
    if Assigned(Body) then
      AddBody(Body);
    if Value <> '' then
      FRestClient.BaseURL := Value;
    FRestRequest.Method   := rmPOST;
    for chave in FListaHeaders.Keys do
    begin
      FListaHeaders.TryGetValue(chave, Valor);
      FRestRequest.Params.AddHeader(chave, Valor);
      FRestRequest.Params.ParameterByName(chave).Options := [poDoNotEncode];
    end;
    FRestRequest.Execute;
    FListaHeaders.Clear;
    Result.Content    := FRestResponse.Content;
    Result.StatusCode := FRestResponse.StatusCode;
  except
    on E: Exception do
    begin
      Result.Content := FRestResponse.Content;
      Result.Error   := E.Message;
      Result.StatusCode := FRestResponse.StatusCode;
    end;
	end;
end;

function TClientREST.RemoveObservador(Value: iObservador): iSujeito;
begin
  Result := Self;
  FListaObservers.Remove(Value);
end;

function TClientREST.Post(Value, Body: string): TClientResult;
var
  Jo   : TJSONObject;
  chave: string;
  Valor: string;
begin
  try
    if Body <> '' then
      AddBody(Body);
    if Value <> '' then
      FRestClient.BaseURL := Value;
    FRestRequest.Method   := rmPOST;
    for chave in FListaHeaders.Keys do
    begin
      FListaHeaders.TryGetValue(chave, Valor);
      FRestRequest.Params.AddHeader(chave, Valor);
      FRestRequest.Params.ParameterByName(chave).Options := [poDoNotEncode];
    end;
    FRestRequest.Execute;
    FListaHeaders.Clear;
    Result.Content    := FRestResponse.Content;
    Result.StatusCode := FRestResponse.StatusCode;
  except
    on E: Exception do
    begin
      Result.Content := FRestResponse.Content;
      Result.Error   := E.Message;
      Result.StatusCode := FRestResponse.StatusCode;
    end;
  end;
end;

function TClientREST.Post(Value: string; Body: TJSONArray): TClientResult;
var
  Jo   : TJSONObject;
  chave: string;
  Valor: string;
begin
  try
    if Assigned(Body) then
      AddBody(Body);
    if Value <> '' then
      FRestClient.BaseURL := Value;
    FRestRequest.Method   := rmPOST;
    for chave in FListaHeaders.Keys do
    begin
      FListaHeaders.TryGetValue(chave, Valor);
      FRestRequest.Params.AddHeader(chave, Valor);
      FRestRequest.Params.ParameterByName(chave).Options := [poDoNotEncode];
    end;
    FRestRequest.Execute;
    FListaHeaders.Clear;
    Result.Content    := FRestResponse.Content;
    Result.StatusCode := FRestResponse.StatusCode;
  except
    on E: Exception do
    begin
      Result.Content := FRestResponse.Content;
      Result.Error   := E.Message;
      Result.StatusCode := FRestResponse.StatusCode;
    end;
	end;
end;

function TClientREST.Put(Value: string = ''): TClientResult;
var
  chave: string;
  Valor: string;
begin
  try
    if Value <> '' then
      FRestClient.BaseURL := Value;
    FRestRequest.Method   := rmPUT;
    for chave in FListaHeaders.Keys do
    begin
      FListaHeaders.TryGetValue(chave, Valor);
      FRestRequest.Params.AddHeader(chave, Valor);
      FRestRequest.Params.ParameterByName(chave).Options := [poDoNotEncode];
    end;
    FRestRequest.Execute;
    FListaHeaders.Clear;
    Result.Content    := FRestResponse.Content;
    Result.StatusCode := FRestResponse.StatusCode;
  except
    on E: Exception do
    begin
      Result.Content    := FRestResponse.Content;
      Result.Error      := E.Message;
      Result.StatusCode := FRestResponse.StatusCode;
    end;
  end;
end;

end.
