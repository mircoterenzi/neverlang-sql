CREATE TABLE Book (
    BookID INT,
    Title VARCHAR(100),
    Author VARCHAR(50),
    Year INT,
    Price FLOAT,
    Available BOOLEAN
);

INSERT INTO Book (BookID, Title, Author, Year, Price, Available)
VALUES (1, 'Il Nome della Rosa', 'Umberto Eco', 1980, NULL, TRUE);

INSERT INTO Book (BookID, Title, Author, Year, Price, Available)
VALUES (2, 'Cento Anni di Solitudine', 'Gabriel Garcia Marquez', 1967, 12.50, TRUE);

INSERT INTO Book (BookID, Title, Author, Year, Price, Available)
VALUES (3, 'Il Signore degli Anelli', 'JRR Tolkien', 1954, NULL, FALSE);

INSERT INTO Book (BookID, Title, Author, Year, Price, Available)
VALUES (4, '1984', 'George Orwell', 1949, 14.99, TRUE);

INSERT INTO Book (BookID, Title, Author, Year, Price, Available)
VALUES (5, 'Il Grande Gatsby', 'F Scott Fitzgerald', 1925, 10.99, FALSE);

SELECT * FROM Book
ORDER BY Title ASC;

SELECT * FROM Book
WHERE Price > 12 AND Available = TRUE;

SELECT * FROM Book
WHERE Year > 1950 OR Price IS NULL;

SELECT * FROM Book
WHERE Author = 'Umberto Eco';

SELECT * FROM Book
ORDER BY Price ASC;