insert into roads values ('Sweden', 'Kungsbacka', 'Sweden', 'Gothenburg', 'Sweden', '19960123-2631', '1');
insert into roads values ('Sweden', 'Gothenburg', 'Sweden', 'Kungsbacka', 'Sweden', '19960123-2631', '1');
delete from roads WHERE fromcountry = 'Sweden' AND fromarea = 'Gothenburg' AND tocountry = 'Sweden' AND toarea = 'Kungsbacka' AND ownercountry = 'Sweden' AND ownerpersonnummer = '19960123-2631';
