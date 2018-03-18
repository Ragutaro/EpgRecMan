unit Rename;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, HideListView,
  System.StrUtils, IniFilesDX;

type
  TfrmRename = class(TForm)
    lnlOldname: TLabel;
    edtInput: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    lblFilename: TLabel;
    lblPreFix: TLabel;
    lblExt: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private 宣言 }
    procedure _Execute;
    procedure _LoadSettings;
    procedure _SaveSettings;
  public
    { Public 宣言 }
  end;

var
  frmRename: TfrmRename;

implementation

{$R *.dfm}

uses
  main,
  HideUtils;

procedure TfrmRename.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmRename.btnOKClick(Sender: TObject);
begin
  _Execute;
  Close;
end;

procedure TfrmRename.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _SaveSettings;
  Release;
  frmRename := nil;
end;

procedure TfrmRename.FormCreate(Sender: TObject);
var
  item : TListItemEx;
  s : String;
begin
  DisableVclStyles(Self, '');
  _LoadSettings;
  item := TListItemEx(frmMain.lvwList.Selected);
  if item <> nil then
  begin
    s := ExtractFileName(item.sProgramFullPath);
    lblFilename.Caption := ChangeFileExt(s, '');
    edtInput.Text := RemoveLeft(lblFilename.Caption, 8);
    lblPreFix.Caption := LeftStr(lblFilename.Caption, 8);
    lblExt.Caption := RightStr(s, 3);
  end;
end;

procedure TfrmRename._Execute;
var
  sr : TSearchRec;
  item : TListItemEx;
  sPath, sJKPath, sOld, sNew, sJKOld, sJKNew, sTmp, sJKDate : String;
  i, iHnd : Integer;
begin
  item    := TListItemEx(frmMain.lvwList.Selected);
  sPath   := ExtractFilePath(item.sProgramFullPath);
  sJKPath := ExtractFilePath(item.sJK_JKL_FullPath);
  sOld    := lblFilename.Caption;
  sNew    := lblPreFix.Caption + Trim(edtInput.Text);
  //変更がない場合
  if (sOld= sNew) or (sNew = '') then Exit;
  //無効文字がある場合
  if Not IsValidFileName(sNew) then
  begin
  	ShowMessage('ファイル名に使えない文字が含まれています。');
    Exit;
  end;

  //変更処理の開始
  for i := 1 to 6 do
  begin
    RenameFile(sPath + sOld + sExt[i], sPath + sNew + sExt[i]);
    frmMain._OutputMessage(sPath + sNew + sExt[i] + ' に名称変更しました。');
  end;

  //JKLの変更
  iHnd := FindFirst(sJKPath + '*' + RemoveLeft(sOld, 8) + '*.jkl', faAnyFile, sr);
  if iHnd = 0 then
  begin
    sJKDate := CopyStrToEnd(sr.Name, '[jk');
    sJKOld := sJKPath + sr.Name;
    sJKNew := sJKPath + LeftStr(sr.Name, 8) + Trim(edtInput.Text) + sJKDate;
    RenameFile(sJKOld, sJKNew);
    frmMain._OutputMessage(sJKNew + ' に名称変更しました。');
  end;
  //ListViewの更新
  sTmp := frmMain._CreateProgramTitle(sNew);
  if PosText('_', sTmp) = 5 then
    sTmp := RemoveLeft(sTmp, 8);
  item.Caption := sTmp;
  item.sProgramFullPath := sPath + sNew + '.ts';
  item.sJK_JKL_FullPath := sJKNew;
  //通知
  ShowNotification(frmMain.NotificationCenter,
                   Self.Caption,
                   'ファイル名の変更',
                   edtInput.Text + ' に変更しました。');
end;

procedure TfrmRename._LoadSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.ReadWindow(Self.Name, Self);
    Self.Font.Name := ini.ReadString('Font', 'FontName', '游ゴシック Medium');
    Self.Font.Size := ini.ReadInteger('Font', 'FontSize', 9);
  finally
    ini.Free;
  end;
end;

procedure TfrmRename._SaveSettings;
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

end.
