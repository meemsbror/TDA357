--Cant create two hotels in a city
begin;
insert into countries values ('Sweden');
insert into areas values ('Sweden', 'A', 2);
insert into areas values ('Sweden', 'B', 2);
insert into areas values ('Sweden', 'C', 2);
insert into cities values ('Sweden', 'A', 0);

insert into persons values ('Sweden', '19960123-2631', 'Frej Karlsson', 'Sweden', 'A', 10000);

insert into hotels values ('Sunny', 'Sweden', 'A', 'Sweden', '19960123-2631');
insert into hotels values ('Sunni', 'Sweden', 'A', 'Sweden', '19960123-2631');
rollback;
