object frmMain: TfrmMain
  Left = 1557
  Top = 238
  Caption = 'Add Fontname'
  ClientHeight = 191
  ClientWidth = 322
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
  DesignSize = (
    322
    191)
  PixelsPerInch = 96
  TextHeight = 18
  object lstProcess: TListBox
    Left = 0
    Top = 0
    Width = 322
    Height = 153
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 18
    TabOrder = 0
  end
  object btnExecute: TButton
    Left = 239
    Top = 159
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #23455#34892
    TabOrder = 1
    OnClick = btnExecuteClick
  end
  object cmbFont: TSpTBXFontComboBox
    Left = 8
    Top = 159
    Width = 185
    Height = 26
    Anchors = [akLeft, akBottom]
    ItemHeight = 23
    TabOrder = 2
  end
end
