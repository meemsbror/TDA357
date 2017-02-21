/*Run shouldWork.sql first and then this file. That will make these lines fail. */

/* Wrong format of personnummer */
insert into persons values ('Sweden', '19960123-263', 'Frej Karlsson', 'Sweden', 'Gothenburg', 100000);

/* Person not in right location */
insert into roads values ('Sweden', 'Arvika', 'Sweden', 'Stockholm', 'Sweden', '19960123-2631', 1);

/* Should fail since road Arvka -- Gothenburg already exists*/
insert into roads values ('Sweden', 'Arvika', 'Sweden', 'Gothenburg', 'Sweden', '19960123-2631', 1);

/*TODO: Assert that budget is NOT updated for that perssonnummer*/

insert into roads values ('Sweden', 'Stockholm', 'Sweden', 'Stockholm', 'Sweden', '19960123-2631', 1);

/* Already owns hotel in this city*/
update hotels
set ownerpersonnummer = '19960123-2631', ownercountry='Sweden'
where ownerpersonnummer = '19960115-1120';

update hotels
set ownerpersonnummer = '19960115-1120', ownercountry = 'Finland'
where name = 'Sunny Beach 2';

/*To poor to buy new hotel*/


insert into hotels values('King bed 2', 'Sweden', 'Kungsbacka', 'Sweden', '19960115-1120');

/* Assert that bugdet hasn't been updated when too poor */

select assert((select budget
				from persons
				where personnummer='19960115-1120' 
				and country = 'Sweden'), -779.2);

/* Cannot update hotel location */
update hotels
set locationname='Gothenburg';

/*Cannot update anything but the roadtax */
update roads
set roadtax = 2, toarea = 'Stockholm'
where ownerpersonnummer = '19960123-2631' and ownercountry = 'Sweden' and toarea = 'Arvika' and
tocountry = 'Sweden' and fromarea = 'Gothenburg' and fromcountry = 'Sweden'  ;
