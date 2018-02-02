object frmRename: TfrmRename
  Left = 358
  Top = 677
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #12501#12449#12452#12523#21517#12398#22793#26356
  ClientHeight = 136
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lnlOldname: TLabel
    Left = 12
    Top = 8
    Width = 84
    Height = 13
    Caption = #29694#22312#12398#12501#12449#12452#12523#21517':'
  end
  object lblFilename: TLabel
    Left = 12
    Top = 32
    Width = 52
    Height = 13
    Caption = 'lblFilename'
  end
  object lblPreFix: TLabel
    Left = 12
    Top = 59
    Width = 46
    Height = 13
    Caption = '1234_56-'
  end
  object lblExt: TLabel
    Left = 503
    Top = 59
    Width = 13
    Height = 13
    Caption = '.ts'
  end
  object edtInput: TEdit
    Left = 64
    Top = 56
    Width = 433
    Height = 21
    TabOrder = 0
    Text = 'edtInput'
  end
  object btnOK: TButton
    Left = 192
    Top = 96
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 280
    Top = 96
    Width = 75
    Height = 25
    Caption = #12461#12515#12531#12475#12523
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
