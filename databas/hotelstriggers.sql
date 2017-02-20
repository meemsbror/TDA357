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



