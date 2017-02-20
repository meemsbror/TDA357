CREATE OR REPLACE FUNCTION updatePerson() RETURNS TRIGGER AS $$
    BEGIN
    /* Check it the person has moved */
    IF(new.locationarea = old.locationarea
        AND new.locationcountry = old.locationcountry)
        THEN RAISE EXCEPTION 'Cannot move to same area';
    END IF;

    /* Check if there is a valid road to the new location*/
    IF((SELECT COUNT(*)
        FROM NextMoves
        WHERE personcountry = new.country AND personnummer = new.personnummer
        AND country = old.locationcountry AND area = old.locationarea
        AND destcountry = new.locationcountry AND destarea = new.locationarea)> 0) THEN

            /* Check if the person has enough money to travel on the 
            cheapest road (which is the only one returned in nextmoves) */
            IF((SELECT COUNT(*)
                FROM hotels
                WHERE locationcountry = new.locationcountry
                AND locationname = new.locationarea)>0)
                THEN

                IF((SELECT cost
                    FROM NextMoves
                    WHERE personcountry = old.country AND personnummer = old.personnummer
                    AND country = old.locationcountry AND area = old.locationarea
                    AND destcountry = new.locationcountry AND destarea = new.locationarea)
                    +
                    getval('cityvisit')
                    >
                    (SELECT budget
                    FROM persons
                    WHERE country = old.country
                    AND personnummer = old.personnummer)) THEN
                    RAISE EXCEPTION 'Not enough money to travel here';
                    RETURN OLD;
                END IF;
            ELSIF ((SELECT cost
                    FROM NextMoves
                    WHERE personcountry = old.country AND personnummer = old.personnummer
                    AND country = old.locationcountry AND area = old.locationarea
                    AND destcountry = new.locationcountry AND destarea = new.locationarea)
                    >
                    (SELECT budget
                    FROM persons
                    WHERE country = old.country
                    AND personnummer = old.personnummer)) THEN
                    RAISE EXCEPTION 'Not enough money to travel here';
                    RETURN OLD;
                END IF;
                RETURN NEW;
        END IF;
        RAISE EXCEPTION 'No road from your location to the destination';

    END
    $$ LANGUAGE 'plpgsql';


CREATE TRIGGER beforePerUpdate
    BEFORE UPDATE OF locationArea, locationCountry
    ON Persons
    FOR EACH ROW
    EXECUTE PROCEDURE updatePerson();

CREATE OR REPLACE FUNCTION afterUpdatePerson() RETURNS TRIGGER AS $$
    BEGIN
        IF((SELECT COUNT(*)
            FROM Persons
            WHERE personnummer = new.personnummer AND country = new.country
            AND locationcountry = new.locationcountry AND locationarea = new.locationarea)
            > 0)
        THEN
            /* Deducts the roadtax and citivisit (if city) from budget */
            IF((SELECT COUNT(*)
                FROM hotels
                WHERE locationcountry = new.locationcountry
                AND locationname = new.locationarea)>0)
            THEN
                UPDATE persons
                SET budget = budget - 
                    (SELECT cost
                     FROM NextMoves
                     WHERE personcountry = old.country
                     AND personnummer = old.personnummer
                     AND country = new.locationcountry
                     AND area = new.locationarea
                     AND destcountry = old.locationcountry
                     AND destarea = old.locationarea)
                - getval('cityvisit')
                WHERE personnummer = new.personnummer AND country = new.country;

                UPDATE Persons p
                SET budget = budget + 
                getval('cityvisit') /
                (SELECT COUNT(*)
                    FROM hotels
                    WHERE locationcountry = new.locationcountry
                    AND locationname = new.locationarea)
                FROM hotels h
                WHERE p.country = h.ownercountry
                    AND p.personnummer = h.ownerpersonnummer
                    AND h.locationcountry = new.locationcountry
                    AND h.locationname = new.locationarea

                ;

            ELSE
                /* Deducts the roadtax from budget, if the person moved */
            UPDATE persons
            SET budget = budget - 
            (SELECT cost
                FROM NextMoves
                WHERE personcountry = old.country
                AND personnummer = old.personnummer
                AND country = new.locationcountry
                AND area = new.locationarea
                AND destcountry = old.locationcountry
                AND destarea = old.locationarea)
            WHERE personnummer = new.personnummer AND country = new.country;

            END IF;

            /* Adds citybonus to person's budget, if there is a citybonus*/
            IF((SELECT COUNT(*)
                FROM Cities
                WHERE country = new.locationcountry
                AND name = new.locationarea) > 0) THEN
                    UPDATE persons
                    SET budget = budget +
                        (SELECT visitbonus
                         FROM Cities
                         WHERE country = new.locationcountry
                         AND name = new.locationarea)
                    WHERE personnummer = new.personnummer AND country = new.country;

                    --Set bonus to zero after used
                    UPDATE cities
                    SET visitbonus = 0
                    WHERE new.locationcountry = country AND new.locationarea = name;

            RETURN NEW;
            END IF;
        END IF;

    RETURN OLD;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER afterUpdate
    AFTER UPDATE OF locationArea, locationCountry
    ON Persons
    FOR EACH ROW
    EXECUTE PROCEDURE afterUpdatePerson();


