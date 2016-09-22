unit delphiDatadog.event;

interface

uses
	delphiDatadog.header;

type
  TDataDogEvent = class(TObject)
  private
    FTitle: string;
    FText: string;
    FMillisSinceEpoch: Int64;
    FHostName: string;
    FAggregationKey: string;
    FPriority: TDataDogEventPriority;
    FSourcerTypeName: string;
    FAlertType: TDataDogEventAlertType;
  public
    function ToMap: string;

    property Title: string read FTitle write FTitle;
    property Text: string read FText write FText;
    property MillisSinceEpoch: Int64 read FMillisSinceEpoch write FMillisSinceEpoch;
    property HostName: string read FHostName write FHostName;
    property AggregationKey: string read FAggregationKey write FAggregationKey;
    property Priority: TDataDogEventPriority read FPriority write FPriority;
    property SourcerTypeName: string read FSourcerTypeName write FSourcerTypeName;
    property AlertType: TDataDogEventAlertType read FAlertType write FAlertType;
  end;

implementation

uses
	System.SysUtils, delphiDatadog.utils;

{ TDataDogEvent }

function TDataDogEvent.ToMap: string;
var
  MapParams: TStringBuilder;
  DoubleResult: Double;
  PriorityText: string;
  AlertText: string;
begin
  MapParams := TStringBuilder.Create;
  try
    if (MillisSinceEpoch <> 0) then
    begin
      DoubleResult := MillisSinceEpoch / 1000;
      MapParams.Append('|d:').Append(DoubleResult);
    end;

    if not HostName.IsEmpty then
      MapParams.Append('|h:').Append(HostName);

    if not AggregationKey.IsEmpty then
      MapParams.Append('|k:').Append(AggregationKey);

    PriorityText := DataTagsEventPriorityToText(Priority);
    if not PriorityText.IsEmpty then
      MapParams.Append('|p:').Append(PriorityText);

    AlertText := DataTagsEventAlertToText(AlertType);
    if not AlertText.IsEmpty then
      MapParams.Append('|t:').Append(AlertText);

    Result := MapParams.ToString;
  finally
    MapParams.Free;
  end;
end;

end.
