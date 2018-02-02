object frmSetFileTime: TfrmSetFileTime
  Left = 312
  Top = 480
  BorderStyle = bsDialog
  Caption = #12479#12452#12512#12473#12479#12531#12503#12398#22793#26356
  ClientHeight = 231
  ClientWidth = 483
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #12513#12452#12522#12458
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 18
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 60
    Height = 18
    Caption = #12501#12449#12452#12523#21517
  end
  object lblPath: TLabel
    Left = 8
    Top = 198
    Width = 39
    Height = 18
    Caption = 'lblPath'
    Visible = False
  end
  object 現在の日時: TGroupBox
    Left = 8
    Top = 84
    Width = 217
    Height = 97
    Caption = #29694#22312#12398#26085#26178
    TabOrder = 0
    object Label2: TLabel
      Left = 14
      Top = 32
      Width = 53
      Height = 18
      Caption = #20316#25104#26085#26178':'
    end
    object lblNowCreation: TLabel
      Left = 76
      Top = 32
      Width = 122
      Height = 18
      Caption = '2016/11/08 13:00:00'
    end
    object lblNowUpdate: TLabel
      Left = 76
      Top = 60
      Width = 122
      Height = 18
      Caption = '2016/11/08 13:00:00'
    end
    object Label4: TLabel
      Left = 14
      Top = 60
      Width = 53
      Height = 18
      Caption = #26356#26032#26085#26178':'
    end
  end
  object GroupBox1: TGroupBox
    Left = 242
    Top = 84
    Width = 227
    Height = 97
    Caption = #26032#12375#12356#26085#26178
    TabOrder = 1
    object Label3: TLabel
      Left = 14
      Top = 32
      Width = 53
      Height = 18
      Caption = #20316#25104#26085#26178':'
    end
    object Label7: TLabel
      Left = 14
      Top = 60
      Width = 53
      Height = 18
      Caption = #26356#26032#26085#26178':'
    end
    object masCreation: TMaskEdit
      Left = 73
      Top = 26
      Width = 140
      Height = 26
      EditMask = '0000/00/00 00:00:00;1;_'
      MaxLength = 19
      TabOrder = 0
      Text = '    /  /     :  :  '
    end
    object masUpdate: TMaskEdit
      Left = 73
      Top = 58
      Width = 140
      Height = 26
      EditMask = '0000/00/00 00:00:00;1;_'
      MaxLength = 19
      TabOrder = 1
      Text = '    /  /     :  :  '
    end
  end
  object btnCancel: TButton
    Left = 394
    Top = 196
    Width = 75
    Height = 25
    Caption = #12461#12515#12531#12475#12523
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object btnOk: TButton
    Left = 306
    Top = 196
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = btnOkClick
  end
  object lblFilename: TStaticText
    Left = 8
    Top = 30
    Width = 461
    Height = 48
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = 'lblFilename'
    TabOrder = 4
  end
end
