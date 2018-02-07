unit MainU;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, {System.ImageList,}
  FMX.ImgList, DataModuleU, FMX.Layouts, System.ImageList;

type

  TfrmMain = class(TForm)
    btnRoll: TButton;
    btnReset: TButton;
    Glyph1: TGlyph;
    Glyph2: TGlyph;
    Glyph3: TGlyph;
    Glyph4: TGlyph;
    Glyph5: TGlyph;
    Glyph6: TGlyph;
    Glyph7: TGlyph;
    Glyph8: TGlyph;
    Glyph9: TGlyph;
    Glyph10: TGlyph;
    Glyph11: TGlyph;
    Glyph12: TGlyph;
    GridPanelLayout1: TGridPanelLayout;
    ImageListMain: TImageList;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnRollClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnResetClick(Sender: TObject);
    procedure GlyphTap(Sender: TObject);
  private
    { Private declarations }
    aPlayer: TPlayer;
    player1: TPlayer;
    player2: TPlayer;
    procedure initializePlayer(aPlayer: TPlayer);
  public
    { Public declarations }

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}
{$R *.Macintosh.fmx MACOS}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TfrmMain.btnResetClick(Sender: TObject);
begin
  if (aPlayer = player1) then
    aPlayer := player2
  else
    aPlayer := player1;
  aPlayer.reset;
  Label1.Text := aPlayer.name;
end;

procedure TfrmMain.btnRollClick(Sender: TObject);
begin
  aPlayer.rollCup;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  aPlayer.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  randomize;
  player1 := TPlayer.Create('Laura');
  player2 := TPlayer.Create('Alan');
  initializePlayer(player1);
  initializePlayer(player2);
  player1.score:=0;
  player2.score:=0;

  aPlayer := player1;
  aPlayer.reset;
  Label1.Text := aPlayer.name;

  Glyph1.HitTest := true;
  Glyph1.OnClick := GlyphTap;
  Glyph2.HitTest := true;
  Glyph2.OnClick := GlyphTap;
  Glyph3.HitTest := true;
  Glyph3.OnClick := GlyphTap;
  Glyph4.HitTest := true;
  Glyph4.OnClick := GlyphTap;
  Glyph5.HitTest := true;
  Glyph5.OnClick := GlyphTap;
  Glyph6.HitTest := true;
  Glyph6.OnClick := GlyphTap;
  Glyph7.HitTest := true;
  Glyph7.OnClick := GlyphTap;
  Glyph8.HitTest := true;
  Glyph8.OnClick := GlyphTap;
  Glyph9.HitTest := true;
  Glyph9.OnClick := GlyphTap;
  Glyph10.HitTest := true;
  Glyph10.OnClick := GlyphTap;
  Glyph11.HitTest := true;
  Glyph11.OnClick := GlyphTap;
  Glyph12.HitTest := true;
  Glyph12.OnClick := GlyphTap;
end;

procedure TfrmMain.GlyphTap(Sender: TObject);
var
  i: integer;
  s:string;
begin
  for i := 1 to 6 do
  //select a die
    if (aPlayer.diceCup[i].activeImage = (Sender as TGlyph)) then
    begin
      aPlayer.selectedDice.Add(aPlayer.diceCup[i].value);
      aPlayer.diceCup[i].isActive := false;
      aPlayer.diceCup[i].activeImage.imageIndex := -1;
      aPlayer.diceCup[i].inactiveImage.imageIndex := aPlayer.diceCup[i]
        .imageIndex;
    end
    else if (aPlayer.diceCup[i].inactiveImage = (Sender as TGlyph)) then
    //unselect a die
    begin
      aPlayer.selectedDice.Remove(aPlayer.diceCup[i].value);
      aPlayer.diceCup[i].isActive := true;
      aPlayer.diceCup[i].inactiveImage.imageIndex := -1;
      aPlayer.diceCup[i].activeImage.imageIndex := aPlayer.diceCup[i]
        .imageIndex;
    end;
  s:=aPlayer.scoreTurn;
  if s<>'' then Label1.Text:=s;
end;

procedure TfrmMain.initializePlayer(aPlayer: TPlayer);
var
  i: integer;
begin
  for i := 1 to 6 do
  begin
    aPlayer.diceCup[i] := TDice.Create;
    aPlayer.diceCup[i].isActive := true;
  end;
  if (aPlayer = player1) then
  begin
    aPlayer.diceCup[1].activeImage := Glyph1;
    aPlayer.diceCup[2].activeImage := Glyph2;
    aPlayer.diceCup[3].activeImage := Glyph3;
    aPlayer.diceCup[4].activeImage := Glyph4;
    aPlayer.diceCup[5].activeImage := Glyph5;
    aPlayer.diceCup[6].activeImage := Glyph6;
    aPlayer.diceCup[1].inactiveImage := Glyph7;
    aPlayer.diceCup[2].inactiveImage := Glyph8;
    aPlayer.diceCup[3].inactiveImage := Glyph9;
    aPlayer.diceCup[4].inactiveImage := Glyph10;
    aPlayer.diceCup[5].inactiveImage := Glyph11;
    aPlayer.diceCup[6].inactiveImage := Glyph12;
  end
  else if (aPlayer = player2) then
  begin
    player2.diceCup[1].inactiveImage := Glyph1;
    player2.diceCup[2].inactiveImage := Glyph2;
    player2.diceCup[3].inactiveImage := Glyph3;
    player2.diceCup[4].inactiveImage := Glyph4;
    player2.diceCup[5].inactiveImage := Glyph5;
    player2.diceCup[6].inactiveImage := Glyph6;
    player2.diceCup[1].activeImage := Glyph7;
    player2.diceCup[2].activeImage := Glyph8;
    player2.diceCup[3].activeImage := Glyph9;
    player2.diceCup[4].activeImage := Glyph10;
    player2.diceCup[5].activeImage := Glyph11;
    player2.diceCup[6].activeImage := Glyph12;
  end;
end;

end.
