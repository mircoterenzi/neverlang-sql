CREATE TABLE Panetteria(nomePane VARCHAR(26));
DROP TABLE Panetteria;
CREATE TABLE Panetteria(
    nomePane VARCHAR(26),
    qtKg FLOAT
);
ALTER TABLE Panetteria DROP nomePane;
ALTER TABLE Panetteria ADD prezzoKg FLOAT;
CREATE TABLE Fioraio(nomeFiore VARCHAR(26));