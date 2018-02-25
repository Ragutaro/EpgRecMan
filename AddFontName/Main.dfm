object frmMain: TfrmMain
  Left = 323
  Top = 283
  BorderIcons = [biSystemMenu]
  Caption = 'Add Fontname'
  ClientHeight = 368
  ClientWidth = 581
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
  object lstProcess: TListBox
    Left = 0
    Top = 0
    Width = 581
    Height = 216
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 18
    TabOrder = 0
  end
  object pagControl: TPageControl
    Left = 0
    Top = 219
    Width = 581
    Height = 149
    ActivePage = tabAdd
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 90
    ExplicitWidth = 417
    object tabAdd: TTabSheet
      Caption = #12501#12457#12531#12488#35373#23450#12398#36861#21152
      DesignSize = (
        573
        116)
      object Label2: TLabel
        Left = 10
        Top = 22
        Width = 65
        Height = 18
        Caption = #12501#12457#12531#12488#21517':'
      end
      object Label1: TLabel
        Left = 10
        Top = 56
        Width = 89
        Height = 18
        Anchors = [akLeft, akBottom]
        Caption = #12501#12457#12531#12488#12469#12452#12474':'
        ExplicitTop = 46
      end
      object cmbFont: TSpTBXFontComboBox
        Left = 112
        Top = 18
        Width = 453
        Height = 26
        Anchors = [akLeft, akRight, akBottom]
        ItemHeight = 23
        TabOrder = 0
      end
      object edtFontSize: TEdit
        Left = 111
        Top = 52
        Width = 32
        Height = 26
        Alignment = taCenter
        Anchors = [akLeft, akBottom]
        NumbersOnly = True
        TabOrder = 1
        Text = '12'
      end
      object btnExecute: TButton
        Left = 490
        Top = 86
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = #23455#34892
        TabOrder = 2
        OnClick = btnExecuteClick
      end
    end
    object tabEdit: TTabSheet
      Caption = #12501#12457#12531#12488#35373#23450#12398#22793#26356
      ImageIndex = 1
      DesignSize = (
        573
        116)
      object Button1: TButton
        Left = 490
        Top = 86
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #23455#34892
        TabOrder = 0
        OnClick = Button1Click
      end
      object grpFontName: TGroupBox
        Left = 3
        Top = 6
        Width = 325
        Height = 107
        TabOrder = 1
        DesignSize = (
          325
          107)
        object Label5: TLabel
          Left = 14
          Top = 32
          Width = 41
          Height = 18
          Caption = #32622#25563#21069':'
        end
        object Label6: TLabel
          Left = 14
          Top = 68
          Width = 41
          Height = 18
          Caption = #32622#25563#24460':'
        end
        object cmbFontBefore: TSpTBXFontComboBox
          Left = 61
          Top = 28
          Width = 256
          Height = 26
          Anchors = [akLeft, akRight, akBottom]
          Enabled = False
          ItemHeight = 23
          TabOrder = 0
        end
        object cmbFontAfter: TSpTBXFontComboBox
          Left = 61
          Top = 64
          Width = 256
          Height = 26
          Anchors = [akLeft, akRight, akBottom]
          ItemHeight = 23
          TabOrder = 1
        end
      end
      object grpFontSize: TGroupBox
        Left = 334
        Top = 6
        Width = 145
        Height = 105
        TabOrder = 2
        object Label3: TLabel
          Left = 14
          Top = 32
          Width = 41
          Height = 18
          Caption = #32622#25563#21069':'
        end
        object Label4: TLabel
          Left = 14
          Top = 68
          Width = 41
          Height = 18
          Caption = #32622#25563#24460':'
        end
        object edtAfter: TEdit
          Left = 73
          Top = 64
          Width = 30
          Height = 26
          Alignment = taCenter
          NumbersOnly = True
          TabOrder = 0
        end
        object edtBefore: TEdit
          Left = 73
          Top = 28
          Width = 30
          Height = 26
          Alignment = taCenter
          NumbersOnly = True
          TabOrder = 1
        end
      end
      object chkFontName: TCheckBox
        Left = 17
        Top = 2
        Width = 97
        Height = 17
        Caption = #12501#12457#12531#12488#21517
        TabOrder = 3
      end
      object chkFontSize: TCheckBox
        Left = 348
        Top = -1
        Width = 105
        Height = 26
        Caption = #12501#12457#12531#12488#12469#12452#12474
        TabOrder = 4
      end
    end
  end
end
