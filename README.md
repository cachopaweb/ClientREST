# Client REST
Class for utilities REST Client

### For install in your project using [boss](https://github.com/HashLoad/boss):
``` sh
$ boss install github.com/CachopaWeb/client-rest
```

Sample 
```delphi

uses 
  System.SysUtils,
  UnitClientREST.Model.Interfaces,
  UnitClientREST.Model;

var
  LResult: TClientResult;
begin
  LResult := TClientREST.New('http://sua-api.com.br').Get();
  if LResult.StatusCode = 200 then
  begin
    showMessage(LResult.Content);
  end;
end.
```