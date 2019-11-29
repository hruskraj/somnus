:- dynamic(current_position/1).
:- dynamic(inventory/1).
:- dynamic(item_position/2).
:- dynamic(locked/2).
:- dynamic(teleport_to/1).
:- dynamic(enemy_position/2).
:- dynamic(health/1).
:- dynamic(hidden/1).
:- initialization(init).

init :- nl, info.

%current_position(-Room) - returns Room in which the player currently is
current_position(1).

%hidden(-Room) - returns the hidden Room which is hidden
hidden(14).

%inventory(-Item) :- returns current Item in inventory
inventory(1).

%health(-HP) :- returns current Health Points of the player
health(3).

%teleport_to(-Room) - returns the Room to which player will teleport 
teleport_to(10).

%locked(+Room, -ItemNeeded) - returns which Room is locked and which Item you need to open it
locked(9, 3).
locked(16, 4).

%change_position(+X, +Y) - changes the position from X to Y and prints description of new room
change_position(_, _) :- health(HP), HP = 0, end_game, !.
change_position(X, Y) :- enemy_encounter(Y); true, asserta(current_position(Y)), retract(current_position(X)), room_transition(Y).

%room_west(+X, -Y) - returns the room Y which is to the west of room X
room_west(1, 2).
room_west(4, 1).
room_west(5, 4).
room_west(6, 5).
room_west(7, 6).
room_west(8, 7).
room_west(10, 11).
room_west(12, 8).
room_west(15, 13).
room_west(16, 15).
room_west(19, 20).
room_west(21, 18).
room_west(22, 17).
%room_north(+X, -Y) - returns the room Y which is to the north of room X
room_north(2, 3).
room_north(9, 6).
room_north(10, 9).
room_north(12, 13).
room_north(13, 14).
room_north(16, 18).
room_north(17, 16).
room_north(19, 21).
room_north(22, 19).
%room_south(+X, -Y) - returns the room Y which is to the south of room X
room_south(X, Y) :- room_north(Y, X).
%room_east(+X, -Y) - returns the room Y which is to the east of room X
room_east(X, Y) :- room_west(Y, X).

%room_transition(+X) - writes the text which is shown upon entering the room X
room_transition(X) :- room_description(X), room_item(X); true, player_description, room_layout(X).

%info - writes the information about current room
info :- end_game, write('Game is over!\n'), !.
info :- current_position(X), room_transition(X).

%room_description(+X) - writes the description of the room X
room_description(1) :- write('You are in the entrance of the castle. It\'s cold in here.\n'),
                         write('There is a mirror opposite of the entrance door.\n'), !.
room_description(2) :- write('You are in a small room. There are torches burning on the walls.\n'),
                         write('This was supposed to be abandoned place so you are suprised that they are lit.\n'), !.
room_description(3) :- write('You are in a room which seems to be an armory. There is an armor stand with a shiny armor.\n'),
                         write('There are some weapons on the ground but they are mostly useless.\n'), !.
room_description(4) :- write('There is a dead adventurer laying on the ground. It seems that he wasn\'t so lucky...\n'), !.
room_description(5) :- write('There is a coffin in the middle of the room.\nThere are some bottles with a red liquid next to the coffin.\n'), !.
room_description(6) :- write('You are in a room with terrible smell coming from the south.\nIt smells worse than stables of your brother!\n'), !.
room_description(7) :- write('For a moment you are blinded by the light. You have finally found some room with the windows.\n'),
                         write('There is a pile of ashes near the window.\n'), !.
room_description(8) :- write('There is another adventurer! But he is also dead.\n'),
                         write('Or at least you can assume that since his head is missing.\n'), !.
room_description(9) :- write('Now you now why it smelled so badly - you are in the sewers!\n'), !.
room_description(10) :- write('There seems to be some kind of book. The title says TELEPORTATION FOR DUMMIES.\n'), !.
room_description(11) :- write('You are in the deepest part of the sewers. You can\'t go any further from there.\n'), !.
room_description(12) :- write('You are in a dining room. There is a huge table with some chairs.\nSadly, there is no food left.\n'), !.
room_description(13) :- write('You are in a library. There are some scratches in front of a bookshelf.\n'), !.
room_description(14) :- write('There isn\'t much in this room. In the middle there is a pedestal.\nIt\'s there to keep the mightiest weapon.\n'), !.
room_description(15) :- write('There is a dead person laying on the ground.\nIt doesn\'t even suprise you anymore.\n'),
                          write('There is a lot happening in this so called "abandoned place"...\n'), !.
room_description(16) :- write('You are in a T-shaped room. You can see the elixir right in front of you!\nBut it\'s in a different room...\n'), !.
room_description(17) :- write('You are in the long corridor. There are paintings on the wall.\nOne of the paintings is clearly missing.\n'), !.
room_description(18) :- write('You are in the long corridor. There are paintings on the wall.\n'), !.
room_description(19) :- write('You are in the big hall. You feel that you are close to the end.\n'), !.
room_description(20) :- write('You have made it! Now your wife is safe.\n'), !.
room_description(21) :- write('You are in the tower. You can see some cannons pointing outside.\n'), !.
room_description(22) :- write('You are in the destroyed tower. You must be careful not to fall down.\n'), !.
room_description(X) :- write(X), nl.

%room_item(+X) - writes the name of an item which is in the room X
room_item(X) :- item_position(Item, X), item_name(Item, Name),
                 format('There is a/an ~w laying on the ground.\n', [Name]), fail.

%room_layout(+X) - writes the layout of the doors in the room X
room_layout(X) :- door_north(X); true, door_east(X); true, door_south(X); true, door_west(X); true.
door_north(9) :- write('There is blue door to the north [unlocked].\n'), !, fail.
door_north(13) :- hidden(14), !, fail.
door_north(13) :- write('There is secret door to the north [revealed].\n'), !, fail.
door_north(X) :- room_north(X, _), write('There is door to the north.\n'), fail.
door_south(6) :- locked(9, _), write('There is blue door to the south [locked].\n'), !, fail.
door_south(6) :- write('There is blue door to the south [unlocked].\n'), !, fail.
door_south(X) :- room_south(X, _), write('There is door to the south.\n'), fail.
door_east(15) :- locked(16, _), write('There is red door to the east [locked].\n'), !, fail.
door_east(15) :- write('There is red door to the east [unlocked].\n'), !, fail.
door_east(X) :- room_east(X, _), write('There is door to the east.\n'), fail.
door_west(16) :- write('There is red door to the west [unlocked].\n'), !, fail.
door_west(X) :- room_west(X, _), write('There is door to the west.\n'), fail.

%north - If there is a room to the north of the current room then it changes current position to that room.
%        Otherwise, it prints that there is no room to the north.
north :- end_game, write('Game is over!\n'), !.
north :- current_position(X), room_north(X, Y), \+ hidden(Y), change_position(X, Y), !.
north :- write('There is no room to the north.').

%south - If there is a room to the south of the current room then it changes current position to that room.
%        Otherwise, it prints that there is no room to the south.
south :- end_game, write('Game is over!\n'), !.
south :- current_position(6), room_south(6, Y), locked(Y, Item), inventory(Item), retract(locked(Y, Item)),
          retract(inventory(Item)), change_position(6, Y), !.
south :- current_position(6), room_south(6, Y), locked(Y, _), write('You don\'t have the key!\n'), !.
south :- current_position(X), room_south(X, Y), change_position(X, Y), !.
south :- write('There is no room to the south.').

%west - If there is a room to the west of the current room then it changes current position to that room.
%        Otherwise, it prints that there is no room to the west.
west :- end_game, write('Game is over!\n'), !.
west :- current_position(X), room_west(X, Y), change_position(X, Y), !.
west :- write('There is no room to the west.').

%east - If there is a room to the east of the current room then it changes current position to that room.
%        Otherwise, it prints that there is no room to the east.
east :- end_game, write('Game is over!\n'), !.
east :- current_position(15), room_east(15, Y), locked(Y, Item), inventory(Item),
         retract(locked(Y, Item)), retract(inventory(Item)), change_position(15, Y), !.
east :- current_position(15), room_east(15, Y), locked(Y, _), write('You don\'t have the key!\n'), !.
east :- current_position(X), room_east(X, Y), change_position(X, Y), !.
east :- write('There is no room to the east.').

%item_position(+Item, -Room) :- returns the room in which item is stored
item_position(2, 3).
item_position(3, 2).
item_position(4, 12).
item_position(5, 10).
item_position(6, 8).
item_position(7, 14).
item_position(8, 11).
item_position(9, 5).
item_position(9, 7).
item_position(9, 16).
item_position(9, 18).
item_position(10, 20).

%item_name(+X, -Name) - returns the name of item X
item_name(1, 'letter').
item_name(2, 'rusty sword').
item_name(3, 'blue key').
item_name(4, 'red key').
item_name(5, 'teleport rune').
item_name(6, 'mace').
item_name(7, 'dragonslayer').
item_name(8, 'painting').
item_name(9, 'health potion').
item_name(10, 'elixir of life').

%player_description - writes information about player
player_description :- health_description, inventory_description.

%health_description - writes information about player's health
health_description :- health(3), write('You have full health.\n'), !.
health_description :- health(HP), format('You have ~d health points.\n', [HP]).

%inventory_description - writes the content of player's inventory
inventory_description :- inventory(Item), item_name(Item, Name), format('You have ~w in your inventory.\n', [Name]), !.
inventory_description :- write('You don\'t have anything in your inventory.\n').

%take - Takes an item from the current room and places it in inventory.
%       If there is no item here then notifies the player.
%       If player has something in inventory then it replaces the items.
take :- end_game, write('Game is over!\n'), !.
take :- current_position(Room), item_position(9, Room), health(X), X < 3, write('You have used health potion.\n'),
         NewHP is X + 1, retract(health(X)), asserta(health(NewHP)), retract(item_position(9, Room)), !.
take :- \+ inventory(_), current_position(Room), item_position(Item, Room),
         item_name(Item, Name), format('You have taken ~w.\n', [Name]),
         asserta(inventory(Item)), retract(item_position(Item, Room)), !.
take :- current_position(X), \+ item_position(_, X), write('There is nothing to be taken here.\n'), !.
take :- inventory(CurrentItem), current_position(Room), item_position(FoundItem, Room), item_name(CurrentItem, CurName),
         item_name(FoundItem, FoundName), retract(inventory(CurrentItem)), asserta(inventory(FoundItem)),
		 retract(item_position(FoundItem, Room)), asserta(item_position(CurrentItem, Room)), 
		 format('Your have replaced ~w with ~w.\n', [CurName, FoundName]), !.

%leave - Leaves an item in the current room and removes it from inventory.
%        If there is any item here already or if player's inventory is empty then notifies the player.
leave :- end_game, write('Game is over!\n'), !.
leave :- inventory(5), current_position(Room), \+ item_position(_, Room), teleport_to(X), 
          retract(teleport_to(X)), asserta(teleport_to(Room)), fail.
leave :- inventory(Item), current_position(Room), \+ item_position(_, Room),
          item_name(Item, Name), format('You have left ~w here.\n', [Name]),
          retract(inventory(Item)), asserta(item_position(Item, Room)), !.
leave :- \+ inventory(_), write('You don\'t have anything in your inventory.\n'), !.
leave :- write('There is already an item in this room.\n').

%use - tries to use the current item in inventory
use :- end_game, write('Game is over!\n'), !.
use :- inventory(1), write('Dear Nathan,\n\nI am so sorry about Natalie. I found out that none of the doctors could help her.\n'),
        write('It must be really frustrating, seeing your wife dying while you can\'t do anything about it.\n'),
        write('But there is a solution! I found something in that old book which our father left us.\nDo you know that old castle on the hill?\n'),
        write('There is supposed to be an elixir of life, one which can heal any disease!\n'), 
        write('This place is abandoned so it shouldn\'t be difficult to get it.\nYou are your wife\'s last hope.\n\nMatthew\n'), !.
use :- inventory(5), write('You have used the teleport rune.\n'), current_position(X), teleport_to(Y), change_position(X, Y), !. 
use :- inventory(8), current_position(17), retract(inventory(8)), retract(hidden(14)),
        write('You placed painting on the wall. Suddenly you hear squeeking noise from the distance.\n'), !.
use :- inventory(9), health(HP), HP < 3, NewHP is HP + 1, retract(health(HP)), asserta(health(NewHP)),
        write('You have used health potion.\n'), retract(inventory(9)).
use :- write('You can\'t use this item.\n').

%inspect - gives more detailed desription of the room
inspect :- end_game, write('Game is over!\n'), !.
inspect :- current_position(1), write('You look in the mirror and you see a tall man. This man is no warrior he is obviously a farmer.\n'),
            write('Nonetheless, you can see determination in his eyes.\n'), !.
inspect :- current_position(3), write('You tried to put on the armor but it\'s to heavy for you.'), !.
inspect :- current_position(4), write('The adventurer doesn\'t have anything useful...\n'), !.
inspect :- current_position(5), write('You opened the coffin. What an stupid idea...\nLuckily, the coffin was empty so you closed it.\n'), !.
inspect :- current_position(8), write('The adventurer doesn\'t have anything useful...\n'), !.
inspect :- current_position(10), write('TELEPORTATION FOR DUMMIES\n1. Place rune in the room you want to teleport to.\n'),
            write('2. Take the rune as soon as it starts glowing.\n'),
            write('3. Touch the rune to teleport.\n'), !.
inspect :- current_position(17), write('If only you had some painting...\n'), !.
inspect :- write('There is nothing to be inspected.\n').

%enemy_information(+Enemy, -Name, -WeaknessItem) - returns basic information about enemy
enemy_information(1, 'goblin', 2).
enemy_information(2, 'troll', 6).
enemy_information(3, 'dragon', 7).

%enemy_position(+Room, -Enemy) - returns the Enemy in the Room
enemy_position(4, 1).
enemy_position(12, 1).
enemy_position(13, 2).
enemy_position(21, 1).
enemy_position(22, 2).
enemy_position(19, 3).

%enemy_encounter(+X) :- resolves possible encounter with an enemy in room X
enemy_encounter(X) :- enemy_position(X, Enemy), enemy_information(Enemy, Name, Weakness), format('Dangerous ~w appeared in front of you!\n', [Name]),
                        inventory(Weakness), write('You have slained the enemy!\n'), retract(enemy_position(X, Enemy)), !, fail.
enemy_encounter(X) :- enemy_position(X, _), write('Your weapon wasn\'t effective against this enemy!\nYou have lost 1 HP.\n'),
                        health(HP), NewHp is HP - 1, retract(health(HP)), asserta(health(NewHp)), \+ end_game, info, !.
enemy_encounter(_) :- health(0), write('You have died.\n').

help :- write('info - show information about current room\n'),
         write('north/south/west/east - go to the next room\n'),
		 write('take - take item in current room\n'),
		 write('leave - leave item in current room\n'),
		 write('inspect - show more information in current room\n'),
		 write('use - use an item\n').

end_game :- current_position(20).
end_game :- health(HP), HP < 1, !.