unit Main;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils, IniFilesDX, System.IOUtils, System.Types,
  Vcl.Filectrl, Vcl.StdCtrls, SpTBXEditors, SpTBXExtEditors, Vcl.ComCtrls;

type
  TfrmMain = class(TForm)
    lstProcess: TListBox;
    pagControl: TPageControl;
    tabAdd: TTabSheet;
    tabEdit: TTabSheet;
    Label2: TLabel;
    cmbFont: TSpTBXFontComboBox;
    Label1: TLabel;
    edtFontSize: TEdit;
    btnExecute: TButton;
    Button1: TButton;
    grpFontName: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    cmbFontBefore: TSpTBXFontComboBox;
    cmbFontAfter: TSpTBXFontComboBox;
    grpFontSize: TGroupBox;
    edtAfter: TEdit;
    edtBefore: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    chkFontName: TCheckBox;
    chkFontSize: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private 宣言 }
    procedure _LoadSettings;
    procedure _SaveSettings;
    procedure _Execute;
    procedure _ExecuteReplace;
    procedure _LoadXAML;
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

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  _ExecuteReplace;
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
  _LoadXAML;
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
            begin
            	sl[i] := ReplaceText(sl[i], 'FontSize="12"', Format('FontSize="%s"', [edtFontSize.Text]));
            	sl[i] := ReplaceText(sl[i], '>', Format(' FontFamily="%s">', [cmbFont.Text]));
            end else
              sl[i] := ReplaceText(sl[i], '>', Format(' FontSize="%s" FontFamily="%s">', [edtFontSize.Text, cmbFont.Text]));
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

procedure TfrmMain._ExecuteReplace;
var
  sl : TStringList;
  ar : TStringDynArray;
  s : String;
  i : Integer;
begin
  //置換処理は、すでに Font設定が追加されていることが前提となる。
  ar := TDirectory.GetFiles(GetApplicationPath + 'EpgTimer', '*.xaml', TSearchOption.soAllDirectories);
  sl := TStringList.Create;
  try
    for s in ar do
    begin
      lstProcess.Items.Add('open:' + ExtractFileName(s));
      lstProcess.TopIndex := lstProcess.Items.Count-1;
      Application.ProcessMessages;
      sl.LoadFromFile(s, TEncoding.UTF8);
      try
        for i := 0 to sl.Count-1 do
        begin
          if ContainsText(sl[i], 'FontFamily=') then
          begin
            Application.ProcessMessages;
            //フォント名
            if chkFontName.Checked then
            begin
            	sl[i] := ReplaceText(sl[i],
                                  Format('FontFamily="%s"', [cmbFontBefore.text]),
                                  Format('FontFamily="%s"', [cmbFontAfter.text]));
              lstProcess.Items.Add('changed FontFamily:' + ExtractFileName(s));
              lstProcess.TopIndex := lstProcess.Items.Count-1;
            end;
            //フォントサイズ
            if chkFontSize.Checked then
            begin
            	sl[i] := ReplaceText(sl[i],
                                  Format('FontSize="%s"', [edtBefore.Text]),
                                  Format('FontSize="%s"', [edtAfter.Text]));
              lstProcess.Items.Add('changed FontSize:' + ExtractFileName(s));
              lstProcess.TopIndex := lstProcess.Items.Count-1;
            end;
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
    lstProcess.Items.Add('終了');
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
  finally
    ini.Free;
  end;
end;

procedure TfrmMain._LoadXAML;
var
  sl : TStringList;
  sTmp, sName, sSize : String;
begin
  sl := TStringList.Create;
  try
    sl.LoadFromFile(GetApplicationPath + 'EpgTimer\AddManualAutoAddWindow.xaml', TEncoding.UTF8);
    sTmp := CopyStr(sl.Text, 'FontSize', '>');
    if sTmp <> '' then
    begin
      SplitStringsToAandB(sTmp, ' ', sSize, sName);
      sSize := RemoveRight(RemoveLeft(sSize, 10), 1);
      sName := RemoveRight(RemoveLeft(sName, 12), 1);
      cmbFont.Text := sName;
      edtFontSize.Text := sSize;
      cmbFontBefore.Text := sName;
      edtBefore.Text := sSize;
      pagControl.Pages[0].Destroy;
    end
    else
    begin
      pagControl.Pages[1].Destroy;
    end;
  finally
    sl.Free;
  end;
end;

procedure TfrmMain._SaveSettings;
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
