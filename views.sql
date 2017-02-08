CREATE OR REPLACE VIEW  NextMoves AS
SELECT p.country, p.personnummer, p.locationcountry, p.locationarea r.*
FROM Persons p, Roads r
WHERE (p.country = r.fromcountry AND p.area = r.fromarea) OR (p.country = r.tocountry AND p.area = r.fromarea);


WITH
    roadAssets AS(
        SELECT ownercountry, ownerpersonnummer, COUNT(*) * getval('roadprice') AS assets
        FROM (
            SELECT DISTINCT ownercountry, ownerpersonnummer
            FROM Roads
        )
    )
    hotelAssets AS(
    SELECT ownercountry, ownerpersonnummer, COUNT(*) * getval('hotelprice') AS assets, COUNT(*) * getval('hotelrefund') AS reclaimable
        FROM (
            SELECT DISTINCT ownercountry, ownerpersonnummer
            FROM Hotels
        
    )
CREATE OR REPLACE VIEW AssetsSummary AS
SELECT
;
