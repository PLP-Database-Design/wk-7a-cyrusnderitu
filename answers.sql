-- ### Question 1 Achieving 1NF (First Normal Form) 🛠️
CREATE DATABASE trials;
use trials;
CREATE TABLE Orders_1NF_Violated (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    ProductsOrdered TEXT -- This violates 1NF by storing multiple values in one field
);

INSERT INTO Orders_1NF_Violated (OrderID, CustomerName, ProductsOrdered)
VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');


-- Normalizing The Table that violates 1NF
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Transferring the OrderId and CustomerName from the violated table to the new Orders Table
INSERT INTO Orders
SELECT OrderID, CustomerName FROM Orders_1NF_Violated;

-- Order_Products table created to solve the violation of 1NF
CREATE TABLE Order_Products (
    OrderProductID INT AUTO_INCREMENT PRIMARY KEY, -- new table PrimaryKey
    OrderID INT,
    ProductName VARCHAR(100),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE numbers (n INT);
INSERT INTO numbers VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

-- Transferring Multiple Data to each single cell to prevent redundancy
INSERT INTO Order_Products (OrderID, ProductName)
SELECT
  o.OrderID,
  TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(o.ProductsOrdered, ',', n.n), ',', -1)) AS ProductName
FROM
  Orders_1NF_Violated o
JOIN
  numbers n ON n.n <= 1 + LENGTH(o.ProductsOrdered) - LENGTH(REPLACE(o.ProductsOrdered, ',', ''));
  
  SELECT * FROM Order_Products;
  SELECT * FROM Orders;
  
  -- ### Question 2 Achieving 2NF (Second Normal Form) 🧩
  
-- Normal Table Violating 2NF
CREATE TABLE Orders_2NF_Violation (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT
);
INSERT INTO Orders_2NF_Violation VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

SELECT * FROM Orders_2NF_Violation;

-- Sepating the table to two (Orders, Order_details)
CREATE TABLE Orders_2NF(
OrderID INT PRIMARY KEY,
CustomerName VARCHAR(100)
);
-- Trasferring only OrderID and CustomerName(Partial Dependent) to the Orders Table
INSERT INTO Orders_2NF(OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName FROM Orders_2NF_Violation;

CREATE TABLE Order_Details (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
-- Trasferring only OrderID, Product & CustomerName to the OrdersDetails (OrderId Dependent)
INSERT INTO Order_Details (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity FROM Orders_2NF_Violation;
