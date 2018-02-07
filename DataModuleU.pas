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
  {Vcl.Controls} Generics.Collections;

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
    fRollSum: integer;
    fScore: integer;
    procedure scoreOneDice(aDice: integer);
    procedure scoreTriplet(temp: integer);
    procedure setScore;
  public
    diceCup: array [1 .. 6] of TDice;
    selectedDice: TList<integer>;
    property name: string read fName write fName;
    property score: integer read fScore write fScore;
    constructor Create(aName: string); overload;
    destructor Destroy; override;
    procedure rollCup;
    procedure reset;
    function scoreTurn: string;
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

constructor TPlayer.Create(aName: string);
begin
  inherited Create;
  fName := aName;
  selectedDice := TList<integer>.Create;
end;

destructor TPlayer.Destroy;
var
  i: integer;
begin
  for i := 1 to 6 do
    diceCup[i].Free;
  selectedDice.Free;
  inherited;
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
  selectedDice.Clear;
  // fRollSum:=0;
end;

function TPlayer.scoreTurn: string;
var
  i, temp: integer;
begin
  fRollSum := 0;
  selectedDice.Sort;
  // selectedDice.Count tells how many dice selected

  // =================================================
  if selectedDice.Count = 6 then
  begin
    // Do you have 6 of a kind?
    temp := selectedDice[0];
    if (selectedDice[1] = temp) and (selectedDice[2] = temp) and
      (selectedDice[3] = temp) and (selectedDice[4] = temp) and
      (selectedDice[5] = temp) then
    begin
      fRollSum := fRollSum + 3000;
      setScore;
      result := IntToStr(fRollSum);
      exit; // 6 of a kind matches other score catgories too...so let's not go there
    end;

    // Do you have two triplets?
    if (selectedDice[0] = selectedDice[1]) and
      (selectedDice[0] = selectedDice[2]) and (selectedDice[3] = selectedDice[4]
      ) and (selectedDice[3] = selectedDice[5]) then
    begin
      fRollSum := fRollSum + 2500;
      setScore;
      result := IntToStr(fRollSum);
      exit; // you're not going to get more ... let's go
    end;

    // Do you have 5 of a kind, with a 1,5?
    // If so, selectedDice[1] is going to be part of the 5 of a kind
    temp := selectedDice[1];
    // Do the first 5 dice match?
    if (selectedDice[0] = temp) and (selectedDice[2] = temp) and
      (selectedDice[3] = temp) and (selectedDice[4] = temp) and
      (selectedDice[5] <> temp) then
    begin
      fRollSum := fRollSum + 2000;
      setScore;
      scoreOneDice(selectedDice[5]);
      result := IntToStr(fRollSum);
      exit;
    end
    // Or do the last 5 dice match?
    else if (selectedDice[0] <> temp) and (selectedDice[2] = temp) and
      (selectedDice[3] = temp) and (selectedDice[4] = temp) and
      (selectedDice[5] = temp) then
    begin
      fRollSum := fRollSum + 2000;
      setScore;
      scoreOneDice(selectedDice[0]);
      result := IntToStr(fRollSum);
      exit;
    end;

    // Do you have a straight?
    if (selectedDice[0] = 1) and (selectedDice[1] = 2) and (selectedDice[2] = 3)
      and (selectedDice[3] = 4) and (selectedDice[4] = 5) and
      (selectedDice[5] = 6) then
    begin
      fRollSum := fRollSum + 1500;
      setScore;
      result := IntToStr(fRollSum);
      exit; // scored with all the dice...might as well move on
    end;

    // Do you have 3 pairs?
    if (selectedDice[0] = selectedDice[1]) and
      (selectedDice[2] = selectedDice[3]) and (selectedDice[4] = selectedDice[5])
    then
    begin
      fRollSum := fRollSum + 1500;
      setScore;
      result := IntToStr(fRollSum);
      exit;
    end;

    // Do you have 4 of a kind, with 1,5's?
    // Do positions 0-3 match?
    if (selectedDice[0] = selectedDice[1]) and
      (selectedDice[0] = selectedDice[2]) and (selectedDice[0] = selectedDice[3])
    then
    begin
      fRollSum := fRollSum + 1000;
      setScore;
      scoreOneDice(selectedDice[4]);
      scoreOneDice(selectedDice[5]);
      result := IntToStr(fRollSum);
      exit;
    end
    // Or do positions 1-4 match?
    else if (selectedDice[1] = selectedDice[2]) and
      (selectedDice[1] = selectedDice[3]) and (selectedDice[1] = selectedDice[4])
    then
    begin
      fRollSum := fRollSum + 1000;
      setScore;
      scoreOneDice(selectedDice[0]);
      scoreOneDice(selectedDice[5]);
      result := IntToStr(fRollSum);
      exit;
    end
    // Or do positions 2-5 match?
    else if (selectedDice[2] = selectedDice[3]) and
      (selectedDice[2] = selectedDice[4]) and (selectedDice[2] = selectedDice[5])
    then
    begin
      fRollSum := fRollSum + 1000;
      setScore;
      scoreOneDice(selectedDice[0]);
      scoreOneDice(selectedDice[1]);
      result := IntToStr(fRollSum);
      exit;
    end;

    // Do you have "4x2"?
    if (selectedDice[0] = selectedDice[1]) and
      (selectedDice[2] = selectedDice[3]) and (selectedDice[2] = selectedDice[4]
      ) and (selectedDice[2] = selectedDice[5]) then
    begin
      fRollSum := fRollSum + 1500;
      setScore;
      result := IntToStr(fRollSum);
      exit;
    end
    else if (selectedDice[0] = selectedDice[1]) and
      (selectedDice[0] = selectedDice[2]) and (selectedDice[0] = selectedDice[3]
      ) and (selectedDice[4] = selectedDice[5]) then
    begin
      fRollSum := fRollSum + 1500;
      setScore;
      result := IntToStr(fRollSum);
      exit;
    end;

    // Do you have a triplet, with 3 1,5's?
    // Do positions 0-2 match? ... Make sure 3-5 don't also match!
    if (selectedDice[0] = selectedDice[1]) and
      (selectedDice[0] = selectedDice[2]) and
      ((selectedDice[3] <> selectedDice[4]) or
      (selectedDice[4] <> selectedDice[5])) then
    begin
      scoreTriplet(selectedDice[0]);
      scoreOneDice(selectedDice[3]);
      scoreOneDice(selectedDice[4]);
      scoreOneDice(selectedDice[5]);
      result := IntToStr(fRollSum);
      exit;
    end
    // Or do positions 1-3 match?
    else if (selectedDice[1] = selectedDice[2]) and
      (selectedDice[1] = selectedDice[3]) then
    begin
      scoreTriplet(selectedDice[1]);
      scoreOneDice(selectedDice[0]);
      scoreOneDice(selectedDice[4]);
      scoreOneDice(selectedDice[5]);
      result := IntToStr(fRollSum);
      exit;
    end
    // Or do positions 2-4 match?
    else if (selectedDice[2] = selectedDice[3]) and
      (selectedDice[2] = selectedDice[4]) then
    begin
      scoreTriplet(selectedDice[2]);
      scoreOneDice(selectedDice[0]);
      scoreOneDice(selectedDice[1]);
      scoreOneDice(selectedDice[5]);
      result := IntToStr(fRollSum);
      exit;
    end
    // Or do positions 3-5 match? ... Make sure 0-2 don't also match!
    else if (selectedDice[3] = selectedDice[4]) and
      (selectedDice[3] = selectedDice[5]) and
      ((selectedDice[0] <> selectedDice[1]) or
      (selectedDice[0] <> selectedDice[2])) then
    begin
      scoreTriplet(selectedDice[3]);
      scoreOneDice(selectedDice[0]);
      scoreOneDice(selectedDice[1]);
      scoreOneDice(selectedDice[2]);
      result := IntToStr(fRollSum);
      exit;
    end;

    // Finally, check for six 5,1's
    // only time this next code should run is when there are six dice selected,
    // and fRollSum is still at 0...
    if fRollSum = 0 then
      for i := 0 to 5 do
      begin
        scoreOneDice(selectedDice[i]);
      end;

  end; // end selectedDice.Count=6
  // =================================================

  // =================================================
  if selectedDice.Count = 5 then
  // can score with 5 of a kind (2000)
  // 4 of a kind + 5,1
  // triplet + a pair of 5,1's
  // five 5,1's
  begin
    // check for 5 of a kind
    temp := selectedDice[0];
    if (selectedDice[1] = temp) and (selectedDice[2] = temp) and
      (selectedDice[3] = temp) and (selectedDice[4] = temp) then
    begin
      fRollSum := fRollSum + 2000;
      setScore;
    end;

    // check for 4 of a kind
    // if 4 of 5 dice match, then there'll be 4 of whatever's in second position
    // but also need to be sure there's a non-matching dice
    temp := selectedDice[1];
    if (selectedDice[0] = temp) and (selectedDice[2] = temp) and
      (selectedDice[3] = temp) and (selectedDice[4] <> temp) then
    begin
      fRollSum := fRollSum + 1000;
      setScore;
      scoreOneDice(selectedDice[4]); // this dice should be a 1 or a 5 for pts
    end
    else if (selectedDice[2] = temp) and (selectedDice[3] = temp) and
      (selectedDice[4] = temp) and (selectedDice[0] <> temp) then
    begin
      fRollSum := fRollSum + 1000;
      setScore;
      scoreOneDice(selectedDice[0]); // this dice should be a 1 or a 5 for pts
    end;

    // check for triplets
    // if 3 of 5 dice match, there'll be 3 of whatever's in third position
    // as well as 2 non-matching dice
    temp := selectedDice[2];
    if (selectedDice[0] = temp) and (selectedDice[1] = temp) and
      (selectedDice[3] <> temp) and (selectedDice[4] <> temp) then
    begin
      scoreTriplet(temp);
      scoreOneDice(selectedDice[3]);
      scoreOneDice(selectedDice[4]);
    end
    else if (selectedDice[1] = temp) and (selectedDice[3] = temp) and
      (selectedDice[0] <> temp) and (selectedDice[4] <> temp) then
    begin
      scoreTriplet(temp);
      scoreOneDice(selectedDice[0]);
      scoreOneDice(selectedDice[4]);
    end
    else if (selectedDice[3] = temp) and (selectedDice[4] = temp) and
      (selectedDice[0] <> temp) and (selectedDice[1] <> temp) then
    begin
      scoreTriplet(temp);
      scoreOneDice(selectedDice[0]);
      scoreOneDice(selectedDice[1]);
    end;

    // check for five 5,1's
    // only time this next code should run is when there are five dice selected,
    // and fRollSum is still at 0...
    if fRollSum = 0 then
      for i := 0 to 4 do
      begin
        scoreOneDice(selectedDice[i]);
      end;

  end; // end if selectedDice.Count=5

  // =================================================

  // =================================================
  if selectedDice.Count = 4 then
  // can score with 4 of a kind (1000),
  // triplet + a 5,1
  // four 5,1
  begin
    // check for 4 of a kind
    temp := selectedDice[0];
    if (selectedDice[1] = temp) and (selectedDice[2] = temp) and
      (selectedDice[3] = temp) then
    begin
      fRollSum := fRollSum + 1000;
      setScore;
    end;

    // check for triplets + a 5,1
    // 1st, 2nd, and 3rd dice the same, 4th dice must be 1 or 5
    // temp already assigned to selectedDice[0]
    // make sure one dice doesn't match
    if (selectedDice[1] = temp) and (selectedDice[2] = temp) and
      (selectedDice[3] <> temp) then
    begin
      scoreTriplet(temp);
      scoreOneDice(selectedDice[3]);
    end
    else
      // or 2nd, 3rd, and 4th dice the same, 1st dice must be 1 or 5
      if (selectedDice[2] = selectedDice[1]) and
        (selectedDice[3] = selectedDice[1]) and
        (selectedDice[0] <> selectedDice[1]) then
      begin
        scoreTriplet(selectedDice[1]);
        scoreOneDice(selectedDice[0]);
      end;

    // four 5,1
    // only time this next code should run is when there are four dice selected,
    // and fRollSum is still at 0...
    if fRollSum = 0 then
      for i := 0 to 3 do
      begin
        scoreOneDice(selectedDice[i]);
      end;

  end; // end if selectedDice.Count = 4
  // =================================================

  // =================================================
  if selectedDice.Count = 3 then
  // can score with a triplet, or with 1's and 5's
  begin
    // check for triplet
    if (selectedDice[0] = selectedDice[1]) and
      (selectedDice[1] = selectedDice[2]) then
    begin
      temp := selectedDice[0];
      scoreTriplet(temp);
      // for i := 0 to 2 do
      // selectedDice.Remove(temp);
    end
    else
      // no triplets, check for 1's and 5's
      for i := 0 to 2 do
      begin
        scoreOneDice(selectedDice[i]);
      end;
  end;
  // =================================================

  // =================================================
  if selectedDice.Count = 2 then
  // 1's and 5's are only ways to score
  begin
    for i := 0 to 1 do
      scoreOneDice(selectedDice[i]);
  end;
  // =================================================

  // =================================================
  if selectedDice.Count = 1 then
  begin
    scoreOneDice(selectedDice[0]);
  end;
  // =================================================

  result := IntToStr(fRollSum);
end;

procedure TPlayer.setScore;
begin
  fScore := fScore + fRollSum;
end;

procedure TPlayer.scoreTriplet(temp: integer);
begin
  case temp of
    1:
      begin
        fRollSum := fRollSum + 300;
        setScore;
      end;
    2:
      begin
        fRollSum := fRollSum + 200;
        setScore;
      end;
    3:
      begin
        fRollSum := fRollSum + 300;
        setScore;
      end;
    4:
      begin
        fRollSum := fRollSum + 400;
        setScore;
      end;
    5:
      begin
        fRollSum := fRollSum + 500;
        setScore;
      end;
    6:
      begin
        fRollSum := fRollSum + 600;
        setScore;
      end;
  end;
end;

procedure TPlayer.scoreOneDice(aDice: integer);
begin

  // a 1 or a 5 is only way to score
  begin
    if aDice = 1 then
    begin
      fRollSum := fRollSum + 100;
      setScore;
    end
    else if aDice = 5 then
    begin
      fRollSum := fRollSum + 50;
      setScore;
    end;
  end;
end;

end.
