program ClusterTruckTakeHome;

uses
  Vcl.Forms,
  clsMainServerForm in 'clsMainServerForm.pas' {ServerForm},
  clsConst in 'clsConst.pas',
  clsMessageStrings in 'clsMessageStrings.pas',
  clsItemData in 'clsItemData.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TServerForm, ServerForm);
  Application.Run;
end.
