CREATE TABLE IF NOT EXISTS Countries (
    name TEXT,
    PRIMARY KEY (name)
    );

CREATE TABLE IF NOT EXISTS Areas (
    country TEXT,
    name TEXT,
    population INT NOT NULL,
    CHECK(population >= 0),
    PRIMARY KEY (country,name),
    FOREIGN KEY (country) REFERENCES Countries (name)
    );

CREATE TABLE IF NOT EXISTS Towns (
    country TEXT,
    name TEXT,
    PRIMARY KEY (country,name),
    FOREIGN KEY (country,name) REFERENCES Areas (country,name)
    );

CREATE TABLE IF NOT EXISTS Cities (
    country TEXT,
    name TEXT,
    visitbonus NUMERIC NOT NULL,
    CHECK(visitbonus >= 0),
    PRIMARY KEY (country,name),
    FOREIGN KEY (country,name) REFERENCES Areas (country,name)
    );

CREATE TABLE IF NOT EXISTS Persons (
    country TEXT,
    personnummer TEXT,
    name TEXT NOT NULL,
    locationcountry TEXT NOT NULL,
    locationarea TEXT NOT NULL,
    budget NUMERIC NOT NULL,

    CHECK(budget >= 0),
    CHECK(personnummer ~* '^[0-9]{8}-[0-9]{4}$' OR (country = ' ' AND personnummer = ' ')),
    PRIMARY KEY (country,personnummer),
    FOREIGN KEY (country) REFERENCES Countries (name),
    FOREIGN KEY (locationarea, locationcountry) REFERENCES Areas (name,country)
    );


CREATE TABLE IF NOT EXISTS Hotels (
    name TEXT NOT NULL,
    locationcountry TEXT,
    locationname TEXT,
    ownercountry TEXT,
    ownerpersonnummer TEXT,
    PRIMARY KEY (locationcountry,locationname,ownercountry,ownerpersonnummer),
    FOREIGN KEY (locationcountry,locationname) REFERENCES Cities (country,name),
    FOREIGN KEY (ownercountry,ownerpersonnummer) REFERENCES Persons (country,personnummer)
    );


CREATE TABLE IF NOT EXISTS Roads (
    fromcountry TEXT,
    fromarea TEXT,
    tocountry TEXT,
    toarea TEXT,
    ownercountry TEXT,
    ownerpersonnummer TEXT,
    roadtax  NUMERIC NOT NULL,

    CHECK(roadtax >= 0),
    CHECK(NOT(fromarea=toarea AND fromcountry=tocountry)),
    PRIMARY KEY (fromcountry,fromarea,tocountry,toarea,ownercountry,ownerpersonnummer),
    FOREIGN KEY (fromcountry,fromarea) REFERENCES Areas (country,name),
    FOREIGN KEY (tocountry,toarea) REFERENCES Areas (country,name),
    FOREIGN KEY (ownercountry,ownerpersonnummer) REFERENCES Persons (country,personnummer)
    );




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
 




CREATE OR REPLACE FUNCTION beforeNewHotel() RETURNS TRIGGER AS $$
    BEGIN
        /* Government cannot own hotel */
        IF(new.ownerpersonnummer = ' ' AND new.ownercountry = ' ')
            THEN RAISE EXCEPTION 'The government cannot own a hotel';
        END IF;

        /* See if person has enough money before buying hotel*/
       IF((SELECT budget 
          FROM Persons
          WHERE personnummer = new.ownerpersonnummer
          AND country = new.ownercountry) < getval('hotelprice'))
            THEN RAISE EXCEPTION 'You are too poor to buy a new hotel';
       END IF;
       /* Check if person is already owner of a hotel in that city*/
        IF((SELECT COUNT(*) 
            FROM Hotels
            WHERE ownerpersonnummer = new.ownerpersonnummer 
            AND ownercountry = new.ownercountry
            AND locationcountry = new.locationcountry
            AND locationname = new.locationname) > 0 )
            THEN RAISE EXCEPTION 'Person already owner of a hotel in this city!';
        END IF;
    RETURN NEW;
    END
    $$ LANGUAGE 'plpgsql';

CREATE TRIGGER beforeNewHotel
    BEFORE INSERT ON Hotels
    FOR EACH ROW
    EXECUTE PROCEDURE beforeNewHotel();

CREATE OR REPLACE FUNCTION afterNewHotel() RETURNS TRIGGER AS $$
    BEGIN
    
        /*Update person's budget after buying new hotel*/
        UPDATE Persons
        SET budget = budget - getval('hotelprice')
        WHERE personnummer = new.ownerpersonnummer 
        AND country = new.ownercountry;

    RETURN NEW;
    END
    $$ LANGUAGE 'plpgsql';

CREATE TRIGGER afterNewHotel
    AFTER INSERT ON Hotels
    FOR EACH ROW
    EXECUTE PROCEDURE afterNewHotel();

CREATE OR REPLACE FUNCTION updateHotelOwner() RETURNS TRIGGER AS $$
    BEGIN
         /* Government cannot own hotel */
        IF(new.ownerpersonnummer = ' ' AND new.ownercountry = ' ')
            THEN RAISE EXCEPTION 'The government cannot own a hotel';
        END IF;
        
        /* If already owns hotel, cannot change owner to this person */
        IF((SELECT COUNT(*) 
            FROM Hotels
            WHERE ownerpersonnummer = new.ownerpersonnummer 
            AND ownercountry = new.ownercountry
            AND locationcountry = new.locationcountry
            AND locationname = new.locationname) > 0 )
                THEN RAISE EXCEPTION 'Person already owner of a hotel in this city!';
        END IF;

        /* You cannot change the hotel's location */
            new.locationcountry := old.locationcountry;
            new.locationname := old.locationname;

    RETURN NEW;
    END
    $$ LANGUAGE 'plpgsql';

CREATE TRIGGER updateHotelOwner
    BEFORE UPDATE OF ownercountry,ownerpersonnummer
    ON Hotels
    FOR EACH ROW
    EXECUTE PROCEDURE updateHotelOwner();

CREATE OR REPLACE FUNCTION updateHotelCity() RETURNS TRIGGER AS $$
    BEGIN
        /* A hotel may not change it's location */
        RAISE EXCEPTION 'Can not move hotel to new city';

    RETURN NEW;
    END
    $$ LANGUAGE 'plpgsql';

CREATE TRIGGER updateHotelCity
    BEFORE UPDATE OF locationcountry, locationname
    ON Hotels
    FOR EACH ROW
    EXECUTE PROCEDURE updateHotelCity();


CREATE OR REPLACE FUNCTION sellHotel() RETURNS TRIGGER AS $$
    BEGIN
        /* If a hotel is sold (deleted), increase the persons's budget with refund */
        UPDATE Persons
        SET budget = budget + (getval('hotelrefund') * getval('hotelprice'))
        WHERE personnummer = OLD.personnummer 
        AND country = OLD.country;

    RETURN OLD;
    END
    $$ LANGUAGE 'plpgsql';

CREATE TRIGGER deleteHotel
    AFTER DELETE ON Hotels
    FOR EACH ROW
    EXECUTE PROCEDURE sellHotel();




CREATE OR REPLACE VIEW  NextMoves AS
    WITH
    NextMovesHelp AS(
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

        UNION ALL

        SELECT p.country AS personcountry,
        p.personnummer,
        p.locationcountry AS country,
        p.locationarea AS area,
        r.tocountry AS destcountry,
        r.toarea AS destarea,
        0 AS cost
        FROM Persons p, Roads r
        WHERE (p.locationcountry = r.fromcountry AND p.locationarea = r.fromarea) AND
        ( p.personnummer = r.ownerpersonnummer AND p.country = r.ownercountry)

        UNION ALL

        SELECT p.country AS personcountry,
        p.personnummer,
        p.locationcountry AS country,
        p.locationarea AS area,
        r.fromcountry AS destcountry,
        r.fromarea AS destarea,
        0 AS cost
        FROM Persons p, Roads r
        WHERE (p.locationcountry = r.tocountry AND p.locationarea = r.toarea) AND
        ( p.personnummer = r.ownerpersonnummer AND p.country = r.ownercountry)
    )

    SELECT personcountry, personnummer, country, area, destcountry, destarea, MIN(cost) AS cost
    FROM NextMovesHelp
    WHERE personnummer <> ' ' AND personcountry <> ' '
    GROUP BY personcountry, personnummer, country, area, destcountry, destarea
    ORDER BY personnummer
;

CREATE OR REPLACE VIEW AssetsSummary AS
WITH
    roadAssets AS(
        SELECT ownercountry, ownerpersonnummer, COUNT(*) * getval('roadprice') AS rAssets
        FROM Roads
        GROUP BY ownercountry, ownerpersonnummer
    ),
    hotelAssets AS(
        SELECT ownercountry, ownerpersonnummer, COUNT(*) * getval('hotelprice') AS hAssets,
        COUNT(*) * getval('hotelrefund') * getval('hotelprice') AS reclaimable
        FROM Hotels
        GROUP BY ownercountry, ownerpersonnummer
    ),
    personBudget AS(
    	SELECT personnummer AS ownerpersonnummer, country AS ownercountry, budget
    	FROM Persons)
SELECT ownercountry AS country, ownerpersonnummer AS personnummer, budget, hAssets + rAssets AS assets, reclaimable
FROM roadAssets r
NATURAL INNER JOIN hotelAssets h
NATURAL INNER JOIN personBudget p
WHERE ownerpersonnummer<>' '
;

