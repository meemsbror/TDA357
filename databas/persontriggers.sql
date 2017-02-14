CREATE OR REPLACE FUNCTION updatePerson() RETURNS TRIGGER AS $$
    BEGIN
    /* Check if there is a valid road to the new location*/
    IF((SELECT COUNT(*)
        FROM NextMoves
        WHERE personcountry = old.country AND personnummer = old.personnummer
        AND country = old.locationcountry AND area = old.locationarea
        AND destcountry = new.locationcountry AND destarea = new.locationarea)> 0) THEN

            /* Check if there is a free road between the locations */
            --THIS IS UNNECESSARY
            IF((SELECT COUNT(*)
                FROM Roads
                WHERE ((fromarea = old.locationarea AND fromcountry = old.locationcountry
                AND toarea = new.locationarea AND tocountry = new.locationcountry)
                OR (fromarea = new.locationarea AND fromcountry = new.locationcountry
                AND toarea = old.locationarea AND tocountry = old.locationcountry))

                AND ((ownerpersonnummer = new.personnummer AND ownercountry = new.country)
                OR ((ownerpersonnummer = ' ' AND ownercountry = ' ')))) > 0) THEN

                RETURN NEW;
            END IF;

            /* If there is no free road check if the person has enough money 
            to travel on the cheapest one */
            --ONLY NEED TO CHECK IF PERSON HAS ENOUGH MONEY TO TRAVEL. NEXT MOVES ALWAYS SHOWS THE CHEAPEST WAY
            IF((SELECT roadtax
                FROM Roads
                WHERE ((fromarea = old.locationarea AND fromcountry = old.locationcountry
                AND toarea = new.locationarea AND tocountry = new.locationcountry)
                OR (fromarea = new.locationarea AND fromcountry = new.locationcountry
                AND toarea = old.locationarea AND tocountry = old.locationcountry))
                ORDER BY roadtax ASC
                LIMIT 1
                ) < new.budget) THEN
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

CREATE OR REPLACE FUNCTION afterUpdatePerson() RETURNS TRIGGER AS $$
    BEGIN
    /* Check if there is a free road between the locations */
    --My dear... Same as above. 
    IF((SELECT COUNT(*)
        FROM Roads
        WHERE ((fromarea = old.locationarea AND fromcountry = old.locationcountry
        AND toarea = new.locationarea AND tocountry = new.locationcountry)
        OR (fromarea = new.locationarea AND fromcountry = new.locationcountry
        AND toarea = old.locationarea AND tocountry = old.locationcountry))

        AND ((ownerpersonnummer = new.personnummer AND ownercountry = new.country)
        OR ((ownerpersonnummer = ' ' AND ownercountry = ' ')))) > 0) THEN

        RETURN NEW;
    END IF;

    /* Deducts cheapest alternative from budget */
    -- :(
    UPDATE persons
    SET budget = budget - 
    (SELECT cost
    FROM NextMoves
    WHERE country = old.locationcountry AND area = old.locationarea
    AND destcountry = new.locationcountry AND destarea = new.locationarea
    ORDER BY cost ASC
    LIMIT 1)
    WHERE personnummer = new.personnummer AND country = new.country;

    RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER afterUpdate
    AFTER UPDATE OF locationArea, locationCountry
    ON Persons
    FOR EACH ROW
    EXECUTE PROCEDURE afterUpdatePerson();
