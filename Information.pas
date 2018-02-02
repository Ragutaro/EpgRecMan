unit Information;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw, IniFilesDX,
  Vcl.ComCtrls, Vcl.ToolWin;

type
  TfrmInformation = class(TForm)
    WebBrowser: TWebBrowser;
    ToolBar1: TToolBar;
    tbrBack: TToolButton;
    tbrForward: TToolButton;
    ToolButton3: TToolButton;
    tbrStop: TToolButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure tbrStopClick(Sender: TObject);
    procedure tbrBackClick(Sender: TObject);
    procedure tbrForwardClick(Sender: TObject);
    procedure WebBrowserCommandStateChange(ASender: TObject; Command: Integer;
      Enable: WordBool);
  private
    { Private 宣言 }
    procedure _LoadSettings;
    procedure _SaveSettings;
  public
    { Public 宣言 }
  end;

var
  frmInformation: TfrmInformation;

implementation

{$R *.dfm}

{ TfrmInformation }

uses
  Main, HideUtils;

procedure TfrmInformation.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _SaveSettings;
  Release;
  FreeAndNil(frmInformation);
end;

procedure TfrmInformation.FormCreate(Sender: TObject);
begin
  _LoadSettings;
  WebBrowser.Navigate(av.sAppPath + 'ProgramInformation.html');
  DisableVclStyles(Self, '');
end;

procedure TfrmInformation.tbrBackClick(Sender: TObject);
begin
  WebBrowser.GoBack;
end;

procedure TfrmInformation.tbrForwardClick(Sender: TObject);
begin
  WebBrowser.GoForward;
end;

procedure TfrmInformation.tbrStopClick(Sender: TObject);
begin
  WebBrowser.Stop;
end;

procedure TfrmInformation.WebBrowserCommandStateChange(ASender: TObject;
  Command: Integer; Enable: WordBool);
begin
  Case Command of
    CSC_NAVIGATEBACK : tbrBack.Enabled := Enable;
    CSC_NAVIGATEFORWARD : tbrForward.Enabled := Enable;
  end;
end;

procedure TfrmInformation._LoadSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.ReadWindowPosition(Self.Name, Self);
    Self.Font.Name    := ini.ReadString('Font', 'FontName', '游ゴシック Medium');
    Self.Font.Size    := ini.ReadInteger('Font', 'FontSize', 10);
  finally
    ini.Free;
  end;
end;

procedure TfrmInformation._SaveSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.WriteWindowPosition(Self.Name, Self);
    ini.UpdateFile;
  finally
    ini.Free;
  end;
end;

end.
