unit delphiDatadog.serviceCheck;

interface

uses
	delphiDatadog.header;

type
  TDataDogServiceCheck = class(TObject)
  private
    FName: string;
    FHostname: string;
    FStatus: TDataDogServiceStatus;
    FRunId: Integer;
    FTimeStamp: Cardinal;
    FTags: TDataDogTags;
    FMessageText: string;
    FPort: Integer;
    procedure SetHostname(const Value: string);
    procedure SetPort(const Value: Integer);
  public
    constructor Create;

    function ToStatsDString: string;

    property Name: string read FName write FName;
    property Hostname: string read FHostname write SetHostname;
    property Port: Integer read FPort write SetPort;
    property Status: TDataDogServiceStatus read FStatus write FStatus;
    property MessageText: string read FMessageText write FMessageText;
    property RunId: Integer read FRunId write FRunId;
    property TimeStamp: Cardinal read FTimeStamp write FTimeStamp;
    property Tags: TDataDogTags read FTags write FTags;
  end;

implementation

uses
	System.SysUtils, delphiDatadog.utils;

const
  STAND_PORT = 8125;
  STAND_HOST = 'localhost';

{ TDataDogServiceCheck }

constructor TDataDogServiceCheck.Create;
begin
  FHostname := STAND_HOST;
  FStatus := dssUndefined;
  FPort := STAND_PORT;
end;

procedure TDataDogServiceCheck.SetHostname(const Value: string);
begin
  if Value.IsEmpty then
    FHostname := STAND_HOST
  else
    FHostname := Value;
end;

procedure TDataDogServiceCheck.SetPort(const Value: Integer);
begin
  if Value = 0 then
    FPort :=  STAND_PORT
  else
    FPort := Value;
end;

function TDataDogServiceCheck.ToStatsDString: string;
var
  StatsString: TStringBuilder;
begin
  StatsString := TStringBuilder.Create;

  StatsString.Append(Format('_sc|%s|%d', [Name, Ord(Status)]));
  if (Timestamp > 0) then
      StatsString.Append(Format('|d:%d', [Timestamp]));

  if not (HostName.IsEmpty) then
      StatsString.Append(Format('|h:%s', [Hostname]));

  StatsString.Append(DataTagsToText(Tags));
  if (not MessageText.IsEmpty) then
      StatsString.Append(Format('|m:%s', [EscapedMessage(MessageText)]));

  Result := StatsString.ToString;
  StatsString.Free;
end;

end.
