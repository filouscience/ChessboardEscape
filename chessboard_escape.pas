Program ChessboardEscape;

type
    Figurka = record
        id : integer;       // not used, may be useful for debugging
        typ : char;
        moving : boolean;
        moved : boolean;
        x : integer;
        y : integer;
        dist : integer;
        new_x : integer;
        new_y : integer
    end;

type
    pFigurka = ^Figurka;
    tFigArray = array of pFigurka;
    // we will declare the array dynamically for a known number of pieces
    // instead of: "var figurky : array [1..SIZE*SIZE] of pFigurka"

const
    SIZE = 6;   // board size

var
    n,t : integer;
    figurky : tFigArray;


function Distance(const typ : char; const x,y : integer): integer;
begin
    Distance := 0;
    case (typ) of
        'L' : Distance := x;
        'P' : Distance := SIZE+1-x;
        'N' : Distance := y;
        'D' : Distance := SIZE+1-y
    end
end;

function NextX(const x : integer; const typ : char): integer;
begin
    case (typ) of
        'L' : NextX := x-1;
        'P' : NextX := x+1
    else
        NextX := x
    end
end;

function NextY(const y : integer; const typ : char): integer;
begin
    case (typ) of
        'N' : NextY := y-1;
        'D' : NextY := y+1
    else
        NextY := y
    end
end;

procedure FigurkyUpdate();
var
    k : integer;
begin
    for k := 1 to n do
    begin
        figurky[k]^.dist := Distance(figurky[k]^.typ, figurky[k]^.x, figurky[k]^.y);
        figurky[k]^.moving := false;
        figurky[k]^.moved := false
    end
end;

procedure FigurkyDrop();
var
    k : integer;
begin
    for k := 1 to n do
    begin
        if figurky[k]^.dist < 1 then n := n-1
    end
end;

procedure Swap(var a,b : pointer); // arguments declared as "var" --> passing by reference
var
    f : pointer;
begin
    f := a;
    a := b;
    b := f
end;


procedure FigurkySort(); // bubble sort algorithm, descending order
var
   k,l : integer;
   swapped : boolean;
begin
    for k := 1 to n do
    begin
        swapped := false;
        for l := n downto k+1 do
        begin
            if (figurky[l]^.dist > figurky[l-1]^.dist) then
            begin
                Swap(figurky[l],figurky[l-1]);
                swapped := true
            end
        end;
        if (not swapped) then exit // no swaps were needed: the array is already sorted
    end
end;

procedure FigurkyMove(const do_it : boolean);
var
    k : integer;
begin
    for k := 1 to n do
    begin
        if (do_it and figurky[k]^.moving) then
        begin
            figurky[k]^.x := figurky[k]^.new_x;
            figurky[k]^.y := figurky[k]^.new_y;
            figurky[k]^.moved := true
        end;
        figurky[k]^.new_x := 0;
        figurky[k]^.new_y := 0;
        figurky[k]^.moving := false
    end
end;

function FigurkaAtCoord(const x,y : integer): pFigurka;
var
    k : integer;
begin
    FigurkaAtCoord := NIL;
    for k := 1 to n do
    begin
        if (((figurky[k]^.moving = true) and (figurky[k]^.new_x = x) and (figurky[k]^.new_y = y)) or
            ((figurky[k]^.moving = false) and (figurky[k]^.x = x) and (figurky[k]^.y = y))) then
        begin
            FigurkaAtCoord := figurky[k];
            exit
        end
    end
end;

procedure TryMove(const f1 : pFigurka);
var
    f2 : pFigurka;
begin
    if ((f1^.moving = true) or (f1^.moved = true)) then
    begin
        FigurkyMove(false);
        exit
    end;
    f1^.new_x := NextX(f1^.x, f1^.typ);
    f1^.new_y := NextY(f1^.y, f1^.typ);

    f2 := FigurkaAtCoord(f1^.new_x, f1^.new_y);

    f1^.moving := true;
    
    if (f2 = NIL) then
    begin
        FigurkyMove(true);
        exit
    end;
    TryMove(f2)
end;

(*
input form:
n
T x y
T x y
...

where:
n - number of pieces
T - one of four piece types (L, P, N, D)
x - piece x coord
y - piece y coord
*)
procedure FigurkyInput();
var
    i : integer;
    f : pFigurka;
begin
    ReadLn(n);
    SetLength(figurky,n);   // dynamic length of the array
    for i := 1 to n do
    begin
        New(f);
        figurky[i] := f;
        f^.id := i;
        ReadLn(f^.typ, f^.x, f^.y)
    end
end;

procedure PrintBoard();
var
    i,j : integer;
    f : pFigurka;
begin
    Write('step: ');
    WriteLn(t);
    for i := 1 to SIZE do
    begin
        for j := 1 to SIZE do
        begin
            f := FigurkaAtCoord(j,i);
            if (f = NIL) then
                Write(' - ')
            else
                Write(Concat(' ', f^.typ, ' '))
        end;
        WriteLn()
    end;
    WriteLn('##################')
end;

var
    i,j : integer;
begin
    t := 0;
    FigurkyInput();
    FigurkyUpdate();
    FigurkySort();
    PrintBoard();
    
    repeat
        t := t + 1;
        for i := 1 to n do
        begin
            j := i;
            TryMove(figurky[j])
        end;
        FigurkyUpdate();
        FigurkySort();
        FigurkyDrop();
        PrintBoard()
    until n = 0;
    
    Write('number of steps: ');
    WriteLn(t)
end.
