--Check so you cant't create road if no moneyz;
begin;
insert into countries values ('Sweden');
insert into areas values ('Sweden', 'A', 2);
insert into areas values ('Sweden', 'B', 2);

insert into persons values ('Sweden', '19960123-2631', 'Frej Karlsson', 'Sweden', 'A', 1);

insert into roads values ('Sweden', 'A', 'Sweden', 'B', 'Sweden', '19960123-2631', 1);
rollback;
