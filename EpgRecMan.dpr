program EpgRecMan;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  Information in 'Information.pas' {frmInformation},
  Rename in 'Rename.pas' {frmRename},
  Vcl.Themes,
  Vcl.Styles,
  SetFileTime in 'SetFileTime.pas' {frmSetFileTime};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10');
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
