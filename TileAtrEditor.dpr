program TileAtrEditor;

uses
  Forms,
  main in 'main.pas' {MainWindow};

{$R *.res}

begin
  Application.Initialize;
  Application.HelpFile := 'Dune 2000 Tileset Attributes Editor';
  Application.Title := 'D2k+ TileAtr Editor';
  Application.CreateForm(TMainWindow, MainWindow);
  Application.Run;
end.
