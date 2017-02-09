insert into areas values ('Sweden', 'Kungsbacka', 2);
insert into persons values ('Sweden', '19960123-2631', 'Frej Karlsson', 'Sweden', 'Gothenburg', '100000');
insert into roads values ('Sweden', 'Kungsbacka', 'Sweden', 'Gothenburg', 'Sweden', '19960123-2631', '1');

delete from roads WHERE fromcountry = 'Sweden' AND fromarea = 'Gothenburg' AND tocountry = 'Sweden' AND toarea = 'Kungsbacka' AND ownercountry = 'Sweden' AND ownerpersonnummer = '19960123-2631';
