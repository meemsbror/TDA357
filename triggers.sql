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


CREATE OR REPLACE FUNCTION removeDuplicate() RETURNS TRIGGER AS $$
    BEGIN
        IF(TG_OP = 'DELETE' ) THEN
        IF((SELECT COUNT(*)
        FROM Roads
            WHERE ownerpersonnummer = OLD.ownerpersonnummer AND fromarea = OLD.toarea AND toarea = OLD.fromarea AND fromcountry = OLD.tocountry
            AND tocountry = OLD.fromcountry AND ownercountry = OLD.ownercountry) > 0)
            THEN RAISE EXCEPTION 'asdf happend';
       END IF;
    END IF;
    RETURN OLD;
    END
    $$ LANGUAGE 'plpgsql';
CREATE TRIGGER removeRoad
    BEFORE DELETE ON Roads
    FOR EACH STATEMENT
    EXECUTE PROCEDURE removeDuplicate();
