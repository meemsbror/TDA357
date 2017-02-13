CREATE OR REPLACE FUNCTION beforeNewHotel() RETURNS TRIGGER AS $$
    BEGIN
       IF((SELECT budget 
          FROM Persons
          WHERE personnummer = new.ownerpersonnummer
          AND country = new.ownercountry) < getval('hotelprice'))
            THEN RAISE EXCEPTION 'You too poor bro';
       END IF;
    RETURN NEW;
    END
    $$ LANGUAGE 'plpgsql';

CREATE TRIGGER beforeNewHotel
    BEFORE INSERT ON Hotels
    FOR EACH ROW
    EXECUTE PROCEDURE beforeNewHotel();