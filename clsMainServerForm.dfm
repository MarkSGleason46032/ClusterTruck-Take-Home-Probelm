object ServerForm: TServerForm
  Left = 0
  Top = 0
  Caption = 'ServerForm'
  ClientHeight = 247
  ClientWidth = 508
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 68
    Height = 13
    Caption = 'Listen On Port'
  end
  object HttpPort: TEdit
    Left = 82
    Top = 5
    Width = 47
    Height = 21
    MaxLength = 5
    NumbersOnly = True
    TabOrder = 0
    Text = '3000'
    OnChange = HttpPortChange
  end
  object startServer: TButton
    Left = 135
    Top = 1
    Width = 80
    Height = 25
    Caption = 'Start Listening'
    TabOrder = 1
    OnClick = startServerClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 32
    Width = 489
    Height = 209
    TabOrder = 2
  end
  object HTTPSocketServer: TIdHTTPServer
    Bindings = <>
    DefaultPort = 3333
    OnCommandGet = HTTPSocketServerCommandGet
    Left = 480
    Top = 8
  end
end
