insert into areas values ('Sweden', 'Kungsbacka', 2);
insert into areas values ('Sweden', 'Stockholm', 2);
insert into areas values ('Sweden', 'Arvika', 2);
insert into persons values ('Sweden', '19960123-2631', 'Frej Karlsson', 'Sweden', 'Gothenburg', 10);
insert into roads values ('Sweden', 'Stockholm', 'Sweden', 'Arvika', 'Sweden', '19960123-2631', 1);
insert into roads values ('Sweden', 'Gothenburg', 'Sweden', 'Arvika', 'Sweden', '19960123-2631', 1);


select * from roads;
update roads
set roadtax = 2, toarea = 'Stockholm';
select * from roads;
select * from persons;

insert into cities values('Sweden', 'Gothenburg', 10);
insert into hotels values('Sunny Beach', 'Sweden', 'Gothenburg', 'Sweden', '19960123-2631');
