
CREATE OR REPLACE VIEW  NextMoves AS
SELECT p.country AS personcountry, 
p.personnummer,
p.locationcountry AS country, 
p.locationarea AS area,
r.tocountry AS destcountry, 
r.toarea AS destarea, 
r.roadtax AS cost

FROM Persons p, Roads r
WHERE (p.locationcountry = r.fromcountry AND p.locationarea = r.fromarea)

UNION ALL

SELECT p.country AS personcountry, 
p.personnummer,
p.locationcountry AS country, 
p.locationarea AS area,
r.fromcountry AS destcountry, 
r.fromarea AS destarea, 
r.roadtax AS cost
FROM Persons p, Roads r
WHERE (p.locationcountry = r.tocountry AND p.locationarea = r.toarea)
;

CREATE OR REPLACE VIEW  NextMoves AS
SELECT p.country AS personcountry, 
p.personnummer,
p.locationcountry AS country, 
p.locationarea AS area,
r.tocountry AS destcountry, 
r.toarea AS destarea, 
r.roadtax AS cost

FROM Persons p, Roads r
WHERE (p.locationcountry = r.fromcountry AND p.locationarea = r.fromarea)

UNION ALL

SELECT p.country AS personcountry, 
p.personnummer,
p.locationcountry AS country, 
p.locationarea AS area,
r.fromcountry AS destcountry, 
r.fromarea AS destarea, 
r.roadtax AS cost
FROM Persons p, Roads r
WHERE (p.locationcountry = r.tocountry AND p.locationarea = r.toarea)
;


CREATE OR REPLACE VIEW AssetsSummary AS
WITH
    roadAssets AS(
        SELECT ownercountry, ownerpersonnummer, COUNT(*) * getval('roadprice') AS rAssets
        FROM Roads
        GROUP BY ownercountry, ownerpersonnummer
    ),
    hotelAssets AS(
        SELECT ownercountry, ownerpersonnummer, COUNT(*) * getval('hotelprice') AS hAssets,
        COUNT(*) * getval('hotelrefund') * getval('hotelprice') AS reclaimable
        FROM Hotels
        GROUP BY ownercountry, ownerpersonnummer
    ),
    personBudget AS(
    	SELECT personnummer AS ownerpersonnummer, country AS ownercountry, budget
    	FROM Persons)
SELECT ownercountry, ownerpersonnummer, hAssets + rAssets AS assets, reclaimable, budget
FROM roadAssets r
NATURAL INNER JOIN hotelAssets h
NATURAL INNER JOIN personBudget p
;

