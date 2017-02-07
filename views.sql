CREATE VIEW IF NOT EXISTS NextMoves AS
SELECT p.country, p.personnummer, p.locationcountry, p.locationarea r.*
FROM Persons p, roads.r
WHERE (p.country = r.fromcountry AND p.area = r.fromarea) OR (p.country = r.tocountry AND p.area = r.fromarea);


WITH 
CREATE VIEW IF NOT EXISTS AssetsSummary AS
SELECT p.country, p.personnummer, p.budget, r.

