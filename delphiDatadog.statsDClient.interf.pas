unit delphiDatadog.statsDClient.interf;

interface

uses
	delphiDatadog.header, delphiDatadog.serviceCheck, delphiDatadog.event;

type

  IDataDogStatsClient = interface(IInterface)
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
  end;


implementation

end.
