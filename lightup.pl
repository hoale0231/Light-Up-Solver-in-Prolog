%%%%%%%%%% Condition is Bulb 1 %%%%%%%%%%
% Is Bulb if 4 neighbor cell is black or number cell
isBulb([X, Y], _, _) :-
	Xg is X+1, Xl is X-1, Yg is Y+1, Yl is Y-1,
	not(whiteCell([Xg, Y])),
	not(whiteCell([Xl, Y])),
	not(whiteCell([X, Yg])),
	not(whiteCell([X, Yl])).

%%%%%%%%%% Condition is Bulb 2 %%%%%%%%%%
% Check if can put Bulb in Cell
canBulbHere([X, Y], Lighted, NotBulbs, 0) :-
	member([X, Y], Lighted);
	member([X, Y], NotBulbs);
	not(whiteCell([X, Y])).
canBulbHere(_, _, _, 1).

% Check if number cell enough Bulb neighbor
isNeedBulb([X, Y, Number], Lighted, NotBulbs) :-
	Xg is X+1, canBulbHere([Xg, Y], Lighted, NotBulbs, N1),
	Xl is X-1, canBulbHere([Xl, Y], Lighted, NotBulbs, N2),
	Yg is Y+1, canBulbHere([X, Yg], Lighted, NotBulbs, N3),
	Yl is Y-1, canBulbHere([X, Yl], Lighted, NotBulbs, N4),
	Number =:= N1 + N2 + N3 + N4.

% Is Bulb if put Bulb in [X, Y] and a neighbor number cell is full
isBulb([X, Y], Lighted, NotBulbs) :- 
	Xg is X+1, numberCell([Xg, Y, Number]), isNeedBulb([Xg, Y, Number], Lighted, NotBulbs);
	Xl is X-1, numberCell([Xl, Y, Number]), isNeedBulb([Xl, Y, Number], Lighted, NotBulbs);
	Yg is Y+1, numberCell([X, Yg, Number]), isNeedBulb([X, Yg, Number], Lighted, NotBulbs);
	Yl is Y-1, numberCell([X, Yl, Number]), isNeedBulb([X, Yl, Number], Lighted, NotBulbs).

%%%%%%%%%% Condition is Bulb 3 %%%%%%%%%%
% Check if in line not have another white Cell
isNotLightedInLine([X, Y], Lighted, NotBulbs, DX, DY) :- 
	NX is X + DX, NY is Y + DY,
	not(whiteCell([NX, NY])).

isNotLightedInLine([X, Y], Lighted, NotBulbs, DX, DY) :- 
	NX is X + DX, NY is Y + DY,
	not(member([NX, NY], Lighted)), 
	not(member([NX, NY], NotBulbs)), !, fail.

isNotLightedInLine([X, Y], Lighted, NotBulbs, DX, DY) :- 
	NX is X + DX, NY is Y + DY,
	isNotLightedInLine([NX, NY], Lighted, NotBulbs, DX, DY).	

% Check if only it can light itself
isBulb([X, Y], Lighted, NotBulbs) :-
	isNotLightedInLine([X, Y], Lighted, NotBulbs, 0, 1),
	isNotLightedInLine([X, Y], Lighted, NotBulbs, 0, -1),
	isNotLightedInLine([X, Y], Lighted, NotBulbs, 1, 0),
	isNotLightedInLine([X, Y], Lighted, NotBulbs, -1, 0).

%%%%%%%%%% Condition is lighted 1 %%%%%%%%%%
% Check if a Bulb in line
isBulbInLine([X, Y], Bulbs, DX, DY) :- 
	NX is X + DX, NY is Y + DY,
	not(whiteCell([NX, NY])), !, fail.

isBulbInLine([X, Y], Bulbs, DX, DY) :- 
	NX is X + DX, NY is Y + DY,
	member([NX, NY], Bulbs).

isBulbInLine([X, Y], Bulbs, DX, DY) :- 
	NX is X + DX, NY is Y + DY,
	isBulbInLine([NX, NY], Bulbs,DX, DY).	

% Check if a cell is Lighted
isLighted([X, Y], Bulbs) :-
	isBulbInLine([X, Y], Bulbs, 0, 1);
	isBulbInLine([X, Y], Bulbs, 0, -1);
	isBulbInLine([X, Y], Bulbs, 1, 0);
	isBulbInLine([X, Y], Bulbs, -1, 0).

%%%%%%%%%% Condition is Not Bulb 1 %%%%%%%%%%
% Check if can put Bulb in Cell
isBulbHere([X, Y], Bulbs, 1) :-
	member([X, Y], Bulbs).
isBulbHere(_, _, 0).

% Check if number cell enough Bulb neighbor
isFullBulb([X, Y, Number], Bulbs) :-
	Xg is X+1, isBulbHere([Xg, Y], Bulbs, N1),
	Xl is X-1, isBulbHere([Xl, Y], Bulbs, N2),
	Yg is Y+1, isBulbHere([X, Yg], Bulbs, N3),
	Yl is Y-1, isBulbHere([X, Yl], Bulbs, N4),
	Number =:= N1 + N2 + N3 + N4.

% Is Bulb if put Bulb in [X, Y] and a neighbor number cell is full
isNotBulb([X, Y], Bulbs) :- 
	Xg is X+1, numberCell([Xg, Y, Number]), isFullBulb([Xg, Y, Number], Bulbs);
	Xl is X-1, numberCell([Xl, Y, Number]), isFullBulb([Xl, Y, Number], Bulbs);
	Yg is Y+1, numberCell([X, Yg, Number]), isFullBulb([X, Yg, Number], Bulbs);
	Yl is Y-1, numberCell([X, Yl, Number]), isFullBulb([X, Yl, Number], Bulbs).

%%%%%%%%%% Main algorithm %%%%%%%%%%
% If all whiteCell is Lighted or Bulb, end algorithm
solve([], _, _, _).
	
% If whiteCell is Lighted, put it to Lighted array
solve([[X, Y] | WhiteCells], Lighted, Bulbs, NotBulbs) :-
	isLighted([X, Y], Bulbs),
	append(Lighted, [[X, Y]], NewLighted),
	solve(WhiteCells, NewLighted, Bulbs, NotBulbs).

% If whiteCell is Lighted, put it to Lighted array
solve([[X, Y] | WhiteCells], Lighted, Bulbs, NotBulbs) :-
	isNotBulb([X, Y], Bulbs),
	append(NotBulbs, [[X, Y]], NewNotBulbs),
	append(WhiteCells, [[X, Y]], NewWhiteCells),
	solve(NewWhiteCells, Lighted, Bulbs, NewNotBulbs).

% If whiteCell is Bulb, put it to Bulbs array
solve([[X, Y] | WhiteCells], Lighted, Bulbs, NotBulbs) :-
	isBulb([X, Y], Lighted, NotBulbs),
	write(X), write(' '), write(Y), nl, 
	append(Bulbs, [[X, Y]], NewBulbs),
	solve(WhiteCells, Lighted, NewBulbs, NotBulbs).

% If not determined this cell, put it to last and determined later
solve([[X, Y] | WhiteCells], Lighted, Bulbs, NotBulbs) :-
	append(WhiteCells, [[X, Y]], NewWhiteCells),
	solve(NewWhiteCells, Lighted, Bulbs, NotBulbs).

%%%%%%%%%% Call Main funciton %%%%%%%%%%
lightup(WhiteCells) :-
	solve(WhiteCells, [], [], []).