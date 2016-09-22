unit delphiDatadog.statsDClient.impl;

interface

uses
	delphiDatadog.statsDClient.interf, delphiDatadog.header, delphiDatadog.serviceCheck,
  delphiDatadog.event, delphiDatadog.statsDClientSender.interf;

type
  TDataDogStatsClientImpl = class(TInterfacedObject, IDataDogStatsClient)
  private
    FPrefix: string;
    FSender: IDataDogStatsClientSender;

    procedure Send(Content: string);
    function IsInvalidSample(Sample: Double): Boolean;
  public
    constructor Create(var Sender: IDataDogStatsClientSender);
    destructor Destroy; override;

    procedure Count(Aspect: TDataDogAspect; Delta: Int64; Tags: TDataDogTags); overload;
    procedure Count(Aspect: TDataDogAspect; Delta: Int64; SampleRate: Double; Tags: TDataDogTags); overload;
    procedure IncrementCounter(Aspect: TDataDogAspect; Tags: TDataDogTags); overload;
    procedure IncrementCounter(Aspect: TDataDogAspect; SampleRate: Double; Tags: TDataDogTags); overload;
    procedure Increment(Aspect: TDataDogAspect; Tags: TDataDogTags); overload;
    procedure Increment(Aspect: TDataDogAspect; SampleRate: Double; Tags: TDataDogTags); overload;
    procedure DecrementCounter(Aspect: TDataDogAspect; Tags: TDataDogTags); overload;
    procedure DecrementCounter(Aspect: TDataDogAspect; SampleRate: Double; Tags: TDataDogTags); overload;
    procedure Decrement(Aspect: TDataDogAspect; Tags: TDataDogTags); overload;
    procedure Decrement(Aspect: TDataDogAspect; SampleRate: Double; Tags: TDataDogTags); overload;
    procedure RecordGaugeValue(Aspect: TDataDogAspect; Value: Double; Tags: TDataDogTags); overload;
    procedure RecordGaugeValue(Aspect: TDataDogAspect; Value: Double; SampleRate: Double; Tags: TDataDogTags); overload;
    procedure Gauge(Aspect: TDataDogAspect; Value: Double; Tags: TDataDogTags); overload;
    procedure Gauge(Aspect: TDataDogAspect; Value: Double; SampleRate: Double; Tags: TDataDogTags); overload;
    procedure RecordGaugeValue(Aspect: TDataDogAspect; Value: Int64; Tags: TDataDogTags); overload;
    procedure RecordGaugeValue(Aspect: TDataDogAspect; Value: Int64; SampleRate: Double; Tags: TDataDogTags); overload;
    procedure Gauge(Aspect: TDataDogAspect; Value: Int64; Tags: TDataDogTags); overload;
    procedure Gauge(Aspect: TDataDogAspect; Value: Int64; SampleRate: Double; Tags: TDataDogTags); overload;
    procedure RecordExecutionTime(Aspect: TDataDogAspect; TimeInMs: Int64; Tags: TDataDogTags); overload;
    procedure RecordExecutionTime(Aspect: TDataDogAspect; TimeInMs: Int64; SampleRate: Double; Tags: TDataDogTags); overload;
    procedure Time(Aspect: TDataDogAspect; Value: Int64; Tags: TDataDogTags); overload;
    procedure Time(Aspect: TDataDogAspect; Value: Int64; SampleRate: Double; Tags: TDataDogTags); overload;
    procedure RecordHistogramValue(Aspect: TDataDogAspect; Value: Double; Tags: TDataDogTags); overload;
    procedure RecordHistogramValue(Aspect: TDataDogAspect; Value: Double; SampleRate: Double; Tags: TDataDogTags); overload;
    procedure Histogram(Aspect: TDataDogAspect; Value: Double; Tags: TDataDogTags); overload;
    procedure Histogram(Aspect: TDataDogAspect; Value: Double; SampleRate: Double; Tags: TDataDogTags); overload;
    procedure RecordHistogramValue(Aspect: TDataDogAspect; Value: Int64; Tags: TDataDogTags); overload;
    procedure RecordHistogramValue(Aspect: TDataDogAspect; Value: Int64; SampleRate: Double; Tags: TDataDogTags); overload;
    procedure Histogram(Aspect: TDataDogAspect; Value: Int64; Tags: TDataDogTags); overload;
    procedure Histogram(Aspect: TDataDogAspect; Value: Int64; SampleRate: Double; Tags: TDataDogTags); overload;
    procedure RecordEvent(Event: TDataDogEvent; Tags: TDataDogTags); overload;
    procedure RecordSetValue(Aspect: TDataDogAspect; Value: string; Tags: TDataDogTags); overload;

    property Prefix: string read FPrefix write FPrefix;
  end;

implementation

uses
	System.SysUtils, delphiDatadog.utils;

var
  DatadogFormatSettings: TFormatSettings;

{ TDataDogStatsClientImpl }

procedure TDataDogStatsClientImpl.Count(Aspect: TDataDogAspect; Delta: Int64; Tags: TDataDogTags);
begin
   Send(Format('%s%s:%d|c%s', [Prefix, Aspect, Delta, DataTagsToText(Tags)]));
end;

procedure TDataDogStatsClientImpl.Count(Aspect: TDataDogAspect; Delta: Int64; SampleRate: Double; Tags: TDataDogTags);
begin
	if not (IsInvalidSample(SampleRate)) then Exit;

  Send(Format('%s%s:%d|c|%f%s', [Prefix, Aspect, Delta, sampleRate, DataTagsToText(Tags)]));
end;

constructor TDataDogStatsClientImpl.Create(var Sender: IDataDogStatsClientSender);
begin
  FSender := Sender;
end;

procedure TDataDogStatsClientImpl.Decrement(Aspect: TDataDogAspect; Tags: TDataDogTags);
begin
  DecrementCounter(Aspect, Tags);
end;

procedure TDataDogStatsClientImpl.Decrement(Aspect: TDataDogAspect; SampleRate: Double; Tags: TDataDogTags);
begin
  DecrementCounter(Aspect, SampleRate, Tags);
end;

procedure TDataDogStatsClientImpl.DecrementCounter(Aspect: TDataDogAspect; Tags: TDataDogTags);
begin
  Count(Aspect, -1, Tags);
end;

procedure TDataDogStatsClientImpl.DecrementCounter(Aspect: TDataDogAspect; SampleRate: Double; Tags: TDataDogTags);
begin
  Count(Aspect, -1, SampleRate, Tags);
end;

destructor TDataDogStatsClientImpl.Destroy;
begin

  inherited;
end;

procedure TDataDogStatsClientImpl.Gauge(Aspect: TDataDogAspect; Value: Int64; Tags: TDataDogTags);
begin
  Send(Format('%s%s:%d|g%s', [Prefix, Aspect, Value, DataTagsToText(Tags)]));
end;

procedure TDataDogStatsClientImpl.Gauge(Aspect: TDataDogAspect; Value, SampleRate: Double; Tags: TDataDogTags);
begin
  RecordGaugeValue(Aspect, Value, SampleRate, Tags);
end;

procedure TDataDogStatsClientImpl.Gauge(Aspect: TDataDogAspect; Value: Double; Tags: TDataDogTags);
begin
  RecordGaugeValue(Aspect, Value, Tags);
end;

procedure TDataDogStatsClientImpl.Gauge(Aspect: TDataDogAspect; Value: Int64; SampleRate: Double; Tags: TDataDogTags);
begin
  RecordGaugeValue(Aspect, Value, SampleRate, Tags);
end;

procedure TDataDogStatsClientImpl.Histogram(Aspect: TDataDogAspect; Value, SampleRate: Double; Tags: TDataDogTags);
begin
  RecordHistogramValue(Aspect, Value, SampleRate, Tags);
end;

procedure TDataDogStatsClientImpl.Histogram(Aspect: TDataDogAspect; Value: Double; Tags: TDataDogTags);
begin
  RecordHistogramValue(Aspect, Value, Tags);
end;

procedure TDataDogStatsClientImpl.Histogram(Aspect: TDataDogAspect; Value: Int64; Tags: TDataDogTags);
begin
  RecordHistogramValue(Aspect, Value, Tags);
end;

procedure TDataDogStatsClientImpl.Histogram(Aspect: TDataDogAspect; Value: Int64; SampleRate: Double; Tags: TDataDogTags);
begin
  RecordHistogramValue(Aspect, Value, SampleRate, Tags);
end;

procedure TDataDogStatsClientImpl.Increment(Aspect: TDataDogAspect; SampleRate: Double; Tags: TDataDogTags);
begin
  IncrementCounter(Aspect, SampleRate, Tags);
end;

procedure TDataDogStatsClientImpl.Increment(Aspect: TDataDogAspect; Tags: TDataDogTags);
begin
  IncrementCounter(Aspect, Tags);
end;

procedure TDataDogStatsClientImpl.IncrementCounter(Aspect: TDataDogAspect; Tags: TDataDogTags);
begin
  Count(Aspect, 1, Tags);
end;

procedure TDataDogStatsClientImpl.IncrementCounter(Aspect: TDataDogAspect; SampleRate: Double; Tags: TDataDogTags);
begin
  Count(Aspect, 1, SampleRate, Tags);
end;

function TDataDogStatsClientImpl.IsInvalidSample(Sample: Double): Boolean;
begin
  Result := True;
end;

procedure TDataDogStatsClientImpl.RecordEvent(Event: TDataDogEvent; Tags: TDataDogTags);
var
  Title: string;
  Text: string;
begin
  Title := EscapedMessage(Prefix + Event.Title);
  Text := EscapedMessage(Event.Text);

  Send(Format('_e{%d,%d}:%s|%s%s%s', [Title.Length, Text.Length, Title, Text, Event.ToMap, DataTagsToText(Tags)]));
end;

procedure TDataDogStatsClientImpl.RecordExecutionTime(Aspect: TDataDogAspect; TimeInMs: Int64; SampleRate: Double; Tags: TDataDogTags);
begin
  if(IsInvalidSample(SampleRate)) then Exit;

  Send(Format('%s%s:%d|ms|%f%s', [Prefix, Aspect, TimeInMs, SampleRate, DataTagsToText(Tags)]));
end;

procedure TDataDogStatsClientImpl.RecordExecutionTime(Aspect: TDataDogAspect; TimeInMs: Int64; Tags: TDataDogTags);
begin
  Send(Format('%s%s:%d|ms%s', [Prefix, Aspect, TimeInMs, DataTagsToText(Tags)]));
end;

procedure TDataDogStatsClientImpl.RecordGaugeValue(Aspect: TDataDogAspect; Value: Int64; Tags: TDataDogTags);
begin
  Send(Format('%s%s:%d|g%s', [Prefix, Aspect, Value, DataTagsToText(tags)]));
end;

procedure TDataDogStatsClientImpl.RecordGaugeValue(Aspect: TDataDogAspect; Value: Double; Tags: TDataDogTags);
begin
  Send(Format('%s%s:%s|g%s', [Prefix, Aspect, FloatToStr(Value, DatadogFormatSettings), DataTagsToText(Tags)]));
end;

procedure TDataDogStatsClientImpl.RecordGaugeValue(Aspect: TDataDogAspect; Value, SampleRate: Double; Tags: TDataDogTags);
begin
  Send(Format('%s%s:%s|g|%f%s', [Prefix, Aspect, FloatToStr(Value, DatadogFormatSettings), SampleRate, DataTagsToText(Tags)]));
end;

procedure TDataDogStatsClientImpl.RecordGaugeValue(Aspect: TDataDogAspect; Value: Int64; SampleRate: Double; Tags: TDataDogTags);
begin
  if not (IsInvalidSample(SampleRate)) then Exit;

  Send(Format('%s%s:%d|g|%f%s', [Prefix, Aspect, Value, SampleRate, DataTagsToText(Tags)]));
end;

procedure TDataDogStatsClientImpl.RecordHistogramValue(Aspect: TDataDogAspect; Value: Int64; Tags: TDataDogTags);
begin
  Send(Format('%s%s:%d|h%s', [Prefix, Aspect, Value, DataTagsToText(Tags)]));
end;

procedure TDataDogStatsClientImpl.RecordHistogramValue(Aspect: TDataDogAspect; Value, SampleRate: Double; Tags: TDataDogTags);
begin
  if(IsInvalidSample(SampleRate)) then Exit;

  Send(Format('%s%s:%s|h|%f%s', [Prefix, Aspect, FloatToStr(Value, DatadogFormatSettings), SampleRate, DataTagsToText(Tags)]));
end;

procedure TDataDogStatsClientImpl.RecordHistogramValue(Aspect: TDataDogAspect; Value: Double; Tags: TDataDogTags);
begin
  Send(Format('%s%s:%s|h%s', [Prefix, Aspect, FloatToStr(Value, DatadogFormatSettings), DataTagsToText(Tags)]));
end;

procedure TDataDogStatsClientImpl.RecordHistogramValue(Aspect: TDataDogAspect; Value: Int64; SampleRate: Double; Tags: TDataDogTags);
begin
  if(isInvalidSample(SampleRate)) then Exit;

  Send(Format('%s%s:%d|h|%f%s', [Prefix, Aspect, Value, SampleRate, DataTagsToText(Tags)]));
end;

procedure TDataDogStatsClientImpl.RecordSetValue(Aspect: TDataDogAspect; Value: string; Tags: TDataDogTags);
begin
  Send(Format('%s%s:%s|s%s', [Prefix, Aspect, Value, DataTagsToText(Tags)]));
end;

procedure TDataDogStatsClientImpl.Send(Content: string);
begin
  FSender.Send(Content);
end;

procedure TDataDogStatsClientImpl.Time(Aspect: TDataDogAspect; Value: Int64; SampleRate: Double; Tags: TDataDogTags);
begin
  RecordExecutionTime(Aspect, Value, SampleRate, Tags);
end;

procedure TDataDogStatsClientImpl.Time(Aspect: TDataDogAspect; Value: Int64; Tags: TDataDogTags);
begin
  RecordExecutionTime(Aspect, Value, Tags);
end;

end.
