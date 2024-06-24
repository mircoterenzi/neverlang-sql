CREATE TABLE EventDetails (
    EventID INT,
    EventName VARCHAR(100),
    Location VARCHAR(100),
    Organizer VARCHAR(100),
    MaxAttendees INT,
    IsCancelled BOOLEAN
);

INSERT INTO EventDetails (EventID, EventName, Location, Organizer, MaxAttendees, IsCancelled)
VALUES (1, SummerPicnic, CentralPark, CompanyEventsTeam, 100, FALSE);

INSERT INTO EventDetails (EventID, EventName, Location, Organizer, MaxAttendees, IsCancelled)
VALUES (2, TechConference, ConventionCenter, TechConGroup, 300, FALSE);

INSERT INTO EventDetails (EventID, EventName, Location, Organizer, MaxAttendees, IsCancelled)
VALUES (3, CharityGala, GrandHotelBallroom, LocalCharityFoundation, 200, TRUE);

INSERT INTO EventDetails (EventID, EventName, Location, Organizer, MaxAttendees, IsCancelled)
VALUES (4, HolidayParty, OfficeHeadquarters, HRDepartment, 150, FALSE);

SELECT EventName, MaxAttendees
FROM EventDetails;