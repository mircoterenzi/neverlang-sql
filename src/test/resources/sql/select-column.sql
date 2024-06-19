CREATE TABLE Panetteria(
    nomePane VARCHAR(26), 
    prezzoKg FLOAT, 
    qt INT, 
    fattoInCasa BOOLEAN
);
INSERT INTO Panetteria(nomePane, prezzoKg, qt, fattoInCasa)  VALUES (Rosetta, 10.0, 20, True);
INSERT INTO Panetteria(nomePane, prezzoKg, qt, fattoInCasa)  VALUES (Ciabatta, 2.0, 3, True);
INSERT INTO Panetteria(nomePane, prezzoKg, qt, fattoInCasa)  VALUES (Arabo, 13.0, 50, False);
SELECT nomePane FROM Panetteria;