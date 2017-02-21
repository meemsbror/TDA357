INSERT INTO countries VALUES ('Sweden') ;
INSERT INTO areas VALUES ('Sweden','Gothenburg', 491630) ;
INSERT INTO persons VALUES ('', '', 'The government', 'Sweden', 'Gothenburg', 0);


nsert into countries values ('Finland');

insert into areas values ('Sweden', 'Kungsbacka', 2);
insert into areas values ('Sweden', 'Stockholm', 2);
insert into areas values ('Sweden', 'Arvika', 2);

insert into persons values ('Sweden', '19960123-2631', 'Frej Karlsson', 'Sweden', 'Gothenburg', 100000);
insert into persons values ('Finland', '19960115-1120', 'Maija Happonen', 'Sweden', 'Stockholm', 1500);
insert into persons values ('Sweden', '19900123-3030', 'Mimmi Jarlsson', 'Sweden', 'Arvika', 1000000);

insert into roads values ('Sweden', 'Gothenburg', 'Sweden', 'Arvika', 'Sweden', '19960123-2631', 1);

/* Roadprice is deducted form budget 100000 - 456.9 = 99543.1*/
select assert((select budget from Persons where personnummer = '19960123-2631' and country = 'Sweden'), 99543.1);

insert into roads values ('Sweden', 'Stockholm', 'Sweden', 'Arvika', 'Finland', '19960115-1120', 3);

insert into roads values ('Sweden', 'Stockholm', 'Sweden', 'Arvika', '', '', 0);

/* Assert that budget is NOT updated for that government*/	
select assert((select budget from Persons where personnummer = '' and country = ''), 0);

insert into cities values('Sweden', 'Gothenburg', 10);
insert into cities values('Sweden', 'Kungsbacka', 22);

	
insert into hotels values('Sunny Beach', 'Sweden', 'Gothenburg', 'Finland', '19960115-1120');

/*TODO: Assert that budget is updated for that perssonnummer*/	

insert into hotels values('Sunny Beach 2', 'Sweden', 'Gothenburg', 'Sweden', '19960123-2631');

/* 100000 - 789,2 = 99210,8*/
--select assert((select budget from Persons where personnummer = '19960123-2631' and country = 'Sweden'), 99210.8);

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


/*
Make sure money is deducted from person if they travel to city with hotel 
and it is transferred to the owners of the hotels

Also checks if the visitbonus is transferred
 */
insert into roads values ('Sweden', 'Arvika', 'Sweden', 'Gothenburg', '', '', 0);

update persons
set locationarea = 'Gothenburg'
where personnummer = '19900123-3030' AND country = 'Sweden';


select assert(
    (select budget
        from persons
        where personnummer = '19900123-3030' AND country = 'Sweden'),
    1000000 - getval('cityvisit') + 10);

select assert(
    (select budget
        from persons
        where personnummer = '19960123-2631'
        AND country = 'Sweden'),
        97964.7 + getval('cityvisit')/2);

select assert(
    (select visitbonus from cities where country = 'Sweden' AND name ='Gothenburg'), 0);
