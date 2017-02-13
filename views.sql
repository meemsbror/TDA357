CREATE OR REPLACE VIEW  NextMoves AS
SELECT p.country AS personcountry, p.personnummer,
p.locationcountry AS country, p.locationarea AS area,
r.tocountry AS destcountry, r.toarea AS destarea, r.roadtax AS cost
FROM Persons p, Roads r
WHERE (p.locationcountry = r.fromcountry AND p.locationarea = r.fromarea)

UNION ALL

SELECT p.country AS personcountry, p.personnummer,
p.locationcountry AS country, p.locationarea AS area,
r.fromcountry AS destcountry, r.fromarea AS destarea, r.roadtax AS cost
FROM Persons p, Roads r
WHERE (p.locationcountry = r.tocountry AND p.locationarea = r.toarea)
;



CREATE OR REPLACE VIEW AssetsSummary AS
WITH
    roadAssets AS(
        SELECT ownercountry, ownerpersonnummer, COUNT(*) * getval('roadprice') AS assets
        FROM Roads
        GROUP BY ownercountry, ownerpersonnummer
    ),
    hotelAssets AS(
        SELECT ownercountry, ownerpersonnummer, COUNT(*) * getval('hotelprice') AS assets,
        COUNT(*) * getval('hotelrefund') AS reclaimable
        FROM Hotels
        GROUP BY ownercountry, ownerpersonnummer
    )
SELECT ownercountry, ownerpersonnummer, h.assets + r.assets AS assets, reclaimable
FROM roadAssets r
NATURAL JOIN hotelAssets h

;
