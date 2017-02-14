CREATE OR REPLACE FUNCTION checkRoad() RETURNS TRIGGER AS $$
    BEGIN
       /* Check if the owner already has a road between the areas */
       IF((SELECT COUNT(*)
            FROM Roads
            WHERE ownerpersonnummer = NEW.ownerpersonnummer 
            AND fromarea = NEW.toarea 
            AND toarea = NEW.fromarea 
            AND fromcountry = NEW.tocountry
            AND tocountry = NEW.fromcountry 
            AND ownercountry = NEW.ownercountry) > 0)
            THEN RAISE EXCEPTION 'Road already exists';
       END IF;

       /* Check if it is the goverment, location or money not neccessary*/
       IF(new.ownerpersonnummer = ' ' AND new.ownercountry = ' ')
            THEN RETURN NEW;
        END IF;

       /* Check if the owner is either in the start pos or end pos of the road */
       IF((SELECT COUNT(*)
            FROM Persons
            WHERE personnummer = new.ownerpersonnummer AND country = new.ownercountry AND
            ((LocationArea=new.fromarea AND LocationCountry=new.fromcountry ) OR
                (LocationArea=new.toarea AND LocationCountry=new.tocountry))) < 1 )
            THEN RAISE EXCEPTION 'Person not in right location';
        END IF;

        /* Check if the person has enough money to build the road */
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


/* Update the budgedt after you successfully create a road */
CREATE OR REPLACE FUNCTION updateBudget() RETURNS TRIGGER AS $$
    BEGIN
        /* No budget update needed if it's the government */
        IF(new.ownerpersonnummer = ' ' AND new.ownercountry = ' ')
            THEN RETURN NEW;
        END IF;

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

/* Blocks all updates except on roadtax */
CREATE OR REPLACE FUNCTION updateRoadTaxOnly() RETURNS TRIGGER AS $$
    BEGIN
        RAISE EXCEPTION 'Can only change the roadtax of roads';
    END
    $$ LANGUAGE 'plpgsql';

CREATE TRIGGER updateRoad
    BEFORE UPDATE OF toarea,fromarea,tocountry,fromcountry,ownercountry,ownerpersonnummer
    ON Roads
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

