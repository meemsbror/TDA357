insert into areas values ('Sweden', 'Kungsbacka', 2);
insert into areas values ('Sweden', 'Stockholm', 2);
insert into areas values ('Sweden', 'Arvika', 2);
insert into persons values ('Sweden', '19960123-2631', 'Frej Karlsson', 'Sweden', 'Gothenburg', 1000);
insert into persons values ('Sweden', '19960123-2632', 'Mimmi Jarlsson', 'Sweden', 'Arvika', 1000);
insert into roads values ('Sweden', 'Gothenburg', 'Sweden', 'Arvika', 'Sweden', '19960123-2632', 2000);

/* Check  if you can move to location with no road attached*/
update persons
set locationarea = 'Stockholm'
where personnummer = '19960123-2631' AND  country = 'Sweden';

/* Check if you can move when you don't have enough money */
update persons
set locationarea = 'Arvika'
where personnummer = '19960123-2631' AND  country = 'Sweden';

insert into roads values ('Sweden', 'Gothenburg', 'Sweden', 'Arvika', 'Sweden', '19960123-2632', 2000);

/* Check so no money is deducted when traveling on own road */
select * from persons where personnummer = '19960123-2631';
update persons
set locationarea = 'Arvika'
where personnummer = '19960123-2631' AND  country = 'Sweden';

select * from persons where personnummer = '19960123-2631';

/* Check so roadtax is deducted */
insert into roads values ('Sweden', 'Arvika', 'Sweden', 'Stockholm', 'Sweden', '19960123-2632', 20);

update persons
set locationarea = 'Stockholm'
where personnummer = '19960123-2631' AND  country = 'Sweden';

select * from persons where personnummer = '19960123-2631';
