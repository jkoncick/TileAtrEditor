unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Menus, StdCtrls, CheckLst, XPMan, Math,
  Buttons, IniFiles, StrUtils;

const program_caption = 'Dune 2000 Tileset Attributes Editor';
const num_tiles = 800;
const tileset_max_height = 40;
const num_tileatr_values = 8;
const cnt_block_preset_groups = 8;
const cnt_block_preset_keys = 40;
const max_undo_steps = 4095;

type
  TTilesetInfo = record
    name: String;
    image_name: String;
    tileatr_name: String;
  end;

type
  TUndoEntry = record
    index: integer;
    data: cardinal;
    is_first: boolean;
  end;

type
  TTileAttribute = record
    name: string;
    value: cardinal;
    combined_color: cardinal;
  end;

const atr: array[0..1, 0..num_tileatr_values-1] of TTileAttribute =
  (
    (
      (name: 'Vehicles can pass';                     value: $2000;     combined_color: $000080),
      (name: 'Infantry can pass';                     value: $4000;     combined_color: $003000),
      (name: 'Buildings can be placed, Rock craters'; value: $8000;     combined_color: $00C000),
      (name: 'Sandworm can pass, Sand craters';       value: $10000;    combined_color: $000060),
      (name: 'Rock (wheeled +10% speed)';             value: $20000000; combined_color: $002020),
      (name: 'Dunes (wheeled -50%, other -20% sp.)';  value: $40000000; combined_color: $C00000),
      (name: 'Rough Rock (all -50% speed)';           value: $80000000; combined_color: $204000),
      (name: '';                                      value: $00000000; combined_color: $000000)
    ),
    (
      (name: 'Paint type 1 (Clean Sand)';  value: $01; combined_color: $0000E0),
      (name: 'Paint type 2 (Clean Rock)';  value: $02; combined_color: $00C000),
      (name: 'Paint type 3 (Clean Dunes)'; value: $04; combined_color: $C00000),
      (name: 'Paint type 4 (Clean Ice)';   value: $08; combined_color: $C000C0),
      (name: 'Area type 1 (Sand area)';    value: $10; combined_color: $00009F),
      (name: 'Area type 2 (Rock area)';    value: $20; combined_color: $007F00),
      (name: 'Area type 3 (Dunes area)';   value: $40; combined_color: $7F0000),
      (name: 'Area type 4 (Ice area)';     value: $80; combined_color: $7F007F)
    )
  );

const atrvalueset: array[0..1] of cardinal = ($FFFFFF00, $000000FF);

type
   SetOperation = (opSet, opAdd, opRemove);

type
   MarkSelection = (msAll, msExact, msFilterHaving, msFilterNotHaving, msInfantryOnly, msNothing);

type
   ViewMode = (vmDrawTilesetAttributes, vmCheckBlockPresetCoverage);

type
  TMainWindow = class(TForm)
    MainMenu: TMainMenu;
    StatusBar: TStatusBar;
    TilesetImage: TImage;
    TilesetScrollBar: TScrollBar;
    TileAtrValue: TEdit;
    lbTileAtrValue: TLabel;
    File1: TMenuItem;
    OpenTileset1: TMenuItem;
    OpenTileAtr1: TMenuItem;
    OpenBoth1: TMenuItem;
    N1: TMenuItem;
    SaveTileAtr1: TMenuItem;
    OpenTilesetDialog: TOpenDialog;
    OpenTileAtrDialog: TOpenDialog;
    Help1: TMenuItem;
    MouseActions1: TMenuItem;
    N2: TMenuItem;
    About1: TMenuItem;
    TileAtrList: TCheckListBox;
    btnTileAtrValueApply: TButton;
    Quickopen1: TMenuItem;
    rgMarkSelection: TRadioGroup;
    rgOperation: TRadioGroup;
    cbMultipleSelectMode: TCheckBox;
    ReloadTileatr1: TMenuItem;
    N3: TMenuItem;
    SaveTileAtras1: TMenuItem;
    SaveTileAtrDialog: TSaveDialog;
    rgViewMode: TRadioGroup;
    rbGameAttributes: TRadioButton;
    rbEditorAttributes: TRadioButton;
    btnImportEditorAttributes: TButton;
    Gamefolder1: TMenuItem;
    Editorfolder1: TMenuItem;
    N4: TMenuItem;
    SaveBothTileAtr1: TMenuItem;
    N5: TMenuItem;
    Exit1: TMenuItem;
    cbShowGrid: TCheckBox;
    cbMarkSelection: TCheckBox;
    Edit1: TMenuItem;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    btnClearAttributes: TButton;
    KeyShortcuts1: TMenuItem;
    // Form actions
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CMDialogKey(var AMessage: TCMDialogKey); message CM_DIALOGKEY;
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    // Menu actions
    procedure OpenTileset1Click(Sender: TObject);
    procedure OpenTileAtr1Click(Sender: TObject);
    procedure OpenBoth1Click(Sender: TObject);
    procedure ReloadTileatr1Click(Sender: TObject);
    procedure SaveTileAtr1Click(Sender: TObject);
    procedure SaveBothTileAtr1Click(Sender: TObject);
    procedure SaveTileAtras1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure SelectFolderClick(Sender: TObject);
    procedure QuickOpenClick(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure Redo1Click(Sender: TObject);
    procedure KeyShortcuts1Click(Sender: TObject);
    procedure MouseActions1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    // Controls actions
    procedure TilesetImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TilesetImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TilesetImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TilesetScrollBarChange(Sender: TObject);
    procedure TileAtrListClickCheck(Sender: TObject);
    procedure btnTileAtrValueApplyClick(Sender: TObject);
    procedure selectAttributeSet(Sender: TObject);
    procedure btnImportEditorAttributesClick(Sender: TObject);
    procedure btnClearAttributesClick(Sender: TObject);
    procedure cbOptionClick(Sender: TObject);

  private
    { Private declarations }
    current_dir: String;

    // Configutarion variables
    cnt_tilesets: integer;
    menuitems: array of TMenuItem;
    tileset_info: array of TTilesetInfo;
    game_folder: String;

    // Status variables
    cur_tileset: integer;
    atrset: integer;
    active_tile: integer;
    tileset_top: integer;
    tileset_height: integer;

    // Data variables
    tileset_loaded: boolean;
    tileset_bitmap: TBitmap;
    tileatr_loaded: boolean;
    tileatr_filename: string;
    tileatr_data: array[0..(num_tiles*2)-1] of cardinal;
    block_preset_coverage: array[0..num_tiles-1] of integer;

    // Undo variables
    undo_history: array[0..max_undo_steps] of TUndoEntry;
    undo_start: integer;
    undo_max: integer;
    undo_pos: integer;
    undo_block_start: boolean;

    // Mouse and control-related variables
    mouse_old_x: integer;
    mouse_old_y: integer;
    select_started: boolean;
    select_start_x: integer;
    select_start_y: integer;
    select_end_x: integer;
    select_end_y: integer;

    procedure init_tilesets;
    procedure open_tileset(filename: string);
    procedure load_tileatr(filename: string);
    procedure save_tileatr(filename: string);
    procedure load_tileset_configuration(filename: string);
    procedure set_no_quick_open;
    procedure render_tileset;
    procedure init_attribute_names;
    procedure do_undo;
    procedure do_redo;
    procedure reset_undo_history;
    procedure set_tile_attribute_list(value: cardinal);
    procedure set_tile_attributes(tile_index: integer; single_op: boolean);
  public
    { Public declarations }
  end;

var
  MainWindow: TMainWindow;

implementation

{$R *.dfm}

procedure TMainWindow.FormCreate(Sender: TObject);
begin
  current_dir := ExtractFilePath(Application.ExeName);
  tileset_bitmap := TBitmap.Create;
  TilesetImage.Picture.Bitmap.Width := 640;
  cur_tileset := -1;
  atrset := 0;
  init_tilesets;
  init_attribute_names;
end;

procedure TMainWindow.FormResize(Sender: TObject);
var
  new_tileset_height: integer;
begin
  new_tileset_height := (ClientHeight - 32) div 32;
  if new_tileset_height > tileset_max_height then
    new_tileset_height := tileset_max_height;
  if new_tileset_height = tileset_height then
    exit;
  tileset_height := new_tileset_height;
  TilesetImage.Picture.Bitmap.Height := tileset_height * 32;
  TilesetImage.Height := tileset_height * 32;
  TilesetScrollBar.Height := tileset_height * 32;
  TilesetScrollBar.Max := tileset_max_height - tileset_height;
  if tileset_height = tileset_max_height then
    TilesetScrollBar.Enabled := False
  else
    TilesetScrollBar.Enabled := True;
  render_tileset;
end;

procedure TMainWindow.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssCtrl in Shift then
  begin
    case key of
      ord('G'): cbShowGrid.Checked := not cbShowGrid.Checked;
      ord('M'): cbMarkSelection.Checked := not cbMarkSelection.Checked;
    end;
  end else
  if ActiveControl <> TileAtrValue then
  begin
    case key of
      ord('S'): rgOperation.ItemIndex := 0;
      ord('A'): rgOperation.ItemIndex := 1;
      ord('R'): rgOperation.ItemIndex := 2;
      ord('M'): cbMultipleSelectMode.Checked := not cbMultipleSelectMode.Checked;
      ord('C'): btnClearAttributesClick(nil);
    end;
  end;
end;

procedure TMainWindow.CMDialogKey(var AMessage: TCMDialogKey);
begin
  if AMessage.CharCode = VK_TAB then
  begin
    if rbGameAttributes.Checked then
      rbEditorAttributes.Checked := true
    else
      rbGameAttributes.Checked := true;
    AMessage.Result := 1;
  end else
    inherited;
end;

procedure TMainWindow.FormMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  TilesetScrollBar.Position := TilesetScrollBar.Position + 2;
  Handled := true;
end;

procedure TMainWindow.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  TilesetScrollBar.Position := TilesetScrollBar.Position - 2;
  Handled := true;
end;

procedure TMainWindow.OpenTileset1Click(Sender: TObject);
begin
  if OpenTilesetDialog.Execute then
  begin
    open_tileset(OpenTilesetDialog.FileName);
    render_tileset;
    set_no_quick_open;
  end;
end;

procedure TMainWindow.OpenTileAtr1Click(Sender: TObject);
begin
  if OpenTileatrDialog.Execute then
  begin
    load_tileatr(OpenTileatrDialog.FileName);
    render_tileset;
    set_no_quick_open;
  end;
end;

procedure TMainWindow.OpenBoth1Click(Sender: TObject);
begin
  OpenTileset1Click(Sender);
  OpenTileAtr1Click(Sender);
end;

procedure TMainWindow.ReloadTileatr1Click(Sender: TObject);
begin
  if tileatr_loaded then
  begin
    load_tileatr(tileatr_filename);
    render_tileset;
  end;
end;

procedure TMainWindow.SaveTileAtr1Click(Sender: TObject);
begin
  if tileatr_loaded then
    save_tileatr(tileatr_filename);
end;

procedure TMainWindow.SaveBothTileAtr1Click(Sender: TObject);
var
  i: integer;
begin
  // Save Editor TileAtr file
  save_tileatr(tileatr_filename);
  // Remove all Editor attributes and save Game TileAtr
  for i := 0 to num_tiles - 1 do
    tileatr_data[i] := tileatr_data[i] and atrvalueset[0];
  save_tileatr(game_folder + 'Data\bin\' + tileset_info[cur_tileset].tileatr_name+'.BIN');
  // Reload Editor TileAtr file
  load_tileatr(current_dir + 'tilesets\' + tileset_info[cur_tileset].tileatr_name+'.BIN');
end;

procedure TMainWindow.SaveTileAtras1Click(Sender: TObject);
begin
  if tileatr_loaded then
  begin
    if SaveTileAtrDialog.Execute then
    begin
      save_tileatr(SaveTileAtrDialog.FileName);
      set_no_quick_open;
    end;
  end;
end;

procedure TMainWindow.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainWindow.SelectFolderClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := true;
  if cur_tileset <> -1 then
    QuickOpenClick(menuitems[cur_tileset]);
end;

procedure TMainWindow.QuickOpenClick(Sender: TObject);
var
  index: integer;
  tileset_filename: string;
  tileatr_filename: string;
begin
  index := (Sender as TMenuItem).Tag;
  // Open Tileset
  tileset_filename := current_dir+'tilesets\'+tileset_info[index].image_name+'.bmp';
  if not FileExists(tileset_filename) then
  begin
    Application.MessageBox(PChar('Could not find tileset image ('+tileset_filename+').'),'Tileset loading error', MB_ICONERROR);
    exit;
  end;
  open_tileset(tileset_filename);
  // Load TileAtr
  if Gamefolder1.Checked then
    tileatr_filename := game_folder + 'Data\bin\' + tileset_info[index].tileatr_name+'.BIN'
  else
    tileatr_filename := current_dir + 'tilesets\' + tileset_info[index].tileatr_name+'.BIN';
  if not FileExists(tileatr_filename) then
  begin
    Application.MessageBox(PChar('Could not find TILEATR file ('+tileatr_filename+').'),'Tileset loading error', MB_ICONERROR);
    exit;
  end;
  load_tileatr(tileatr_filename);
  load_tileset_configuration(current_dir + 'tilesets\' + tileset_info[index].name+'.ini');
  render_tileset;
  // Update GUI
  (Sender as TMenuItem).Checked := true;
  cur_tileset := index;
  Caption := program_caption + ' - ' + tileset_info[index].name + ' (' + IfThen(Gamefolder1.Checked,'game','editor') + ')';
  SaveBothTileAtr1.Enabled := Editorfolder1.Checked;
end;

procedure TMainWindow.Undo1Click(Sender: TObject);
begin
  do_undo;
  render_tileset;
end;

procedure TMainWindow.Redo1Click(Sender: TObject);
begin
  do_redo;
  render_tileset;
end;

procedure TMainWindow.KeyShortcuts1Click(Sender: TObject);
begin
  ShowMessage('Key shortcuts:'#13#13'Tab = Toggle Game/Editor attributes'#13'Ctrl + G = Show Grid'#13'Ctrl + M = Mark Selection'#13 +
              'S = Set attributes'#13'A = Add selected attributes'#13'R = Remove selected attributes'#13'C = Clear selected attributes'#13'M = Multiple-select mode');
end;

procedure TMainWindow.MouseActions1Click(Sender: TObject);
begin
  ShowMessage('Mouse actions:'#13#13'Left click = Set tileset attributes'#13'Right click = Get tileset attributes'#13'Middle click = Unmark selected tile'#13'Use "Multiple-tile-select mode" and'#13'drag over all tiles you want to modify.');
end;

procedure TMainWindow.About1Click(Sender: TObject);
begin
  ShowMessage('Dune 2000 Tileset Attributes Editor'#13#13'Part of D2K+ Editing tools'#13#13'Made by Klofkac'#13'Version 1.1'#13'Date: 2015-10-21'#13#13'http://github.com/jkoncick/TileAtrEditor');
end;

procedure TMainWindow.TilesetImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pos_x, pos_y: integer;
  tile_index: integer;
begin
  pos_x := X div 32;
  pos_y := Y div 32 + tileset_top;
  tile_index := pos_x + pos_y * 20;
  if Button = mbRight then
  begin
    TileAtrValue.Text := IntToHex(tileatr_data[tile_index], 8);
    set_tile_attribute_list(tileatr_data[tile_index]);
    active_tile := tile_index;
  end
  else if Button = mbLeft then
  begin
    if not cbMultipleSelectMode.Checked then
      set_tile_attributes(tile_index, true)
    else
    begin
      select_started := true;
      select_start_x := pos_x;
      select_start_y := pos_y;
      select_end_x := pos_x;
      select_end_y := pos_y;
    end;
  end
  else if Button = mbMiddle then
  begin
    active_tile := -1;
  end;
  render_tileset;
end;

procedure TMainWindow.TilesetImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  pos_x, pos_y: integer;
begin
  pos_x := X div 32;
  pos_y := Y div 32 + tileset_top;
  if (mouse_old_x = pos_x) and (mouse_old_y = pos_y) then
    exit;
  mouse_old_x := pos_x;
  mouse_old_y := pos_y;
  StatusBar.Panels[0].Text := 'x : ' + inttostr(pos_x) + ' y : ' + inttostr(pos_y) + '  (' + inttostr(pos_y*20 + pos_x) + ')';
  if (not select_started) and (ssLeft in Shift) then
    TilesetImageMouseDown(Sender, mbLeft, Shift, X, Y);
  if select_started and ((pos_x <> select_end_x) or (pos_y <> select_end_y)) then
  begin
    select_end_x := pos_x;
    select_end_y := pos_y;
    render_tileset;
  end;
end;

procedure TMainWindow.TilesetImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  min_x, min_y, max_x, max_y: integer;
  xx, yy: integer;
begin
  if select_started then
  begin
    select_started := false;
    undo_block_start := true;
    min_x := min(select_start_x, select_end_x);
    max_x := max(select_start_x, select_end_x);
    min_y := min(select_start_y, select_end_y);
    max_y := max(select_start_y, select_end_y);
    for yy := min_y to max_y do
      for xx:= min_x to max_x do
        set_tile_attributes(xx + yy*20, false);
    render_tileset;
  end;
end;

procedure TMainWindow.TilesetScrollBarChange(Sender: TObject);
begin
  tileset_top := TilesetScrollBar.Position;
  render_tileset;
end;

procedure TMainWindow.TileAtrListClickCheck(Sender: TObject);
var
  i: integer;
  value: cardinal;
begin
  value := 0;
  for i := 0 to TileAtrList.Count - 1 do
  begin
    if TileAtrList.Checked[i] then
      value := value or atr[atrset,i].value;
    TileAtrValue.Text := IntToHex(value, 8);
  end;
  active_tile := -1;
  render_tileset;
end;

procedure TMainWindow.btnTileAtrValueApplyClick(Sender: TObject);
begin
  set_tile_attribute_list(strtoint('$'+TileAtrValue.Text));
  render_tileset;
end;

procedure TMainWindow.selectAttributeSet(Sender: TObject);
var
  num: integer;
begin
  num := (Sender as TRadioButton).Tag;
  if atrset <> num then
  begin
    atrset := num;
    btnImportEditorAttributes.Visible := num = 1;
    init_attribute_names;
    set_tile_attribute_list(strtoint('$'+TileAtrValue.Text));
    render_tileset;
  end;
end;

procedure TMainWindow.btnImportEditorAttributesClick(Sender: TObject);
var
  tileatr_file: file of cardinal;
  tmp_tileatr_data: array[0..num_tiles-1] of cardinal;
  i: integer;
begin
  if OpenTileatrDialog.Execute then
  begin
    AssignFile(tileatr_file, OpenTileatrDialog.FileName);
    Reset(tileatr_file);
    BlockRead(tileatr_file, tmp_tileatr_data, num_tiles);
    CloseFile(tileatr_file);
    for i := 0 to num_tiles - 1 do
      tileatr_data[i] := (tileatr_data[i] and atrvalueset[0]) or (tmp_tileatr_data[i] and atrvalueset[1]);
    render_tileset;
  end;
end;

procedure TMainWindow.btnClearAttributesClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to TileAtrList.Count - 1 do
  begin
    TileAtrList.Checked[i] := false;
  end;
  TileAtrListClickCheck(nil);
end;

procedure TMainWindow.cbOptionClick(Sender: TObject);
begin
  render_tileset;
end;

procedure TMainWindow.init_tilesets;
var
  ini_filename: String;
  ini: TMemIniFile;
  tmp_strings: TStringList;
  i: integer;
begin
  // Load game folder
  ini := TMemIniFile.Create('D2kEditor.ini');
  game_folder := ini.ReadString('Paths','GamePath',current_dir+'..\');
  ini.Destroy;
  // Load list of tilesets
  ini_filename := current_dir + 'config/tilesets.ini';
  if not FileExists(ini_filename) then
  begin
    Application.MessageBox(PChar('Could not find tileset configuration file (config\tilesets.ini). Please move this program into the Map Editor folder.'),'Error', MB_ICONERROR);
    exit;
  end;
  ini := TMemIniFile.Create(ini_filename);
  tmp_strings := TStringList.Create;
  ini.ReadSections(tmp_strings);
  cnt_tilesets := tmp_strings.Count;
  SetLength(tileset_info, cnt_tilesets);
  SetLength(menuitems, cnt_tilesets);
  for i := 0 to cnt_tilesets -1 do
  begin
    tileset_info[i].name := tmp_strings[i];
    tileset_info[i].image_name := ini.ReadString(tmp_strings[i], 'image', '');
    tileset_info[i].tileatr_name := ini.ReadString(tmp_strings[i], 'tileatr', '');
    menuitems[i] := TMenuItem.Create(MainWindow.Quickopen1);
    menuitems[i].Caption := tileset_info[i].name;
    menuitems[i].RadioItem := true;
    menuitems[i].GroupIndex := 1;
    menuitems[i].Tag := i;
    if i < 12 then
      menuitems[i].ShortCut := 112 + i;
    menuitems[i].RadioItem := true;
    menuitems[i].GroupIndex := 2;
    menuitems[i].OnClick := MainWindow.QuickOpenClick;
    MainWindow.Quickopen1.Add(menuitems[i]);
  end;
  ini.Destroy;
  tmp_strings.Destroy;
end;

procedure TMainWindow.open_tileset(filename: string);
begin
  tileset_bitmap.LoadFromFile(filename);
  StatusBar.Panels[1].Text := filename;
  tileset_loaded := true;
end;

procedure TMainWindow.load_tileatr(filename: string);
var
  tileatr_file: file of cardinal;
  i: integer;
begin
  AssignFile(tileatr_file, filename);
  Reset(tileatr_file);
  BlockRead(tileatr_file, tileatr_data, num_tiles*2);
  CloseFile(tileatr_file);
  for i := 0 to num_tiles - 1 do
    block_preset_coverage[i] := 0;
  StatusBar.Panels[2].Text := filename;
  tileatr_filename := filename;
  active_tile := -1;
  reset_undo_history;
  tileatr_loaded := true;
end;

procedure TMainWindow.save_tileatr(filename: string);
var
  tileatr_file: file of cardinal;
begin
  AssignFile(tileatr_file, filename);
  ReWrite(tileatr_file);
  BlockWrite(tileatr_file, tileatr_data, num_tiles*2);
  CloseFile(tileatr_file);
  StatusBar.Panels[2].Text := filename;
  tileatr_filename := filename;
end;

procedure TMainWindow.load_tileset_configuration(filename: string);
var
  ini: TMemIniFile;
  tmp_strings: TStringList;
  decoder, decoder2: TStringList;
  i, j, k, x, y: integer;
  key: char;
begin
  if not FileExists(filename) then
    exit;
  ini := TMemIniFile.Create(filename);
  tmp_strings := TStringList.Create;
  decoder := TStringList.Create;
  decoder2 := TStringList.Create;
  decoder.Delimiter := ';';
  decoder2.Delimiter := '.';
  // Load block presets
  for i := 0 to cnt_block_preset_groups - 1 do
  begin
    for j := 0 to cnt_block_preset_keys - 1 do
    begin
      key := ' ';
      if (j >= 0) and (j <= 9) then
        key := chr(j + ord('0'))
      else if (j >= 10) and (j <= 35) then
        key := chr(j + ord('A') - 10)
      else if j = 36 then
        key := '<'
      else if j = 37 then
        key := '>'
      else if j = 38 then
        key := ':'
      else if j = 39 then
        key := '?';
      decoder.DelimitedText := ini.ReadString('Block_Preset_Group_'+(inttostr(i+1)), key, '');
      for k := 0 to decoder.Count - 1 do
      begin
        decoder2.DelimitedText := decoder[k];
        if decoder2.Count <> 4 then
          continue;
        for x := strtoint(decoder2[2]) to strtoint(decoder2[2]) + strtoint(decoder2[0]) - 1 do
          for y := strtoint(decoder2[3]) to strtoint(decoder2[3]) + strtoint(decoder2[1]) - 1 do
            inc(block_preset_coverage[x + y * 20]);
      end;
    end;
  end;
  ini.Destroy;
  tmp_strings.Destroy;
  decoder.Destroy;
  decoder2.Destroy;
end;


procedure TMainWindow.set_no_quick_open;
begin
  if cur_tileset <> -1 then
  begin
    menuitems[cur_tileset].Checked := false;
    Caption := program_caption;
    SaveBothTileAtr1.Enabled := false;
    cur_tileset := -1;
  end;
end;

procedure TMainWindow.render_tileset;
var
  top_pixels: integer;
  x, y: integer;
  i: integer;
  tile_index: integer;
  tile_value: cardinal;
  mark_selection: MarkSelection;
  view_mode: ViewMode;
  mark_tile: boolean;
  selected_value: cardinal;
  color: cardinal;
  min_x, min_y, max_x, max_y: integer;
begin
  top_pixels := tileset_top * 32;
  selected_value := strtoint('$'+TileAtrValue.Text) and atrvalueset[atrset];
  if tileatr_loaded then
  begin
    // Draw tileset
    TilesetImage.Canvas.CopyRect(Rect(0,0,640,tileset_height*32), tileset_bitmap.Canvas, Rect(0,top_pixels,640,top_pixels+tileset_height*32));
    // Draw grid
    if cbShowGrid.Checked then
    begin
      TilesetImage.Canvas.Pen.Color:= clBlack;
      TilesetImage.Canvas.Pen.Width := 1;
      for x:= 0 to 20-1 do
      begin
        TilesetImage.Canvas.MoveTo(x*32,0);
        TilesetImage.Canvas.LineTo(x*32,tileset_height*32);
      end;
      for y:= 0 to tileset_height-1 do
      begin
        TilesetImage.Canvas.MoveTo(0,y*32);
        TilesetImage.Canvas.LineTo(640,y*32);
      end;
    end;
    // Draw attributes
    mark_selection := MarkSelection(rgMarkSelection.ItemIndex);
    view_mode := ViewMode(rgViewMode.ItemIndex);
    TilesetImage.Canvas.Brush.Style := bsClear;
    TilesetImage.Canvas.Pen.Width := 2;
    for y := 0 to tileset_height - 1 do
      for x := 0 to 19 do
      begin
        tile_index := x + (y + tileset_top) * 20;
        tile_value := tileatr_data[tile_index] and atrvalueset[atrset];
        if view_mode = vmDrawTilesetAttributes then
        begin
          mark_tile := false;
          case mark_selection of
            msAll:              mark_tile := true;
            msExact:            mark_tile := tile_value = selected_value;
            msFilterHaving:     mark_tile := (tile_value and selected_value) = selected_value;
            msFilterNotHaving:  mark_tile := (tile_value and selected_value) = 0;
            msInfantryOnly:     mark_tile := (tile_value and $00006000) = $00004000;
            msNothing:          mark_tile := false;
            end;
          if mark_tile then
          begin
            color := $0;
            for i := 0 to num_tileatr_values - 1 do
              if (tileatr_data[tile_index] and atr[atrset,i].value) <> 0 then
                color := color or atr[atrset,i].combined_color;
            TilesetImage.Canvas.Pen.Color := color;
            TilesetImage.Canvas.Rectangle(x*32+2, y*32+2, x*32+31, y*32+31);
          end;
        end else
        if view_mode = vmCheckBlockPresetCoverage then
        begin
          if (block_preset_coverage[tile_index] > 0) or ((tileatr_data[tile_index] and $f) <> 0) then
          begin
            color := $000000;
            if block_preset_coverage[tile_index] = 0 then
              color := $00D0D0
            else if block_preset_coverage[tile_index] = 1 then
              color := $00A000
            else if block_preset_coverage[tile_index] > 1 then
              color := $0000D0;
            TilesetImage.Canvas.Pen.Color := color;
            TilesetImage.Canvas.Rectangle(x*32+2, y*32+2, x*32+31, y*32+31);
          end;
        end;
        if (active_tile = tile_index) and cbMarkSelection.Checked then
        begin
          TilesetImage.Canvas.Brush.Style := bsClear;
          TilesetImage.Canvas.Pen.Width := 2;
          TilesetImage.Canvas.Pen.Color := $FF0000;
          TilesetImage.Canvas.Rectangle(x*32+1, y*32+1, x*32+32, y*32+32);
        end;
      end;
    // Draw selection
    if select_started then
    begin
      TilesetImage.Canvas.Brush.Style := bsClear;
      TilesetImage.Canvas.Pen.Width := 2;
      TilesetImage.Canvas.Pen.Color := $FF;
      min_x := min(select_start_x, select_end_x) * 32+1;
      max_x := max(select_start_x, select_end_x) * 32+32;
      min_y := (min(select_start_y, select_end_y) - tileset_top) * 32+1;
      max_y := (max(select_start_y, select_end_y) - tileset_top) * 32+32;
      TilesetImage.Canvas.Rectangle(min_x, min_y, max_x, max_y);
    end;
  end;
end;

procedure TMainWindow.init_attribute_names;
var
  i: integer;
begin
  TileAtrList.Items.Clear;
  for i := 0 to num_tileatr_values - 1 do
    if atr[atrset,i].name <> '' then
      TileAtrList.Items.add(atr[atrset,i].name)
end;

procedure TMainWindow.do_undo;
var
  tmp_data: cardinal;
begin
  if undo_pos = undo_start then
    exit;
  repeat
    undo_pos := (undo_pos - 1) and max_undo_steps;
    tmp_data := tileatr_data[undo_history[undo_pos].index];
    tileatr_data[undo_history[undo_pos].index] := undo_history[undo_pos].data;
    undo_history[undo_pos].data := tmp_data;
  until undo_history[undo_pos].is_first or (undo_pos = undo_start);
  if undo_pos = undo_start then
    Undo1.Enabled := false;
  Redo1.Enabled := true;
end;

procedure TMainWindow.do_redo;
var
  tmp_data: cardinal;
begin
  if undo_pos = undo_max then
    exit;
  repeat
    tmp_data := tileatr_data[undo_history[undo_pos].index];
    tileatr_data[undo_history[undo_pos].index] := undo_history[undo_pos].data;
    undo_history[undo_pos].data := tmp_data;
    undo_pos := (undo_pos + 1) and max_undo_steps;
  until undo_history[undo_pos].is_first or (undo_pos = undo_max);
  if undo_pos = undo_max then
    Redo1.Enabled := false;
  Undo1.Enabled := true;
end;

procedure TMainWindow.reset_undo_history;
begin
  Undo1.Enabled := false;
  Redo1.Enabled := false;
  undo_start := 0;
  undo_max := 0;
  undo_pos := 0;
end;

procedure TMainWindow.set_tile_attribute_list(value: cardinal);
var
  i: integer;
begin
  for i := 0 to TileAtrList.Count - 1 do
  begin
    if (value and atr[atrset,i].value) <> 0 then
      TileAtrList.Checked[i] := true
    else
      TileAtrList.Checked[i] := false;
  end;
end;

procedure TMainWindow.set_tile_attributes(tile_index: integer; single_op: boolean);
var
  selected_value: cardinal;
  tileatr_value: cardinal;
  operation: SetOperation;
begin
  selected_value := strtoint('$'+TileAtrValue.Text);
  tileatr_value := 0;
  operation := SetOperation(rgOperation.ItemIndex);
  // Get the target tileatr value according to the operation
  case operation of
    opSet:    tileatr_value := (tileatr_data[tile_index] and (not atrvalueset[atrset])) or (selected_value and atrvalueset[atrset]);
    opAdd:    tileatr_value := tileatr_data[tile_index] or selected_value;
    opRemove: tileatr_value := tileatr_data[tile_index] and (not selected_value);
    end;
  // Save old tileatr value into undo history
  undo_history[undo_pos].index := tile_index;
  undo_history[undo_pos].data := tileatr_data[tile_index];
  undo_history[undo_pos].is_first := single_op or undo_block_start;
  undo_block_start := false;
  undo_pos := (undo_pos + 1) and max_undo_steps;
  if undo_start = undo_pos then
    undo_start := (undo_start + 1) and max_undo_steps;
  undo_max := undo_pos;
  Undo1.Enabled := true;
  Redo1.Enabled := false;
  // Save new tileatr value
  tileatr_data[tile_index] := tileatr_value;
end;

end.
