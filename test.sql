
insert into countries values ('Finland');

insert into areas values ('Sweden', 'Kungsbacka', 2);
insert into areas values ('Sweden', 'Stockholm', 2);
insert into areas values ('Sweden', 'Arvika', 2);

insert into persons values ('Sweden', '19960123-2631', 'Frej Karlsson', 'Sweden', 'Gothenburg', 100000);
insert into persons values ('Finland', '19960115-1120', 'Maija Happonen', 'Sweden', 'Stockholm', 1000);

insert into roads values ('Sweden', 'Stockholm', 'Sweden', 'Kungsbacka', 'Sweden', '19960123-2631', 5);
insert into roads values ('Sweden', 'Gothenburg', 'Sweden', 'Arvika', 'Sweden', '19960123-2631', 1);
insert into roads values ('Sweden', 'Stockholm', 'Sweden', 'Arvika', 'Finland', '19960115-1120', 3);

insert into cities values('Sweden', 'Gothenburg', 10);
insert into cities values('Sweden', 'Kungsbacka', 22);
	
insert into hotels values('Sunny Beach', 'Sweden', 'Gothenburg', 'Finland', '19960115-1120');
insert into hotels values('Sunny Beach 2', 'Sweden', 'Gothenburg', 'Sweden', '19960123-2631');
insert into hotels values('King bed', 'Sweden', 'Kungsbacka', 'Sweden', '19960123-2631');

select * from persons;
insert into persons values ('Sweden', '960123-2631', 'Frej Karlsson', 'Sweden', 'Gothenburg', '100000');

select * from persons;
select * from hotels;
