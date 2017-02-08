CREATE OR REPLACE FUNCTION checkDuplicateRoad() RETURNS TRIGGER AS $$
    BEGIN
       IF((SELECT COUNT(*)
        FROM Roads
            WHERE ownerpersonnummer = NEW.ownerpersonnummer AND fromarea = NEW.toarea AND toarea = NEW.fromarea AND fromcountry = NEW.tocountry
            AND tocountry = NEW.fromcountry AND ownercountry = NEW.ownercountry) > 0)
            THEN RAISE EXCEPTION 'Road already exists';
       END IF;
    RETURN NEW;
    END
    $$ LANGUAGE 'plpgsql';

CREATE TRIGGER roadDirection
    BEFORE INSERT ON Roads
    FOR EACH ROW
    EXECUTE PROCEDURE checkDuplicateRoad();
