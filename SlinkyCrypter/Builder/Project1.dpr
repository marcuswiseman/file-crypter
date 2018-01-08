program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

begin
  Application.Initialize;
  Application.Title := 'Slinky Builder';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
