# datadog-delphi

A [StatsD](https://github.com/statsd/statsd) / [DogStatsD](https://docs.datadoghq.com/developers/dogstatsd/) client library written in Delphi. It formats metrics, events and tags as DogStatsD datagrams and sends them over UDP to a Datadog agent (or any compatible StatsD listener).

Version 1.0

[https://www.datadoghq.com/](https://www.datadoghq.com/)

This README has two parts:

- [Using the library](#using-the-library): for people who add datadog-delphi to their own application.
- [Developing the library](#developing-the-library): for people who change datadog-delphi itself.

---

# Using the library

## Requirements

- The [Indy](https://www.indyproject.org/) components (`IdUDPClient`) must be available to your project.
- Delphi XE7 or later is probably required, because the code uses the `TDataDogTags.Create(...)` array constructor syntax. This has not been verified on any compiler.

## Installation

There is no package or build file. Add the units to your project (or to its search path):

- `delphiDatadog.header.pas`
- `delphiDatadog.statsDClient.interf.pas`
- `delphiDatadog.statsDClient.impl.pas`
- `delphiDatadog.statsDClientSender.interf.pas`
- `delphiDatadog.statsDClientSender.impl.pas`
- `delphiDatadog.event.pas`
- `delphiDatadog.serviceCheck.pas`
- `delphiDatadog.utils.pas`

The demo's `Demo.dpr` references them by relative path.

## Usage

Create the service settings, the sender and the client:

```delphi
uses
  delphiDatadog.header, delphiDatadog.event, delphiDatadog.serviceCheck,
  delphiDatadog.statsDClient.interf, delphiDatadog.statsDClient.impl,
  delphiDatadog.statsDClientSender.interf, delphiDatadog.statsDClientSender.impl;

var
  Sender: IDataDogStatsClientSender;
  Service: TDataDogServiceCheck;
  StatsD: IDataDogStatsClient;
  Event: TDataDogEvent;
begin
  Service := TDataDogServiceCheck.Create;   // defaults: localhost:8125
  // Service.Hostname := 'my-agent-host';
  // Service.Port := 8125;

  Sender := TDataDogStatsClientSender.Create(Service);
  StatsD := TDataDogStatsClientImpl.Create(Sender);
  StatsD.SetPrefix('myapp.');

  StatsD.Count('qtt', 1, TDataDogTags.Create('mob', 'foo'));
  StatsD.RecordExecutionTime('testBM', Random(500), TDataDogTags.Create('valueX'));

  Event := TDataDogEvent.Create;
  try
    Event.Title := 'Error on report';
    Event.Text := 'Error while trying to translate the report';
    Event.Priority := ddLow;
    Event.AlertType := ddError;
    StatsD.RecordEvent(Event, TDataDogTags.Create('eventTest'));
  finally
    Event.Free;
  end;
end;
```

The `Count`, `RecordExecutionTime` and `RecordEvent` calls come from `Demo/uMain.pas` (`btnSendMetricsClick`); the setup comes from `FormCreate` in the same file. The `SetPrefix` call is not part of the demo.

Things to know when copying this:

- The client constructor takes its sender by `var` (`Create(var Sender: IDataDogStatsClientSender)`), so pass a variable of type `IDataDogStatsClientSender`, not an expression.
- The sender keeps a reference to the `TDataDogServiceCheck` object and reads it on its background thread, so keep it alive while the sender is in use. The library never frees it.

## What it supports

The client interface is `IDataDogStatsClient` (`delphiDatadog.statsDClient.interf.pas`). Most calls take an aspect (the metric name), a value, an optional `SampleRate` and an array of tags.

| Metric type | Methods | Wire format |
| --- | --- | --- |
| Counter | `Count`, `IncrementCounter` / `Increment`, `DecrementCounter` / `Decrement` | `name:value\|c` |
| Gauge | `RecordGaugeValue` / `Gauge` (`Double` and `Int64` overloads) | `name:value\|g` |
| Timer | `RecordExecutionTime` / `Time` (value in milliseconds) | `name:value\|ms` |
| Histogram | `RecordHistogramValue` / `Histogram` (`Double` and `Int64` overloads) | `name:value\|h` |
| Set | `RecordSetValue` | `name:value\|s` |
| Event | `RecordEvent` (takes a `TDataDogEvent`) | `_e{titleLen,textLen}:title\|text\|...` |

Other behavior:

- **Prefix**: the prefix (`GetPrefix` / `SetPrefix` on the interface; also a `Prefix` property on `TDataDogStatsClientImpl`) is prepended to every metric name and to event titles. No separator is added, so include a trailing `.` in the prefix if you want one.
- **Tags**: `TDataDogTags` is `TArray<string>`. Tags are appended as `|#tag1,tag2`. An empty array adds nothing.
- **Events**: `TDataDogEvent` (`delphiDatadog.event.pas`) has `Title`, `Text`, `MillisSinceEpoch`, `HostName`, `AggregationKey`, `Priority` (`ddLow`, `ddNormal`) and `AlertType` (`ddError`, `ddWarning`, `ddInfo`, `ddSuccess`, `ddUndefined`).
  - `|d:`, `|h:` and `|k:` are written only when `MillisSinceEpoch`, `HostName` and `AggregationKey` are set.
  - `|p:` is always written, and `|t:` is written unless the alert type is `ddUndefined`. The enum defaults are `ddLow` and `ddError`, so an event you leave at the defaults carries `|p:low|t:error`. Set `Priority` and `AlertType` explicitly.
  - `SourcerTypeName` exists but is not written to the datagram.
- **Service checks**: `TDataDogServiceCheck` (`delphiDatadog.serviceCheck.pas`) holds the agent connection settings (`Hostname`, default `localhost`; `Port`, default `8125`). It also has `Name`, `Status`, `MessageText`, `TimeStamp` and `Tags`. `ToStatsDString` builds the `_sc|...` string. The client does not call `ToStatsDString`; the demo uses the class only to configure the host and port.

## Current behavior notes

- A private check, `IsInvalidSample`, always returns `True` (`delphiDatadog.statsDClient.impl.pas`). The `SampleRate` overloads use it in different ways:
  - `Count` and the `Int64` `RecordGaugeValue` test it with `not`, so they send. `Increment` and `Decrement` with a sample rate go through `Count`.
  - The `Double` `RecordGaugeValue` does not call it, so it sends.
  - `RecordExecutionTime` (and `Time`) and both `RecordHistogramValue` overloads (and `Histogram`) exit when it returns `True`, so with a `SampleRate` they currently send nothing.
  - The overloads without `SampleRate` always send.
- The sample rate is written into the datagram as given. The library does not do any sampling itself.
- Every client method requires a `Tags` argument; there is no overload without it. Pass an empty `TDataDogTags` (for example `nil`) when you have no tags.
- **Number formatting (not run-tested)**: `Double` gauge and histogram values are formatted with a unit-level `TFormatSettings` variable (`DatadogFormatSettings`) that is never initialised. Fractional values, such as `1.5`, are therefore likely to produce a malformed datagram. This comes from reading the code; nobody has run it. The `%f` sample rate and the event `|d:` timestamp use the process locale, so they may print a comma as the decimal separator. Until this is fixed, prefer the `Int64` overloads or whole-number values.
- **Shutdown**: releasing the sender only asks its background thread to stop. It does not flush the queue, so messages still queued (the thread checks every 500 ms) may be lost.

## Demo

`Demo/Demo.dpr` is a VCL application with a single button. On startup it builds the service settings, sender and client. Clicking **Send Metrics** sends one counter, one timer and one event. Open the project in Delphi and run it while a Datadog agent or StatsD listener is reachable on `localhost:8125`. The demo does not free its `TDataDogServiceCheck`.

---

# Developing the library

## Source layout

| File | Contents |
| --- | --- |
| `delphiDatadog.header.pas` | Shared types and enums (`TDataDogTags`, `TDataDogAspect`, event priority and alert type, service status) |
| `delphiDatadog.statsDClient.interf.pas` | `IDataDogStatsClient` |
| `delphiDatadog.statsDClient.impl.pas` | `TDataDogStatsClientImpl`, which formats the datagrams |
| `delphiDatadog.statsDClientSender.interf.pas` | `IDataDogStatsClientSender` (one method, `Send`) |
| `delphiDatadog.statsDClientSender.impl.pas` | `TDataDogStatsClientSender`, which queues messages and sends them over UDP from a background thread |
| `delphiDatadog.event.pas` | `TDataDogEvent` |
| `delphiDatadog.serviceCheck.pas` | `TDataDogServiceCheck` |
| `delphiDatadog.utils.pas` | Helpers for tag, priority and alert text, and message escaping |
| `Demo/` | A VCL demo project (`Demo.dpr`, `uMain.pas`, `uMain.dfm`) |

## How sending works

1. Calls on the client format a DogStatsD string with `Format` and pass it to the sender (`TDataDogStatsClientImpl.Send`).
2. The sender adds the string to an in-memory queue (`TStringList`) guarded by a critical section.
3. A private `TThread` (`TDatadogThreadSender`) wakes every 500 ms. If the queue is not empty, it reads the host and port from the `TDataDogServiceCheck`, swaps the queue and sends each queued string as one UDP datagram using Indy's `TIdUDPClient`.

The sender destructor only calls `Terminate`; the thread is `FreeOnTerminate`. The sender holds the `TDataDogServiceCheck` reference and does not free it.

## Conventions

- Units are named `delphiDatadog.<area>[.impl|.interf].pas`. The client and the sender each have an interface unit and an implementation unit.
- Types use a `TDataDog` or `IDataDog` prefix, fields use `F`, and method names are PascalCase.
- The code has almost no comments apart from the IDE-generated `{ TClass }` section headers.
- `.gitignore` is the standard Delphi ignore list.

## Working on it

- There is no package, build script or test project. Open `Demo/Demo.dpr` in Delphi to compile the library units and exercise them by hand against a local agent or listener.
- There are no automated tests in this repository.
- `IsInvalidSample`, the uninitialised `DatadogFormatSettings` and the shutdown behaviour are described under [Current behavior notes](#current-behavior-notes). They are documented as they are; it is not known whether `IsInvalidSample` is intentional.

---

## License

MIT. See [`LICENSE`](LICENSE).

<br>
<br>
<br>

This package is provided by **Coolblue** :D

More information [http://www.careersatcoolblue.com/](http://www.careersatcoolblue.com/)
