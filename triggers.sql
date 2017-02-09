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
            WHERE peronnummer = new.ownerpersonnummer AND country = new.ownercountry AND 
            ((personLocationArea=new.fromarea AND personLocationCountry=new.fromcountry ) OR 
                (personLocationArea=new.toarea AND personLocationCountry=new.tocountry))) < 1 )
            THEN RAISE EXCEPTION 'Person not in right location';
        ENDIF;

        IF((SELECT budget
            FROM Persons
            WHERE peronnummer = new.ownerpersonnummer AND country = new.ownercountry) < getvalue('roadprice') )
            THEN RAISE EXCEPTION 'Not enough money';
        ENDIF;

    RETURN NEW;
    END
    $$ LANGUAGE 'plpgsql';

CREATE TRIGGER newRoad
    BEFORE INSERT ON Roads
    FOR EACH ROW
    EXECUTE PROCEDURE checkRoad();


REATE OR REPLACE FUNCTION updateBudget() RETURNS TRIGGER AS $$
    BEGIN
        UPDATE Persons
        SET budget = budget - getvalue('roadprice')
        WHERE peronnummer = new.ownerperonnummer 
        AND country = new.ownercountry;
    RETURN NEW;
    END
    $$ LANGUAGE 'plpgsql';

CREATE TRIGGER afterNewRoad
    AFTER INSERT ON Roads
    FOR EACH ROW
    EXECUTE PROCEDURE updateBudget();


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

CREATE TRIGGER personLocation
    BEFORE INSERT ON 
