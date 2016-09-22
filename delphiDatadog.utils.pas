unit delphiDatadog.utils;

interface

uses
	delphiDatadog.header;

  function DataTagsToText(Tags: TDataDogTags): string;

  function DataTagsEventPriorityToText(Priority: TDataDogEventPriority): string;
  function DataTagsEventAlertToText(AlertType: TDataDogEventAlertType): string;

  function EscapedMessage(Title: string): string;

implementation

uses
	System.SysUtils;

function DataTagsToText(Tags: TDataDogTags): string;
var
  I: Integer;
  Tag: string;
begin
  Result := '';

  if Length(Tags) = 0 then Exit;

  for Tag in Tags do
  begin
    if Result.IsEmpty then
      Result := Tag
    else
      Result := Result + ',' + Tag
  end;

  Result := '|#' + Result;
end;

function DataTagsEventPriorityToText(Priority: TDataDogEventPriority): string;
begin
  case Priority of
    ddLow: Result := 'low';
    ddNormal: Result := 'normal';
  end;
end;

function DataTagsEventAlertToText(AlertType: TDataDogEventAlertType): string;
begin
  case AlertType of
    ddError: Result := 'error';
    ddWarning: Result := 'warning';
    ddInfo: Result := 'info';
    ddSuccess: Result := 'success';
    ddUndefined: Result := '';
  end;
end;

function EscapedMessage(Title: string): string;
begin
  Result := Title.Replace('\n', '\\n');
end;

end.
