

main:-
    write('Welcome to Pro-Wordle!'), nl,
    write('----------------------') ,nl,
    build_kb,
	play.

is_category(C):-
	word(_,C).
	
build_kb:-
    write('Please enter a word and its category on separate lines:'), nl,
	read(W),
	(W==done;
	read(C),
	assert(word(W,C)),
	build_kb).
	
categories(L):-	
   findall(C, is_category(C),L). %the_order_is_wrong
categories1(L,L1):- categories(L),remove_duplicates(L,L1).

available_length(L):- 
    word(W,_),
	atom_length(W,L).
	
pick_word(W,L,C):-
    word(W,C),
	atom_length(W,L).


correct_letters(L1,L2,CL):- 
    intersection(L2,L1,CL),
	remove_duplicates(CL,R),
	write(R).
	%helper_to_delete_duplicates
	
remove_from_set(_,[],[]).
remove_from_set(X,[X|T],L1):- remove_from_set(X,T,L1).
remove_from_set(X,[H|T],[H|L1]):- remove_from_set(X,T,L1).

remove_duplicates([],[]).
remove_duplicates([H|T],[H|L1]):-
member(H,T),!, 
remove_from_set(H,T,L2),
remove_duplicates(L2,L1).

remove_duplicates([H|T],[H|L1]):-
remove_duplicates(T,L1).	
	

correct_positions([],[],[]).	
correct_positions([H|T1],[H|T2],[H|T3]):-
	correct_positions(T1,T2,T3).
correct_positions([H1|T1],[H2|T2],PL):-
    H1\=H2,
    correct_positions(T1,T2,PL).
	
length_word(C):-
	write('Choose a length'),nl,read(N),
	((available_length(N),
	pick_word(W,N,C), 
	write('Game started. You have '), 
	N1 is N+1,
	write(N1), write(' guesses:'),nl, lengthhelper(W,N,N1,C),!);
	(write('this length does not exist'), nl,
	length_word(C))).
	
check_category:-
    read(C),
	(is_category(C),length_word(C),!; 
	write('There is no such category'),nl,
	write('Choose a category: '),nl,
	check_category).
	
noLettersIn(W,W1,N,N1):-
    atom_length(W1,F),
    F\==N,
	write('Word is not composed of '),
	write(N),
	write(' letters. Try again.'),nl,
	write('Remaining Guesses are '),
	write(N1),nl,nl,
	lengthhelper(W,N,N1,C).
	
	
lengthhelper(W,N,N1,C):-
	write('Enter a word composed of '),
	write(N),
	write(' letters: '),nl,
	read(W1),
	X is N1-1,
	(((X==0),
	write('You lost!'),!);
	((noLettersIn(W,W1,N,N1));
	(atom_chars(W,L1),
	atom_chars(W1,L2),
	((W==W1,nl,
	write('You Won!'),!);
	(write('Correct letters are: '),
	correct_letters(L1,L2,CL),nl,
	write('Correct letters in correct positions are: '),
	correct_positions(L1,L2,R),
	write(R),nl,
	write('Remaining Guesses are '),
	write(X),nl,nl,
	lengthhelper(W,N,X,C)))))).



play:-
	write('The available categories are: '),
	categories(L),
	write(L), nl,
	write('Choose a category: '),nl,
	check_category,!.