CREATE TABLE Customer (
    CustomerID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT,
    CustomerID INT,
    Amount FLOAT,
    Shipped BOOLEAN
);

ALTER TABLE Orders
ADD ShippingAddress VARCHAR(200);

ALTER TABLE Orders
ADD OrderStatus VARCHAR(50);

ALTER TABLE Orders
DROP Amount;

ALTER TABLE Orders
DROP Shipped;

DROP TABLE Customer;