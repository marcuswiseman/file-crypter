unit RCx;

// Code written by Hagen ([url]http://www.delphipraxis.net/topic12881,15.html[/url])

// unit created by maximov 29.07.2004

interface

type 
  TRC4Context = record 
    D: array[Byte] of Byte; 
    I,J: Byte; 
  end; 
  
procedure RC4Init(var RC4: TRC4Context; const Key: String);
procedure RC4Code(var RC4: TRC4Context; const Source; var Dest; Count: Integer); overload;
function RC4Code(var RC4: TRC4Context; const Value: String): String; overload; 
function RC4Code(const Value, Password: String): String; overload; 
procedure RC4Done(var RC4: TRC4Context); 


procedure RC4Seed(const Seed: String); 
function TRC4Random: Cardinal; 

implementation

type 
  PByteArray = ^TByteArray;
  TByteArray = array[0..($FFFF shr 1)-1] of byte;

var 
  RC4Random: TRC4Context; 


function RC4Code(var RC4: TRC4Context; const Value: String): String; overload; 
var 
  Count: Integer; 
begin 
  Count := Length(Value); 
  SetLength(Result, Count); 
  RC4Code(RC4, Value[1], Result[1], Count); 
end; 

function RC4Code(const Value, Password: String): String; overload; 
var 
  RC4: TRC4Context; 
begin 
  RC4Init(RC4, Password); 
  try 
    Result := RC4Code(RC4, Value); 
  finally 
    RC4Done(RC4); 
  end; 
end; 


procedure RC4Init(var RC4: TRC4Context; const Key: String); 
var 
  R,S,T,K: Byte; 
  U,L: Integer; 
begin 
  L := Length(Key); 
  with RC4 do 
  begin 
    I := 0; 
    J := 0; 
    for S := 0 to 255 do D[S] := S; 
    R := 0; 
    U := 0; 
    for S := 0 to 255 do 
    begin 
      if U < L then K := PByteArray(Key)[U] else K := 0; 
      Inc(U); 
      if U >= L then U := 0; 

      Inc(R, D[S] + K); 
      T := D[S]; 
      D[S] := D[R]; 
      D[R] := T; 
    end; 
  end; 
end; 

procedure RC4Code(var RC4: TRC4Context; const Source; var Dest; Count: Integer); 
var 
  S: Integer; 
  T: Byte; 
begin 
  with RC4 do 
    for S := 0 to Count -1 do 
    begin 
      Inc(I); 
      T := D[I]; 
      Inc(J, T); 
      D[I] := D[J]; 
      D[J] := T; 
      Inc(T, D[I]); 
      TByteArray(Dest)[S] := TByteArray(Source)[S] xor D[T]; 
    end; 
end; 

procedure RC4Done(var RC4: TRC4Context); 
begin 
  FillChar(RC4, SizeOf(RC4), 0); 
end; 





procedure RC4Seed(const Seed: String); 
begin 
  RC4Init(RC4Random, Seed); 
end; 

function TRC4Random: Cardinal; 
type 
  PRC4Cast = ^TRC4Cast;
  TRC4Cast = record 
    FirstSBOX: Cardinal; 
  end; 

begin 
// verschlüssele die dynamsiche SBOX von RC4Random.D mit sich selber und gebe die 4 ersten Bytes 
// als Zufallswert zurück !! 
  RC4Code(RC4Random, RC4Random.D, RC4Random.D, SizeOf(RC4Random.D)); 
  Result := PRC4Cast(@RC4Random).FirstSBOX; 
end; 

initialization 
  RC4Seed('5C103319-9C6F-4F88-BBDC-752779958047'); 
  
finalization 

end.
