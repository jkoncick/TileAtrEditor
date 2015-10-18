object MainWindow: TMainWindow
  Left = 191
  Top = 112
  Width = 900
  Height = 600
  Caption = 'Dune 2000 Tileset Attributes Editor'
  Color = clBtnFace
  Constraints.MaxWidth = 900
  Constraints.MinHeight = 600
  Constraints.MinWidth = 900
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCreate = FormCreate
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object TilesetImage: TImage
    Left = 8
    Top = 8
    Width = 640
    Height = 512
    OnMouseDown = TilesetImageMouseDown
    OnMouseMove = TilesetImageMouseMove
    OnMouseUp = TilesetImageMouseUp
  end
  object lbTileAtrValue: TLabel
    Left = 680
    Top = 12
    Width = 87
    Height = 13
    Caption = 'Tile attribute value'
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 527
    Width = 892
    Height = 19
    Panels = <
      item
        Text = 'X: 0  Y: 0'
        Width = 100
      end
      item
        Text = 'No Tileset loaded'
        Width = 360
      end
      item
        Text = 'No TileAtr loaded'
        Width = 360
      end
      item
        Text = 'v1.0'
        Width = 20
      end>
  end
  object TilesetScrollBar: TScrollBar
    Left = 656
    Top = 8
    Width = 17
    Height = 512
    Kind = sbVertical
    Max = 24
    PageSize = 0
    TabOrder = 1
    OnChange = TilesetScrollBarChange
  end
  object TileAtrValue: TEdit
    Left = 776
    Top = 8
    Width = 73
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object TileAtrList: TCheckListBox
    Left = 680
    Top = 62
    Width = 204
    Height = 141
    OnClickCheck = TileAtrListClickCheck
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 17
    ParentFont = False
    Style = lbOwnerDrawFixed
    TabOrder = 3
  end
  object btnTileAtrValueApply: TButton
    Left = 856
    Top = 8
    Width = 25
    Height = 21
    Caption = 'OK'
    TabOrder = 4
    OnClick = btnTileAtrValueApplyClick
  end
  object rgMarkSelection: TRadioGroup
    Left = 680
    Top = 328
    Width = 201
    Height = 121
    Caption = ' Tile-marking selection '
    ItemIndex = 0
    Items.Strings = (
      'Mark &all tiles'
      'Mark til&es of this type'
      '&Filter tiles having attributes'
      'Filter tiles &not having attributes'
      'Mark &infantry-only')
    TabOrder = 5
    OnClick = btnTileAtrValueApplyClick
  end
  object rgOperation: TRadioGroup
    Left = 680
    Top = 233
    Width = 201
    Height = 80
    Caption = ' Operation '
    ItemIndex = 0
    Items.Strings = (
      'Set attributes'
      'Add selected attributes'
      'Remove selected attributes')
    TabOrder = 6
  end
  object cbMultipleTileMode: TCheckBox
    Left = 688
    Top = 210
    Width = 137
    Height = 17
    Caption = 'Multiple-tile-select mode'
    TabOrder = 7
  end
  object rgMarkType: TRadioGroup
    Left = 680
    Top = 461
    Width = 201
    Height = 60
    Caption = ' Tile-marking style '
    ItemIndex = 0
    Items.Strings = (
      'Mark tiles with single color'
      'Mark all attributes separately')
    TabOrder = 8
    OnClick = btnTileAtrValueApplyClick
  end
  object rbGameAttributes: TRadioButton
    Left = 684
    Top = 40
    Width = 97
    Height = 17
    Hint = 'Standard attributes actually used by game.'
    Caption = 'Game attributes'
    Checked = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    TabStop = True
    OnClick = selectAttributeSet
  end
  object rbEditorAttributes: TRadioButton
    Tag = 1
    Left = 788
    Top = 40
    Width = 97
    Height = 17
    Hint = 
      'Attributes used only by Campaign Map Editor.'#13'You should not set ' +
      'them in TileAtr files used by game!'
    Caption = 'Editor attributes'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    OnClick = selectAttributeSet
  end
  object btnImportEditorAttributes: TButton
    Left = 836
    Top = 208
    Width = 45
    Height = 21
    Hint = 'Import Editor attributes from different TileAtr file'
    Caption = 'Import'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
    Visible = False
    OnClick = btnImportEditorAttributesClick
  end
  object MainMenu: TMainMenu
    object File1: TMenuItem
      Caption = 'File'
      object OpenTileset1: TMenuItem
        Caption = 'Open Tileset'
        OnClick = OpenTileset1Click
      end
      object OpenTileAtr1: TMenuItem
        Caption = 'Open TileAtr'
        OnClick = OpenTileAtr1Click
      end
      object OpenBoth1: TMenuItem
        Caption = 'Open Both'
        ShortCut = 16463
        OnClick = OpenBoth1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object ReloadTileatr1: TMenuItem
        Caption = 'Reload TileAtr'
        ShortCut = 16466
        OnClick = ReloadTileatr1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object SaveTileAtr1: TMenuItem
        Caption = 'Save TileAtr'
        ShortCut = 16467
        OnClick = SaveTileAtr1Click
      end
      object SaveTileAtras1: TMenuItem
        Caption = 'Save TileAtr as'
        OnClick = SaveTileAtras1Click
      end
    end
    object Quickopen1: TMenuItem
      Caption = 'Quick open'
      object BLOXBASE1: TMenuItem
        Tag = 1
        Caption = 'BLOXBASE'
        ShortCut = 112
        OnClick = QuickOpenClick
      end
      object BLOXBAT1: TMenuItem
        Tag = 2
        Caption = 'BLOXBAT'
        ShortCut = 113
        OnClick = QuickOpenClick
      end
      object BLOXBGBS1: TMenuItem
        Tag = 3
        Caption = 'BLOXBGBS'
        ShortCut = 114
        OnClick = QuickOpenClick
      end
      object BLOXICE1: TMenuItem
        Tag = 4
        Caption = 'BLOXICE'
        ShortCut = 115
        OnClick = QuickOpenClick
      end
      object BLOXTREE1: TMenuItem
        Tag = 5
        Caption = 'BLOXTREE'
        ShortCut = 116
        OnClick = QuickOpenClick
      end
      object BLOXWAST1: TMenuItem
        Tag = 6
        Caption = 'BLOXWAST'
        ShortCut = 117
        OnClick = QuickOpenClick
      end
      object BLOXXMAS1: TMenuItem
        Tag = 7
        Caption = 'BLOXXMAS'
        ShortCut = 118
        OnClick = QuickOpenClick
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object Howtouse1: TMenuItem
        Caption = 'How to use'
        OnClick = Howtouse1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
    end
  end
  object OpenTilesetDialog: TOpenDialog
    DefaultExt = 'bmp'
    Filter = 'Image (*.bmp)|*.bmp'
    Left = 32
  end
  object OpenTileAtrDialog: TOpenDialog
    DefaultExt = 'bin'
    Filter = 'Dune 2000 tileatr file (*.bin)|*.bin'
    Left = 64
  end
  object SaveTileAtrDialog: TSaveDialog
    DefaultExt = 'bin'
    Filter = 'Dune 2000 tileatr file (*.bin)|*.bin'
    Left = 96
  end
end
