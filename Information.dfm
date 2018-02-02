object frmInformation: TfrmInformation
  Left = 321
  Top = 493
  Caption = #30058#32068#24773#22577
  ClientHeight = 112
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object WebBrowser: TWebBrowser
    Left = 0
    Top = 30
    Width = 289
    Height = 82
    Align = alClient
    TabOrder = 0
    OnCommandStateChange = WebBrowserCommandStateChange
    ExplicitLeft = 12
    ExplicitTop = 96
    ExplicitWidth = 300
    ExplicitHeight = 66
    ControlData = {
      4C000000DE1D00007A0800000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E12620A000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 289
    Height = 30
    AutoSize = True
    ButtonHeight = 30
    ButtonWidth = 31
    Caption = 'ToolBar1'
    Images = frmMain.imgX24
    TabOrder = 1
    object tbrBack: TToolButton
      Left = 0
      Top = 0
      Caption = 'tbrBack'
      ImageIndex = 4
      OnClick = tbrBackClick
    end
    object tbrForward: TToolButton
      Left = 31
      Top = 0
      Caption = 'tbrForward'
      ImageIndex = 5
      OnClick = tbrForwardClick
    end
    object ToolButton3: TToolButton
      Left = 62
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object tbrStop: TToolButton
      Left = 70
      Top = 0
      Caption = 'tbrStop'
      ImageIndex = 3
      OnClick = tbrStopClick
    end
  end
end
