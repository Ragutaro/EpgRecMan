unit Main;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils, IniFilesDX, System.IOUtils, System.Types,
  Vcl.Filectrl, Vcl.StdCtrls, SpTBXEditors, SpTBXExtEditors;

type
  TfrmMain = class(TForm)
    lstProcess: TListBox;
    btnExecute: TButton;
    cmbFont: TSpTBXFontComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
  private
    { Private 宣言 }
    procedure _LoadSettings;
    procedure _SaveSettings;
    procedure _Execute;
  public
    { Public 宣言 }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  HideUtils,
  dp;

procedure TfrmMain.btnExecuteClick(Sender: TObject);
begin
  _Execute;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _SaveSettings;
  Release;
  frmMain := nil;   //フォーム名に変更する
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  _LoadSettings;
end;

procedure TfrmMain._Execute;
var
  sl : TStringList;
  ar : TStringDynArray;
  s : String;
  i : Integer;
begin
  ar := TDirectory.GetFiles(GetApplicationPath + 'EpgTimer', '*.xaml', TSearchOption.soAllDirectories);
  sl := TStringList.Create;
  try
    for s in ar do
    begin
      lstProcess.Items.Add('open:' + s);
      lstProcess.TopIndex := lstProcess.Items.Count-1;
      Application.ProcessMessages;
      sl.LoadFromFile(s, TEncoding.UTF8);
      try
        for i := 0 to sl.Count-1 do
        begin
          if ContainsText(sl[i], 'FontFamily=') then
          begin
            lstProcess.Items.Add('changed:' + s);
            lstProcess.TopIndex := lstProcess.Items.Count-1;
            Application.ProcessMessages;
            sl[i] := ReplaceText(sl[i], 'MS Gothic', cmbFont.Text);
            Break;
          end
          else if ContainsText(sl[i], 'd:DesignHeight=') or ContainsText(sl[i], 'Title=') then
          begin
            lstProcess.Items.Add('changed:' + s);
            lstProcess.TopIndex := lstProcess.Items.Count-1;
            Application.ProcessMessages;
            if ContainsText(sl[i], 'FontSize') then
              sl[i] := ReplaceText(sl[i], '>', Format(' FontFamily="%s">', [cmbFont.Text]))
            else
              sl[i] := ReplaceText(sl[i], '>', Format(' FontSize="12" FontFamily="%s">', [cmbFont.Text]));
            Break;
          end;
      end;
        except
          lstProcess.Items.Add('error:' + s);
          lstProcess.TopIndex := lstProcess.Items.Count-1;
          Application.ProcessMessages;
        end;
      sl.SaveToFile(s, TEncoding.UTF8);
    end;
  finally
    sl.Free;
  end;
end;

procedure TfrmMain._LoadSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.ReadWindowPosition(Self.Name, Self);
    cmbFont.Text := ini.ReadString(Self.Name, 'FontName', 'メイリオ');
  finally
    ini.Free;
  end;
end;

procedure TfrmMain._SaveSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.WriteWindowPosition(Self.Name, Self);
    ini.WriteString(Self.Name, 'FontName', cmbFont.Text);
    ini.UpdateFile;
  finally
    ini.Free;
  end;
end;

end.
