unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils, IniFilesDX,
  Vcl.ComCtrls, HideListView, System.IOUtils, System.Types, Vcl.StdCtrls,
  Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, Vcl.ToolWin, Vcl.Menus,
  WinApi.ShellAPI, System.UITypes, TB2Item, SpTBXItem, TB2Dock, TB2Toolbar,
  System.RegularExpressions, HideComboBox, System.Notification, SpTBXDkPanels;

type
  TListItemEx = class(TListItem)
  public
    sProgramFullPath : String;
    sJK_TXT_FullPath : String;
    sJK_JKL_FullPath : String;
    sWeekName : String;
    sGroupHeaderString : String;
    iWeekDay : Integer;
    iFileSize : UInt64;
  end;

  TfrmMain = class(TForm)
    popLvwList: TPopupMenu;
    popInformation: TMenuItem;
    popOpenJKTxt: TMenuItem;
    N1: TMenuItem;
    popOpenRecordFolder: TMenuItem;
    popOpenJKFolder: TMenuItem;
    N2: TMenuItem;
    imgX24: TImageList;
    N3: TMenuItem;
    popEraseFolders: TMenuItem;
    imgX14: TImageList;
    timRecBar: TTimer;
    SpTBXDock: TSpTBXDock;
    Toolbar1: TSpTBXToolbar;
    tbrIsWeek: TSpTBXItem;
    tbrIsGroup: TSpTBXItem;
    tbrIsExpand: TSpTBXItem;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    tbrDeleteFiles: TSpTBXItem;
    SpTBXSeparatorItem2: TSpTBXSeparatorItem;
    tbrIsDebug: TSpTBXItem;
    Toolbar2: TSpTBXToolWindow;
    lblRecCount: TLabel;
    cmbSearch: THideComboBox;
    lblSearch: TLabel;
    popRename: TMenuItem;
    timNewRec: TTimer;
    NotificationCenter: TNotificationCenter;
    Toolbar3: TSpTBXToolbar;
    SpTBXItem1: TSpTBXItem;
    SpTBXItem2: TSpTBXItem;
    SpTBXItem3: TSpTBXItem;
    SpTBXItem4: TSpTBXItem;
    popEraseJK: TMenuItem;
    lvwList: THideListView;
    lstLog: TListBox;
    splLvw: TSpTBXSplitter;
    popSetFileTime: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure lvwListCreateItemClass(Sender: TCustomListView;
      var ItemClass: TListItemClass);
    procedure lvwListDblClick(Sender: TObject);
    procedure popInformationClick(Sender: TObject);
    procedure popOpenJKTxtClick(Sender: TObject);
    procedure popOpenRecordFolderClick(Sender: TObject);
    procedure popOpenJKFolderClick(Sender: TObject);
    procedure lvwListColumnClick(Sender: TObject; Column: TListColumn);
    procedure popEraseFoldersClick(Sender: TObject);
    procedure lvwListClick(Sender: TObject);
    procedure tbrIsExpandClick(Sender: TObject);
    procedure tbrIsGroupClick(Sender: TObject);
    procedure tbrIsWeekClick(Sender: TObject);
    procedure tbrDeleteFilesClick(Sender: TObject);
    procedure tbrIsDebugClick(Sender: TObject);
    procedure cmbSearchKeyPress(Sender: TObject; var Key: Char);
    procedure popRenameClick(Sender: TObject);
    procedure timRecBarTimer(Sender: TObject);
    procedure timNewRecTimer(Sender: TObject);
    procedure popLvwListPopup(Sender: TObject);
    procedure SpTBXItem3Click(Sender: TObject);
    procedure SpTBXItem2Click(Sender: TObject);
    procedure SpTBXItem1Click(Sender: TObject);
    procedure SpTBXItem4Click(Sender: TObject);
    procedure popEraseJKClick(Sender: TObject);
    procedure lvwListCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure popSetFileTimeClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private 宣言 }
    procedure _LoadSettings;
    procedure _SaveSettings;
    function _CreateGroupHeaderString(const S: String): String;
    procedure _LoadTSFiles(const IsTitle: Boolean);
    function _GetFileSize(const S: String): String;
    procedure _CreateInformationHtml(const S: String);
    procedure _MoveRecFiles;
    function _GetWatermark(const S: String): Integer;
    function _GetJKLog_FileName(const S: String): String;
    procedure _CheckNewRecordingFile;
    function _CreateFileBodyFromOriginalFile(const Filename: String): String;
    function _SearchNicoTXT(const sTsFullPath: String): String;
    procedure _ReloadRecording;
    procedure _SaveGroupStatus;
  public
    { Public 宣言 }
    function _CreateProgramTitle(const S: String): String;
    procedure _OutputMessage(sMessage: String);
  end;

  TApplicationValues = record
    sAppPath : String;
    sRecordFolder : String;
    sJKLogFolder : String;
    sRegExp : String;
    sTVPlayer, sTVonRec : String;
    IsCollupsed : Boolean;
    bIsTitle : Boolean;
    IsDebug : Boolean;
  end;

var
  frmMain: TfrmMain;
  av : TApplicationValues;

const
  sExt : array[1..6] of String = ('.ts', '.chapter', '.logo.txt', '.ts.err', '.ts.program.txt', '.txt');

var
  slRecording : TStringList;

implementation

{$R *.dfm}

uses
  HideUtils,
  Information,
  Rename,
  SetFileTime,
  dp;

procedure TfrmMain.cmbSearchKeyPress(Sender: TObject; var Key: Char);
var
  item : TListItemEx;
begin
  if Key = Char(VK_RETURN) then
  begin
    Key := Char(0);
    cmbSearch.Text := Trim(cmbSearch.Text);
    cmbSearch.UAddItem(atTop);
    item := TListItemEx(lvwList.SearchString(cmbSearch.Text, False));
    if item <> nil then
    begin
      lvwList.ClearSelection;
    	item.Selected := True;
      item.MakeVisible(True);
    end;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  slRecording.Free;
  _SaveSettings;
  _SaveGroupStatus;
  Release;
  frmMain := nil; //フォーム名に従って書き換える
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  DisableVclStyles(Self, '');
  WriteIEVersionToRegistry;
  slRecording := TStringList.Create;
  _LoadSettings;
  _MoveRecFiles;
  lvwList.Items.BeginUpdate;
  lvwList.Groups.BeginUpdate;
  try
    _LoadTSFiles(av.bIsTitle);
    _ReloadRecording;
  finally
    lvwList.Groups.EndUpdate;
    lvwList.Items.EndUpdate;
  end;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case key of
    char(VK_ESCAPE) :
      begin
        Key := char(0);
        Close;
      end;
  end;
end;

procedure TfrmMain.lvwListClick(Sender: TObject);
var
  item : TListItemEx;
begin
  item := TListItemEx(lvwList.Selected);
  if av.IsDebug and (item <> nil) then
  begin
    _OutputMessage(Format('ProgramFullPath:%s', [item.sProgramFullPath]));
    _OutputMessage(Format('JK_TXT_FULLPATH:%s', [item.sJK_TXT_FullPath]));
    _OutputMessage(Format('JK_JKL_FULLPATH:%s', [item.sJK_JKL_FullPath]));
    _OutputMessage(Format('Weekname:%s', [item.sWeekName]));
    _OutputMessage(Format('GroupHeaderString:%s', [item.sGroupHeaderString]));
    _OutputMessage(Format('GroupID:%d', [item.GroupID]));
    _OutputMessage(Format('WeekdayIndex:%d', [item.iWeekDay]));
    _OutputMessage(Format('ImageIndex:%d', [item.ImageIndex]));
    _OutputMessage(Format('FileSize:%d', [item.iFileSize]));
    _OutputMessage(Format('ItemIndex:%d', [item.Index]));
    _OutputMessage('------- Debug Output -------');
  end;
end;

procedure TfrmMain.lvwListColumnClick(Sender: TObject; Column: TListColumn);
begin
  Case Column.Index of
    0 : lvwList.ColumnClickEx(Column, True);
    1 : lvwList.ColumnClickEx(Column, True);
    2 : lvwList.ColumnClickEx(Column, False);
    3 : lvwList.ColumnClickEx(Column, True);
    4 : lvwList.ColumnClickEx(Column, False);
  end;
  _ReloadRecording;
end;

procedure TfrmMain.lvwListCreateItemClass(Sender: TCustomListView;
  var ItemClass: TListItemClass);
begin
  ItemClass := TListItemEx;
end;

procedure TfrmMain.lvwListCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  DefaultDraw := True;

  with lvwList.Canvas do
  begin
    Brush.Style := bsSolid;
    if cdsHot in State then
    begin
      Brush.Color := $00FFF3E5;
      Font.Color  := clWindowText;
      Font.Style  := [fsUnderline];
    end
    else
    begin
      Brush.Color := clWindow;
    end;
  end;
end;

procedure TfrmMain.lvwListDblClick(Sender: TObject);
const
  STR_FORMAT = 'call "%s" %s "%s"';
  STR_ON_REC = '/fullscreen /jkdlgview chatselect /jkchatsrc ニコニコ実況,ニコニコ実況過去ログ';
  STR_PLAYER = '/fullscreen';
var
  item : TListItemEx;
  sl : TStringList;
  s, sBat : String;
begin
  item := TListItemEx(lvwList.Selected);
  if item <> nil then
  begin
    sl := TStringList.Create;
    try
      sBat := GetApplicationPath + 'ViewTV.bat';
      if item.ImageIndex >= 82 then
        s := Format(STR_FORMAT, [av.sTVonRec, STR_ON_REC, item.sProgramFullPath])
      else
        s := Format(STR_FORMAT, [av.sTVPlayer, STR_PLAYER, item.sProgramFullPath]);

      sl.Add('@echo');
      sl.Add('chcp 65001');
      sl.Add(s);
      sl.SaveToFile(sBat, TEncoding.UTF8);
    finally
      sl.Free;
    end;
    ShellExecuteW(Self.Handle, 'open', PWideChar(sBat), nil, nil, SW_MINIMIZE);
  end;
end;

procedure TfrmMain.popEraseFoldersClick(Sender: TObject);
resourcestring
  m_Deleted = ' を削除しました。';
  m_Finished = 'フォルダの整理が終わりました。';
var
  sList : TStringDynArray;
  sName : String;
  iCnt : Integer;
begin
  //まずは子フォルダの削除
  iCnt := 0;
  sList := TDirectory.GetDirectories(av.sRecordFolder, '*', TSearchOption.soAllDirectories);
  for sName in sList do
  begin
    if TDirectory.IsEmpty(sName) then
    begin
    	TDirectory.Delete(sName);
      _OutputMessage(sName + m_Deleted);
      iCnt := iCnt + 1;
    end;
  end;
  //親フォルダの削除
  sList := TDirectory.GetDirectories(av.sRecordFolder, '*', TSearchOption.soAllDirectories);
  for sName in sList do
  begin
    if TDirectory.IsEmpty(sName) then
    begin
    	TDirectory.Delete(sName);
      _OutputMessage(sName + m_Deleted);
      iCnt := iCnt + 1;
    end;
  end;
  //NicoJKLog
  sList := TDirectory.GetDirectories(av.sJKLogFolder, '*', TSearchOption.soAllDirectories);
  for sName in sList do
  begin
    if TDirectory.IsEmpty(sName) then
    begin
    	TDirectory.Delete(sName);
      _OutputMessage(sName + m_Deleted);
      iCnt := iCnt + 1;
    end;
  end;
  _OutputMessage(Format('%d個のフォルダを削除しました。', [iCnt]));
//  _OutputMessage(m_Finished);
//  ShowNotification(NotificationCenter,
//                   Self.Caption,
//                   'フォルダの整理',
//                   Format('%d個のフォルダを削除しました。', [iCnt]));
end;

procedure TfrmMain.popInformationClick(Sender: TObject);
var
  item : TListItemEx;
begin
  item := TListItemEx(lvwList.Selected);
  if item <> nil then
  begin
    _CreateInformationHtml(Item.sProgramFullPath);
//    Application.CreateForm(TfrmInformation, frmInformation);
//    frmInformation.Show;
    ShellExecuteW(Self.Handle, 'open', 'iexplore.exe', PWideChar(av.sAppPath + 'ProgramInformation.html'), nil,  SW_NORMAL);
  end;
end;

procedure TfrmMain.popLvwListPopup(Sender: TObject);
var
  item : TListItem;
begin
  popRename.Enabled := True;
  item := lvwList.Selected;
  if (item <> nil) and (item.ImageIndex in [82..107]) then
    popRename.Enabled := False;
end;

procedure TfrmMain.popOpenJKFolderClick(Sender: TObject);
var
  s : String;
begin
  s := '/e, ' + av.sJKLogFolder;
  ShellExecuteW(Self.Handle, 'OPEN', 'explorer.exe', PWideChar(s), nil, SW_NORMAL);
end;

procedure TfrmMain.popOpenJKTxtClick(Sender: TObject);
var
  item : TListItemEx;
begin
  item := TListItemEx(lvwList.Selected);
  if item <> nil then
  begin
    ShellExecuteSimple(item.sJK_TXT_FullPath);
  end;
end;

procedure TfrmMain.popOpenRecordFolderClick(Sender: TObject);
var
  item : TListItemEx;
  s : String;
begin
  item := TListItemEx(lvwList.Selected);
  if item <> nil then
  begin
  	s := '/e, ' + ExtractFilePath(item.sProgramFullPath);
    ShellExecuteW(Self.Handle, 'OPEN', 'explorer.exe', PWideChar(s), nil, SW_NORMAL);
  end;
end;

procedure TfrmMain.popRenameClick(Sender: TObject);
begin
  Application.CreateForm(TfrmRename, frmRename);
  frmRename.ShowModal;
end;

procedure TfrmMain.popSetFileTimeClick(Sender: TObject);
const
  C_DATETIME = 'YYYY/MM/DD HH:NN:SS';
var
  item : TListItemEx;
  dDateTime : TDateTime;
begin
  item := TListItemEx(lvwList.Selected);
  if item <> nil then
  begin
    dDateTime :=  TFile.GetCreationTime(item.sProgramFullPath);
    Application.CreateForm(TfrmSetFileTime, frmSetFileTime);
    frmSetFileTime.lblFilename.Caption := ExtractFileName(item.sProgramFullPath);
    frmSetFileTime.lblPath.Caption := ExtractFilePath(item.sProgramFullPath);
    frmSetFileTime.lblNowCreation.Caption := FormatDateTime(C_DATETIME, dDateTime);
    frmSetFileTime.masCreation.Text := FormatDateTime(C_DATETIME, dDateTime);
    dDateTime := TFile.GetLastWriteTime(item.sProgramFullPath);
    frmSetFileTime.lblNowUpdate.Caption := FormatDateTime(C_DATETIME, dDateTime);
    frmSetFileTime.masUpdate.Text := FormatDateTime(C_DATETIME, dDateTime);
    frmSetFileTime.Show;
  end;
end;

procedure TfrmMain.SpTBXItem1Click(Sender: TObject);
begin
  popOpenJKFolderClick(nil);
end;

procedure TfrmMain.SpTBXItem2Click(Sender: TObject);
begin
  popOpenRecordFolderClick(nil);
end;

procedure TfrmMain.SpTBXItem3Click(Sender: TObject);
begin
  popInformationClick(nil);
end;

procedure TfrmMain.SpTBXItem4Click(Sender: TObject);
begin
  popOpenJKTxtClick(nil);
end;

procedure TfrmMain.tbrIsDebugClick(Sender: TObject);
begin
  av.IsDebug := Not av.IsDebug;
end;

procedure TfrmMain.tbrIsExpandClick(Sender: TObject);
var
  i : Integer;
begin
  lvwList.Groups.BeginUpdate;
  try
    for i := 0 to lvwList.Groups.Count-1 do
    begin
      Case av.IsCollupsed of
        True : lvwList.Groups[i].State := [lgsNormal, lgsCollapsible];
        False: lvwList.Groups[i].State := [lgsCollapsed, lgsCollapsible];
      end;
    end;
    av.IsCollupsed := Not av.IsCollupsed;
  finally
    lvwList.Groups.EndUpdate;
  end;
end;

procedure TfrmMain.tbrIsGroupClick(Sender: TObject);
begin
  lvwList.GroupView := Not lvwList.GroupView;
end;

procedure TfrmMain.tbrIsWeekClick(Sender: TObject);
begin
  av.bIsTitle := Not av.bIsTitle;
  lvwList.SortOrder := soAscending;
  timRecBar.Enabled := False;
  lvwList.Items.BeginUpdate;
  lvwList.Groups.BeginUpdate;
  try
    _LoadTSFiles(av.bIsTitle);
    _ReloadRecording;
  finally
    lvwList.Groups.EndUpdate;
    lvwList.Items.EndUpdate;
  end;
end;

procedure TfrmMain.timNewRecTimer(Sender: TObject);
begin
  _CheckNewRecordingFile;
end;

procedure TfrmMain.timRecBarTimer(Sender: TObject);
var
  item : TListItemEx;
  i : Integer;
begin
  if slRecording.Count = 0 then
  begin
    timRecBar.Enabled := False;
  	Exit;
  end;
  //録画中のファイルがある場合
  for i := slRecording.Count-1 downto 0 do
  begin
    item := TListItemEx(lvwList.Items[StrToInt(slRecording[i])]);
    if item.ImageIndex = 107 then
    begin
      if IsFileOpend(item.sProgramFullPath) then
    	  item.ImageIndex := 82
      else
      begin
        item.ImageIndex := _GetWatermark(item.sProgramFullPath);
        item.SubItems[2] := _SearchNicoTXT(item.sProgramFullPath);
        item.SubItems[3] := _GetFileSize(av.sJKLogFolder + item.SubItems[2]);
        slRecording.Delete(i);
        _OutputMessage(item.sProgramFullPath + ' の録画が終了しました。');
        if slRecording.Count = 0 then
        	timRecBar.Enabled := False;
      end;
    end
    else
      item.ImageIndex := item.ImageIndex + 1;
  end;
end;

function TfrmMain._CreateProgramTitle(const S: String): String;
var
  sTmp : String;
  iPos : Integer;
begin
  sTmp := ReplaceAtoB(S, '[', ']', '');
  sTmp := RemoveFileExt(sTmp);
  iPos := PosBackText('￥', sTmp);
  if iPos > 0 then
    Result := Copy(sTmp, iPos+1, MaxInt)
  else
    Result := sTmp;
end;

function TfrmMain._GetFileSize(const S: String): String;
var
  sr : TSearchRec;
  cSize : Cardinal;
begin
  try
    if FindFirst(S, faAnyFile, sr) = 0 then
    begin
      if sr.Size > 1000 then
      begin
        cSize := sr.Size div 1000;
        Result := FormatFloat('#,##0', cSize) + ' KB';
      end else
        Result := '1 KB';
    end
    else
    begin
      Result := '';
    end;
  finally
    FindClose(sr);
  end;
end;

function TfrmMain._GetWatermark(const S: String): Integer;
const
  sMk : array[0..82] of String = ('ＫＢＣテレビ',         'ＮＨＫＥテレ１北九州', 'ＮＨＫ総合１・北九州', 'ＲＫＢ毎日放送',
                                  'ＦＢＳ福岡放送１',     'ＴＶＱ九州放送１',     'テレビ西日本１',       'ＮＨＫＢＳ１',
                                  'ＮＨＫＢＳプレミアム', 'ＢＳ日テレ',           'ＢＳ朝日１',           'ＢＳ－ＴＢＳ',
                                  'ＢＳジャパン',         'ＢＳフジ',             'ＷＯＷＯＷプライム',   'ＷＯＷＯＷライブ',
                                  'ＷＯＷＯＷシネマ',     'スターチャンネル１',   'スターチャンネル２',   'スターチャンネル３',
                                  'ＢＳ１１',             'ＴｗｅｌｌＶ',         'ＦＯＸスポーツエンタ', 'ＢＳスカパー！',
                                  'Ｊ　ＳＰＯＲＴＳ　１', 'Ｊ　ＳＰＯＲＴＳ　２', 'Ｊ　ＳＰＯＲＴＳ　３', 'Ｊ　ＳＰＯＲＴＳ　４',
                                  'イマジカＢＳ・映画',   'ＢＳ日本映画専門ｃｈ', 'ＱＶＣ',               '東映チャンネル',
                                  '衛星劇場',             '映画・ｃｈＮＥＣＯ',   'ザ・シネマ',           'ＦＯＸムービー',
                                  'ムービープラスＨＤ',   'ｓｋｙ・Ａスポーツ＋', 'ＧＡＯＲＡ',           '日テレジータス',
                                  'ゴルフネットＨＤ',     'ＳＫＹ　ＳＴＡＧＥ',   '時代劇専門ｃｈＨＤ',   'ファミリー劇場ＨＤ',
                                  'ホームドラマＣＨ',     'ＴＢＳチャンネル１',   'ＴＢＳチャンネル２',   'テレ朝チャンネル１',
                                  'テレ朝チャンネル２',   '日テレプラス',         '銀河◆歴ドラ・サスペ', 'フジテレビＯＮＥ',
                                  'フジテレビＴＷＯ',     'フジテレビＮＥＸＴ',   'スーパー！ドラマＨＤ', 'ＡＸＮ　海外ドラマ',
                                  'ＦＯＸ',               '女性ｃｈ／ＬａＬａ',   'スペシャプラス',       'スペースシャワーＴＶ',
                                  'ＭＴＶ　ＨＤ',         'エムオン！ＨＤ',       'ミュージック・エア',   '歌謡ポップス',
                                  'キッズステーション',   'カートゥーン',         'ＡＴ－Ｘ',             'ディズニージュニア',
                                  'ディスカバリー',       'アニマルプラネット',   'ヒストリーチャンネル', 'ナショジオチャンネル',
                                  '日テレＮＥＷＳ２４',   '日テレＮＥＷＳ２４',   'ＴＢＳニュースバード', 'ＢＢＣワールド',
                                  'ＣＮＮｊ',             '旅チャンネル',         '囲碁・将棋チャンネル', 'スカチャン０',
                                  'スカチャン１',         'スカチャン２',         'スカチャン３');
var
  i : Integer;
begin
  Result := -1;
  for i := 0 to High(sMk)  do
  begin
    if ContainsText(S, sMk[i]) then
    begin
    	Result := i;
      Break;
    end;
  end;
end;

procedure TfrmMain._CheckNewRecordingFile;
var
  sList : TStringDynArray;
  sl : TStringList;
  s : String;
begin
  sl := TStringList.Create;
  try
    sList := TDirectory.GetFiles(av.sRecordFolder, '*.ts');
    for s in sList do
    begin
    	if IsFileOpend(s) then
        sl.Add(s);
    end;
    //現在の録画数と新しい録画数を比較する。
    if sl.Count > slRecording.Count then
    begin
    	timRecBar.Enabled := False;
      lvwList.Items.BeginUpdate;
      lvwList.Groups.BeginUpdate;
      try
        _LoadTSFiles(av.bIsTitle);
        _ReloadRecording;
      finally
        lvwList.Groups.EndUpdate;
        lvwList.Items.EndUpdate;
      end;
    end;
  finally
    sl.Free;
  end;
end;

function TfrmMain._CreateFileBodyFromOriginalFile(const Filename: String): String;
var
  iPos : Integer;
  sTmp : String;
begin
  iPos := PosBackText('￥', Filename);
  if iPos > 0 then
    sTmp := Copy(Filename, iPos+1, MaxInt)
  else
  	sTmp := ExtractFileName(Filename);
  Result := RemoveFileExt(sTmp);//, '');
end;

function TfrmMain._CreateGroupHeaderString(const S: String): String;
var
  m : TMatch;
  sTmp, sTitle : String;
begin
  sTmp := ReplaceAtoBEx(S,
                        ['[', '【', '～'],
                        [']', '】', '～'],
                        ['',  '',   '']);
//  sExp := '[＃#♯][０-９|0-9]+|.[０-９|0-9|終]+[）話夜]|[第最].[話回音]|[①-⑳]|[▽▼]';
  m := TRegEx.Match(sTmp, av.sRegExp);
  if m.Index > 1 then
    sTitle := Copy(sTmp, 1, m.Index-1)
  else
    sTitle := sTmp;
  sTitle := ReplaceText(sTitle, '　', ' ');
  sTitle := Trim(sTitle);
  Result := sTitle;
end;

procedure TfrmMain._CreateInformationHtml(const S: String);
const
  m_Header : String = '<html>' + #13#10 +
                      '<head>番組情報</head>' + #13#10 +
                      '<body bgcolor="#FFFFFF" style="font-family: メイリオ; font-size=11pt">';
  m_Footer : String = '</body>' + #13#10 +
                      '</html>';
var
  sl : TStringList;
  i : Integer;
  sTmp, sTo : String;
begin
  sl := TStringList.Create;
  try
    sl.LoadFromFile(ChangeFileExt(S, '.ts.program.txt'), TEncoding.Default);
    for i := 0 to sl.Count-1 do
    begin
      if ContainsText(sl[i], 'http') then
      begin
        sTmp := CopyStrToEnd(sl[i], 'http', True);
        sTo := Format('<a href="%s">%s</a>', [sTmp, sTmp]);
        sl[i] := ReplaceText(sl[i], sTmp, sTo);
      end
      else if ContainsText(sl[i], 'ｈｔｔｐ') then
      begin
        sl[i] := ConvertMBENtoSBENW(sl[i]);
        sl[i] := Format('<a href="%s">%s</a>', [sl[i], sl[i]]);
      end;
    end;
    sl.Text := ReplaceText(sl.Text, #13#10, '<br>'#13#10);
    sl.Insert(0, m_Header);
    sl.Add(m_Footer);
    sl.SaveToFile(av.sAppPath + 'ProgramInformation.html', TEncoding.Default);
  finally
    sl.Free;
  end;
end;

procedure TfrmMain._LoadSettings;
var
  ini : TMemIniFile;
  i : Integer;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    for i := 0 to 4 do
      lvwList.Column[i].Width := ini.ReadInteger(Self.Name, Format('lvwList.Column[%d].Width', [i]), lvwList.Column[i].Width);
    ini.ReadWindowPosition(Self.Name, Self);
    lvwList.Height    := ini.ReadInteger(Self.Name, 'lvwList.Height', lvwList.Height);
    lvwList.GroupView := ini.ReadBool(Self.Name,    'lvwList.GroupView', lvwList.GroupView);
    Toolbar1.DockPos  := ini.ReadInteger(Self.Name, 'Toolbar1.DockPos', Toolbar1.DockPos);
    Toolbar1.DockRow  := ini.ReadInteger(Self.Name, 'Toolbar1.DockRow', Toolbar1.DockRow);
    Toolbar2.DockPos  := ini.ReadInteger(Self.Name, 'Toolbar2.DockPos', Toolbar2.DockPos);
    Toolbar2.DockRow  := ini.ReadInteger(Self.Name, 'Toolbar2.DockRow', Toolbar2.DockRow);
    Toolbar3.DockPos  := ini.ReadInteger(Self.Name, 'Toolbar3.DockPos', Toolbar3.DockPos);
    Toolbar3.DockRow  := ini.ReadInteger(Self.Name, 'Toolbar3.DockRow', Toolbar3.DockRow);
    av.sAppPath       := ExtractFilePath(Application.ExeName);
    av.sRecordFolder  := ini.ReadString(Self.Name,  'TVTestRecordedFolder', 'D:\Recorded TV\TvTest\');
    av.sJKLogFolder   := ini.ReadString(Self.Name,  'NicoJKLogFolder', 'D:\Recorded TV\TvTest\!NicoJK\');
    av.sRegExp        := ini.ReadString(Self.Name,  'RegExpression', '[＃#♯][０-９|0-9]+|.[０-９|0-9|終]+[）話夜]|[第最].[話回音]|[①-⑳]|[▽▼]');
    av.IsCollupsed    := ini.ReadBool(Self.Name,    'lvwList.Group.State', False);
    av.bIsTitle       := ini.ReadBool(Self.Name,    'CategorizeByTitle', False);
    av.IsDebug        := False;
    av.sTVPlayer      := ini.ReadString(Self.Name,  'TVPlayer', '');
    av.sTVonRec       := ini.ReadString(Self.Name,  'TVonRec', '');
    Self.Font.Name    := ini.ReadString('Font', 'FontName', '游ゴシック Medium');
    Self.Font.Size    := ini.ReadInteger('Font', 'FontSize', 10);
    if FileExists('Search.txt') then
      cmbSearch.Items.LoadFromFile('Search.txt', TEncoding.UTF8);
  finally
    ini.Free;
  end;
  Self.Caption := 'EpgTimer Recfiles Manager - Ver.' + GetFileVersion;
end;

function TfrmMain._GetJKLog_FileName(const S: String): String;
var
  sr : TSearchRec;
  sTmp : String;
begin
  sTmp := RemoveLeft(RemoveFileExt(ExtractFileName(S)), 8);
  FindFirst(Format('%s*%s*.jkl', [av.sJKLogFolder, sTmp]), faAnyFile, sr);
  try
    Result := sr.Name;
  finally
    FindClose(sr);
  end;
end;

procedure TfrmMain._LoadTSFiles(const IsTitle: Boolean);
  function _In_RemoveDate(const S: String): String;
  begin
    if Copy(S, 5, 1) = '_' then
      Result := RemoveLeft(S, 8)
    else
      Result := s;
  end;

var
  gr : TListGroup;
  item : TListItemEx;
  sList : TStringDynArray;
  sGroupList, slGrStatus : TStringList;
  i, iWeekDay, idx, iGrPos : Integer;
  iTotalSize, iSize : UInt64;
  x : String;
  sProgramName, sDate, sFileSize, sJKFullPath, sJKTxtName, sJKFileSize, sWeekName, sGroupHeader : String;
  d : TDateTime;
begin
  sGroupList := TStringList.Create;
  slGrStatus := TStringList.Create;
  try
    iTotalSize := 0;
    lvwList.Items.Clear;
    lvwList.Groups.Clear;
    sList := TDirectory.GetFiles(av.sRecordFolder, '*.*ts', TSearchOption.soAllDirectories);

    //グループの作成
    Case IsTitle of
      True :
        begin
          sGroupList.Add('000未分類');
          for x in sList do
          begin
            sProgramName := _CreateProgramTitle(ExtractFileName(x));
            sProgramName := _In_RemoveDate(sProgramName);
            sGroupHeader := _CreateGroupHeaderString(sProgramName);
            d := TFile.GetCreationTime(x);
            iWeekDay := DayOfWeek(d);
            if Not ContainsTextInStringList(sGroupList, sGroupHeader) then
              sGroupList.Add(IntToStr(iWeekDay) + FormatDateTime('HH', d) + sGroupHeader);
          end;
          sGroupList.Sort;
          //曜日を削除する
          for i := 0 to sGroupList.Count-1 do
            sGroupList[i] := RemoveLeft(sGroupList[i], 3);
        end;
      False :
        begin
          sGroupList.Add('');
          sGroupList.Add('日曜日');
          sGroupList.Add('月曜日');
          sGroupList.Add('火曜日');
          sGroupList.Add('水曜日');
          sGroupList.Add('木曜日');
          sGroupList.Add('金曜日');
          sGroupList.Add('土曜日');
        end;
    end;

    slGrStatus.LoadFromFile(av.sAppPath + 'GroupState.txt', TEncoding.UTF8);
    try

    except
      //
    end;

    for x in sGroupList do
    begin
      gr := lvwList.Groups.Add;
      gr.Header       := x;
      gr.HeaderAlign  := taCenter;
      iGrPos := ContainsTextIndexInStringList(slGrStatus, x);
      if (iGrPos > 0) and (Pos('Collapsed', slGrStatus[iGrPos]) > 0) then
        gr.State := [lgsCollapsed, lgsCollapsible]
      else
        gr.State := [lgsNormal, lgsCollapsible];
    end;

    for x in sList do
    begin
      sProgramName  := _CreateProgramTitle(ExtractFileName(x));
      sProgramName  := _In_RemoveDate(sProgramName);
      sDate         := FormatDateTime('YYYY/MM/DD HH:MM', TFile.GetCreationTime(x));
      iSize         := GetFileSize(x);
      sFileSize     := FormatFileSize(iSize, fsGB);
      sJKFullPath   := av.sJKLogFolder + _GetJKLog_FileName(x);
      sJKTxtName    := _SearchNicoTXT(sJKFullPath);
      sJKFileSize   := GetFileSizeString(av.sJKLogFolder + sJKTxtName, fsKB);
      sWeekName     := GetWeeklyJapaneseName(StrToDate(LeftStr(sDate, 10)), False);
      sGroupHeader  := _CreateGroupHeaderString(sProgramName);
      iWeekDay      := DayOfWeek(StrToDate(LeftStr(sDate, 10)));
      iTotalSize    := iTotalSize + iSize;

      item := TListItemEx(lvwList.Items.Add);
      item.Caption := sProgramName;
      item.SubItems.Add(sDate);
      item.SubItems.Add(sFileSize);
      item.SubItems.Add(sJKTxtName);
      item.SubItems.Add(sJKFileSize);
      item.sProgramFullPath := x;
      item.sJK_JKL_FullPath := sJKFullPath;
      item.sJK_TXT_FullPath := av.sJKLogFolder + sJKTxtName;
      item.sWeekName := sWeekName;
      item.sGroupHeaderString := sGroupHeader;
      item.iWeekDay := iWeekDay;
      item.iFileSize := iSize;
      if IsTitle = True then
      begin
        idx := sGroupList.IndexOf(sGroupHeader);
        if idx = -1 then
          item.GroupID := 0
        else
      	  item.GroupID := idx;
      end else
        item.GroupID := iWeekDay;

      //録画中のファイルの存否を調べる
      //録画中のファイルは必ずルートにあるので、そのファイルだけを調べる
      if PosText('￥', x) > 0 then
      begin
      	if IsFileOpend(x) then
          item.ImageIndex := 82;
      end else
        item.ImageIndex := _GetWatermark(x);
    end;

    if av.bIsTitle then
      //タイトルでグループ分けの場合
      lvwList.ColumnClickEx(lvwList.Column[1], True)
    else
      //曜日でグループ分けの場合
      lvwList.ColumnClickEx(lvwList.Column[0], True);

    lblRecCount.Caption := Format('録画件数:%d', [lvwList.Items.Count]) + ' / ' +
                           FormatFileSize(iTotalSize, fsGB);

  finally
    sGroupList.Free;
    slGrStatus.Free;
  end;
end;

procedure TfrmMain._MoveRecFiles;
  function In_IsEmptyRecFile(const sFilename: String): Boolean;
  var
    sr : TSearchRec;
  begin
    Result := False;
    FindFirst(sFilename, faAnyFile, sr);
    try
      if sr.Size = 0 then
        Result := True;
    finally
      FindClose(sr);
    end;
  end;

var
  sList : TStringDynArray;
  sName, sNew, sOld : String;
  i : Integer;
  bRecording : Boolean;
begin
  bRecording := False;
  sList := TDirectory.GetFiles(av.sRecordFolder, '*.ts');
  for sName in sList do
  begin
    if IsFileOpend(sName) then
    begin
      _OutputMessage(sName + ' は録画中です。');
      timRecBar.Enabled := True;
      bRecording := True;
    end
    else
    begin
      sOld := RemoveFileExt(sName);
      sNew := RemoveFileExt(ReplaceText(sName, '￥', '\'));
      if In_IsEmptyRecFile(sOld + '.ts') then
      begin
        MessageDlg('0バイトの録画ファイルがあります。' + #13#10 +
                    'PT3が受信できていない恐れがありますので、Windowsを再起動して下さい。',
                    '録画失敗',
                    mtWarning, [mbOK]);
//        ShowMessage('0バイトの録画ファイルがあります。' + #13#10 +
//                    'PT3が受信できていない恐れがありますので、Windowsを再起動して下さい。');
      end else
      begin
        for i := 1 to 6 do
        begin
          try
            RenameFile(sOld + sExt[i], sNew + sExt[i]);
            _OutputMessage(sOld + sExt[i] + ' をフォルダ分けしました。');
          except
            //
          end;
        end;
      end;
    end;
  end;
  if bRecording then
    ShowNotification(NotificationCenter,
                     'EpgTimer Recfiles Manager',
                     '録画中です。',
                     '録画中の番組があります。');

end;

procedure TfrmMain._OutputMessage(sMessage: String);
begin
  lstLog.Items.Add(FormatDateTime('HH:MM:SS - ', Now) + sMessage);
  lstLog.TopIndex := lstLog.Items.Count-1;
  Application.ProcessMessages;
end;

procedure TfrmMain._ReloadRecording;
var
  item : TListItemEx;
  i : Integer;
begin
  //録画中のファイルがある場合、ImageIndex値を変更する
  slRecording.Clear;
  for i := 0 to lvwList.Items.Count-1 do
  begin
    item := TListItemEx(lvwList.Items[i]);
    if item.ImageIndex in [82..107] then
    begin
      slRecording.Add(IntToStr(i));
      timRecBar.Enabled := True;
    end;
  end;
end;

procedure TfrmMain._SaveGroupStatus;
var
  gr : TListGroup;
  sl, sm : TStringList;
  i : Integer;
begin
  sl := TStringList.Create;
  sm := TStringList.Create;
  try
    for i := 0 to lvwList.Groups.Count-1 do
    begin
      gr := lvwList.Groups[i];
      sm.Clear;
      sm.Add(gr.Header);
      if lgsCollapsed in gr.State then
        sm.Add('Collapsed')
      else
        sm.Add('Expanded');
      sl.Add(sm.CommaText);
    end;
    sl.SaveToFile(av.sAppPath + 'GroupState.txt', TEncoding.UTF8);
  finally
    sl.Free;
    sm.Free;
  end;
end;

procedure TfrmMain._SaveSettings;
var
  ini : TMemIniFile;
  i : Integer;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    for i := 0 to 4 do
      ini.WriteInteger(Self.Name, Format('lvwList.Column[%d].Width', [i]), lvwList.Column[i].Width);
    ini.WriteWindowPosition(Self.Name, Self);
    ini.WriteInteger(Self.Name, 'lvwList.Height',       lvwList.Height);
    ini.WriteBool(Self.Name,    'lvwList.GroupView',    lvwList.GroupView);
    ini.WriteBool(Self.Name,    'lvwList.Group.State',  av.IsCollupsed);
    ini.WriteBool(Self.Name,    'CategorizeByTitle',    av.bIsTitle);
    ini.WriteInteger(Self.Name, 'Toolbar1.DockPos',     Toolbar1.DockPos);
    ini.WriteInteger(Self.Name, 'Toolbar1.DockRow',     Toolbar1.DockRow);
    ini.WriteInteger(Self.Name, 'Toolbar2.DockPos',     Toolbar2.DockPos);
    ini.WriteInteger(Self.Name, 'Toolbar2.DockRow',     Toolbar2.DockRow);
    ini.WriteInteger(Self.Name, 'Toolbar3.DockPos',     Toolbar3.DockPos);
    ini.WriteInteger(Self.Name, 'Toolbar3.DockRow',     Toolbar3.DockRow);
    ini.WriteString(Self.Name,  'RegExpression',        av.sRegExp);
    ini.UpdateFile;
    cmbSearch.Items.SaveToFile('Search.txt', TEncoding.UTF8);
  finally
    ini.Free;
  end;
end;

function TfrmMain._SearchNicoTXT(const sTsFullPath: String): String;
var
  sFilename, sFolder, sName, sJKL : String;
begin
  //録画直後のファイルの場合
  if PosText('￥', sTsFullPath ) > 0 then
    sFilename := ReplaceText(sTsFullPath, '￥', '\')
  else
    sFilename := sTsFullPath;

  //検索処理の開始
  sFilename := RemoveLeft(ExtractFileName(sFilename), 8);
  if sFilename = '' then
  begin
  	Result := '';
    Exit;
  end;

  sJKL := FindFile(Format('%s*%s*.jkl', [av.sJKLogFolder, RemoveFileExt(sFilename)]));
  if sJKL <> '' then
  begin
    sJKL    := ExtractFileBody(sJKL);
    sFolder := RightStr(sJKL, '[jk');
    sFolder := RemoveLeft(LeftStr(sFolder, ']'), 1);
    sName   := RightStr(sJKL, 10);
    Result  := Format('%s\%s.txt', [sFolder, sName]);
  end;
end;

procedure TfrmMain.tbrDeleteFilesClick(Sender: TObject);
resourcestring
  m_IsDeleted = '削除します。よろしいですか?';
  m_Deleted = ' を削除しました。';
  m_NotDeleted = 'を削除できませんでした。';
var
  item : TListItemEx;
  s, sName : String;
  i, j, iCnt : Integer;
  iSize : UInt64;
begin
  if MessageDlg(m_IsDeleted, '削除の確認', mtConfirmation, [mbYes, mbNo]) = mrNo then
    Exit;

  timRecBar.Enabled := False;
  timNewRec.Enabled := False;
  lvwList.Items.BeginUpdate;
  lvwList.Groups.BeginUpdate;
  try
    iCnt := 0;
    iSize := 0;
    for i := lvwList.Items.Count-1 downto 0 do
    begin
      item := TListItemEx(lvwList.Items[i]);
      if item.Selected then
      begin
        s := RemoveFileExt(item.sProgramFullPath);
        for j := 1 to 6 do
        begin
          sName := s + sExt[j];
          if DeletedFile(sName) then
          begin
            iCnt := Icnt + 1;
            _OutputMessage(sName + m_Deleted);
          end;
        end;

        //JKLog
        //未分類の場合
        sName := _CreateFileBodyFromOriginalFile(sName);
        sName := _GetJKLog_FileName(sName);
        sName := av.sJKLogFolder + sName;
        if DeletedFile(sName) then
        begin
          iCnt := Icnt + 1;
        	_OutputMessage(sName + m_Deleted);
        end
        else
          _OutputMessage(sName + m_NotDeleted);

        sName := item.sJK_TXT_FullPath;
        if DeletedFile(sName) then
        begin
          iCnt := Icnt + 1;
          _OutputMessage(sName + m_Deleted);
        end
        else
          _OutputMessage(sName + m_NotDeleted);

        //リストの削除
        item.Delete;
      end else
        iSize := iSize + item.iFileSize;
    end;
    lblRecCount.Caption := '録画件数:' + IntToStr(lvwList.Items.Count) + ' / ' +
                           FormatFileSize(iSize, fsGB);
    //通知
    _OutputMessage(IntToStr(iCnt) + '個のファイルを削除しました。');
//    ShowNotification(NotificationCenter,
//                     'EpgTimer Recfiles Manager',
//                     '削除しました。',
//                     IntToStr(iCnt) + '個のファイルを削除しました。' + #13#10 +
//                     '詳細はログウィンドウを見て下さい。');

    //録画中のファイルがある場合
    if slRecording.Count > 0 then
    begin
      timRecBar.Enabled := False;
      lvwList.SortOrder := soAscending;
      _LoadTSFiles(av.bIsTitle);
      _ReloadRecording;
    end;
  finally
    lvwList.Groups.EndUpdate;
    lvwList.Items.EndUpdate;
  end;
  timRecBar.Enabled := True;
  timNewRec.Enabled := True;
end;

procedure TfrmMain.popEraseJKClick(Sender: TObject);
var
  sTxt, sJkl : TStringDynArray;
  sName, sBody, sId, sPath : String;
  bFind : Boolean;
  iCnt : Integer;
begin
  iCnt := 0;
  sTxt := TDirectory.GetFiles(av.sJKLogFolder, '*.txt', TSearchOption.soAllDirectories);
  sJkl := TDirectory.GetFiles(av.sJKLogFolder, '*.jkl', TSearchOption.soTopDirectoryOnly);
  for sName in sTxt do
  begin
    bFind := False;
    sBody := ExtractFileBody(sName);  // 1442823101 を取得
    sId := RemoveRight(ReplaceText(ExtractFilePath(sName), av.sJKLogFolder, ''), 1);  //jk6 を取得
    for sPath in sJkl do
    begin
      if ContainsText(sPath, sBody) and ContainsText(sPath, sId) then
      begin
        bFind := True;
        Break;
      end;
    end;

    if Not bFind then
    begin
      DeleteFile(sName);
      iCnt := iCnt + 1;
      _OutputMessage(sName + 'を削除しました。');
    end;
  end;
  _OutputMessage(IntToStr(iCnt) + '個のファイルを削除しました。');
end;

end.
