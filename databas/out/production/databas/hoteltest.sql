insert into countries values('Sweden');

INSERT INTO Areas VALUES('Sweden', 'Gothenburg', 500000);

INSERT INTO Cities VALUES('Sweden', 'Gothenburg', 1000000);
INSERT INTO Persons VALUES('Sweden', '19940301-1234', 'Justin Bieber', 'Sweden', 'Gothenburg', 10000);
INSERT INTO Hotels VALUES('The Never Say Never Hotel', 'Sweden', 'Gothenburg', 'Sweden', '19940301-1234');
-- Hotel costs money
SELECT assert((SELECT budget FROM Persons WHERE country='Sweden' AND personnummer = '19940301-1234'), 10000 - getval('hotelprice'));
    -- Destroying hotel gives 50% refund
DELETE FROM Hotels WHERE ownercountry='Sweden' AND ownerpersonnummer = '19940301-1234';

SELECT assert((SELECT budget FROM Persons WHERE country='Sweden' AND personnummer = '19940301-1234'), 10000 - getval('hotelprice') * getval('hotelrefund'));
