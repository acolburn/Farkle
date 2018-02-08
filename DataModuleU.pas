unit DataModuleU;
// TODO need to keep track of all dice selected through multiple turns
// when all six dice have been selected, player is still alive and
// they all need to be de-selected & the turn continue
// TODO Farkle?
// TODO first roll > 500

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
    property turnScore: integer read fTurnScore; // read only
    property gameScore: integer read fGameScore; // read only
    property rollScore: integer read fRollScore; //read only
    constructor Create(aName: string); overload;
    destructor Destroy; override;
    procedure rollCup;
    procedure reset;
    procedure scoreTurn;
    procedure addDice(aDiceValue: integer);
    procedure removeDice(aDiceValue: integer);
    procedure newGame;
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
end;

destructor TPlayer.Destroy;
var
  i: integer;
begin
  for i := 1 to 6 do
    diceCup[i].Free;
  // selectedDice.Free;
  fScoreCalculator.Free;
  inherited;
end;

procedure TPlayer.newGame;
begin
  fTurnScore := 0;
  fGameScore := 0;
end;

procedure TPlayer.removeDice(aDiceValue: integer);
begin
  fScoreCalculator.selectedDice.Remove(aDiceValue);
end;

procedure TPlayer.reset;
var
  i: integer;
begin
  for i := 1 to 6 do
  begin
    diceCup[i].isActive := true;
    diceCup[i].activeImage.imageIndex := 0;
    diceCup[i].inactiveImage.imageIndex := -1;
  end;
end;

procedure TPlayer.rollCup;
var
  i: integer;
begin
  fTurnScore:=fTurnScore+fRollScore;
  for i := 1 to 6 do
    if diceCup[i].isActive then
    begin
      diceCup[i].rollDice;
      diceCup[i].activeImage.imageIndex := diceCup[i].imageIndex;
    end;
  // each roll is scored separately
  fScoreCalculator.selectedDice.Clear;
end;

procedure TPlayer.scoreTurn;
begin
  fRollScore := fScoreCalculator.scoreTurn;
end;

end.
