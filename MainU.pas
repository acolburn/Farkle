unit MainU;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, {System.ImageList,}
  FMX.ImgList, DataModuleU, FMX.Layouts, System.ImageList, FMX.Effects,
  FMX.Edit, FMX.Media;

type

  TfrmMain = class(TForm)
    btnRoll: TButton;
    btnSwitch: TButton;
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
    ImageListMain: TImageList;
    Edit1: TEdit;
    GlowEffect1: TGlowEffect;
    Edit2: TEdit;
    GlowEffect2: TGlowEffect;
    GridPanelLayout1: TGridPanelLayout;
    MediaPlayer1: TMediaPlayer;
    procedure FormCreate(Sender: TObject);
    procedure btnRollClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSwitchClick(Sender: TObject);
    procedure GlyphTap(Sender: TObject);
    procedure displayText(aString: string);
  private
    fSoundPlayed: Boolean;
    procedure switchPlayer;
    procedure playFarkleSound;
    procedure continueIfAlive;
  public
    aPlayer: TPlayer;
    player1: TPlayer;
    player2: TPlayer;
    procedure initializePlayer(aPlayer: TPlayer);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses System.IOUtils;

procedure TfrmMain.btnSwitchClick(Sender: TObject);
begin
  aPlayer.turnEnded;
  displayText(aPlayer.turnEndedMessage);
  switchPlayer;
  aPlayer.resetGameBoard;
end;

procedure TfrmMain.displayText(aString: string);
begin
  if aPlayer = player1 then
    Edit1.Text := aString
  else if aPlayer = player2 then
    Edit2.Text := aString;
end;

procedure TfrmMain.btnRollClick(Sender: TObject);
begin
  fSoundPlayed := false; // only want sound once/turn, at which point -> true;
  aPlayer.startTurn;
  displayText(aPlayer.turnStartedMessage);
  continueIfAlive;
  if aPlayer.farkleCheck=true then
  begin
    playFarkleSound;
    displayText(aPlayer.name + '''s turn. This turn (Farkle): 0 pts. Game: ' +
      aPlayer.gameScore.ToString + ' pts.');
  end;
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
  aPlayer := player1;
  GlowEffect1.Enabled := true;
  aPlayer.resetGameBoard;
  Edit1.Text := player1.name;
  Edit2.Text := player2.name;

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
  temp: integer;
begin
  for i := 1 to 6 do
    // select a die
    if (aPlayer.diceCup[i].activeImage = (Sender as TGlyph)) then
    begin
      aPlayer.addDice(aPlayer.diceCup[i].value);
      aPlayer.diceCup[i].isActive := false;
      aPlayer.diceCup[i].activeImage.imageIndex := -1;
      aPlayer.diceCup[i].inactiveImage.imageIndex := aPlayer.diceCup[i]
        .imageIndex;
    end
    else if (aPlayer.diceCup[i].inactiveImage = (Sender as TGlyph)) then
    // unselect a die
    begin
      aPlayer.removeDice(aPlayer.diceCup[i].value);
      aPlayer.diceCup[i].isActive := true;
      aPlayer.diceCup[i].inactiveImage.imageIndex := -1;
      aPlayer.diceCup[i].activeImage.imageIndex := aPlayer.diceCup[i]
        .imageIndex;
    end;
  aPlayer.scoreTurn; // calculates roll score
  // display roll score for this turn
  temp := aPlayer.turnScore + aPlayer.rollScore;
  displayText(IntToStr(temp) + ' pts. this turn');
  // get excited, but only once/turn
  if (aPlayer.rollScore > 600) and (fSoundPlayed=false) then
  begin
    MediaPlayer1.FileName := TPath.Combine(TPath.GetDocumentsPath,
      'excited1.mp3');
    MediaPlayer1.Play;
    fSoundPlayed := true;
  end;
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

procedure TfrmMain.continueIfAlive;
var
  i: integer;
begin
  // Special Case: player has selected all six dice, but is still alive
  // First, find out if player's still alive
  // If player's alive, then all dice in diceCup will have been selected
  // so their .isActive property will be false.
  with aPlayer do
  begin
    if ((diceCup[1].isActive = false) and (diceCup[2].isActive = false) and
      (diceCup[3].isActive = false) and (diceCup[4].isActive = false) and
      (diceCup[5].isActive = false) and (diceCup[6].isActive = false)) then
      // make 'em all active again
      for i := 1 to 6 do
      begin
        diceCup[i].isActive := true;
        diceCup[i].inactiveImage.imageIndex := -1;
        diceCup[i].activeImage.imageIndex := diceCup[i].imageIndex;
      end;
  end;
end;

procedure TfrmMain.playFarkleSound;
var
  i: integer;
begin
  i := random(3);
  if i = 0 then
    MediaPlayer1.FileName := TPath.Combine(TPath.GetDocumentsPath,
      'farkle1.mp3')
  else if i = 1 then
    MediaPlayer1.FileName := TPath.Combine(TPath.GetDocumentsPath,
      'farkle2.mp3')
  else if i = 2 then
    MediaPlayer1.FileName := TPath.Combine(TPath.GetDocumentsPath,
      'farkle3.mp3');
  MediaPlayer1.Play;
end;

procedure TfrmMain.switchPlayer;
begin
  if (aPlayer = player1) then
  begin
    aPlayer := player2;
    GlowEffect2.Enabled := true;
    GlowEffect1.Enabled := false;
  end
  else
  begin
    aPlayer := player1;
    GlowEffect1.Enabled := true;
    GlowEffect2.Enabled := false;
  end;
end;

end.
