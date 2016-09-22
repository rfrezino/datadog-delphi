object frmDemo: TfrmDemo
  Left = 0
  Top = 0
  Caption = 'Demo'
  ClientHeight = 92
  ClientWidth = 619
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnSendMetrics: TButton
    Left = 54
    Top = 19
    Width = 131
    Height = 25
    Caption = 'Send Metrics'
    TabOrder = 0
    OnClick = btnSendMetricsClick
  end
end
