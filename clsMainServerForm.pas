unit clsMainServerForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdContext, IdCustomHTTPServer,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdHTTPServer,
  clsConst,clsMessageStrings,clsItemData,
  Vcl.StdCtrls,System.Generics.Collections;

type
  TServerForm = class(TForm)
    HTTPSocketServer: TIdHTTPServer;
    Label1: TLabel;
    HttpPort: TEdit;
    startServer: TButton;
    Memo1: TMemo;
    procedure HTTPSocketServerCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure startServerClick(Sender: TObject);
    procedure HttpPortChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FBalloonHint : TBalloonHint;
    FCurrentItemsINList : TObjectList<TItemData>;
    procedure WMActivateApp(var AMessage: TMessage); message WM_ActivateApp;
    procedure WMWindowPosChanged(var AMessage: TMessage);  message WM_WindowPosChanged;
    function ValidatePortNumber(AStr : string; var Value : integer) : boolean;
    function ValidateAPIKEYandUPC(apiKey : string; upc : string) : string;
  public
    { Public declarations }
  end;

var
  ServerForm: TServerForm;

implementation

{$R *.dfm}
function TServerForm.ValidatePortNumber(AStr : string; var Value : integer) : boolean;
begin
  //Function will make sure the user only enters a valid port number
  result := TryStrToInt(AStr, Value) and (Value >= MINPORT) and (Value <= MAXPORT);
end;
function TServerForm.ValidateAPIKEYandUPC(apiKey : string; upc : string ): string;
var
  tempItemData : TItemData;
  i : integer;
begin
  result := InvalidUPC;
  if (apiKey = VALID_API_KEY ) then
  begin
    // would really look these up in a Database
    // Select Price, Description From UPCCodes where upc = :upc
    //Check to see if we return a record
    for i := 0 to FCurrentItemsINList.Count - 1 do
    begin
      if (FCurrentItemsINList.Items[i].FupcID = upc ) then
      begin
         result := format(ReturnMessage,[FloatToStr(FCurrentItemsINList.Items[i].Fprice),FCurrentItemsINList.Items[i].FDescription ]);
         break; //leave for
      end;

    end;
  end
  else
    result := InvalidApiKey;
  Memo1.Lines.Add(result);
end;
procedure TServerForm.startServerClick(Sender: TObject);
//Starts or stops the HTTP server
begin
  if HTTPSocketServer.Active then // we must want to stop it
  begin
    startServer.Caption := StartListening;
    HTTPSocketServer.Active := false;
  end
  else
  begin
    HTTPSocketServer.DefaultPort := StrToInt(HttpPort.Text);
    try
      HTTPSocketServer.Active := true;
      startServer.Caption := StopListening;
    except
      on E: Exception do
        Memo1.Lines.Add(Format(ErrMsg,[e.Message]));
  end;
  end;
end;

procedure TServerForm.FormCreate(Sender: TObject);
var
  tempdata : TItemData;
begin
  FBalloonHint := TBalloonHint.Create(Self);
  FBalloonHint.HideAfter := 2000;
  FBalloonHint.Delay := 0;
  FCurrentItemsINList := TObjectList<TItemData>.create;
  { Set the OwnsObjects to true - the List will free them automatically }
  FCurrentItemsINList.OwnsObjects := true;
  //load data
  tempdata := TItemData.Create('012044038840',2.54,'Spice High Endurance Fresh Scent Men' + #39 + 's Deodorant, 3 oz.');
  FCurrentItemsINList.Add(tempdata);
  tempdata := TItemData.Create('811571013579',35,'Google Chromecast HDMI Streaming Media Player (2014 Model).');
  FCurrentItemsINList.Add(tempdata);
  tempdata := TItemData.Create('012044038840',29.96,'Back To The Future: 30th Anniversary… (truncated)');
  FCurrentItemsINList.Add(tempdata);

end;

procedure TServerForm.FormDestroy(Sender: TObject);
begin
  FBalloonHint.Free;
  FCurrentItemsINList.Free;
end;

procedure TServerForm.HttpPortChange(Sender: TObject);
var
  Value : integer;
  R: TRect;
begin

 if Not ValidatePortNumber(HttpPort.Text,Value) then
 begin
   //will show a ballon message if the port is less than 1 or greater that 65535
   FBalloonHint.Description := Format( ValidPortMessge, [IntToStr(MINPORT),IntToStr(MAXPORT)]);
   R := HttpPort.BoundsRect;
   R.TopLeft := ClientToScreen(R.TopLeft);
   R.BottomRight := ClientToScreen(R.BottomRight);
   FBalloonHint.ShowHint(R);
 end;
end;

procedure TServerForm.HTTPSocketServerCommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);

var
  i : integer;
  apiKey : string;
  upc : string;
begin
  if UpperCase(ARequestInfo.Command) =  VALID_COMMAND then
  begin
    //So far so good
    //lets valid the params that got passed in we need a apiKey and a UPC
    if ARequestInfo.Params.Count >= 2 then
    begin
      if (ARequestInfo.Params.IndexOfName(VALID_API_KEY_STR) > -1 ) and
         (ARequestInfo.Params.IndexOfName(VALID_UPC_STR) > -1 ) then
      begin
        apiKey := ARequestInfo.Params.ValueFromIndex[ARequestInfo.Params.IndexOfName(VALID_API_KEY_STR)];
        upc := ARequestInfo.Params.ValueFromIndex[ARequestInfo.Params.IndexOfName(VALID_UPC_STR)];
        //lets vaild the apiKey insure

        AResponseInfo.ContentText := ValidateAPIKEYandUPC(apiKey,upc);
      end
      else
        AResponseInfo.ContentText := WrongParamsName ;
    end
    else
      AResponseInfo.ContentText := WrongParamsCount ;
  end
  else
    AResponseInfo.ContentText := format(InvalidCommandType,[ARequestInfo.Command]);

end;

procedure TServerForm.WMActivateApp(var AMessage: TMessage);
begin
  if Assigned(FBalloonHint) then FBalloonHint.HideHint;
  inherited;
end;

procedure TServerForm.WMWindowPosChanged(var AMessage: TMessage);
begin
  if Assigned(FBalloonHint) then FBalloonHint.HideHint;
  inherited;
end;
end.
