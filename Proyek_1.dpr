program Proyek_1;

uses
  Forms,
  uutama in 'uutama.pas' {futama},
  usancaes in 'usancaes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfutama, futama);
  Application.Run;
end.
