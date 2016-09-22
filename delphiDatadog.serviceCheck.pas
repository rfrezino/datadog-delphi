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
  public
    constructor Create;

    function ToStatsDString: string;

    property Name: string read FName write FName;
    property Hostname: string read FHostname write FHostname;
    property Port: Integer read FPort write FPort;
    property Status: TDataDogServiceStatus read FStatus write FStatus;
    property MessageText: string read FMessageText write FMessageText;
    property RunId: Integer read FRunId write FRunId;
    property TimeStamp: Cardinal read FTimeStamp write FTimeStamp;
    property Tags: TDataDogTags read FTags write FTags;
  end;

implementation

uses
	System.SysUtils, delphiDatadog.utils;

{ TDataDogServiceCheck }

constructor TDataDogServiceCheck.Create;
begin
  FHostname := 'localhost';
  FStatus := dssUndefined;
  FPort := 8125;
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
