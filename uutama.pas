unit uutama;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, shellapi, filectrl, xpman, Menus, StdCtrls, Spin, ExtCtrls, ComCtrls,
  MPlayer, inifiles;

type
  Tfutama = class(TForm)
    mp: TMediaPlayer;
    lv: TListView;
    p: TPanel;
    cb: TCheckBox;
    b: TButton;
    l: TLabel;
    se: TSpinEdit;
    b0: TButton;
    b1: TButton;
    pm: TPopupMenu;
    mi1: TMenuItem;
    mi2: TMenuItem;
    mi3: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    mi: TMenuItem;
    mi0: TMenuItem;
    t: TTimer;
    gb: TGroupBox;
    l0: TLabel;
    l2: TLabel;
    l1: TLabel;
    procedure b1Click(Sender: TObject);
    procedure miClick(Sender: TObject);
    procedure mi0Click(Sender: TObject);
    procedure mi1Click(Sender: TObject);
    procedure mi2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lvDblClick(Sender: TObject);
    procedure bClick(Sender: TObject);
    procedure b0Click(Sender: TObject);
    procedure tTimer(Sender: TObject);
    procedure cbClick(Sender: TObject);
    procedure mi3Click(Sender: TObject);
  private
    { Deklarasi hanya untuk penggunaan dalam unit ini saja }
  public
    { Deklarasi untuk penggunaan ke semua unit yang terintegerasi }
    bplay: boolean;
    sfn: string;
    ilast, iloop: integer;
  end;

var
  futama: Tfutama;

implementation

uses
  usancaes;

{$R *.dfm} //template tweaked by : Araachmadi Putra Pambudi

procedure Tfutama.b1Click(Sender: TObject);
begin
  pm.Popup(Mouse.CursorPos.X, mouse.CursorPos.Y);
end;

function ambilen(media: string): string;
var
  mp: TMediaPlayer;
  s: string;
begin
  mp := TMediaPlayer.Create(nil);
  mp.Parent := futama;
  mp.Hide;
  mp.Close;
  mp.FileName := media;
  mp.Open;
  s := IntToStr(mp.Length);
  mp.Close;
  mp.Free;
  result := s;
end;

procedure Tfutama.miClick(Sender: TObject);
var
  tod: topendialog;
  tli: tlistitem;
  i: integer;
begin
  tod := TOpenDialog.Create(nil);
  tod.Filter := 'File MP3|*.mp3|File OGG|*.ogg';
  tod.Options := [ofAllowMultiSelect];
  if tod.Execute then
  begin
    lv.DoubleBuffered := true;
    for i := 0 to tod.Files.Count - 1 do
    begin
      tli := lv.Items.Add;
      tli.Caption := ExtractFilePath(tod.Files.Strings[i]);
      tli.SubItems.Add(ExtractFileName(tod.Files.Strings[i]));
      tli.SubItems.Add(ambilen(tod.Files.Strings[i]));
      tli.SubItems.Add('0');
      Application.ProcessMessages;
    end;
  end;
  tod.Free;
end;

procedure Tfutama.mi0Click(Sender: TObject);
begin
  if lv.SelCount = 0 then
    exit
  else if MessageBox(Handle, pchar('Hapus ' + inttostr(lv.SelCount) + ' item'), 'Hapus Item', 48 + 4) = mrno then
    exit
  else
    lv.DeleteSelected;
end;

procedure Tfutama.mi1Click(Sender: TObject);
var
  tif: tinifile;
  tsd: tsavedialog;
  tsl: tstringlist;
  i: Integer;
begin
  tsd := TSaveDialog.Create(nil);
  tsd.Filter := 'File RenLoop|*.renloop';
  if tsd.Execute then
  begin
    tif := TIniFile.Create(ChangeFileExt(tsd.FileName, '.renloop'));
    tif.WriteInteger('init', 'jml', lv.Items.Count);
    for i := 0 to lv.Items.Count - 1 do
    begin
      tif.WriteString('file', inttostr(i), lv.Items.Item[i].Caption + lv.Items.Item[i].SubItems.strings[0]);
      tif.WriteString('panjang', IntToStr(i), lv.Items.Item[i].SubItems.strings[1]);
      tif.WriteString('loop', IntToStr(i), lv.Items.Item[i].SubItems.strings[2]);
    end;
    if lv.ItemIndex < 0 then
      lv.ItemIndex := 0;
    tif.WriteInteger('init', 'sel', lv.ItemIndex);
    tif.WriteInteger('init', 'wpath', lv.Columns.Items[0].Width);
    tif.WriteInteger('init', 'wjdl', lv.Columns.Items[1].Width);
    tif.WriteInteger('init', 'wpjg', lv.Columns.Items[2].Width);
    tif.WriteInteger('init', 'wpos', lv.Columns.Items[3].Width);
    tif.Free;
    tsl := tstringlist.Create;
    try
      tsl.LoadFromFile(ChangeFileExt(tsd.FileName, '.renloop'));
      tsl.Text := sEncryptText(tsl.Text, 'sayori', 2);
      tsl.SaveToFile(ChangeFileExt(tsd.FileName, '.renloop'));
    finally
      tsl.Free;
    end;
  end;
  tsd.Free;
end;

procedure Tfutama.mi2Click(Sender: TObject);
var
  tod: topendialog;
  tli: tlistitem;
  tif: tinifile;
  tsl: tstringlist;
  i, j: integer;
begin
  tod := TOpenDialog.Create(nil);
  tod.Filter := 'File RenLoop|*.renloop';
  if tod.Execute then
  begin
    if lv.Items.Count <> 0 then
      if MessageBox(Handle, 'Membuka list akan menghapus semua daftar saat ini, lanjutkan?', 'Buka List', 48 + 4) = mrno then
      begin
        tod.Free;
        Exit;
      end
      else
        tsl.Clear;
    tsl := tstringlist.Create;
    try
      tsl.LoadFromFile(tod.FileName);
      tsl.Text := sDecryptText(tsl.Text, 'sayori', 2);
      tsl.SaveToFile(tod.FileName + '$');
    finally
      tsl.Free;
    end;
    tif := TIniFile.Create(tod.FileName + '$');
    i := tif.ReadInteger('init', 'jml', 0);
    if i <> 0 then
    begin
      for j := 0 to i - 1 do
      begin
        tli := lv.Items.Add;
        tli.Caption := extractfilepath(tif.ReadString('file', IntToStr(j), '-'));
        tli.subitems.add(extractfilename(tif.ReadString('file', IntToStr(j), '-')));
        tli.SubItems.Add(tif.ReadString('panjang', IntToStr(j), '0'));
        tli.SubItems.Add(tif.ReadString('loop', IntToStr(j), '0'));
      end;
    end;
    lv.Columns.Items[0].Width := tif.ReadInteger('init', 'wpath', 100);
    lv.Columns.Items[1].Width := tif.ReadInteger('init', 'wjdl', 100);
    lv.Columns.Items[2].Width := tif.ReadInteger('init', 'wpjg', 50);
    lv.Columns.Items[3].Width := tif.ReadInteger('init', 'wpos', 50);
    lv.ItemIndex := tif.ReadInteger('init', 'sel', 0);
    lv.Items.Item[lv.ItemIndex].MakeVisible(true);
    lv.SetFocus;
    tif.Free;
    DeleteFile(tod.FileName + '$');
  end;
  tod.free;
end;

procedure Tfutama.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := MessageBox(Handle, 'Yakin mau keluar?', 'Keluar', 48 + 4) = mryes;
end;

procedure Tfutama.lvDblClick(Sender: TObject);
begin
  if not FileExists(lv.Items.Item[lv.itemindex].Caption + lv.Items.Item[lv.itemindex].SubItems.Strings[0]) then
    MessageBox(Handle, pchar('File media "' + lv.Items.Item[lv.itemindex].Caption + lv.Items.Item[lv.itemindex].SubItems.Strings[0] + '" tidak ditemukan'), 'File Tidak Ada', 16)
  else
  begin
    iloop := 0;
    mp.Close;
    mp.FileName := lv.Items.Item[lv.itemindex].Caption + lv.Items.Item[lv.itemindex].SubItems.Strings[0];
    mp.Open;
    mp.Play;
    if lv.Items.Item[lv.itemindex].SubItems.Strings[2] <> '0' then
      se.Text := lv.Items.Item[lv.itemindex].SubItems.Strings[2];
    se.MaxValue := mp.Length - 1000;
    if cb.Checked then
      t.Tag := 1
    else
      t.Tag := 0;
  end;
end;

procedure Tfutama.bClick(Sender: TObject);
begin
  if ilast <> se.Value then
  begin
    ilast := se.Value;
    mp.Position := se.Value;
    mp.Play;
  end
  else
  begin
    if mp.Mode = mpPlaying then
      mp.Stop
    else
      mp.Play;
  end;
end;

procedure Tfutama.b0Click(Sender: TObject);
begin
  lv.Items.BeginUpdate;
  lv.Items.Item[lv.itemindex].SubItems.Strings[2] := se.Text;
  lv.Items.EndUpdate;
end;

procedure Tfutama.tTimer(Sender: TObject);
begin
  if t.Tag = 1 then
  begin
    if not cb.Checked then
    begin
      mp.Stop;
      t.Tag := 0;
      iloop := 0;
    end;
    if ((mp.Position div 10) >= (mp.Length div 10)) and (mp.Mode = mpPlaying) then
    begin
      mp.Position := se.Value;
      mp.Play;
      Inc(iloop, 1);
    end;
  end;
  if mp.Mode = mpPlaying then
  begin
    l1.Caption := MinimizeName(mp.FileName, l1.Canvas, 255);
    l2.Caption := 'Pos (Loop N) : ' + inttostr(mp.Position) + ' (' + inttostr(iloop) + ')';
  end;
end;

procedure Tfutama.cbClick(Sender: TObject);
begin
  if mp.mode = mpPlaying then
    if cb.Checked then
      t.Tag := 1
    else
      t.Tag := 0;
end;

procedure Tfutama.mi3Click(Sender: TObject);
var
  tm: tmemo;
  i: integer;
begin
  tm := TMemo.Create(futama);
  tm.Parent := futama;
  tm.Hide;
  for i := 0 to lv.Items.Count - 1 do
    tm.Lines.Add('define audio.t' + changefileext(lv.Items.Item[i].SubItems.Strings[0], '') + ' = "<loop ' + floattostr(strtofloat(lv.Items.Item[i].SubItems.Strings[2]) / 1000) + '>bgm/' + lv.Items.Item[i].SubItems.Strings[0] + '"');
  tm.SelectAll;
  tm.CopyToClipboard;
  tm.Free;
  MessageBox(Handle, 'Skrip sudah dibuat dan diletakkan pada clipboard', 'RenPy: generate script', 64);
end;

end.

