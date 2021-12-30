%%%%%%%%%% Condition is Bulb 1 %%%%%%%%%%
% Is Bulb if 4 neighbor cell is black or number cell
isBulb([X, Y], _) :-
	R is X+1, L is X-1, U is Y+1, D is Y-1,
	not(whiteCell([R, Y])),
	not(whiteCell([L, Y])),
	not(whiteCell([X, U])),
	not(whiteCell([X, D])).

%%%%%%%%%% Condition is Bulb 2 %%%%%%%%%%
% Check if can put Bulb in Cell
canBulbHere([X, Y], Lighted, 0) :-
	member([X, Y], Lighted);
	not(whiteCell([X, Y])).
canBulbHere(_, _, 1).

% Check if number cell enough Bulb neighbor
isNeedBulb([X, Y, Number], Lighted) :-
	R is X+1, canBulbHere([R, Y], Lighted, N1),
	L is X-1, canBulbHere([L, Y], Lighted, N2),
	U is Y+1, canBulbHere([X, U], Lighted, N3),
	D is Y-1, canBulbHere([X, D], Lighted, N4),
	Number =:= N1 + N2 + N3 + N4.

% Is Bulb if put Bulb in [X, Y] and a neighbor number cell can be satisfy
isBulb([X, Y], Lighted) :- 
	R is X+1, numberCell([R, Y, Number]), isNeedBulb([R, Y, Number], Lighted);
	L is X-1, numberCell([L, Y, Number]), isNeedBulb([L, Y, Number], Lighted);
	U is Y+1, numberCell([X, U, Number]), isNeedBulb([X, U, Number], Lighted);
	D is Y-1, numberCell([X, D, Number]), isNeedBulb([X, D, Number], Lighted).

%%%%%%%%%% Condition is Bulb 3 %%%%%%%%%%
% Check if in line not have another white Cell
isNotLightedInLine([X, Y], Lighted, DX, DY) :- 
	NX is X + DX, NY is Y + DY,
	not(whiteCell([NX, NY])).

isNotLightedInLine([X, Y], Lighted, DX, DY) :- 
	NX is X + DX, NY is Y + DY,
	not(member([NX, NY], Lighted)), !, fail.

isNotLightedInLine([X, Y], Lighted, DX, DY) :- 
	NX is X + DX, NY is Y + DY,
	isNotLightedInLine([NX, NY], Lighted, DX, DY).	

% Check if only it can light itself
isBulb([X, Y], Lighted) :-
	isNotLightedInLine([X, Y], Lighted, 0, 1),
	isNotLightedInLine([X, Y], Lighted, 0, -1),
	isNotLightedInLine([X, Y], Lighted, 1, 0),
	isNotLightedInLine([X, Y], Lighted, -1, 0).

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
	isBulbInLine([NX, NY], Bulbs, DX, DY).	

% Check if a cell is Lighted
isLighted([X, Y], Bulbs) :-
	isBulbInLine([X, Y], Bulbs, 0, 1);
	isBulbInLine([X, Y], Bulbs, 0, -1);
	isBulbInLine([X, Y], Bulbs, 1, 0);
	isBulbInLine([X, Y], Bulbs, -1, 0).

%%%%%%%%%% Condition is Lighted 2 %%%%%%%%%%
% Check if can put Bulb in Cell
isBulbHere([X, Y], Bulbs, 1) :-
	member([X, Y], Bulbs).
isBulbHere(_, _, 0).

% Check if number cell enough Bulb neighbor
isFullBulb([X, Y, Number], Bulbs) :-
	R is X+1, isBulbHere([R, Y], Bulbs, N1),
	L is X-1, isBulbHere([L, Y], Bulbs, N2),
	U is Y+1, isBulbHere([X, U], Bulbs, N3),
	D is Y-1, isBulbHere([X, D], Bulbs, N4),
	Number =:= N1 + N2 + N3 + N4.

% Is not Bulb if a neighbor number cell was full
isLighted([X, Y], Bulbs) :- 
	R is X+1, numberCell([R, Y, Number]), isFullBulb([R, Y, Number], Bulbs); 
	L is X-1, numberCell([L, Y, Number]), isFullBulb([L, Y, Number], Bulbs);
	U is Y+1, numberCell([X, U, Number]), isFullBulb([X, U, Number], Bulbs);
	D is Y-1, numberCell([X, D, Number]), isFullBulb([X, D, Number], Bulbs).

%%%%%%%%%% Main algorithm %%%%%%%%%%
% If all whiteCell is Lighted or Bulb, end algorithm
solve([], _, _).
	
% If whiteCell is Lighted, put it to Lighted array
solve([[X, Y] | WhiteCells], Lighted, Bulbs) :-
	isLighted([X, Y], Bulbs),
	append(Lighted, [[X, Y]], NewLighted),
	solve(WhiteCells, NewLighted, Bulbs).

% If whiteCell is Bulb, put it to Bulbs array
solve([[X, Y] | WhiteCells], Lighted, Bulbs) :-
	isBulb([X, Y], Lighted),
	write(X), write(' '), write(Y), nl, 
	append(Bulbs, [[X, Y]], NewBulbs),
	solve(WhiteCells, Lighted, NewBulbs).

% If not determined this cell, put it to last and determined later
solve([[X, Y] | WhiteCells], Lighted, Bulbs) :-
	append(WhiteCells, [[X, Y]], NewWhiteCells),
	solve(NewWhiteCells, Lighted, Bulbs).

%%%%%%%%%% Call Main funciton %%%%%%%%%%
lightup(WhiteCells) :-
	solve(WhiteCells, [], []).
