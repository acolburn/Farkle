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
    //fRollSum: integer;
    fScore: TScore;
  public
    diceCup: array [1 .. 6] of TDice;
    //selectedDice: TList<integer>;
    property name: string read fName write fName;
    property score: TScore read fScore write fScore;
    constructor Create(aName: string); overload;
    destructor Destroy; override;
    procedure rollCup;
    procedure reset;
    function scoreTurn: string;
    procedure addDice(aDiceValue:integer);
    procedure removeDice(aDiceValue:integer);
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
  fScore.selectedDice.Add(aDiceValue);
end;

constructor TPlayer.Create(aName: string);
begin
  inherited Create;
  fName := aName;
  //selectedDice := TList<integer>.Create;
  fScore:=TScore.Create;
end;

destructor TPlayer.Destroy;
var
  i: integer;
begin
  for i := 1 to 6 do
    diceCup[i].Free;
  //selectedDice.Free;
  fScore.Free;
  inherited;
end;

procedure TPlayer.removeDice(aDiceValue: integer);
begin
   fScore.selectedDice.Remove(aDiceValue);
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
  for i := 1 to 6 do
    if diceCup[i].isActive then
    begin
      diceCup[i].rollDice;
      diceCup[i].activeImage.imageIndex := diceCup[i].imageIndex;
    end;
  // each roll is scored separately
  fScore.selectedDice.Clear;
  // fRollSum:=0;
end;



function TPlayer.scoreTurn: string;
begin
  result:=fScore.scoreTurn;
end;

end.
