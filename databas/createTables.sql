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
    CHECK(personnummer ~* '^[0-9]{8}-[0-9]{4}$' OR (country = '' AND personnummer = '')),
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
    roadtax  NUMERIC NOT NULL DEFAULT getval('roadtax'),

    CHECK(roadtax >= 0),
    CHECK(NOT(fromarea=toarea AND fromcountry=tocountry)),
    PRIMARY KEY (fromcountry,fromarea,tocountry,toarea,ownercountry,ownerpersonnummer),
    FOREIGN KEY (fromcountry,fromarea) REFERENCES Areas (country,name),
    FOREIGN KEY (tocountry,toarea) REFERENCES Areas (country,name),
    FOREIGN KEY (ownercountry,ownerpersonnummer) REFERENCES Persons (country,personnummer)
    );



