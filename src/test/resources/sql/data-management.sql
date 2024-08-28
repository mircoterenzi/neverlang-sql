CREATE TABLE EventDetails (
    EventID INT,
    EventName VARCHAR(100),
    Location VARCHAR(100),
    Organizer VARCHAR(100),
    MaxAttendees INT,
    IsCancelled BOOLEAN
);

INSERT INTO EventDetails (EventID, EventName, Location, Organizer, MaxAttendees, IsCancelled)
VALUES (1, "Summer Picnic", "Central Park", "Company Events Team", 100, FALSE);

INSERT INTO EventDetails (EventID, EventName, Location, Organizer, MaxAttendees, IsCancelled)
VALUES (2, "Tech Conference", "Convention Center", "Tech Group", 300, FALSE);

INSERT INTO EventDetails (EventID, EventName, Location, Organizer, MaxAttendees, IsCancelled)
VALUES (3, "Charity Gala", "Grand Hotel Ball room", "Local Charity Foundation", 150, TRUE);

INSERT INTO EventDetails (EventID, EventName, Location, Organizer, MaxAttendees, IsCancelled)
VALUES (4, "Holiday Party", "Office Headquarters", NULL, 150, FALSE);

SELECT *
FROM EventDetails;

DELETE
FROM EventDetails
WHERE EventID = 4;

SELECT *
FROM EventDetails;

UPDATE EventDetails
SET IsCancelled = FALSE
WHERE EventID = 3;