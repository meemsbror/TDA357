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
-- some hotels
INSERT INTO Hotels VALUES('X', 'A', 'A', 'A', '19940301-1234');
INSERT INTO Hotels VALUES('X', 'B', 'B', 'A', '19940301-1234');
INSERT INTO Hotels VALUES('X', 'B', 'B', 'B', '19940301-5678');
-- There should be 2 entries in total
SELECT assert((SELECT COUNT(*) FROM AssetSummary), 2);
-- budget
SELECT assert((SELECT budget FROM AssetSummary WHERE country = 'A' AND personnummer = '19940301-1234'), 10000.00 - 2*getval('roadprice') - 2*getval('hotelprice'));
SELECT assert((SELECT budget FROM AssetSummary WHERE country = 'A' AND personnummer = '19940301-1234'), 10000.00 - 2*getval('roadprice') - 2*getval('hotelprice'));
SELECT assert((SELECT budget FROM AssetSummary WHERE country = 'B' AND personnummer = '19940301-5678'), 5000.00 - 2*getval('roadprice') - 1*getval('hotelprice'));
-- assets
SELECT assert((SELECT assets FROM AssetSummary WHERE country = 'A' AND personnummer = '19940301-1234'), 2*getval('roadprice') + 2*getval('hotelprice'));
SELECT assert((SELECT assets FROM AssetSummary WHERE country = 'B' AND personnummer = '19940301-5678'), 2*getval('roadprice') + 1*getval('hotelprice'));
-- reclaimable
SELECT assert((SELECT reclaimable FROM AssetSummary WHERE country = 'A' AND personnummer = '19940301-1234'), getval('hotelrefund') * 2*getval('hotelprice'));
SELECT assert((SELECT reclaimable FROM AssetSummary WHERE country = 'B' AND personnummer = '19940301-5678'), getval('hotelrefund') * 1*getval('hotelprice'));
[!] Exception messages from 'teacherprovided/2_view_works/assetsummary.sql':
            Person not in right location
            [!] Executed SQL statements in 'teacherprovided/2_view_works/nextmoves.sql':
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
        -- 3 for Justin and 3 for Markus
    SELECT assert((SELECT COUNT(*) FROM NextMoves WHERE personcountry = 'A' AND personnummer = '19940301-1234'), 3);
        SELECT assert((SELECT COUNT(*) FROM NextMoves WHERE personcountry = 'B' AND personnummer = '19940301-5678') + 10, 3 + 10);
            -- all Markus' destination have cost 0
    SELECT assert((SELECT COUNT(*) FROM NextMoves WHERE personcountry = 'B' AND personnummer = '19940301-5678' AND cost <> 0) + 20, 0 + 20);
        -- Justin has 2 roads with cost 0, and road A -> B with cost 20
    SELECT assert((SELECT COUNT(*) FROM NextMoves WHERE personcountry = 'A' AND personnummer = '19940301-1234' AND cost = 0) + 30, 2 + 30);
        SELECT assert((SELECT COUNT(*) FROM NextMoves WHERE personcountry = 'A' AND personnummer = '19940301-1234' AND
                    	country = 'A' AND area = 'A' AND destcountry = 'B' AND destarea = 'B' and cost = 20) + 40, 1 + 40);
