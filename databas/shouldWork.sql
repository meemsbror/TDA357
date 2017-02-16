
insert into countries values ('Finland');

insert into areas values ('Sweden', 'Kungsbacka', 2);
insert into areas values ('Sweden', 'Stockholm', 2);
insert into areas values ('Sweden', 'Arvika', 2);

insert into persons values ('Sweden', '19960123-2631', 'Frej Karlsson', 'Sweden', 'Gothenburg', 100000);
insert into persons values ('Finland', '19960115-1120', 'Maija Happonen', 'Sweden', 'Stockholm', 1500);

insert into roads values ('Sweden', 'Gothenburg', 'Sweden', 'Arvika', 'Sweden', '19960123-2631', 1);

/*TODO: Assert that budget is updated for that perssonnummer*/	

insert into roads values ('Sweden', 'Stockholm', 'Sweden', 'Arvika', 'Finland', '19960115-1120', 3);

/*TODO: Assert that budget is updated for that perssonnummer*/	

insert into roads values ('Sweden', 'Stockholm', 'Sweden', 'Arvika', ' ', ' ', 1);

/*TODO: Assert that budget is NOT updated for that government*/	

insert into cities values('Sweden', 'Gothenburg', 10);
insert into cities values('Sweden', 'Kungsbacka', 22);
	
insert into hotels values('Sunny Beach', 'Sweden', 'Gothenburg', 'Finland', '19960115-1120');

/*TODO: Assert that budget is updated for that perssonnummer*/	

insert into hotels values('Sunny Beach 2', 'Sweden', 'Gothenburg', 'Sweden', '19960123-2631');

/*TODO: Assert that budget is updated for that perssonnummer*/	

insert into hotels values('King bed', 'Sweden', 'Kungsbacka', 'Sweden', '19960123-2631');

/*TODO: Assert that budget is updated for that perssonnummer*/	

update hotels
set ownerpersonnummer = '19960115-1120', ownercountry = 'Finland'
where name = 'King bed';

update hotels
set ownerpersonnummer = '19960123-2631', ownercountry = 'Sweden'
where name = 'King bed';

update roads
set roadtax = 8
where ownerpersonnummer = '19960123-2631' and ownercountry = 'Sweden' and toarea = 'Arvika' and
tocountry = 'Sweden' and fromarea = 'Gothenburg' and fromcountry = 'Sweden'  ;



