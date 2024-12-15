CREATE TABLE Profile (
    ID_Profile SERIAL PRIMARY KEY,
    Name TEXT NOT NULL
);

CREATE TABLE Coordinate (
    ID_Coordinate SERIAL PRIMARY KEY,
    Name TEXT NOT NULL,
    X NUMERIC NOT NULL,
    Y NUMERIC NOT NULL,
    Z NUMERIC NOT NULL,
    Profile_ID INT NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Profile_ID) REFERENCES Profile(ID_Profile) ON DELETE CASCADE
);
