insert into areas values ('Sweden', 'Kungsbacka', 2);
insert into areas values ('Sweden', 'Stockholm', 2);
insert into areas values ('Sweden', 'Arvika', 2);
insert into persons values ('Sweden', '19960123-2631', 'Frej Karlsson', 'Sweden', 'Gothenburg', 1000);
insert into persons values ('Sweden', '19960123-2632', 'Frej Karlsson', 'Sweden', 'Arvika', 1000);

insert into roads values ('Sweden', 'Gothenburg', 'Sweden', 'Arvika', 'Sweden', '19960123-2632', 20);

select * from persons;

SELECT cost
    FROM NextMoves
    WHERE country = 'Sweden' AND area = 'Gothenburg'
    AND destcountry = 'Sweden' AND destarea = 'Arvika'
    ORDER BY cost ASC
    LIMIT 1;

update persons
set locationarea = 'Arvika'
where personnummer = '19960123-2631' AND  country = 'Sweden';

select * from persons;

SELECT cost
    FROM NextMoves
    WHERE country = 'Sweden' AND area = 'Gothenburg'
    AND destcountry = 'Sweden' AND destarea = '
    ORDER BY cost ASC
    LIMIT 1
