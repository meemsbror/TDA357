CREATE OR REPLACE FUNCTION updatePerson() RETURNS TRIGGER AS $$
    BEGIN
    IF((SELECT COUNT(*)
        FROM Roads
        WHERE (fromarea = old.locationarea AND fromcountry = old.locationcountry
        AND toarea = new.locationarea AND tocountry = new.locationcountry)
        OR (fromarea = new.locationarea AND fromcountry = new.locationcountry
        AND toarea = old.locationarea AND tocountry = old.locationcountry)) > 0) THEN

            IF((SELECT COUNT(*)
                FROM Roads
                WHERE (fromarea = old.locationarea AND fromcountry = old.locationcountry
                AND toarea = new.locationarea AND tocountry = new.locationcountry)
                OR (fromarea = new.locationarea AND fromcountry = new.locationcountry
                AND toarea = old.locationarea AND tocountry = old.locationcountry)
                AND (ownerpersonnummer = new.personnummer AND ownercountry = new.country)
                OR ((ownerpersonnummer = ' ' AND ownercountry = ' '))) > 0) THEN
                    RETURN NEW;
            END IF;

            IF((SELECT TOP roadtax
                FROM Roads
                WHERE (fromarea = old.locationarea AND fromcountry = old.locationcountry
                AND toarea = new.locationarea AND tocountry = new.locationcountry)
                OR (fromarea = new.locationarea AND fromcountry = new.locationcountry
                AND toarea = old.locationarea AND tocountry = old.locationcountry))
                < new.budget) THEN
                RETURN NEW;
            END IF;

            RAISE EXCEPTION 'Not enough moneyz to move here';
        END IF;
        RAISE EXCEPTION 'No road yo';

    END
    $$ LANGUAGE 'plpgsql';


CREATE TRIGGER beforePerUpdate
    BEFORE UPDATE OF locationArea, locationCountry
    ON Persons
    FOR EACH ROW
    EXECUTE PROCEDURE updatePerson();


