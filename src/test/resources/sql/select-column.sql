CREATE TABLE Panetteria(
    nomePane VARCHAR(26),
    qtKg FLOAT
);
INSERT INTO Panetteria(nomePane, qtKg) VALUES (Rosetta, 10);
INSERT INTO Panetteria(nomePane, qtKg) VALUES (Ciabatta, 2);
INSERT INTO Panetteria(nomePane, qtKg) VALUES (Arabo, 13);
SELECT nomePane FROM Panetteria;