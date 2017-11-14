unit clsItemData;

interface
uses
  Windows, messages, classes, SysUtils, SyncObjs;
 type
   TItemData = class(Tobject)
     FupcID : string; // since there is leading zeros
     Fprice : double;
     FDescription : string;
     public
       constructor Create(upcID: string; Price : double; Desription :string);
       destructor Destroy(); override;
   end;
implementation
constructor TItemData.Create(upcID: string; Price : double; Desription :string);
begin
  FupcID := upcID ;
  Fprice := Price;
  FDescription := Desription;
end;
destructor TItemData.Destroy;
begin
  inherited;
end;
end.
