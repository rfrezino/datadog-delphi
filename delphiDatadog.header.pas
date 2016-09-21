unit delphiDatadog.header;

interface

type
  TDataDogTag = string;
  TDataDogAspect = string;

  TDataDogTags = array of TDataDogTag;

  TDataDogEventPriority = (ddLow, ddNormal);

  TDataDogEventAlertType = (ddError, ddWarning, ddInfo, ddSuccess, ddUndefined);

  TDataDogServiceStatus = (dssOK = 0, dssWarning = 1, dssCritical = 2, dssUnknown = 3, dssUndefined = 4);

implementation

end.
