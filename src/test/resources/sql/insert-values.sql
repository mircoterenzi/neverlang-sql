CREATE TABLE Bakery (
    BakeryID INT,
    Name VARCHAR(100),
    City VARCHAR(100),
    FoundedYear INT,
    HasOnlineShop BOOLEAN
);

INSERT INTO Bakery (BakeryID, Name, City, FoundedYear, HasOnlineShop)
VALUES (1, "SweetDelightsBakery", "Cityville", 2005, TRUE);

INSERT INTO Bakery (BakeryID, Name, City, FoundedYear, HasOnlineShop)
VALUES (2, "ArtisanalBreadsAndPastries", "Townburg", 2010, FALSE);

INSERT INTO Bakery (BakeryID, Name, City, FoundedYear, HasOnlineShop)
VALUES (3, "TasteofHomeBakery", "Villageton", 1998, TRUE);

INSERT INTO Bakery (BakeryID, Name, City, FoundedYear, HasOnlineShop)
VALUES (4, "GourmetCupcakesByEmily", "Countryside", 2015, TRUE);