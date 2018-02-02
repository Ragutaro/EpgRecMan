unit SetFileTime;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils, IniFilesDX, System.IOUtils, System.Types,
  Vcl.Filectrl, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Mask, HideListView;

type
  TfrmSetFileTime = class(TForm)
    Label1: TLabel;
    現在の日時: TGroupBox;
    Label2: TLabel;
    lblNowCreation: TLabel;
    lblNowUpdate: TLabel;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label7: TLabel;
    btnCancel: TButton;
    btnOk: TButton;
    masCreation: TMaskEdit;
    masUpdate: TMaskEdit;
    lblPath: TLabel;
    lblFilename: TStaticText;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private 宣言 }
    procedure _LoadSettings;
    procedure _SaveSettings;
    procedure _SetNewFileDateTime;
  public
    { Public 宣言 }
  end;

var
  frmSetFileTime: TfrmSetFileTime;

implementation

{$R *.dfm}

uses
  HideUtils,
  main,
  dp;

procedure TfrmSetFileTime.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSetFileTime.btnOkClick(Sender: TObject);
begin
  _SetNewFileDateTime;
  Close;
end;

procedure TfrmSetFileTime.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _SaveSettings;
  Release;
  FreeAndNil(frmSetFileTime);// frmSetFileTime := nil;   //フォーム名に変更する
end;

procedure TfrmSetFileTime.FormCreate(Sender: TObject);
begin
  DisableVclStyles(Self);
  _LoadSettings;
end;

procedure TfrmSetFileTime._LoadSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.ReadWindow(Self.Name, Self);
    Self.Font.Name    := ini.ReadString('Font', 'FontName', '游ゴシック Medium');
    Self.Font.Size    := ini.ReadInteger('Font', 'FontSize', 10);
  finally
    ini.Free;
  end;
end;

procedure TfrmSetFileTime._SaveSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.WriteWindow(Self.Name, Self);
    ini.UpdateFile;
  finally
    ini.Free;
  end;
end;

procedure TfrmSetFileTime._SetNewFileDateTime;
var
  d : TDateTime;
  item : TListItemEx;
  i : Integer;
  sFile : String;
begin
  sFile := lblPath.Caption + lblFilename.Caption;
  for i := 0 to frmMain.lvwList.Items.Count-1 do
  begin
  	item := TListItemEx(frmMain.lvwList.Items[i]);
    if item.sProgramFullPath = sFile then
    begin
      d := StrToDateTime(masCreation.Text);
      item.SubItems[0] := FormatDateTime('YYYY/MM/DD HH:NN', d);
      TFile.SetCreationTime(sFile, d);
      d := StrToDateTime(masUpdate.Text);
      TFile.SetLastWriteTime(sFile, d);
      Break;
    end;
  end;
end;

end.
