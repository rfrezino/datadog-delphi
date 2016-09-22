unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, delphiDatadog.statsDClient.interf;

type
  TfrmDemo = class(TForm)
    btnSendMetrics: TButton;
    procedure btnSendMetricsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
  Event: TDataDogEvent;
begin
  StatsDClient.Count('qtt', 1, TDataDogTags.Create('mob', 'foo'));
  StatsDClient.RecordExecutionTime('testBM', Random(500), TDataDogTags.Create('valueX'));

  Event := TDataDogEvent.Create;
  Event.Title := 'Error on report';
  Event.Text := 'Error while trying to translate the report';
  Event.Priority := ddLow;
  Event.AlertType := ddError;
  StatsDClient.RecordEvent(Event, TDataDogTags.Create('eventTest'));
  Event.Free;
end;

procedure TfrmDemo.FormCreate(Sender: TObject);
var
  SenderStatsDClient: IDataDogStatsClientSender;
  DataDogService: TDataDogServiceCheck;
begin
  DataDogService := TDataDogServiceCheck.Create;
  SenderStatsDClient := TDataDogStatsClientSender.Create(DataDogService);
  StatsDClient := TDataDogStatsClientImpl.Create(SenderStatsDClient);
end;

end.
