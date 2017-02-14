
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


CREATE OR REPLACE VIEW HotelAssets AS
	SELECT 	ownercountry AS country, 
			ownerpersonnummer AS personnummer, 
			COUNT(*) * getval('hotelprice') AS assets, 
			COUNT(*) * getval('hotelrefund') * getval('hotelprice') AS reclaimable
	FROM Hotels
	GROUP BY ownercountry, ownerpersonnummer
	;

CREATE OR REPLACE VIEW RoadAssets AS
	SELECT 	ownercountry AS country, 
			ownerpersonnummer AS personnummer, 
			COUNT(*) * getval('roadprice') AS assets
	FROM Roads
	GROUP BY ownercountry, ownerpersonnummer
	;


CREATE OR REPLACE VIEW AssetsSummary AS
	SELECT p.country, 
	p.personnummer, 
	p.budget,
	h.assets + r.assets AS assets,
	h.reclaimable  
	FROM Persons p, RoadAssets r, HotelAssets h
	/*WHERE r.ownercountry = p.country AND h.ownercountry = p.country
	AND r.ownerpersonnummer = p.personnummer AND h.ownerpersonnummer = p.personnummer
	*/
	;
