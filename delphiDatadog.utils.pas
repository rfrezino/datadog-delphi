unit delphiDatadog.utils;

interface

uses
	delphiDatadog.header;

  function DataTagsToText(Tags: TDataDogTags): string;

  function DataTagsEventPriorityToText(Priority: TDataDogEventPriority): string;
  function DataTagsEventAlertToText(Priority: TDataDogEventAlertType): string;

  function EscapedMessage(Title: string): string;

implementation

uses
	System.SysUtils;

function DataTagsToText(Tags: TDataDogTags): string;
begin
end;

function DataTagsEventPriorityToText(Priority: TDataDogEventPriority): string;
begin
end;

function DataTagsEventAlertToText(Priority: TDataDogEventAlertType): string;
begin
end;

function EscapedMessage(Title: string): string;
begin
  Result := Title.Replace('\n', '\\n');
end;

end.
