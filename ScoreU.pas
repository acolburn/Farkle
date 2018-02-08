unit ScoreU;

interface

uses System.SysUtils, Generics.Collections;

type
  TScoreCalculator = class(TObject)
  private
    fRollScore: integer;
    procedure scoreOneDice(aDice: integer);
    procedure scoreTwoDice;
    procedure scoreThreeDice;
    procedure scoreTriplet(temp: integer);
    procedure scoreFourDice;
    procedure scoreFiveDice;
    procedure scoreSixDice;
  public
    selectedDice: TList<integer>;
    constructor Create;
    destructor Destroy; override;
    function scoreTurn: integer;
  end;

implementation

constructor TScoreCalculator.Create;
begin
  inherited Create;
  selectedDice := TList<integer>.Create;
end;

destructor TScoreCalculator.Destroy;
begin
  selectedDice.Free;
  inherited;
end;

function TScoreCalculator.scoreTurn: integer;
begin
  fRollScore := 0;
  selectedDice.Sort;

  case selectedDice.Count of  // selectedDice.Count tells how many dice selected
  6:scoreSixDice;
  5:scoreFiveDice;
  4:scoreFourDice;
  3:scoreThreeDice;
  2:scoreTwoDice;
  1:scoreOneDice(selectedDice[0]);
  end;

  result := fRollScore;
end;

procedure TScoreCalculator.scoreTwoDice;
var
  i: integer;
begin
  // 1's and 5's are only ways to score
  begin
    for i := 0 to 1 do
      scoreOneDice(selectedDice[i]);
  end;
end;

procedure TScoreCalculator.scoreThreeDice;
var
  i, temp: integer;
begin
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
end;

procedure TScoreCalculator.scoreTriplet(temp: integer);
begin
  case temp of
    1:
      begin
        fRollScore := fRollScore + 300;
      end;
    2:
      begin
        fRollScore := fRollScore + 200;
      end;
    3:
      begin
        fRollScore := fRollScore + 300;
      end;
    4:
      begin
        fRollScore := fRollScore + 400;
      end;
    5:
      begin
        fRollScore := fRollScore + 500;
      end;
    6:
      begin
        fRollScore := fRollScore + 600;
      end;
  end;
end;

procedure TScoreCalculator.scoreFiveDice;
var
  i, temp: integer;
begin
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
      fRollScore := fRollScore + 2000;
    end;

    // check for 4 of a kind
    // if 4 of 5 dice match, then there'll be 4 of whatever's in second position
    // but also need to be sure there's a non-matching dice
    temp := selectedDice[1];
    if (selectedDice[0] = temp) and (selectedDice[2] = temp) and
      (selectedDice[3] = temp) and (selectedDice[4] <> temp) then
    begin
      fRollScore := fRollScore + 1000;
      scoreOneDice(selectedDice[4]); // this dice should be a 1 or a 5 for pts
    end
    else if (selectedDice[2] = temp) and (selectedDice[3] = temp) and
      (selectedDice[4] = temp) and (selectedDice[0] <> temp) then
    begin
      fRollScore := fRollScore + 1000;
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
    if fRollScore = 0 then
      for i := 0 to 4 do
      begin
        scoreOneDice(selectedDice[i]);
      end;

  end; // end if selectedDice.Count=5
end;

procedure TScoreCalculator.scoreFourDice;
var
  i,temp:integer;
begin
  // can score with 4 of a kind (1000),
  // triplet + a 5,1
  // four 5,1
  begin
    // check for 4 of a kind
    temp := selectedDice[0];
    if (selectedDice[1] = temp) and (selectedDice[2] = temp) and
      (selectedDice[3] = temp) then
    begin
      fRollScore := fRollScore + 1000;
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
    if fRollScore = 0 then
      for i := 0 to 3 do
      begin
        scoreOneDice(selectedDice[i]);
      end;

  end; // end if selectedDice.Count = 4
end;

procedure TScoreCalculator.scoreOneDice(aDice: integer);
begin

  // a 1 or a 5 is only way to score
  begin
    if aDice = 1 then
    begin
      fRollScore := fRollScore + 100;
    end
    else if aDice = 5 then
    begin
      fRollScore := fRollScore + 50;
    end;
  end;
end;

procedure TScoreCalculator.scoreSixDice;
var
  temp:integer;
  i: Integer;
begin
  begin
    // Do you have 6 of a kind?
    temp := selectedDice[0];
    if (selectedDice[1] = temp) and (selectedDice[2] = temp) and
      (selectedDice[3] = temp) and (selectedDice[4] = temp) and
      (selectedDice[5] = temp) then
    begin
      fRollScore := fRollScore + 3000;
//      result := IntToStr(fRollScore);
      exit; // 6 of a kind matches other score catgories too...so let's not go there
    end;

    // Do you have two triplets?
    if (selectedDice[0] = selectedDice[1]) and
      (selectedDice[0] = selectedDice[2]) and (selectedDice[3] = selectedDice[4]
      ) and (selectedDice[3] = selectedDice[5]) then
    begin
      fRollScore := fRollScore + 2500;
//      result := IntToStr(fRollScore);
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
      fRollScore := fRollScore + 2000;
      scoreOneDice(selectedDice[5]);
//      result := IntToStr(fRollScore);
      exit;
    end
    // Or do the last 5 dice match?
    else if (selectedDice[0] <> temp) and (selectedDice[2] = temp) and
      (selectedDice[3] = temp) and (selectedDice[4] = temp) and
      (selectedDice[5] = temp) then
    begin
      fRollScore := fRollScore + 2000;
      scoreOneDice(selectedDice[0]);
//      result := IntToStr(fRollScore);
      exit;
    end;

    // Do you have a straight?
    if (selectedDice[0] = 1) and (selectedDice[1] = 2) and (selectedDice[2] = 3)
      and (selectedDice[3] = 4) and (selectedDice[4] = 5) and
      (selectedDice[5] = 6) then
    begin
      fRollScore := fRollScore + 1500;
//      result := IntToStr(fRollScore);
      exit; // scored with all the dice...might as well move on
    end;

    // Do you have 3 pairs?
    if (selectedDice[0] = selectedDice[1]) and
      (selectedDice[2] = selectedDice[3]) and (selectedDice[4] = selectedDice[5])
    then
    begin
      fRollScore := fRollScore + 1500;
//      result := IntToStr(fRollScore);
      exit;
    end;

    // Do you have 4 of a kind, with 1,5's?
    // Do positions 0-3 match?
    if (selectedDice[0] = selectedDice[1]) and
      (selectedDice[0] = selectedDice[2]) and (selectedDice[0] = selectedDice[3])
    then
    begin
      fRollScore := fRollScore + 1000;
      scoreOneDice(selectedDice[4]);
      scoreOneDice(selectedDice[5]);
//      result := IntToStr(fRollScore);
      exit;
    end
    // Or do positions 1-4 match?
    else if (selectedDice[1] = selectedDice[2]) and
      (selectedDice[1] = selectedDice[3]) and (selectedDice[1] = selectedDice[4])
    then
    begin
      fRollScore := fRollScore + 1000;
      scoreOneDice(selectedDice[0]);
      scoreOneDice(selectedDice[5]);
//      result := IntToStr(fRollScore);
      exit;
    end
    // Or do positions 2-5 match?
    else if (selectedDice[2] = selectedDice[3]) and
      (selectedDice[2] = selectedDice[4]) and (selectedDice[2] = selectedDice[5])
    then
    begin
      fRollScore := fRollScore + 1000;
      scoreOneDice(selectedDice[0]);
      scoreOneDice(selectedDice[1]);
//      result := IntToStr(fRollScore);
      exit;
    end;

    // Do you have "4x2"?
    if (selectedDice[0] = selectedDice[1]) and
      (selectedDice[2] = selectedDice[3]) and (selectedDice[2] = selectedDice[4]
      ) and (selectedDice[2] = selectedDice[5]) then
    begin
      fRollScore := fRollScore + 1500;
//      result := IntToStr(fRollScore);
      exit;
    end
    else if (selectedDice[0] = selectedDice[1]) and
      (selectedDice[0] = selectedDice[2]) and (selectedDice[0] = selectedDice[3]
      ) and (selectedDice[4] = selectedDice[5]) then
    begin
      fRollScore := fRollScore + 1500;
//      result := IntToStr(fRollScore);
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
//      result := IntToStr(fRollScore);
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
//      result := IntToStr(fRollScore);
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
//      result := IntToStr(fRollScore);
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
//      result := IntToStr(fRollScore);
      exit;
    end;

    // Finally, check for six 5,1's
    // only time this next code should run is when there are six dice selected,
    // and fRollSum is still at 0...
    if fRollScore = 0 then
      for i := 0 to 5 do
      begin
        scoreOneDice(selectedDice[i]);
      end;

  end; // end selectedDice.Count=6
end;

end.
