program Farkle;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainU in 'MainU.pas' {Form1},
  DataModuleU in 'DataModuleU.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDataModule1, DM);
  Application.Run;
end.
