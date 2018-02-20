unit DataModuleU;
// TODO Farkle?


interface

uses
  System.SysUtils, System.Classes, {System.ImageList,}
  FMX.ImgList, {Vcl.ImgList,}
  {Vcl.Controls} Generics.Collections, ScoreU;

type
  TDataModule1 = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TDice = class(TObject)
  private
  public
    imageIndex: integer;
    value: integer;
    isActive: boolean;
    activeImage: TGlyph;
    inactiveImage: TGlyph;
    procedure rollDice;
  end;

  TPlayer = class(TObject)
  private
    fName: string;
    fScoreCalculator: TScoreCalculator;
    fTurnScore: integer;
    fGameScore: integer;
    fRollScore: integer;
  public
    diceCup: array [1 .. 6] of TDice;
    property name: string read fName write fName;
    property scoreCalculator: TScoreCalculator read fScoreCalculator
      write fScoreCalculator;
    property turnScore: integer read fTurnScore write fTurnScore;
    property gameScore: integer read fGameScore write fGameScore;
    property rollScore: integer read fRollScore write fRollScore;
    constructor Create(aName: string); overload;
    destructor Destroy; override;
    function rollCup: integer;
    procedure resetGameBoard;
    procedure scoreTurn;
    procedure addDice(aDiceValue: integer);
    procedure removeDice(aDiceValue: integer);
  end;

var
  DM: TDataModule1;

implementation

{ %CLASSGROUP 'FMX.Controls.TControl' }

{$R *.dfm}
{ TDice }

procedure TDice.rollDice;
begin
  value := random(6) + 1;
  imageIndex := value - 1;
end;

{ TPlayer }

procedure TPlayer.addDice(aDiceValue: integer);
begin
  fScoreCalculator.selectedDice.Add(aDiceValue);
end;

constructor TPlayer.Create(aName: string);
begin
  inherited Create;
  fName := aName;
  fScoreCalculator := TScoreCalculator.Create;
  fGameScore:=0;
  fTurnScore:=0;
end;

destructor TPlayer.Destroy;
var
  i: integer;
begin
  for i := 1 to 6 do
    diceCup[i].Free;
  fScoreCalculator.Free;
  inherited;
end;

procedure TPlayer.removeDice(aDiceValue: integer);
begin
  fScoreCalculator.selectedDice.Remove(aDiceValue);
end;

procedure TPlayer.resetGameBoard;
var
  i: integer;
begin
  fTurnScore := 0;
  fRollScore := 0;
  for i := 1 to 6 do
  begin
    diceCup[i].isActive := true;
    diceCup[i].activeImage.imageIndex := 0;
    diceCup[i].inactiveImage.imageIndex := -1;
  end;
end;

function TPlayer.rollCup: integer;
var
  i, farkleCheck: integer;
begin
  for i := 1 to 6 do
    if diceCup[i].isActive then
    begin
      diceCup[i].rollDice;
      diceCup[i].activeImage.imageIndex := diceCup[i].imageIndex;
    end;
  fScoreCalculator.selectedDice.Clear;
  //Check for a Farkle by running the active dice through the score calculator
  //it the score is 0, player rolled a Farkle!:
  for I := 1 to 6 do
    if diceCup[i].isActive then fScoreCalculator.selectedDice.Add(diceCup[i].value);
  farkleCheck:=fScoreCalculator.scoreTurn;
  fScoreCalculator.selectedDice.Clear;
  if farkleCheck=0 then result:=0 else result:=-1; //reserving other possible outcomes...
end;

procedure TPlayer.scoreTurn;
begin
  fRollScore := fScoreCalculator.scoreTurn;
end;

end.
