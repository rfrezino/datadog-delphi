unit delphiDatadog.statsDClientSender.interf;

interface

type
  IDataDogStatsClientSender = interface(IInterface)
    procedure Send(Content: string);
  end;

implementation

end.
