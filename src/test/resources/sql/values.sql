CREATE TABLE Bakery (
    BakeryID INT PRIMARY KEY,
    Name VARCHAR(100),
    City VARCHAR(100),
    FoundedYear INT,
    HasOnlineShop BOOLEAN
);

INSERT INTO Bakery (BakeryID, Name, City, FoundedYear, HasOnlineShop)
VALUES (1, "Sweet Delights Bakery", "Cityville", 2005, TRUE);

INSERT INTO Bakery (BakeryID, Name, City, FoundedYear, HasOnlineShop)
VALUES (2, "Artisanal Breads And Pastries", "Townburg", 2010, FALSE);

INSERT INTO Bakery (BakeryID, Name, City, FoundedYear, HasOnlineShop)
VALUES (3, "Taste of Home Bakery", "Villageton", 1998, TRUE);

INSERT INTO Bakery (BakeryID, Name, City, FoundedYear, HasOnlineShop)
VALUES (4, "Gourmet Cupcakes By Emily", "Countryside", 2015, TRUE);