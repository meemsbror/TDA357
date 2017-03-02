--Create road when not in start or end point (Should fail)
begin;
insert into countries values ('Sweden');
insert into areas values ('Sweden', 'A', 2);
insert into areas values ('Sweden', 'B',2);
insert into areas values ('Sweden', 'C',2);

insert into persons values ('Sweden', '19960123-2631', 'Frej Karlsson', 'Sweden', 'A', 100000);

insert into roads values ('Sweden', 'B', 'Sweden', 'C', 'Sweden', '19960123-2631', 1);
rollback;
