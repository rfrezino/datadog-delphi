unit delphiDatadog.statsDClientSender.impl;

interface

uses
	delphiDatadog.statsDClientSender.interf, System.SyncObjs, System.Classes, delphiDatadog.serviceCheck,
  IdUDPClient;

type
  TDataDogStatsClientSender = class(TInterfacedObject, IDataDogStatsClientSender)
  private type

    TDatadogThreadSender = class(TThread)
    private
      FUDPCom: TIdUDPClient;
      FRcMessages: TCriticalSection;
      FMessages: TStringList;
      FService: TDataDogServiceCheck;
    protected
      procedure Execute; override;

      procedure SendMessages;
      procedure ConfigureUDP;
      function GetMessagesToSend: TStringList;
    public
      constructor Create(Service: TDataDogServiceCheck);
      destructor Destroy; override;

      procedure Send(Content: string);
    end;

  private
    FSender: TDatadogThreadSender;
  public
    constructor Create(Service: TDataDogServiceCheck);
    destructor Destroy; override;

    procedure Send(Content: string);
  end;

implementation

{ TDataDogStatsClientSender }

constructor TDataDogStatsClientSender.Create(Service: TDataDogServiceCheck);
begin
  inherited Create;
  FSender := TDatadogThreadSender.Create(Service);
  FSender.Start;
end;

destructor TDataDogStatsClientSender.Destroy;
begin
  FSender.Terminate;
  inherited;
end;

procedure TDataDogStatsClientSender.Send(Content: string);
begin
  FSender.Send(Content);
end;

{ TDataDogStatsClientSender.TDatadogThreadSender }

procedure TDataDogStatsClientSender.TDatadogThreadSender.ConfigureUDP;
begin
  FUDPCom.Port := FService.Port;
  FUDPCom.Host := FService.Hostname;
end;

constructor TDataDogStatsClientSender.TDatadogThreadSender.Create(Service: TDataDogServiceCheck);
begin
  inherited Create(True);
  FreeOnTerminate := True;

  FRcMessages := TCriticalSection.Create;
  FService := Service;
  FMessages := TStringList.Create;
  FUDPCom := TIdUDPClient.Create(nil);
end;

destructor TDataDogStatsClientSender.TDatadogThreadSender.Destroy;
begin
  FUDPCom.Free;
  FMessages.Free;
  FRcMessages.Free;
  inherited;
end;

procedure TDataDogStatsClientSender.TDatadogThreadSender.Execute;
begin
  while not Terminated do
  begin
    if FMessages.Count > 0 then
      SendMessages;
    Sleep(500);
  end;
end;

function TDataDogStatsClientSender.TDatadogThreadSender.GetMessagesToSend: TStringList;
begin
  FRcMessages.Acquire;
  try
    Result := FMessages;
    FMessages := TStringList.Create;
  finally
    FRcMessages.Release;
  end;
end;

procedure TDataDogStatsClientSender.TDatadogThreadSender.Send(Content: string);
begin
  FRcMessages.Acquire;
  try
    FMessages.Add(Content);
  finally
    FRcMessages.Release;
  end;
end;

procedure TDataDogStatsClientSender.TDatadogThreadSender.SendMessages;
var
  MessagensToSend: TStringList;
  MessageTxt: string;
begin
  ConfigureUDP;
  MessagensToSend := GetMessagesToSend;
  try
    for MessageTxt in MessagensToSend do
      FUDPCom.Send(MessageTxt);
  finally
    MessagensToSend.Free;
  end;
end;

end.
