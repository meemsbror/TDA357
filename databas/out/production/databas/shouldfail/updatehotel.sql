--Cant update hotel illegally (move location etc)
begin;
insert into countries values ('Sweden');
insert into areas values ('Sweden', 'A', 2);
insert into areas values ('Sweden', 'B', 2);
insert into areas values ('Sweden', 'C', 2);
insert into cities values ('Sweden', 'A', 0);
insert into cities values ('Sweden', 'B', 0);

insert into persons values ('Sweden', '19960123-2631', 'Frej Karlsson', 'Sweden', 'A', 10000);

insert into hotels values ('Sunny', 'Sweden', 'A', 'Sweden', '19960123-2631');
update hotels set locationname = 'B';
rollback;
