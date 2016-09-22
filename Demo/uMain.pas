unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, delphiDatadog.statsDClient.interf;

type
  TfrmDemo = class(TForm)
    btnSendMetrics: TButton;
    procedure btnSendMetricsClick(Sender: TObject);
  private
    StatsDClient: IDataDogStatsClient;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDemo: TfrmDemo;

implementation

uses
	delphiDatadog.statsDClient.impl, delphiDatadog.statsDClientSender.impl, delphiDatadog.serviceCheck,
  delphiDatadog.statsDClientSender.interf, delphiDatadog.header, delphiDatadog.event;

{$R *.dfm}

procedure TfrmDemo.btnSendMetricsClick(Sender: TObject);
var
  SenderStatsDClient: IDataDogStatsClientSender;
  DataDogService: TDataDogServiceCheck;
  Event: TDataDogEvent;
begin
  if StatsDClient = nil then
  begin
    DataDogService := TDataDogServiceCheck.Create;
    SenderStatsDClient := TDataDogStatsClientSender.Create(DataDogService);
    StatsDClient := TDataDogStatsClientImpl.Create(SenderStatsDClient);
  end;

  StatsDClient.Count('time', 1, TDataDogTags.Create('rodrigo', 'farias'));
  StatsDClient.RecordExecutionTime('testBM', Random(500), TDataDogTags.Create('benchmarkRodrigo'));

  Event := TDataDogEvent.Create;
  Event.Title := 'Error on report';
  Event.Text := 'Error while trying to translate the rCprReportIntake';
  Event.Priority := ddLow;
  Event.AlertType := ddError;
  StatsDClient.RecordEvent(Event, TDataDogTags.Create('eventTest'));
  Event.Free;

end;

end.
