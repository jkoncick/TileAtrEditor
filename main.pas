unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Menus, StdCtrls, CheckLst, XPMan, Math;

const num_tiles = 800;
const tileset_max_height = 40;

const num_tileatr_values = 7;
const tileatr_values: array[0..num_tileatr_values-1] of cardinal = ($2000, $4000, $8000, $10000, $20000000, $40000000, $80000000);
const tileatr_combined_colors: array[0..num_tileatr_values-1] of cardinal = ($80, $3000, $C000, $60, $2020, $C00000, $204000);
const tileatr_attribute_colors: array[0..num_tileatr_values-1] of cardinal = ($FF, $FF0000, $FF00, $FF00FF, $FFFF, $FFFF00, $808080);

const num_tilesets = 7;
const tileset_filenames: array[1..num_tilesets] of String = ('BLOXBASE','BLOXBAT','BLOXBGBS','BLOXICE','BLOXTREE','BLOXWAST','BLOXXMAS');
const tileatr_filenames: array[1..num_tilesets] of String = ('tileatr2.bin','tileatr6.bin','tileatr3.bin','tileatr5.bin','tileatr1.bin','tileatr4.bin','tileatr7.bin');

type
   MarkSelection = (msAll, msExact, msFilterHaving, msFilterNotHaving, msInfantryOnly);

type
   SetOperation = (opSet, opAdd, opRemove);

type
   MarkType = (mtSingleColor, mtAllAttributes);

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
    Howtouse1: TMenuItem;
    N2: TMenuItem;
    About1: TMenuItem;
    TileAtrList: TCheckListBox;
    btnTileAtrValueApply: TButton;
    Quickopen1: TMenuItem;
    BLOXBASE1: TMenuItem;
    BLOXBAT1: TMenuItem;
    BLOXBGBS1: TMenuItem;
    BLOXICE1: TMenuItem;
    BLOXTREE1: TMenuItem;
    BLOXWAST1: TMenuItem;
    BLOXXMAS1: TMenuItem;
    rgMarkSelection: TRadioGroup;
    rgOperation: TRadioGroup;
    cbMultipleTileMode: TCheckBox;
    ReloadTileatr1: TMenuItem;
    N3: TMenuItem;
    SaveTileAtras1: TMenuItem;
    SaveTileAtrDialog: TSaveDialog;
    rgMarkType: TRadioGroup;
    // Form actions
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
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
    procedure SaveTileAtras1Click(Sender: TObject);
    procedure QuickOpenClick(Sender: TObject);
    procedure Howtouse1Click(Sender: TObject);
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

  private
    { Private declarations }
    current_dir: String;

    tileset_bitmap: TBitmap;
    tileset_loaded: boolean;
    tileset_top: integer;
    tileset_height: integer;

    tileatr_loaded: boolean;
    tileatr_filename: string;
    tileatr_data: array[0..(num_tiles*2)-1] of cardinal;

    active_tile: integer;

    select_started: boolean;
    select_start_x: integer;
    select_start_y: integer;
    select_end_x: integer;
    select_end_y: integer;

    procedure open_tileset(filename: string);
    procedure open_tileatr(filename: string);
    procedure save_tileatr(filename: string);
    procedure render_tileset;
    procedure set_tile_attribute_list(value: cardinal);
    procedure set_tile_attributes(tile_index: integer);
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
  end;
end;

procedure TMainWindow.OpenTileAtr1Click(Sender: TObject);
begin
  if OpenTileatrDialog.Execute then
  begin
    open_tileatr(OpenTileatrDialog.FileName);
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
    open_tileatr(tileatr_filename);
end;

procedure TMainWindow.SaveTileAtr1Click(Sender: TObject);
begin
  if tileatr_loaded then
    save_tileatr(tileatr_filename);
end;

procedure TMainWindow.SaveTileAtras1Click(Sender: TObject);
begin
  if tileatr_loaded then
  begin
    if SaveTileAtrDialog.Execute then
      save_tileatr(SaveTileAtrDialog.FileName);
  end;
end;

procedure TMainWindow.QuickOpenClick(Sender: TObject);
var
  index: integer;
  tileset_filename: string;
begin
  index := (Sender as TMenuItem).Tag;
  tileset_filename := current_dir+'tilesets\d2k_'+tileset_filenames[index]+'.bmp';
  if not FileExists(tileset_filename) then
  begin
    Application.MessageBox('Could not find tileset image. Move this program into map editor folder or copy "tilesets" folder to this program folder.','Tileset loading error', MB_ICONERROR);
    exit;
  end;
  open_tileset(current_dir+'tilesets\d2k_'+tileset_filenames[index]+'.bmp');
  if FileExists(current_dir+'..\data\bin\'+tileatr_filenames[index]) then
    open_tileatr(current_dir+'..\data\bin\'+tileatr_filenames[index])
  else
    open_tileatr(current_dir+'tilesets\'+tileatr_filenames[index]);
end;

procedure TMainWindow.Howtouse1Click(Sender: TObject);
begin
  ShowMessage('Mouse actions:'#13#13'Left click = Set tileset attributes'#13'Right click = Get tileset attributes'#13'Middle click = Unmark selected tile'#13'Use "Multiple-tile-selection mode" and'#13'drag over all tiles you want to modify.');
end;

procedure TMainWindow.About1Click(Sender: TObject);
begin
  ShowMessage('Dune 2000 Tileset Attributes Editor'#13#13'Part of D2K+ Editing tools'#13#13'Made by Klofkac'#13'Version 0.1'#13'Date: 2015-05-06'#13#13'http://github.com/jkoncick/TileAtrEditor');
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
    if not cbMultipleTileMode.Checked then
      set_tile_attributes(tile_index)
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
  StatusBar.Panels[0].Text := 'x : ' + inttostr(pos_x) + ' y : ' + inttostr(pos_y);
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
    min_x := min(select_start_x, select_end_x);
    max_x := max(select_start_x, select_end_x);
    min_y := min(select_start_y, select_end_y);
    max_y := max(select_start_y, select_end_y);
    for yy := min_y to max_y do
      for xx:= min_x to max_x do
        set_tile_attributes(xx + yy*20);
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
  for i := 0 to num_tileatr_values - 1 do
  begin
    if TileAtrList.Checked[i] then
      value := value or tileatr_values[i];
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

procedure TMainWindow.open_tileset(filename: string);
begin
  tileset_bitmap.LoadFromFile(filename);
  StatusBar.Panels[1].Text := filename;
  tileset_loaded := true;
  render_tileset;
end;

procedure TMainWindow.open_tileatr(filename: string);
var
  tileatr_file: file of cardinal;
begin
  AssignFile(tileatr_file, filename);
  Reset(tileatr_file);
  BlockRead(tileatr_file, tileatr_data, num_tiles*2);
  CloseFile(tileatr_file);
  StatusBar.Panels[2].Text := filename;
  tileatr_filename := filename;
  active_tile := -1;
  tileatr_loaded := true;
  render_tileset;
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

procedure TMainWindow.render_tileset;
var
  top_pixels: integer;
  x, y: integer;
  i: integer;
  tile_index: integer;
  tile_value: cardinal;
  mark_selection: MarkSelection;
  mark_type: MarkType;
  mark_tile: boolean;
  selected_value: cardinal;
  color: cardinal;
  min_x, min_y, max_x, max_y: integer;
begin
  top_pixels := tileset_top * 32;
  selected_value := strtoint('$'+TileAtrValue.Text);
  if tileset_loaded then
    TilesetImage.Canvas.CopyRect(Rect(0,0,640,tileset_height*32), tileset_bitmap.Canvas, Rect(0,top_pixels,640,top_pixels+tileset_height*32));
  if tileatr_loaded then
  begin
    mark_selection := MarkSelection(rgMarkSelection.ItemIndex);
    mark_type := MarkType(rgMarkType.ItemIndex);
    TilesetImage.Canvas.Brush.Style := bsClear;
    TilesetImage.Canvas.Pen.Width := 2;
    for y := 0 to tileset_height - 1 do
      for x := 0 to 19 do
      begin
        tile_index := x + (y + tileset_top) * 20;
        tile_value := tileatr_data[tile_index];
        mark_tile := false;
        case mark_selection of
          msAll:              mark_tile := true;
          msExact:            mark_tile := tile_value = selected_value;
          msFilterHaving:     mark_tile := (tile_value and selected_value) = selected_value;
          msFilterNotHaving:  mark_tile := (tile_value and selected_value) = 0;
          msInfantryOnly:     mark_tile := (tile_value and $00006000) = $00004000;
          end;
        if mark_tile then
        begin
          if mark_type = mtSingleColor then
          begin
            color := $0;
            for i := 0 to num_tileatr_values - 1 do
              if (tileatr_data[tile_index] and tileatr_values[i]) <> 0 then
                color := color or tileatr_combined_colors[i];
            TilesetImage.Canvas.Pen.Color := color;
            TilesetImage.Canvas.Rectangle(x*32+2, y*32+2, x*32+31, y*32+31);
          end
          else if mark_type = mtAllAttributes then
          begin
            TilesetImage.Canvas.Brush.Style := bsSolid;
            TilesetImage.Canvas.Pen.Width := 1;
            for i := 0 to num_tileatr_values - 1 do
              if (tileatr_data[tile_index] and tileatr_values[i]) <> 0 then
              begin
                TilesetImage.Canvas.Pen.Color := tileatr_attribute_colors[i];
                TilesetImage.Canvas.Brush.Color := tileatr_attribute_colors[i];
                TilesetImage.Canvas.Rectangle(x*32+2+i*4, y*32+26, x*32+6+i*4, y*32+30);
              end;
          end;
        end;
        if active_tile = tile_index then
        begin
          TilesetImage.Canvas.Brush.Style := bsClear;
          TilesetImage.Canvas.Pen.Width := 2;
          TilesetImage.Canvas.Pen.Color := $FF0000;
          TilesetImage.Canvas.Rectangle(x*32+1, y*32+1, x*32+32, y*32+32);
        end;
      end;
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

procedure TMainWindow.set_tile_attribute_list(value: cardinal);
var
  i: integer;
begin
  for i := 0 to num_tileatr_values - 1 do
  begin
    if (value and tileatr_values[i]) <> 0 then
      TileAtrList.Checked[i] := true
    else
      TileAtrList.Checked[i] := false;
  end;
end;

procedure TMainWindow.set_tile_attributes(tile_index: integer);
var
  selected_value: cardinal;
  operation: SetOperation;
begin
  selected_value := strtoint('$'+TileAtrValue.Text);
  operation := SetOperation(rgOperation.ItemIndex);
  case operation of
    opSet:    tileatr_data[tile_index] := selected_value;
    opAdd:    tileatr_data[tile_index] := tileatr_data[tile_index] or selected_value;
    opRemove: tileatr_data[tile_index] := tileatr_data[tile_index] and (not selected_value);
    end;
end;

end.
