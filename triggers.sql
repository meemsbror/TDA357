CREATE OR REPLACE FUNCTION checkRoad() RETURNS TRIGGER AS $$
    BEGIN
       IF((SELECT COUNT(*)
            FROM Roads
            WHERE ownerpersonnummer = NEW.ownerpersonnummer AND fromarea = NEW.toarea AND toarea = NEW.fromarea AND fromcountry = NEW.tocountry
            AND tocountry = NEW.fromcountry AND ownercountry = NEW.ownercountry) > 0)
            THEN RAISE EXCEPTION 'Road already exists';
       END IF;

       IF((SELECT COUNT(*)
            FROM Persons
            WHERE personnummer = new.ownerpersonnummer AND country = new.ownercountry AND
            ((LocationArea=new.fromarea AND LocationCountry=new.fromcountry ) OR
                (LocationArea=new.toarea AND LocationCountry=new.tocountry))) < 1 )
            THEN RAISE EXCEPTION 'Person not in right location';
        END IF;

        IF((SELECT budget
            FROM Persons
            WHERE personnummer = new.ownerpersonnummer AND country = new.ownercountry) < getval('roadprice'))
            THEN RAISE EXCEPTION 'Not enough money';
        END IF;

    RETURN NEW;
    END
    $$ LANGUAGE 'plpgsql';

CREATE TRIGGER newRoad
    BEFORE INSERT ON Roads
    FOR EACH ROW
    EXECUTE PROCEDURE checkRoad();


CREATE OR REPLACE FUNCTION updateBudget() RETURNS TRIGGER AS $$
    BEGIN
        UPDATE Persons
        SET budget = budget - getval('roadprice')
        WHERE personnummer = new.ownerpersonnummer
        AND country = new.ownercountry;
    RETURN NEW;
    END
    $$ LANGUAGE 'plpgsql';

CREATE TRIGGER afterNewRoad
    AFTER INSERT ON Roads
    FOR EACH ROW
    EXECUTE PROCEDURE updateBudget();

CREATE OR REPLACE FUNCTION updateRoadTaxOnly() RETURNS TRIGGER AS $$
    BEGIN
        IF(NOT(new.toarea=old.toarea AND new.tocountry=old.tocountry AND new.fromarea=old.fromarea AND 
            new.fromcountry=old.fromcountry AND new.ownerpersonnummer=old.ownerpersonnummer AND new.ownercountry = old.ownercountry))
            SET old.roadtax = new.roadtax;
            RETURN OLD;
        END IF;
    RETURN NEW;
    END
    $$ LANGUAGE 'plpgsql';

CREATE TRIGGER afterNewRoad
    AFTER UPDATE ON Roads
    FOR EACH ROW
    EXECUTE PROCEDURE updateRoadTaxOnly();



/*This no work. Why??? */
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
    FOR EACH ROW
    EXECUTE PROCEDURE removeDuplicate();

