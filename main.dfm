object MainWindow: TMainWindow
  Left = 192
  Top = 97
  Width = 900
  Height = 640
  Caption = 'Dune 2000 Tileset Attributes Editor'
  Color = clBtnFace
  Constraints.MaxWidth = 900
  Constraints.MinHeight = 640
  Constraints.MinWidth = 900
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object TilesetImage: TImage
    Left = 8
    Top = 8
    Width = 640
    Height = 544
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
    Top = 567
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
        Text = 'v1.2'
        Width = 20
      end>
  end
  object TilesetScrollBar: TScrollBar
    Left = 656
    Top = 8
    Width = 17
    Height = 544
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
    MaxLength = 8
    TabOrder = 2
    Text = '00000000'
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
    Top = 344
    Width = 201
    Height = 141
    Caption = ' Tile-marking selection '
    ItemIndex = 0
    Items.Strings = (
      'Mark all tiles'
      'Mark tiles of this type'
      'Filter tiles having attributes'
      'Filter tiles not having attributes'
      'Mark infantry-only'
      'Mark nothing')
    TabOrder = 5
    OnClick = btnTileAtrValueApplyClick
  end
  object rgOperation: TRadioGroup
    Left = 680
    Top = 255
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
  object cbMultipleSelectMode: TCheckBox
    Left = 684
    Top = 210
    Width = 121
    Height = 17
    Caption = 'Multiple-select mode'
    TabOrder = 7
  end
  object rgViewMode: TRadioGroup
    Left = 680
    Top = 493
    Width = 201
    Height = 60
    Caption = ' View mode  '
    ItemIndex = 0
    Items.Strings = (
      'Draw tileset attributes'
      'Check block preset coverage')
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
    Left = 804
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
  object cbShowGrid: TCheckBox
    Left = 684
    Top = 232
    Width = 97
    Height = 17
    Caption = 'Show Grid'
    TabOrder = 12
    OnClick = cbOptionClick
  end
  object cbMarkSelection: TCheckBox
    Left = 784
    Top = 232
    Width = 97
    Height = 17
    Caption = 'Mark Selection'
    Checked = True
    State = cbChecked
    TabOrder = 13
    OnClick = cbOptionClick
  end
  object btnClearAttributes: TButton
    Left = 852
    Top = 208
    Width = 29
    Height = 21
    Hint = 'Clear selected attributes'
    Caption = 'Clr'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 14
    OnClick = btnClearAttributesClick
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
      object SaveBothTileAtr1: TMenuItem
        Caption = 'Save Both TileAtr'
        Enabled = False
        ShortCut = 24659
        OnClick = SaveBothTileAtr1Click
      end
      object SaveTileAtras1: TMenuItem
        Caption = 'Save TileAtr as'
        OnClick = SaveTileAtras1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Quickopen1: TMenuItem
      Caption = 'Quick open'
      object Gamefolder1: TMenuItem
        Caption = 'Game folder'
        GroupIndex = 1
        RadioItem = True
        ShortCut = 45
        OnClick = SelectFolderClick
      end
      object Editorfolder1: TMenuItem
        Caption = 'Editor folder'
        Checked = True
        GroupIndex = 1
        RadioItem = True
        ShortCut = 46
        OnClick = SelectFolderClick
      end
      object N4: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      object Undo1: TMenuItem
        Caption = 'Undo'
        Enabled = False
        ShortCut = 16474
        OnClick = Undo1Click
      end
      object Redo1: TMenuItem
        Caption = 'Redo'
        Enabled = False
        ShortCut = 16473
        OnClick = Redo1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object KeyShortcuts1: TMenuItem
        Caption = 'Key Shortcuts'
        OnClick = KeyShortcuts1Click
      end
      object MouseActions1: TMenuItem
        Caption = 'Mouse Actions'
        OnClick = MouseActions1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object About1: TMenuItem
        Caption = 'About...'
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
