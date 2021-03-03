/*
Host: sji.lmu.build
Username: sjilmubu_dba
Password: sql_2021
*/



-- sakila Database

/*
1. Select all columns from the film table for PG-rated films. (1 point)
*/
SELECT *
FROM film
WHERE rating = "PG";


/*
2. Select the customer_id, first_name, and last_name for the active customers (0 means inactive). Sort the customers by their last name and restrict the results to 10 customers. (1 point)
*/
SELECT
	customer_id,
	first_name,
	last_name
FROM customer
WHERE active = 1
ORDER BY last_name 
LIMIT 10;


/*
3. Select customer_id, first_name, and last_name for all customers where the last name is Clark. (1 point)
*/
SELECT
	customer_id,
	first_name,
	last_name
FROM customer
WHERE last_name = 'Clark';


/*
4. Select film_id, title, rental_duration, and description for films with a rental duration of 3 days. (1 point)
*/
SELECT 
	film_id,
	title,
	rental_duration,
	description
FROM film
WHERE rental_duration = 3;		# using operators to filter results in WHERE statement


/*
5. Select film_id, title, rental_rate, and rental_duration for films that can be rented for more than 1 day and at a cost of $0.99 or more. Sort the results by rental_rate then rental_duration. (2 points)
*/
SELECT 
	film_id,
	title,
	rental_rate,
	rental_duration 
FROM film
WHERE 
	rental_duration > 1
	AND rental_rate >= 0.99		# using AND for multiple WHERE statements
ORDER BY						# orders results by rental_rate first, then rental_duration
	rental_rate,
	rental_duration;


/*
6. Select film_id, title, replacement_cost, and length for films that cost 9.99 or 10.99 to replace and have a running time of 60 minutes or more. (2 points)
*/
SELECT
	film_id,
	title,
	replacement_cost,
	length 
FROM film 
WHERE 
	replacement_cost BETWEEN 0.99 AND 10.99		# BETWEEN specifies a range and is part of the WHERE statement 
	AND length >= 60;


/*
7. Select film_id, title, replacement_cost, and rental_rate for films that cost $20 or more to replace and the cost to rent is less than a dollar. (2 points)
*/
SELECT
	film_id,
	title,
	replacement_cost,
	rental_rate 
FROM film 
WHERE 
	replacement_cost >= 20
	AND rental_rate < 1;


/*
8. Select film_id, title, and rating for films that do not have a G, PG, and PG-13 rating.  Do not use the OR logical operator. (2 points)
*/
SELECT DISTINCT rating			# viewing types of ratings
FROM film;						# none of the other ratings included "G" in the name

SELECT 
	film_id,
	title,
	rating
FROM film
WHERE rating NOT LIKE '%G%';	# Using % wildcard; must have G somewhere in the string (can have other letters in front or after it)
								# NOT LIKE instead of not equal to != operator 

/*
9. How many films can be rented for 5 to 7 days? Your query should only return 1 row. (2 points)
*/
SELECT COUNT(*)
FROM film
WHERE rental_duration BETWEEN 5 and 7;


/*
10. INSERT your favorite movie into the film table. You can arbitrarily set the column values as long as they are related to the column. Only assign values to columns that are not automatically handled by MySQL. (2 points)
*/
INSERT INTO film 														# adding new record
SET
	title = 'Pulp Fiction',												# column = 'new entry'
	description = 'Written and Directed by Quentin Tarantino',
	release_year = '1994',
	language_id = '1',
	rental_duration = '6',
	rental_rate = '4.99',
	length = '120',
	replacement_cost = '10.99',
	rating = 'R',
	special_features = 'Trailers',
	last_update = NOW();

SELECT *							# double checking entry
FROM film
WHERE title = 'Pulp Fiction';


/*
11. INSERT your two favorite actors/actresses into the actor table with a single SQL statement. (2 points)
*/
INSERT INTO actor (first_name, last_name)
VALUES 											# Use VALUES instead of SET as there are only 2 columns
	('Christoph','Waltz'),						# columns are filled based on the order listed and values correspond
	('Jamie','Foxx');

-- Double checking
SELECT *
FROM actor 
WHERE last_name = 'Foxx' OR last_name = 'Waltz';


/*
12. The address2 column in the address table inconsistently defines what it means to not have an address2 associated with an address. UPDATE the address2 column to an empty string where the address2 value is currently null. (2 points)
*/
-- Obtaining number of records to be updated
SELECT COUNT(*)
FROM address
WHERE address2 IS NULL; 	# there are 4 records to be updated

-- Replacing nulls with empty string
UPDATE address
SET address2 = ''			# empty string = blank space
WHERE address2 IS NULL;

-- Double checking
SELECT COUNT(*)
FROM address
WHERE address2 IS NULL; 	# if correct, this should return 0

/*
13. For rated G films less than an hour long, update the special_features column to replace Commentaries with Audio Commentary. Be sure the other special features are not removed. (2 points)
*/
UPDATE film 
SET special_features = REPLACE(special_features, 'Commentaries', 'Audio Commentary')	# REPLACE(column, word to be replaced, replacement)
WHERE 
	special_features LIKE '%Commentaries%'		# filtering strings that include "commentaries" anywhere in string; adding wildcars b/c it's often nested between other features
	AND rating = 'G'							# more filters
	AND length < 60;

-- Double checking results
SELECT special_features
FROM film
WHERE 
	special_features LIKE '%Comm%' 
	AND rating = 'G' 
	AND length < 60;


/*
14. Create a new database named LinkedIn. You will still need to use  LMU.build to create the database. (1 point)
*/
SHOW DATABASES			# verifying that database has been created
LIKE '%LinkedIn%';		# adding wildcare b/c of preceding string

-- Changing default database to sjilmubu_LinkedIn
USE sjilmubu_LinkedIn;


/*
15. Create a user table to store LinkedIn users. The table must include 5 columns minimum with the appropriate data type and a primary key. One of the columns should be Email and must be a unique value. (3 points)
*/
CREATE TABLE user (
	user_id INT(11) NOT NULL AUTO_INCREMENT,	# unique identifier. NOT NULL = must be populated. AUTO_INCREMENT = number increases with each entry automatically; is filled automatically.
	first_name VARCHAR(255),					# ^ INT(11) indicates integer format
	last_name VARCHAR(255),						# VARCHAR(255) indicates string format
	occupation VARCHAR(255),
	email VARCHAR(255),
	PRIMARY KEY (user_id),						# primary key = record ID
	CONSTRAINT email_unique UNIQUE (email)		# using CONSTRAINT and UNIQUE will make sure email is unique, otherwise error message
);												# IRL, will make sure that there are no duplicate users

-- Confirming table columns
DESC user;		# here, DESC = describe, not descending. Returns table structure and confirms that all columns have been added.


/*
16. Create a table to store a user's work experience. The table must include a primary key, a foreign key column to the user table, and have at least 5 columns with the appropriate data type. (3 points)
*/
CREATE TABLE work_experience (
	user_id INT(11) NOT NULL AUTO_INCREMENT,
	email VARCHAR(255),
	title VARCHAR(255),
	company VARCHAR(255),
	years INT(11),
	PRIMARY KEY (user_id),
	FOREIGN KEY (email) REFERENCES user(email)	# the email column can be used when merging the user and work_experience tables. email is the identifier.
);

-- Confirming table columns
DESC work_experience;


/*
17. INSERT 1 user into the user table. (2 points)
*/
INSERT INTO user 
SET
	first_name = 'Silvia',				# column = new value
	last_name = 'Ji',
	occupation = 'Business Analyst',
	email = 'sji2@lion.lmu.edu';

-- Previewing table
SELECT *
FROM user;


/*
18. INSERT 1 work experience entry for the user just inserted. (2 points)
*/
INSERT INTO work_experience 			# when looking up records, the unique email address will connect this work_experience record with the corresponding user record.
SET
	email = 'sji2@lion.lmu.edu',
	title = 'Business Analyst',
	company = 'Amazon',
	years = '3';

-- Previewing table
SELECT *
FROM work_experience;



-- SpecialtyFood Database
-- Setting default database
USE sjilmubu_SpecialityFood;


/*
19. The warehouse manager wants to know all of the products the company carries. Generate a list of all the products with all of the columns. (1 point)
*/
SELECT *
FROM Products;


/*
20. The marketing department wants to run a direct mail marketing campaign to its American, Canadian, and Mexican customers. Write a query to gather the data needed for a mailing label. (2 points)
*/
SELECT 
	ContactName,
	Address,
	City,
	Region,
	PostalCode,
	Country 
FROM Customers
WHERE Country = 'USA' OR 'Canada' OR 'Mexico';


/*
21. HR wants to celebrate hire date anniversaries for the sales representatives in the USA office. Develop a query that would give HR the information they need to coordinate hire date anniversary gifts. Sort the data as you see best fit. (2 points)
*/
-- Need: Employee name, address, country, title, hire date

SELECT
	LastName,
	FirstName,
	Title,
	HireDate,
	Address,
	City,
	Region,
	PostalCode,
	Country
FROM Employees 
WHERE
	Title = 'Sales Representative' 
	AND Country = 'USA';


/*
22. What is the SQL command to show the structure for the Shippers table? (1 point)
*/
-- Using the DESCRIBE aka DESC statement:
DESC Shippers;		# Returns table structure


/*
23. Customer service noticed an increase in shipping errors for orders handled by the employee, Janet Leverling. Return the OrderIDs handled by Janet so that the orders can be inspected for other errors. (2 points)
*/
SELECT 
	Employees.EmployeeID,
	FirstName,
	LastName,
	OrderID
FROM Employees 
JOIN Orders 
	ON Employees.EmployeeID = Orders.EmployeeID		# joining botht ables on EmplyeeID column
WHERE 
	LastName = 'Leverling' 
	AND FirstName = 'Janet';


/*
24. The sales team wants to develop stronger supply chain relationships with its suppliers by reaching out to the managers who have the decision making power to create a just-in-time inventory arrangement. Display the supplier's company name, contact name, title, and phone number for suppliers who have manager or mgr in their title. (2 points)
*/ 
-- supplier's company name, contact name, title, and phone number for suppliers who have manager or mgr in their title
SELECT 
	CompanyName,
	ContactName,
	ContactTitle,
	Phone
FROM Suppliers 
WHERE 
	ContactTitle LIKE '%manager%' 		# filters results that have manager or mgr in their title. %% -> can be nested between other strings
	OR ContactTitle LIKE '%mgr%';		


/*
25. The warehouse packers want to label breakable products with a fragile sticker. Identify the products with glasses, jars, or bottles and are not discontinued (0 = not discontinued). (2 points)
*/
SELECT
	ProductID,
	ProductName,
	QuantityPerUnit,
	Discontinued
FROM Products
WHERE
	QuantityPerUnit LIKE '%glass%' 			# must write 3 seperate LIKE statements, seperated by OR 
	OR QuantityPerUnit LIKE '%jar%' 		# if only one LIKE statement (LIKE... OR... OR...), SQL will only use the first constraint 
	OR QuantityPerUnit LIKE '%bottle%'
	AND Discontinued = '0';


/*
26. How many customers are from Brazil and have a role in sales? Your query should only return 1 row. (2 points)
*/
SELECT COUNT(*)
FROM Customers
WHERE 
	ContactTitle LIKE '%sale%'		# wildcard to make sure all results are included
	AND Country = 'Brazil';


/*
27. Who is the oldest employee in terms of age? Your query should only return 1 row. (2 points)
*/
SELECT
	FirstName,
	LastName,
	DATE(BirthDate) AS Birthday		# returns only the date without hours and minutes
FROM Employees
ORDER BY Birthday ASC
LIMIT 1;							# display only the oldest one


/*
28. Calculate the total order price per order and product before and after the discount. The products listed should only be for those where a discount was applied. Alias the before discount and after discount expressions. (3 points)
*/

SELECT 
	OrderID,
	ProductID,
	UnitPrice AS PreDiscountUnitPrice,										# rename for clarity
	SUM(UnitPrice * (1-Discount)) AS PostDiscountUnitPrice,					# unit price after discount 
	SUM(UnitPrice * Quantity) AS PreDiscountOrderPrice,						# multiply unit price by quantity to find total order price before discount is applied
	SUM((UnitPrice * Quantity) *(1-Discount)) AS PostDiscountOrderPrice		# also multiply by (1-discount) to find post-discount total order price 
FROM OrderDetails
WHERE NOT Discount = '0'													# WHERE NOT instead of != operator
GROUP BY OrderID;															# group by orderID to only see prices for each order; otherwise returns the sum of all orders


/*
29. To assist in determining the company's assets, find the total dollar value for all products in stock. Your query should only return 1 row.  (2 points)
*/
SELECT SUM(UnitPrice * UnitsInStock) AS AllProductsInStockValue		# created alias for readability
FROM Products;


/*
30. Supplier deliveries are confirmed via email and fax. Create a list of suppliers with a missing fax number to help the warehouse receiving team identify who to contact to fill in the missing information. (2 points)
*/
SELECT *
FROM Suppliers 
WHERE Fax IS NULL;


/*
31. The PR team wants to promote the company's global presence on the website. Identify a unique and sorted list of countries where the company has customers. (2 points)
*/
SELECT 
	Country,
	COUNT(CustomerID) AS CustomerCount		# count unique customerIDs
FROM Customers
GROUP BY Country							# to see customers BY country
ORDER BY CustomerCount DESC;				# countries ranked by customer count to decide easier which ones to focus on


/*
32. List the products that need to be reordered from the supplier. Know that you can use column names on the right-hand side of a comparison operator. Disregard the UnitsOnOrder column. (2 points)
*/
SELECT
	ProductID,
	ProductName,
	UnitsInStock,
	ReorderLevel 
FROM Products
WHERE 
	UnitsInStock <= ReorderLevel		# reorder level = reorder if units in stock are lower than this
	AND ReorderLevel > 0; 				# exclude products that should not be reorderd; presumably discontinued since they have 0 units in stock


/*
33. You're the newest hire. INSERT yourself as an employee with the INSERT … SET method. You can arbitrarily set the column values as long as they are related to the column. Only assign values to columns that are not automatically handled by MySQL. (2 points)
*/
INSERT INTO Employees 
SET
	LastName = 'Ji',
	FirstName = 'Silvia',
	Title = 'CEO',
	TitleOfCourtesy = 'Dr.',
	BirthDate = '1996-12-26',
	HireDate = CURDATE(),
	Address = '1 LMU Drive',
	City = 'Los Angeles',
	Region = 'CA',
	PostalCode = '90045',
	Country = 'USA',
	HomePhone = '(123) 4566-7890',
	Extension = '123',
	Notes = 'Our best hire!',
	ReportsTo = '1',
	PhotoPath = 'TBD';


-- Previewing new record
SELECT *
FROM Employees;


/*
34. The supplier, Bigfoot Breweries, recently launched their website. UPDATE their website to bigfootbreweries.com. (2 points)
*/
UPDATE Suppliers
SET HomePage = 'bigfootbreweries.com'			# column = new value
WHERE CompanyName = 'Bigfoot Breweries';


-- Verifying result
SELECT * 
FROM Suppliers
WHERE CompanyName = 'Bigfoot Breweries';


/*
35. The images on the employee profiles are broken. The link to the employee headshot is missing the .com domain extension. Fix the PhotoPath link so that the domain properly resolves. Broken link example: http://accweb/emmployees/buchanan.bmp (2 points)
*/
UPDATE Employees
SET PhotoPath = CONCAT(SUBSTRING(PhotoPath, 1, LENGTH('http://accweb')), '.com', SUBSTRING(PhotoPath, LENGTH('http://accweb.'),100))
WHERE PhotoPath LIKE '%accweb%';	# added filter b/c my own record = TBD

	# Used CONCAT in conjunction with SUBSTRING functions
	# SUBSTRING(column, start position, end position)
	# in photo path column, start at position 1 and include as many characters as there are in 'http://accweb'
	# next, add '.com'
	# lastly, another substring from photo path: start at the position after 'http://accweb.' and include everything after
	# these 3 segments are concatenated into a complete web address


-- Verifying result
SELECT *
FROM Employees;


-- Custom Data Requests

/*
Data Request 1
Identify all customers' total order costs and sort them in ascending order.

The marketing team can use this informating to target customers that have not been profitable, for example by offering them discounts.
*/
SELECT														# first, select the necessary columns from the Customers table
	Customers.CustomerID,
	CompanyName,
	Country,
	SUM(UnitPrice * Quantity) AS TotalOrderCost				# aliased as TotalOrderCost for better readability. Retrieves total order amount to date.
FROM Customers 
JOIN Orders 												# used ERD to see which tables should be joined
	ON Orders.CustomerID = Customers.CustomerID 
JOIN OrderDetails 
	ON Orders.OrderID = OrderDetails.OrderID				# joined with orders and orderDetails tables to retrieve unit price and quantity
GROUP BY CompanyName										# to see TotalOrderCost for each company. This way, SQL doesn't return the total order amount for all customers.
ORDER BY TotalOrderCost;									# to make easier decisions; easier to see most profitable and least profitable customers

-- So far, Centro comercial Moctezuma has been the least profitable customer and should thus be targeted with promotional efforts.


/*
Data Request 2
Select the 3 products that offer the highest discounts, and their units in stock.

With the results, managers are able to identify the products with the highest discounts and decide whether they are worth re-ordering.
*/
SELECT 													# Selecting needed columns from products table
	Products.ProductID,
	ProductName,
	Discount,
	UnitsInStock
FROM Products
JOIN OrderDetails
	ON Products.ProductID = OrderDetails.ProductID		# join OrderDetails table to view discount
WHERE UnitsInStock > '0'								# no need to see products that have already been discontinued 
GROUP BY ProductName									# unique identifier, can also use productID to be safer
ORDER BY 
	Discount DESC,										# view products with highest discounts
	UnitsInStock ASC									# and also lowest units in stock to prioritize which ones to discontinue first
LIMIT 3;

-- Northwoods Cranberry Sauce, Nord-Ost Matjeshering, and Outback Lager are both heavily discounted and have the least units in stock. Thus, management should consider discontinuing them.


/*
Data Request 3
Did employees in the US or the UK close more sales in 2015? What was the average order price? How many employees work in each country?

The results can help managers decide which office is performing the best. This can be useful when giving out end-of-year bonuses or deciding where to allocate training resources.
*/

SELECT 
	Country,
	COUNT(DISTINCT Employees.EmployeeID) AS EmployeesPerCountry,	# number of employees in each country
	COUNT(Country) AS OrdersPerCountry,								# orders per country
	AVG(UnitPrice * Quantity) AvgOrderPrice							# cost of the average order
FROM Employees
JOIN Orders
	ON Employees.EmployeeID = Orders.EmployeeID 					# join tables to get order details
JOIN OrderDetails 
	ON Orders.OrderID = OrderDetails.OrderID
WHERE OrderDate BETWEEN '2015-01-01' AND '2015-12-31 23:59:59'		# filter based on dates as we are only interested in 2015 sales
GROUP BY Country;													# must group by country to see each result; otherwise returns the entire sum

-- While employees in the US placed more orders in 2015, UK employees had a higher average order price. 
-- Considering that the UK also had less employees, they are the better performing country.


/*
Data Request 4
Select employees and their number of sales (orders) in 2015.

To identify the best-performing employees for promotions and bonuses.
*/
SELECT
	Employees.EmployeeID,
	FirstName,
	LastName,
	COUNT(OrderID) AS Sales2015									# alias for easier readability
FROM Employees 
JOIN Orders 
	ON Employees.EmployeeID = Orders.EmployeeID 				# join tables to get order information
WHERE OrderDate BETWEEN '2015-01-01' AND '2015-12-31 23:59:59'	# filter based on dates as we are only interested in 2015 sales
GROUP BY EmployeeID												# use group by to see numbers for each individual employee, not total for all employees
ORDER BY Sales2015 DESC; 										# sort to easily identify top and bottom performers 

-- Margaret Peacock closed the most sales in 2015 and should therefore be considered for a raise.


/*
Data Request 5
How many orders per employee were shipped past the required date? How many days in total did the delays accumulate?

Customers expect timely deliveries of their orders. By identifying employees who delay multiple orders, their managers can discuss logistical issues with them.
*/
SELECT 
	Orders.EmployeeID,
	FirstName,
	LastName,
	COUNT(OrderID) AS NumberOfOrders,								# alias for easier readability
	SUM(DATEDIFF(RequiredDate, ShippedDate)) AS TotalDelayedDays	# DATEDIFF(start date, end date) finds the amount of days that passed between two dates
FROM Orders
JOIN Employees
	ON Orders.EmployeeID = Employees.EmployeeID 					# join tables to find employees resopnsible	for each order
WHERE ShippedDate > RequiredDate									# only display orders that were delayed
GROUP BY EmployeeID													# to show delays for each employee's orders
ORDER BY TotalDelayedDays;											# to see which employee had the most delays in days

-- Margaret Peacock delayed 10 orders which accumulated to 51 days. Thus, her raise should be reconsidered and her managerial should see if she is experiencing any logistical orders.


/*
Data Request 6
List all the Orders and their OrderDate, ShippedDate, and the amount of days between them.

This can help identify how long it takes for an order to be shipped after it has been placed. If the amount of days is too large, orders may be delayed.
Customers whose orders were the most delayed may receive a discount to ensure that they will remain customers.
*/
SELECT
	OrderID,
	CustomerID,
	DATE(OrderDate) AS OrderedOnDate,					# transforming dates into date format to eliminate hours and minutes
	DATE(ShippedDate) AS ShippedOnDate,					# creating alias for easier readability
	DATEDIFF(OrderDate,ShippedDate) AS DaysBetween		# DATEDIFF(start date, end date) finds the amount of days that passed between two dates. days between order date and shipped date
FROM Orders
WHERE ShippedDate IS NOT NULL							# only show orders that have already been shipped
ORDER BY DaysBetween;									# to identify most delayed orders.

-- A number of orders are taking over 30 days to ship. This indicates that the company's shipping logistics must be improved.

