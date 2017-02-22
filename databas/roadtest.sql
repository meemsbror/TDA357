INSERT INTO Countries VALUES('');
INSERT INTO Countries VALUES('A');
INSERT INTO Countries VALUES('B');
INSERT INTO Countries VALUES('C');
INSERT INTO Countries VALUES('D');
INSERT INTO Areas VALUES('A', 'A', 1);
INSERT INTO Areas VALUES('B', 'B', 1);
INSERT INTO Areas VALUES('C', 'C', 1);
INSERT INTO Areas VALUES('D', 'D', 1);
INSERT INTO Cities VALUES('A', 'A', 1000000);
INSERT INTO Cities VALUES('B', 'B', 1000000);
INSERT INTO Towns VALUES('C', 'C');
INSERT INTO Towns VALUES('D', 'D');
INSERT INTO Persons VALUES('A', '19940301-1234', 'Justin Bieber', 'A', 'A', 10000.00);
INSERT INTO Persons VALUES('B', '19940301-5678', 'Markus Bieber', 'B', 'B', 5000.00);
INSERT INTO Persons VALUES('', '', 'The world government', 'A', 'A', 5000.00);
-- Justin's roads
INSERT INTO Roads VALUES('A', 'A', 'C', 'C', 'A', '19940301-1234', 10);
INSERT INTO Roads VALUES('A', 'A', 'D', 'D', 'A', '19940301-1234', 10);
    -- Markus' roads
INSERT INTO Roads VALUES('A', 'A', 'B', 'B', 'B', '19940301-5678', 20);
INSERT INTO Roads VALUES('B', 'B', 'D', 'D', 'B', '19940301-5678', 20);
-- Public roads
INSERT INTO Roads VALUES('B', 'B', 'C', 'C', '', '', 0);
SELECT * FROM NextMoves;
-- There should be 6 destinations in total
SELECT assert((SELECT COUNT(*) FROM NextMoves), 6);
