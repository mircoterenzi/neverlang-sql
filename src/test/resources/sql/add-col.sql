CREATE TABLE Department (
    DepartmentID INT,
    DepartmentName VARCHAR(50)
);

ALTER TABLE Department
ADD ManagerName VARCHAR(50);

ALTER TABLE Department
ADD Budget FLOAT;