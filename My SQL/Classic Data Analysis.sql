-- 1Q(1a)
-- SELECT clause with WHERE, AND, DISTINCT, Wild Card (LIKE)

SELECT * FROM 5th_july.employees;

SELECT DISTINCT employeenumber, firstname, lastname FROM employees WHERE jobtitle = 'Sales Rep' AND reportsto = 1102;

-- 1Q(1b)

SELECT * FROM 5th_july.products;

SELECT DISTINCT productline FROM products WHERE productline LIKE '%cars';

-- 2Q(a)
-- CASE STATEMENTS for Segmentation

SELECT * FROM classicmodels.customers;

SELECT customerNumber, customerName,
       CASE
           WHEN country IN ('USA', 'Canada') THEN 'North America'
           WHEN country IN ('UK', 'France', 'Germany') THEN 'Europe'
           ELSE 'Other'
       END AS CustomerSegment
FROM classicmodels.customers;

-- 3Q(a)
-- Group By with Aggregation functions and Having clause, Date and Time functions

SELECT * FROM classicmodels.orderdetails;

SELECT productCode, SUM(quantityOrdered) AS totalQuantity FROM classicmodels.orderdetails GROUP BY productCode ORDER BY totalQuantity DESC LIMIT 10;


-- 3Q(b)

SELECT * FROM classicmodels.payments;

SELECT MONTHNAME(paymentDate) AS month, COUNT(*) AS totalPayments FROM classicmodels.payments GROUP BY MONTHNAME(paymentDate) HAVING totalPayments > 20 ORDER BY totalPayments DESC;


-- 4Q(a)
-- CONSTRAINTS: Primary, key, foreign key, Unique, check, not null, default

-- Create the database
CREATE DATABASE Customers_Orders;

-- Use the newly created database
USE Customers_Orders;

-- Create the Customers table
CREATE TABLE Customers (customer_id INT AUTO_INCREMENT PRIMARY KEY,first_name VARCHAR(50) NOT NULL,last_name VARCHAR(50) NOT NULL,email VARCHAR(255) UNIQUE,phone_number VARCHAR(20));

-- 4Q(b)
-- Create the Orders table
CREATE TABLE Orders (order_id INT AUTO_INCREMENT PRIMARY KEY,customer_id INT,order_date DATE,total_amount DECIMAL(10,2),CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),CONSTRAINT chk_total_amount CHECK (total_amount >= 0));


-- 5Q(a)
-- JOINS

-- Query to list the top 5 countries by order count

select customers.country,count(orders.ordernumber) as order_count from customers join orders on customers.customernumber = orders.customernumber  group by customers.country order by count(orders.ordernumber) desc limit 5 ;

-- 6Q(a)
-- SELF JOIN

-- Create the project table
CREATE TABLE project (EmployeeID INT AUTO_INCREMENT PRIMARY KEY,FullName VARCHAR(50) NOT NULL,Gender ENUM('Male', 'Female'),ManagerID INT);

-- Insert the provided sample data
INSERT INTO project (EmployeeID, FullName, Gender, ManagerID)VALUES (1, 'Pranaya', 'Male', 3),(2, 'Priyanka', 'Female', NULL),(3, 'Preety', 'Female', 1),(4, 'Anurag', 'Male', 1),(5, 'Sambit', 'Male', 3),(6, 'Rajesh', 'Male', 5),(7, 'Hina', 'Female', 3);
-- Query to find the names of employees and their related managers using self-join
SELECT m.FullName AS Manager_Name, e.FullName AS Emp_Name FROM project e JOIN project m ON e.ManagerID = m.EmployeeID;


-- 7Q(a)
-- DDL Commands: Create, Alter, Rename

CREATE TABLE facility (Facility_ID INT,Name VARCHAR(100),State VARCHAR(100),Country VARCHAR(100));
ALTER TABLE facility MODIFY Facility_ID INT AUTO_INCREMENT,ADD PRIMARY KEY (Facility_ID);
ALTER TABLE facility ADD City VARCHAR(100) NOT NULL AFTER Name;
DESCRIBE facility;


-- 8Q(a)
-- Views in SQL

use classicmodels;
CREATE VIEW product_category_sales AS
 SELECT pl.productLine AS productLine,SUM(od.quantityOrdered * od.priceEach) AS total_sales,COUNT(DISTINCT o.orderNumber) AS number_of_orders FROM Products p JOIN  ProductLines pl ON p.productLine = pl.productLine   JOIN  OrderDetails od ON p.productCode = od.productCode  JOIN  Orders o ON od.ordernumber = o.ordernumber  GROUP BY  pl.productLine;  
select * from product_category_sales;

-- 9Q(a)
-- Stored Procedures in SQL with parameters

CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_country_payments`(IN input_year INT, IN input_country VARCHAR(100))
BEGIN

    SELECT 
        YEAR(P.paymentdate) AS Year, C.country AS Country, CONCAT(ROUND(SUM(P.amount) / 1000, 0), 'K') AS 'Total Amount' FROM Payments P INNER JOIN Customers C ON P.customerNumber = C.customerNumber WHERE YEAR(P.paymentdate) = input_year AND C.country = input_country GROUP BY  YEAR(P.paymentdate), C.country;

END

-- 10(a)
-- Window functions - Rank, dense_rank, lead and lag

SELECT customerName,order_count,DENSE_RANK() OVER (ORDER BY order_count DESC) AS order_frequency_rnk FROM(SELECT  c.customerName,COUNT(o.orderNumber) AS order_count FROM  customers c JOIN  orders o ON c.customerNumber = o.customerNumber GROUP BY  c.customerName ) AS customer_order ORDER BY  order_frequency_rnk;

-- 10(b)

select year(orderDate) as YEAR, monthname(orderDate) as MONTH, count(orderNumber) as 'TOTAL ORDERS',
concat(round(((count(orderNumber) - lag(count(orderNumber),1) over())/lag(count(orderNumber),1) over()) * 100),'%') as '% YOY Change' 
from orders orders group by year(orderDate), monthname(orderDate);

-- 11Q(a)
-- Subqueries and their applications

SELECT productLine, COUNT(*) AS Total FROM products WHERE buyPrice > (SELECT AVG(buyPrice) FROM products) GROUP BY productLine order by Total desc;


-- 12Q(a)
-- ERROR HANDLING in SQL

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertEmployee_EH`(IN p_EmpID INT,IN p_EmpName VARCHAR(100),IN p_EmailAddress VARCHAR(100))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Error occurred' AS ErrorMessage;
	rollback;
    END;
  
    -- Insert the values into the Emp_EH table
    start transaction;
    
    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)VALUES (p_EmpID, p_EmpName, p_EmailAddress);
    commit;
    -- Success message (optional)
    -- SELECT 'Employee successfully added' AS SuccessMessage
END



-- 13(a)
-- TRIGGERS

Create  table Emp_BIT(Name varchar(20) ,Occupation varchar(20),Working_date date,Working_hours int)
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
 
-- before insert trigger code 
CREATE DEFINER=`root`@`localhost` TRIGGER `emp_bit_BEFORE_INSERT` BEFORE INSERT ON `emp_bit` FOR EACH ROW BEGIN
if new.working_hours < 0 then
set new.working_hours = abs(new.working_hours) ;
end if ;
END
