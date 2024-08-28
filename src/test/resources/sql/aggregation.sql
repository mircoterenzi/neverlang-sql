CREATE TABLE VinylStore (
    id INT PRIMARY KEY,
    artist VARCHAR(100),
    album VARCHAR(100),
    genre VARCHAR(50),
    price FLOAT
);

INSERT INTO VinylStore (id, artist, album, genre, price)
VALUES (1, 'The Beatles', 'Abbey Road', 'Rock', 19.99);

INSERT INTO VinylStore (id, artist, album, genre, price)
VALUES (2, 'Pink Floyd', 'The Dark Side of the Moon', 'Rock', 24.99);

INSERT INTO VinylStore (id, artist, album, genre, price)
VALUES (3, 'Michael Jackson', 'Thriller', 'Pop', 14.99);

INSERT INTO VinylStore (id, artist, album, genre, price)
VALUES (4, 'Led Zeppelin', 'Led Zeppelin IV', 'Rock', 21.99);

INSERT INTO VinylStore (id, artist, album, genre, price)
VALUES (5, 'Bob Marley', 'Legend', 'Reggae', 17.99);

INSERT INTO VinylStore (id, artist, album, genre, price)
VALUES (6, 'Pink Floyd', 'Wish You Were Here', 'Rock', 18.99);

INSERT INTO VinylStore (id, artist, album, genre, price)
VALUES (7, 'Elvis Presley', 'Elvis Presley', 'Rock', 16.99);

INSERT INTO VinylStore (id, artist, album, genre, price)
VALUES (8, 'Michael Jackson', 'Bad', 'Pop', 12.99);

INSERT INTO VinylStore (id, artist, album, genre, price)
VALUES (9, 'Michael Jackson', 'Dangerous', 'Pop', 23.99);

SELECT genre, COUNT(*)
FROM VinylStore 
GROUP BY genre;

SELECT artist, AVG(price)
FROM VinylStore 
GROUP BY artist;

SELECT album, MAX(price)
FROM VinylStore 
GROUP BY album;

SELECT genre, MIN(price)
FROM VinylStore 
GROUP BY genre;

SELECT artist, SUM(price)
FROM VinylStore 
GROUP BY artist;

SELECT artist, COUNT(*)
FROM VinylStore
WHERE price > 15
GROUP BY artist
ORDER BY artist ASC;