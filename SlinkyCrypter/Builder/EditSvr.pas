{*****************************************}
{    Edit Server Unit Coded By Bubzuru    }
{          http://bubzuru.info            }
{          http://evilzone.org            }
{             Thanx To Aphex              }
{*****************************************}
unit EditSvr;

interface

type
  SArray = array of string;
  TByteArray = array of Byte;
  //Loader Class
  TLoader = class(TObject)
    Settings:SArray;
    procedure LoadSettings(password:string);
  end;

  //Builder Class
  TBuilder = class(TObject)
    Settings:array[0..100] of string;
    procedure WriteSettings(filen:string;password:string);
  end;

implementation
uses
  Windows,RCx;

const
  ID = '[{#}]';

//Split String Function To Seperate Settings
function Split(const Source,Delimiter:String):SArray;
var
  iCount,iPos,iLength: Integer;
  sTemp: String;
  aSplit:SArray;
begin
  sTemp := Source;
  iCount := 0;
  iLength := Length(Delimiter) - 1;
repeat
  iPos := Pos(Delimiter, sTemp);
  if iPos = 0 then
    break
  else begin
    Inc(iCount);
    SetLength(aSplit, iCount);
    aSplit[iCount - 1] := Copy(sTemp, 1, iPos - 1);
    Delete(sTemp, 1, iPos + iLength);
  end;
until False;
  if Length(sTemp) > 0 then begin
    Inc(iCount);
    SetLength(aSplit, iCount);
    aSplit[iCount - 1] := sTemp;
  end;
    Result := aSplit;
end;

///////////////////////////////////////////
///////// Read Settings From Exe //////////
///////////////////////////////////////////
function _LoadSettings(mutex : string): string;
var
  ResourceLocation: HRSRC;
  ResourceSize: dword;
  ResourceHandle: THandle;
  ResourcePointer: pointer;
begin
  ResourceLocation := FindResource(hInstance, PChar(mutex), RT_RCDATA);
  ResourceSize := SizeofResource(hInstance, ResourceLocation);
  ResourceHandle := LoadResource(hInstance, ResourceLocation);
  ResourcePointer := LockResource(ResourceHandle);
  if ResourcePointer <> nil then
  begin
    SetLength(Result, ResourceSize - 1);
    CopyMemory(@Result[1], ResourcePointer, ResourceSize);
    FreeResource(ResourceHandle);
  end;
end;

procedure TLoader.LoadSettings(password:string);
var i:integer;
begin
  Settings  := Split(_LoadSettings(password),ID);
  for i := 0 to High(Settings) do begin
    if Settings[i] <> '' then
      Settings[i] := RC4Code(Settings[i],password);
  end;
end;
///////////////////////////////////////////


///////////////////////////////////////////
///////// Write Settings To Exe ///////////
///////////////////////////////////////////
procedure _WriteSettings(ServerFile: string; Settings: string; mutex : string);
var
  ResourceHandle: THandle;
  pwServerFile: PWideChar;
  m: pWideChar;
begin
  GetMem(pwServerFile, (Length(ServerFile) + 1) * 2);
  GetMem(m, sizeof(WideChar) * Succ(Length(mutex)));
  try
    StringToWideChar(ServerFile, pwServerFile, Length(ServerFile) * 2);
    StringToWideChar(mutex, m, Succ(Length(mutex)));
    ResourceHandle := BeginUpdateResourceW(pwServerFile, False);
    UpdateResourceW(ResourceHandle, MakeIntResourceW(10), m, 0, @Settings[1], Length(Settings) + 1);
    EndUpdateResourceW(ResourceHandle, False);
  finally
    FreeMem(pwServerFile);
  end;
end;

procedure TBuilder.WriteSettings(filen:string;password:string);
var
  Settingsn:string;
  i:integer;
begin
  for i := 0 to 100 do begin
    if Settings[i] <> '' then
     Settingsn := Settingsn + RC4Code(Settings[i],password) + ID;
  end;
  _WriteSettings(filen, Settingsn,password);
end;
///////////////////////////////////////////

end.
