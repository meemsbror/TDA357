--Government cant create hotels
begin;
insert into countries values ('Sweden');
insert into countries values ('');
insert into areas values ('Sweden', 'A', 2);
insert into areas values ('Sweden', 'B', 2);
insert into areas values ('Sweden', 'C', 2);

insert into persons values ('Sweden', '19960123-2631', 'Frej Karlsson', 'Sweden', 'A', 10000);
insert into persons values ('', '', 'The Gover', 'Sweden', 'A', 0);

insert into hotels values ('Sunny', 'Sweden', 'A', '', '');
rollback;
