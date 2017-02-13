/*Run shouldWork.sql first and then this file. That will make these lines fail. */

insert into areas values ('Sweden', 'Arvika', 2);

insert into persons values ('Sweden', '19960123-263', 'Frej Karlsson', 'Sweden', 'Gothenburg', '100000');

/* works atm. Will fix*/
insert into roads values ('Sweden', 'Arvika', 'Sweden', 'Stockholm', 'Sweden', '19960123-2631', '1');

insert into roads values ('Sweden', 'Stockholm', 'Sweden', 'Stockholm', 'Sweden', '19960123-2631', '1');


/*Shouldn't fail, but should only update the roadtax*/
update roads
set roadtax = 2, toarea = 'Stockholm'
where ownerpersonnummer = '19960123-2631' and ownercountry = 'Sweden' and toarea = 'Arvika' and
tocountry = 'Sweden' and fromarea = 'Gothenburg' and fromcountry = 'Sweden'  ;
