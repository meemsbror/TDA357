insert into countries values ('A');
insert into areas values ('A','B',2);
--countries
insert into countries values (null);
--areas
insert into areas values ('A', null, 2);
insert into areas values ('A', 'Gothenburg', null);
insert into cities values ('A', 'B', null);
--persons
insert into persons values ('A', null, 'Abraham', 'A','B',0);
insert into persons values ('A', '19960123-2631', null, 'A','B',0);
insert into persons values ('A', '19960123-2631', 'Abraham', null,'B',0);
insert into persons values ('A', '19960123-2631', 'Abraham', 'A', null,0);
insert into persons values ('A', '19960123-2631', 'Abraham', 'A','B', null);
insert into persons values ('A', '19960123-2631', 'Abraham', 'A','B', 0);
