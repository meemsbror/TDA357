--Check so you cant travel on road when no moneyz
begin;
insert into countries values ('Sweden');
insert into areas values ('Sweden', 'A', 2);
insert into areas values ('Sweden', 'B', 2);
insert into areas values ('Sweden', 'C', 2);

insert into persons values ('Sweden', '19960123-2631', 'Frej Karlsson', 'Sweden', 'A', 10000);
insert into persons values ('Sweden', '19960123-2632', 'Frej Karlsson', 'Sweden', 'A', 0);

insert into roads values ('Sweden', 'A', 'Sweden', 'B', 'Sweden', '19960123-2631', 1);
update persons set locationarea = 'B';
rollback;
