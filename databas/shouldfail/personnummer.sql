--Try to insert person with invalid personnummer
begin;
insert into countries values ('Sweden');
insert into areas values ('Sweden', 'Gothenburg', 2);
insert into persons values ('Sweden', '19960123-263', 'Frej Karlsson', 'Sweden', 'Gothenburg', 100000);
rollback;
