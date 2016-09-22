program Demo;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmDemo},
  delphiDatadog.event in '..\delphiDatadog.event.pas',
  delphiDatadog.header in '..\delphiDatadog.header.pas',
  delphiDatadog.serviceCheck in '..\delphiDatadog.serviceCheck.pas',
  delphiDatadog.statsDClient.impl in '..\delphiDatadog.statsDClient.impl.pas',
  delphiDatadog.statsDClient.interf in '..\delphiDatadog.statsDClient.interf.pas',
  delphiDatadog.statsDClientSender.impl in '..\delphiDatadog.statsDClientSender.impl.pas',
  delphiDatadog.statsDClientSender.interf in '..\delphiDatadog.statsDClientSender.interf.pas',
  delphiDatadog.utils in '..\delphiDatadog.utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmDemo, frmDemo);
  Application.Run;
end.
