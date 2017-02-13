CREATE OR REPLACE VIEW  NextMoves AS
SELECT p.country, p.personnummer, p.locationcountry, p.locationarea, r.fromcountry, r.fromarea, r.tocountry, r.toarea,
		r.roadtax
FROM Persons p, Roads r
WHERE (p.locationcountry = r.fromcountry AND p.locationarea = r.fromarea) 
OR (p.locationcountry = r.tocountry AND p.locationarea = r.toarea);



CREATE OR REPLACE VIEW AssetsSummary AS
WITH
    roadAssets AS(
        SELECT ownercountry, ownerpersonnummer, COUNT(*) * getval('roadprice') AS assets
        FROM Roads
        GROUP BY ownercountry, ownerpersonnummer
    ),
    hotelAssets AS(
        SELECT ownercountry, ownerpersonnummer, COUNT(*) * getval('hotelprice') AS assets, COUNT(*) * getval('hotelrefund') AS reclaimable
        FROM Hotels
        GROUP BY ownercountry, ownerpersonnummer
    )
SELECT ownercountry, ownerpersonnummer, h.assets + r.assets AS assets, reclaimable
FROM roadAssets r
NATURAL JOIN hotelAssets h

;
