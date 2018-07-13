Unit usancaes;

Interface

Uses
  SysUtils, Classes;

Function sEncryptText(asText, asKey: AnsiString; iShift: Integer = 3): AnsiString;

Function sDecryptText(asText, asKey: AnsiString; iShift: Integer = 3): AnsiString;

Implementation

{
ID
Nama      : Sancaes (Sandi Caesar)
Versi     : 1.0
Penulis   : Arachmadi Putra Pambudi
Deskripsi : Dasar metode yang saya gunakan sangat sederhana yaitu teknik Sandi Caesar
            dengan sedikit perubahan yaitu, user dapat memasukkan kode kunci untuk mengatur map penyandiannya
Batasan   : 1. Karakter NULL / #0 diabaikan
            2. Huruf berulang diabaikan (kecuali geser = 0 yaitu banyaknya geser mengikuti panjang sandi)
Lisensi   : Gratis

EN
Name      : Sancaes (Sandi Caesar / Caesar's Password)
Version   : 1.0
Writter   : Arachmadi Putra Pambudi
Descr.    : The basic method I use is very simple, the name is Caesar Password technique
            with little change that is, the user can enter the lock code to set the encoding map
Limit     : 1. NULL Char / #0 will be ignored
            2. Repeated keycode will be ignored (except if iShift = 0 that is the number of iShift follow the length of the password)
License   : Free
}

Var
  vasMap: AnsiString;

Function fDelDup(asText: AnsiString): AnsiString;
Var
  tslFilter: TStringList;
  asTemp: AnsiString;
  ia: integer;
Begin
  tslFilter := TStringList.Create;
  tslFilter.Sorted := True;
  tslFilter.Duplicates := dupIgnore;
  For ia := 1 To Length(asText) Do
    tslFilter.Add(asText[ia]);
  asTemp := tslFilter.text;
  tslFilter.Free;
  fDelDup := StringReplace(asTemp, #13#10, '', [rfReplaceAll]);
End;

Function fGenKeyMap(asCodeBase: AnsiString): AnsiString;
Var
  acChar: ansichar;
  asCBFix, asNonCB: AnsiString;
  ia: integer;
Begin
  vasMap := '';
  For acChar := Low(AnsiChar) To High(AnsiChar) Do
    If acChar <> #0 Then
      vasMap := vasMap + acChar;
  asCBFix := fDelDup(asCodeBase);
  For ia := 1 To Length(vasMap) Do
  Begin
    If (Pos(vasMap[ia], asCBFix) = 0) Then
      asNonCB := asNonCB + vasMap[ia];
  End;
  Result := asCBFix + asNonCB;
End;

Function sEncryptText(asText, asKey: AnsiString; iShift: Integer = 3): AnsiString;
Var
  ia, ib: integer;
  asKeyMap, asResult: AnsiString;
Begin
  asResult := '';
  If iShift = 0 Then
    iShift := Length(asKey);
  asKeyMap := fGenKeyMap(asKey);
  For ia := 1 To Length(asText) Do
  Begin
    ib := Pos(asText[ia], asKeyMap) + iShift;
    If ib > Length(asKeyMap) Then
      ib := ib - Length(asKeyMap);
    asResult := asResult + asKeyMap[ib];
  End;
  sEncryptText := asResult;
End;

Function sDecryptText(asText, asKey: AnsiString; iShift: Integer = 3): AnsiString;
Var
  ia, ib: integer;
  asKeyMap, asResult: AnsiString;
Begin
  asResult := '';
  If iShift = 0 Then
    iShift := Length(asKey);
  asKeyMap := fGenKeyMap(asKey);
  For ia := 1 To Length(asText) Do
  Begin
    ib := Pos(asText[ia], asKeyMap) - iShift;
    If ib < 0 Then
      ib := ib + Length(asKeyMap);
    asResult := asResult + asKeyMap[ib];
  End;
  sDecryptText := asResult;
End;

End.

