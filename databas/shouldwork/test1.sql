--TODO: remove? 
INSERT INTO countries VALUES ('');
INSERT INTO countries VALUES ('Sweden') ;
INSERT INTO areas VALUES ('Sweden','Gothenburg', 491630) ;
INSERT INTO persons VALUES ('', '', 'The government', 'Sweden', 'Gothenburg', 0);


insert into countries values ('Finland');

insert into areas values ('Sweden', 'Kungsbacka', 2);
insert into areas values ('Sweden', 'Stockholm', 2);
insert into areas values ('Sweden', 'Arvika', 2);

insert into persons values ('Sweden', '19960123-2631', 'Frej Karlsson', 'Sweden', 'Gothenburg', 100000);
insert into persons values ('Finland', '19960115-1120', 'Maija Happonen', 'Sweden', 'Stockholm', 1500);
insert into persons values ('Sweden', '19900123-3030', 'Mimmi Jarlsson', 'Sweden', 'Arvika', 1000000);
insert into persons values ('Sweden', '19960115-1120', 'Poor Chap', 'Sweden', 'Kungsbacka', 15);

insert into roads values ('Sweden', 'Gothenburg', 'Sweden', 'Arvika', 'Sweden', '19960123-2631');

/* Roadprice is deducted form budget 100000 - 456.9 = 99543.1*/
select assert((select budget from Persons where personnummer = '19960123-2631' and country = 'Sweden'), 99543.1);

/*
Check so money is deducted when creating road
New budget: 1043.1
 */
insert into roads values ('Sweden', 'Stockholm', 'Sweden', 'Arvika', 'Finland', '19960115-1120');


select assert((select budget from Persons where personnummer = '19960115-1120' and country = 'Finland'), 1043.1);

/* 
Check so no money is deducted when travelling on own road
*/

update persons 
	set locationarea = 'Arvika' 
	where personnummer = '19960115-1120'
	and country = 'Finland';

select assert((select budget from Persons where personnummer = '19960115-1120' and country = 'Finland'), 1043.1);


insert into roads values ('Sweden', 'Stockholm', 'Sweden', 'Arvika', '', '', 0);

/* Assert that budget is NOT updated for that government*/	
select assert((select budget from Persons where personnummer = '' and country = ''), 0);

insert into cities values('Sweden', 'Gothenburg', 10);
insert into cities values('Sweden', 'Kungsbacka', 22);

	
insert into hotels values('Sunny Beach', 'Sweden', 'Gothenburg', 'Finland', '19960115-1120');

insert into hotels values('Sunny Beach 2', 'Sweden', 'Gothenburg', 'Sweden', '19960123-2631');

/*
Check so money is deducted when creating hotel
99543.1 - 789.2 = 98753.9
*/
select assert((select budget from Persons where personnummer = '19960123-2631' and country = 'Sweden'), 98753.9);

insert into hotels values('King bed', 'Sweden', 'Kungsbacka', 'Sweden', '19960123-2631');

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

insert into persons values ('Sweden', '19930101-0088', 'Hans Hansson', 'Sweden', 'Kungsbacka', 1000);

insert into roads values ('Sweden', 'Kungsbacka', 'Sweden', 'Arvika', 'Sweden', '19930101-0088');

/* 
Check if money is deducted when creating road
new budget for 19930101-0088 = 543.1
 */
select assert((select budget from Persons where personnummer = '19930101-0088' and country = 'Sweden'), 543.1);

/* Move Poor Chap and see that the roadtax is deducted from his budget and added to the owner*/
update persons
	set locationarea = 'Arvika' 
	where personnummer = '19960115-1120' and country = 'Sweden';

select assert((select budget from Persons where personnummer = '19960115-1120' and country = 'Sweden'), 1.5);

select assert((select budget from Persons where personnummer = '19930101-0088' and country = 'Sweden'), 556.6);


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


insert into hotels values('asdfbed', 'Sweden', 'Gothenburg', 'Sweden', '19900123-3030');
select * from assetsummary;
