object futama: Tfutama
  Left = 430
  Top = 133
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'RenLoop'
  ClientHeight = 482
  ClientWidth = 321
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object mp: TMediaPlayer
    Left = 576
    Top = 8
    Width = 253
    Height = 30
    Visible = False
    TabOrder = 0
  end
  object lv: TListView
    Left = 8
    Top = 8
    Width = 305
    Height = 329
    Columns = <
      item
        Caption = 'Loc'
        Width = 100
      end
      item
        Caption = 'Title'
        Width = 100
      end
      item
        Caption = 'Lenth'
      end
      item
        Caption = 'Loop'
      end>
    GridLines = True
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnDblClick = lvDblClick
  end
  object p: TPanel
    Left = 8
    Top = 408
    Width = 305
    Height = 65
    BevelInner = bvLowered
    TabOrder = 2
    object l: TLabel
      Left = 8
      Top = 40
      Width = 60
      Height = 13
      Caption = 'Loop Start : '
    end
    object cb: TCheckBox
      Left = 8
      Top = 12
      Width = 57
      Height = 17
      Caption = 'Loop'
      TabOrder = 0
      OnClick = cbClick
    end
    object b: TButton
      Left = 72
      Top = 8
      Width = 57
      Height = 25
      Caption = '|> [][]'
      TabOrder = 1
      OnClick = bClick
    end
    object se: TSpinEdit
      Left = 72
      Top = 37
      Width = 89
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
    object b0: TButton
      Left = 224
      Top = 8
      Width = 75
      Height = 25
      Caption = 'APPLY'
      TabOrder = 3
      OnClick = b0Click
    end
    object b1: TButton
      Left = 224
      Top = 37
      Width = 75
      Height = 25
      Caption = 'MENU'
      TabOrder = 4
      OnClick = b1Click
    end
  end
  object gb: TGroupBox
    Left = 8
    Top = 344
    Width = 305
    Height = 57
    Caption = 'Now Playing'
    TabOrder = 3
    object l0: TLabel
      Left = 8
      Top = 16
      Width = 30
      Height = 13
      Caption = 'Title : '
    end
    object l2: TLabel
      Left = 8
      Top = 34
      Width = 68
      Height = 13
      Caption = 'Pos (loop N) : '
    end
    object l1: TLabel
      Left = 40
      Top = 16
      Width = 257
      Height = 13
      AutoSize = False
    end
  end
  object pm: TPopupMenu
    Left = 136
    Top = 232
    object mi: TMenuItem
      Caption = 'Tambah'
      OnClick = miClick
    end
    object mi0: TMenuItem
      Caption = 'Hapus'
      OnClick = mi0Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mi1: TMenuItem
      Caption = 'Simpan List'
      OnClick = mi1Click
    end
    object mi2: TMenuItem
      Caption = 'Buka List'
      OnClick = mi2Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mi3: TMenuItem
      Caption = 'RenPy : generate skrip'
      OnClick = mi3Click
    end
  end
  object t: TTimer
    Interval = 10
    OnTimer = tTimer
    Left = 96
    Top = 232
  end
end
