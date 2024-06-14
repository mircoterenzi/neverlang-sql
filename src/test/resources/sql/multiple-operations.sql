CREATE TABLE Panetteria(nomePane string);
DROP TABLE Panetteria;
CREATE TABLE Panetteria(
    nomePane string,
    qtKg double
);
ALTER TABLE Panetteria DROP nomePane;
ALTER TABLE Panetteria ADD prezzoKg double;
CREATE TABLE Fioraio(nomeFiore string)