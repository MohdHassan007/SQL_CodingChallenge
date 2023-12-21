CREATE DATABASE  Shop;
USE Shop;
-- Create Vehicle Table
CREATE TABLE Vehicle (
    carID INT PRIMARY KEY IDENTITY(1,1),
    make VARCHAR(255),
    model VARCHAR(255),
    year INT,
    dailyRate DECIMAL(10, 2),
    status INT,
    passengerCapacity INT,
    engineCapacity INT
);

-- Create Customer Table
CREATE TABLE Customer (
    customerID INT PRIMARY KEY IDENTITY(1,1),
    firstName VARCHAR(255),
    lastName VARCHAR(255),
    email VARCHAR(255),
    phoneNumber VARCHAR(20)
);

-- Create Lease Table
CREATE TABLE Lease (
    leaseID INT PRIMARY KEY IDENTITY(1,1),
    vehicleID INT,
    customerID INT,
    startDate DATE,
    endDate DATE,
    leaseType VARCHAR(50),
    FOREIGN KEY (vehicleID) REFERENCES Vehicle(carID),
    FOREIGN KEY (customerID) REFERENCES Customer(customerID)
);

-- Create Payment Table
CREATE TABLE Payment (
    paymentID INT PRIMARY KEY IDENTITY(1,1),
    leaseID INT,
    transactionDate DATE,
    amount DECIMAL(10, 2),
    FOREIGN KEY (leaseID) REFERENCES Lease(leaseID)
);

INSERT INTO Vehicle (make, model, year, dailyRate, status, passengerCapacity, engineCapacity)
VALUES
('Toyota', 'Camry', 2022, 50.00, 1, 4, 1450),
('Honda', 'Civic', 2023, 45.00, 1, 7, 1500),
('Ford', 'Focus', 2022, 48.00, 0, 4, 1400),
('Nissan', 'Altima', 2023, 52.00, 1, 7, 1200),
('Chevrolet', 'Malibu', 2022, 47.00, 1, 4, 1800),
('Hyundai', 'Sonata', 2023, 49.00, 0, 7, 1400),
('BMW', '3 Series', 2023, 60.00, 1, 7, 2499),
('Mercedes', 'C-Class', 2022, 58.00, 1, 8, 2599),
('Audi', 'A4', 2022, 55.00, 0, 4, 2500),
('Lexus', 'ES', 2023, 54.00, 1, 4, 2500);

-- Insert into Customer Table
INSERT INTO Customer (firstName, lastName, email, phoneNumber)
VALUES
('John', 'Doe', 'johndoe@example.com', '555-555-5555'),
('Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
('Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
('Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
('David', 'Lee', 'david@example.com', '555-987-6543'),
('Laura', 'Hall', 'laura@example.com', '555-234-5678'),
('Michael', 'Davis', 'michael@example.com', '555-876-5432'),
('Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
('William', 'Taylor', 'william@example.com', '555-321-6547'),
('Olivia', 'Adams', 'olivia@example.com', '555-765-4321');

-- Insert into Lease Table
INSERT INTO Lease (vehicleID, customerID, startDate, endDate, leaseType)
VALUES
(1, 1, '2023-01-01', '2023-01-05', 'Daily'),
(2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
(3, 3, '2023-03-10', '2023-03-15', 'Daily'),
(4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
(5, 5, '2023-05-05', '2023-05-10', 'Daily'),
(6, 4, '2023-06-15', '2023-06-30', 'Monthly'),
(7, 7, '2023-07-01', '2023-07-10', 'Daily'),
(8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
(9, 3, '2023-09-07', '2023-09-10', 'Daily'),
(10, 10, '2023-10-10', '2023-10-31', 'Monthly');

-- Insert into Payment Table
INSERT INTO Payment (leaseID, transactionDate, amount)
VALUES
(1, '2023-01-03', 200.00),
(2, '2023-02-20', 1000.00),
(3, '2023-03-12', 75.00),
(4, '2023-04-25', 900.00),
(5, '2023-05-07', 60.00),
(6, '2023-06-18', 1200.00),
(7, '2023-07-03', 40.00),
(8, '2023-08-14', 1100.00),
(9, '2023-09-09', 80.00),
(10, '2023-10-25', 1500.00);

SELECT * from Vehicle;
-- 1. Update the daily rate for a Mercedes car to 68.
UPDATE Vehicle SET dailyRate = 68 WHERE make = 'Mercedes';

-- 2. Delete a specific customer and all associated leases and payments.
-- Step 1: Delete associated records in the Payment table
DELETE FROM Payment WHERE leaseID IN (SELECT leaseID FROM Lease WHERE customerID = 1);
-- Step 2: Delete associated records in the Lease table
DELETE FROM Lease WHERE customerID = 1;

-- Step 3: Delete the record in the Customer table
DELETE FROM Customer WHERE customerID = 1;

-- 3. Rename the "paymentDate" column in the Payment table to "transactionDate".
EXEC sp_rename 'Payment.paymentDate', 'transactionDate', 'COLUMN';

-- 4. Find a specific customer by email.
SELECT * FROM Customer WHERE email = 'robert@example.com';

-- 5. Get active leases for a specific customer.
SELECT * FROM Lease WHERE customerID = 2 AND endDate >= GETDATE();

-- 6. Find all payments made by a customer with a specific phone number.
SELECT * FROM Payment
WHERE leaseID IN (SELECT leaseID FROM Lease WHERE customerID IN (SELECT customerID FROM Customer WHERE phoneNumber = '555-555-5555'));

-- 7. Calculate the average daily rate of all available cars.
SELECT AVG(dailyRate) AS AverageDailyRate FROM Vehicle WHERE status = 1;

-- 8. Find the car with the highest daily rate.
SELECT TOP 1 * FROM Vehicle ORDER BY dailyRate DESC;

-- 9. Retrieve all cars leased by a specific customer.
SELECT v.* FROM Vehicle v
JOIN Lease l ON v.carID = l.vehicleID
WHERE l.customerID = 4;

-- 10. Find the details of the most recent lease.
SELECT TOP 1 * FROM Lease ORDER BY startDate DESC;

-- 11. List all payments made in the year 2023.
SELECT * FROM Payment WHERE YEAR(transactionDate) = 2023;

-- 12. Retrieve customers who have not made any payments.
SELECT c.* FROM Customer c
LEFT JOIN Lease l ON c.customerID = l.customerID
LEFT JOIN Payment p ON l.leaseID = p.leaseID
WHERE p.paymentID IS NULL;

-- 13. Retrieve Car Details and Their Total Payments.
SELECT v.*, COALESCE(SUM(p.amount), 0) AS TotalPayments
FROM Vehicle v
LEFT JOIN Lease l ON v.carID = l.vehicleID
LEFT JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY v.carID;

-- 14. Calculate Total Payments for Each Customer.
SELECT c.*, COALESCE(SUM(p.amount), 0) AS TotalPayments
FROM Customer c
LEFT JOIN Lease l ON c.customerID = l.customerID
LEFT JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID;

-- 15. List Car Details for Each Lease.
SELECT v.*, l.startDate, l.endDate
FROM Vehicle v
JOIN Lease l ON v.carID = l.vehicleID;

-- 16. Retrieve Details of Active Leases with Customer and Car Information.
SELECT v.*, c.*, l.startDate, l.endDate
FROM Vehicle v
JOIN Lease l ON v.carID = l.vehicleID
JOIN Customer c ON l.customerID = c.customerID
WHERE l.endDate >= GETDATE();

-- 17. Find the Customer Who Has Spent the Most on Leases.
SELECT TOP 1 c.*, COALESCE(SUM(p.amount), 0) AS TotalPayments
FROM Customer c
LEFT JOIN Lease l ON c.customerID = l.customerID
LEFT JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID
ORDER BY TotalPayments DESC;

-- 18. List All Cars with Their Current Lease Information.
SELECT v.*, l.*
FROM Vehicle v
LEFT JOIN Lease l ON v.carID = l.vehicleID;
