

CREATE OR REPLACE VIEW  NextMoves AS
    WITH
    NextMovesHelp AS(
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

        UNION ALL

        SELECT p.country AS personcountry,
        p.personnummer,
        p.locationcountry AS country,
        p.locationarea AS area,
        r.tocountry AS destcountry,
        r.toarea AS destarea,
        0 AS cost
        FROM Persons p, Roads r
        WHERE (p.locationcountry = r.fromcountry AND p.locationarea = r.fromarea) AND
        ( p.personnummer = r.ownerpersonnummer AND p.country = r.ownercountry)

        UNION ALL

        SELECT p.country AS personcountry,
        p.personnummer,
        p.locationcountry AS country,
        p.locationarea AS area,
        r.fromcountry AS destcountry,
        r.fromarea AS destarea,
        0 AS cost
        FROM Persons p, Roads r
        WHERE (p.locationcountry = r.tocountry AND p.locationarea = r.toarea) AND
        ( p.personnummer = r.ownerpersonnummer AND p.country = r.ownercountry)
    )

    SELECT personcountry, personnummer, country, area, destcountry, destarea, MIN(cost) AS cost
    FROM NextMovesHelp
    WHERE personnummer <> '' AND personcountry <> ''
    GROUP BY personcountry, personnummer, country, area, destcountry, destarea
    ORDER BY personnummer
;

CREATE OR REPLACE VIEW AssetSummary AS
WITH
    roadAssets AS(
        SELECT ownercountry AS country, ownerpersonnummer AS personnummer, COUNT(*) * getval('roadprice') AS rAssets
        FROM Roads
        GROUP BY ownercountry, ownerpersonnummer),
    hotelAssets AS(
        SELECT ownercountry AS country, ownerpersonnummer AS personnummer, COUNT(*) * getval('hotelprice') AS hAssets,
        COUNT(*) * getval('hotelrefund') * getval('hotelprice') AS reclaimable
        FROM Hotels
        GROUP BY ownercountry, ownerpersonnummer)
SELECT p.country, p.personnummer, budget, 
coalesce(hAssets + rAssets, hAssets, rAssets) AS assets, reclaimable
FROM persons p
LEFT OUTER JOIN
(select coalesce(r.country,h.country) AS country, 
    coalesce(r.personnummer, h.personnummer) AS personnummer, rAssets, hAssets, reclaimable
    from (hotelAssets h FULL OUTER JOIN roadassets r
ON r.country = h.country AND r.personnummer = h.personnummer )) AS foo
ON foo.country = p.country AND foo.personnummer = p.personnummer
WHERE p.personnummer<>''
;

