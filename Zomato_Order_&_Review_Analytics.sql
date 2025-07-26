
-- ========================================
-- SQL Project
-- TITLE : "Cracking the Crust: Zomato Order & Review Analytics"
-- Description: This project involves analyzing Zomato's user behavior, order patterns, and review trends.
-- ========================================

-- ========================================
-- Objective:
-- To analyze Zomato’s order and review datasets by leveraging SQL to:
  -- Understand user behavior and purchasing patterns.
  -- Explore restaurant performance and item-level sales.
  -- Analyze delivery efficiency and customer satisfaction.
  -- Derive city-level revenue and review trends.
  -- Implement sentiment analysis on user reviews for actionable insights.
-- ========================================

-- ========================================
-- Problem Statement:
-- Zomato needs to:
 -- Identify top-performing restaurants and best-selling items.
 -- Analyze city-wise order and revenue distribution.
 -- Measure delivery performance and highlight delayed orders.
 -- Determine customer satisfaction using review sentiments.
 -- Summarize the impact of user location and cuisine preferences on revenue.
-- This project aims to provide a data-driven strategy for improving business performance, enhancing customer experience, and optimizing delivery logistics.
-- ========================================


-- We are starting by creating a new database named "Zomato_Orders_and_Reviews" 
CREATE DATABASE Zomato_Orders_and_Reviews;

-- We now switch to using our new database to create tables in it.
USE Zomato_Orders_and_Reviews;

-- and now creating tables for the following datasets:
-- 1. Users
-- 2. Restaurants
-- 3. Orders
-- 4. Order_Items
-- 5. Reviews
-- The structure of each table will match the schema provided in the CSV files.

-- 1. Users Table
CREATE TABLE Users(
user_id int primary Key,
name varchar(100),
city varchar(100),
registration_date datetime
);

-- 2. Restaurants Table
CREATE TABLE Restaurants
restaurant_id int Primary Key,
Restaurant_name varchar(100),
city varchar(100),
cuisine_type varchar(100)
);

-- 3. Orders Table
CREATE TABLE Orders(
order_id int Primary Key,
user_id int,
restaurant_id int,
order_time datetime,
delivery_time datetime,
total_amount float,
FOREIGN KEY (user_id) REFERENCES Users(user_id),
FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);

-- 4. Order_Items Table
CREATE TABLE Order_Items(
order_id int ,
item_name varchar(100),
quantity int,
price float,
FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- 5. Reviews Table
CREATE TABLE Reviews(
review_id int Primary key,
user_id int,
restaurant_id int,
rating int,
review_text varchar(100),
review_date datetime,
FOREIGN KEY (user_id) REFERENCES Users(user_id),
FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);

-- After creating the tables, we will load data into them from the CSV files.

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv"
INTO TABLE Users
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/restaurants.csv'
INTO TABLE Restaurants
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv"
INTO TABLE Orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_items.csv"
INTO TABLE Order_Items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/reviews.csv"
INTO TABLE Reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Preview first 5 rows from the Users table
SELECT * FROM Users LIMIT 5;

-- Preview first 5 rows from the Restaurants table
SELECT * FROM Restaurants LIMIT 5;

-- Preview first 5 rows from the Orders table
SELECT * FROM Orders LIMIT 5;

-- Preview first 5 rows from the Order_Items table
SELECT * FROM Order_Items LIMIT 5;

-- Preview first 5 rows from the Reviews table
SELECT * FROM Reviews LIMIT 5;

-- Now let's check detailed structure of each table
DESCRIBE Users;
DESCRIBE Restaurants;
DESCRIBE Orders;
DESCRIBE Order_Items;
DESCRIBE Reviews;

-- Calculating Total no. of orders 
SELECT count(order_id) as Total_no_of_orders
From Orders;

-- --------------------
-- Output:
-- Total_no_of_orders
-- '500'
-- --------------------

-- Calculating Total Revenue
SELECT sum(a.price * a.quantity) as Total_Revenue
FROM Order_Items as a
JOIN Orders as b
On a.order_id=b.order_id;

-- --------------------
-- Output:
-- Total_Revenue
-- '414478.2900161743'
-- --------------------

-- Sum the Total Revenue (Amount):
SELECT sum(total_amount) as Sum_of_Total_Revenue
FROM Orders;

-- --------------------
-- Output:
-- Sum_of_Total_Revenue
-- '248145.3197479248'
-- --------------------


-- Count the Total Number of Orders
SELECT count(order_id) as Total_orders
FROM Orders;

-- --------------------
-- Output:
-- Total_orders
-- '500'
-- --------------------


-- Calculate the Average Order Value (AOV)
SELECT SUM(total_amount)/COUNT(order_id) as Average_Order_Value
FROM Orders;

-- --------------------
-- Output:
-- Average_Order_Value
-- '496.29063949584963'
-- --------------------

-- Filter by Specific Conditions (e.g., City or Date)
SELECT SUM(total_amount)/COUNT(order_id) as Average_Order_Value
FROM Orders
JOIN Users
ON  Orders.user_id=Users.user_id
WHERE Users.city="Delhi";

-- calculate the city-wise revenue
SELECT city,sum(total_amount) as city_revenue
FROM Orders as a
JOIN Restaurants as b
ON a.restaurant_id=b.restaurant_id
GROUP BY city
ORDER BY city_revenue DESC;

-- --------------------
-- Output:
-- city         city_revenue
-- Hyderabad	77129.96965026855
-- Delhi	   62028.17008972168
-- Mumbai	   45065.63996887207
-- Kolkata	   38906.4298248291
-- Ahmedabad   25015.1102142334
-- --------------------

-- calculate the delivery duration for each order
SELECT order_id,order_time,delivery_time,
TIMESTAMPDIFF(minute,order_time,delivery_time) as delivery_duration
FROM Orders;

-- calculate the average delivery time by city
SELECT city,avg(TIMESTAMPDIFF(minute,order_time,delivery_time)) as Average_delivery_time
FROM Orders as a
JOIN Restaurants as b
ON a.restaurant_id=b.restaurant_id
GROUP BY city
ORDER BY Average_delivery_time DESC;

-- --------------------
-- Output:
-- city     Average_delivery_time
-- Delhi	 40.7097
-- Ahmedabad 40.4286
-- Kolkata	 40.1250
-- Mumbai	 39.9091
-- Hyderabad 39.8805
-- --------------------

-- identify delayed orders based on the delivery time
SELECT order_id,order_time,delivery_time,
TIMESTAMPDIFF(minute,order_time,delivery_time) as delivery_duration,
CASE 
   WHEN TIMESTAMPDIFF(minute,order_time,delivery_time) > 45 THEN "delayed"
   ELSE "on time"
END as order_status
FROM Orders
WHERE TIMESTAMPDIFF(minute,order_time,delivery_time) > 45;

-- calculate the total number of orders received by each restaurant
SELECT restaurant_name,count(order_id) as total_order
FROM Orders as a
JOIN Restaurants as b
ON a.restaurant_id=b.restaurant_id
GROUP BY restaurant_name
ORDER BY total_order DESC;

-- --------------------
-- Output:
-- restaurant_name total_order
-- Restaurant_18	35
-- Restaurant_8	    28
-- Restaurant_15	28
-- Restaurant_16	28
-- Restaurant_20	28
-- Restaurant_3	    27
-- Restaurant_5	    27
-- Restaurant_10	26
-- Restaurant_19	26
-- Restaurant_6	    25
-- Restaurant_11	25
-- Restaurant_13	25
-- Restaurant_9	    24
-- Restaurant_4	    23
-- Restaurant_14	23
-- Restaurant_2	    22
-- Restaurant_7	    22
-- Restaurant_17	22
-- Restaurant_12	19
-- Restaurant_1	    17
-- --------------------

-- calculate the average rating per restaurant based on the reviews provided by customers
SELECT b.restaurant_name ,round(avg(rating),2) as Average_rating
FROM Reviews as a
JOIN Restaurants as b 
ON a.restaurant_id=b.restaurant_id
GROUP BY a.restaurant_id
ORDER BY Average_rating DESC;

-- --------------------
-- Output:
-- restaurant_name  Average_rating
-- Restaurant_13	3.47
-- Restaurant_3	    3.36
-- Restaurant_14	3.22
-- Restaurant_5	    3.20
-- Restaurant_8	    3.11
-- Restaurant_6	    3.08
-- Restaurant_10	3.06
-- Restaurant_15	2.94
-- Restaurant_11	2.79
-- Restaurant_18	2.73
-- Restaurant_12	2.71
-- Restaurant_17	2.71
-- Restaurant_4	    2.70
-- Restaurant_7	    2.64
-- Restaurant_16	2.63
-- Restaurant_20	2.63
-- Restaurant_1	    2.60
-- Restaurant_9	    2.54
-- Restaurant_19	2.47
-- Restaurant_2	    2.31
-- --------------------

-- identify the top restaurants based on both order volume and average ratings
SELECT b.restaurant_name, count(a.order_id) as Total_Orders,avg(c.rating) as Average_rating
FROM Orders as a
JOIN Restaurants as b 
ON a.restaurant_id=b.restaurant_id
JOIN Reviews as c
ON c.restaurant_id=b.restaurant_id
GROUP BY restaurant_name
HAVING Total_Orders >=20 AND Average_rating >=3.00
ORDER BY Total_Orders DESC,Average_rating DESC;

-- --------------------
-- Output:
-- restaurant_name Total_Orders  Average_rating
-- Restaurant_5	    540	          3.2000
-- Restaurant_10	442	          3.0588
-- Restaurant_14	414	          3.2222
-- Restaurant_13	375	          3.4667
-- Restaurant_6	    300	          3.0833
-- Restaurant_3	    297	          3.3636
-- Restaurant_8	    252	          3.1111
-- --------------------

-- identify the best-selling items from the orders placed by customers.
SELECT b.item_name,sum(b.quantity) as Total_quantity
FROM Order_Items as b
JOIN Orders as a
ON a.order_id=b.order_id
GROUP BY b.item_name
ORDER BY Total_quantity DESC;

-- --------------------
-- Output:
-- item_name        Total_quantity
-- Margarita Pizza	   389
-- Chicken Biryani	   377
-- Pasta Alfredo	   350
-- Chocolate Cake	   331
-- Paneer Butter Masala	325
-- Veg Burger	        300
-- --------------------

-- calculate the total revenue generated by each item
SELECT item_name,sum(price * quantity) as Total_revenue
FROM Order_Items as a
JOIN Orders as b
GROUP BY item_name
ORDER BY Total_revenue DESC;

-- --------------------
-- Output:
-- item_name             Total_revenue
-- Chicken Biryani	     38970094.997406006
-- Margarita Pizza	     38067099.97558594
-- Pasta Alfredo         34634570.08743286
-- Chocolate Cake	     33699044.96002197
-- Paneer Butter Masala	 32947770.00427246
-- Veg Burger	         28920564.98336792
-- --------------------

-- analyze the distribution of customer ratings across all restaurants.
SELECT rating,count(*) Reviws_count
FROM Reviews
GROUP BY rating
ORDER BY rating ASC;

-- --------------------
-- Output:
-- rating  Reviws_count
-- 1	    74
-- 2	    58
-- 3	    59
-- 4	    59
-- 5	    50
-- --------------------

-- calculate the number of reviews submitted from each city.
SELECT city,count(review_id) Reviews_count
FROM Users as a
JOIN Reviews as b 
ON a.user_id=b.user_id
GROUP BY  city 
ORDER BY Reviews_count DESC;

-- --------------------
-- Output:
-- city       Reviews_count
-- Hyderabad	61
-- Delhi	    55
-- Kolkata	    38
-- Pune	        34
-- Chennai	    33
-- Mumbai	    31
-- Ahmedabad	27
-- Bengaluru	21
-- --------------------

-- apply basic sentiment classification to customer reviews
-- Classify Each Review
SELECT review_id,user_id,rating,
CASE 
    WHEN rating >= 4  THEN "Positive" 
    WHEN rating = 3 THEN "Neutral"
    ELSE "Negative"
END as Sentiment
FROM Reviews;
    
-- Count Sentiment Distribution
SELECT 
CASE
	WHEN rating >=4 THEN "Positve"
    WHEN rating =3 THEN "Neutral"
    ELSE "Negative"
END as Sentiment,
count(*) as Review_count
FROM Reviews
GROUP BY Sentiment
ORDER BY Review_count DESC;

-- --------------------
-- Output:
-- Sentiment Review_count
-- Negative	  132
-- Positve	  109
-- Neutral	  59
-- --------------------

-- combine sentiment with city 
SELECT  city,
CASE
	WHEN rating >=4 THEN "Positve"
    WHEN rating =3 THEN "Neutral"
    ELSE "Negative"
END as Sentiment,
count(*) as Review_count
FROM Reviews as a 
JOIN Users  as b 
ON a.user_id=b.user_id
GROUP BY city , Sentiment;

-- Let's create SQL Views
-- Top Restaurants View
CREATE VIEW top_restaurants_view as
SELECT b.restaurant_name, count(a.order_id) as Total_Orders,avg(c.rating) as Average_rating
FROM Orders as a
JOIN Restaurants as b 
ON a.restaurant_id=b.restaurant_id
JOIN Reviews as c
ON c.restaurant_id=b.restaurant_id
GROUP BY restaurant_name
HAVING Total_Orders >=20 AND Average_rating >=3.00
ORDER BY Total_Orders DESC,Average_rating DESC;
select * from top_restaurants_view;

-- --------------------
-- Output:
-- restaurant_name  Total_Orders  Average_rating
-- Restaurant_5   	540	           3.2000
-- Restaurant_10	442	           3.0588
-- Restaurant_14	414	           3.2222
-- Restaurant_13	375	           3.4667
-- Restaurant_6	    300	           3.0833
-- Restaurant_3	    297	           3.3636
-- Restaurant_8	    252	           3.1111
-- --------------------

DROP VIEW delivery_performance_view;

-- City Revenue Summary Viewxxx	
CREATE VIEW city_revenue_view as 
SELECT b.city,sum(a.total_amount) as total_revenue
FROM Orders as a
JOIN Users as b
ON a.user_id=b.user_id
GROUP BY b.city;
select * from city_revenue_view;

-- --------------------
-- Output:
-- city        total_revenue
-- Delhi	   40152.1897277832
-- Mumbai	   30271.02001953125
-- Chennai	   28132.369918823242
-- Hyderabad   43391.480041503906
-- Bengaluru   26723.859924316406
-- Pune	       30562.63006591797
-- Ahmedabad   17489.32000732422
-- Kolkata	   31422.45004272461
-- --------------------

 -- Popular Items View
CREATE VIEW popular_items_view AS
SELECT
    item_name,
    SUM(quantity) AS total_quantity_sold,
    SUM(quantity * price) AS total_revenue
FROM Order_Items
GROUP BY item_name
ORDER BY total_quantity_sold DESC;
select * from popular_items_view;

-- --------------------
-- Output:
-- item_name            total_quantity_sold    total_revenue
-- Margarita Pizza	      389	               76134.19995117188
-- Chicken Biryani	      377	               77940.18999481201
-- Pasta Alfredo	      350	               69269.14017486572
-- Chocolate Cake	      331	               67398.08992004395
-- Paneer Butter Masala	  325	               65895.54000854492
-- Veg Burger	          300	               57841.12996673584
-- --------------------

-- Delivery Performance View
CREATE VIEW delivery_performance_view AS
SELECT
    b.city,
    AVG(TIMESTAMPDIFF(MINUTE, a.order_time, a.delivery_time)) AS avg_delivery_time
FROM Orders as a
JOIN Users as b
ON a.user_id = b.user_id
WHERE a.order_time IS NOT NULL AND a.delivery_time IS NOT NULL
GROUP BY b.city;
select * from delivery_performance_view;

-- --------------------
-- Output:
-- city    avg_delivery_time
-- Delhi	   41.5476
-- Mumbai	   40.7759
-- Chennai	   40.9831
-- Hyderabad   38.8471
-- Bengaluru   39.1200
-- Pune	       39.8197
-- Ahmedabad   41.4211
-- Kolkata	   39.3538
-- --------------------


SELECT city,avg(TIMESTAMPDIFF(minute,order_time,delivery_time)) as Average_delivery_time
FROM Orders as a
JOIN Restaurants as b
ON a.restaurant_id=b.restaurant_id
GROUP BY city
ORDER BY avg(TIMESTAMPDIFF(minute,order_time,delivery_time)) DESC;
select * from delivery_performance_view;

-- --------------------
-- Output:
-- city   Average_delivery_time
-- Delhi	40.7097
-- Ahmedabad	40.4286
-- Kolkata	40.1250
-- Mumbai	39.9091
-- Hyderabad	39.8805
-- --------------------

--  Review Sentiment Summary View
CREATE VIEW review_sentiment_view AS
SELECT
    CASE
        WHEN rating >= 4 THEN 'Positive'
        WHEN rating = 3 THEN 'Neutral'
        ELSE 'Negative'
    END AS sentiment,
    COUNT(*) AS review_count
FROM Reviews
GROUP BY sentiment;
select * from review_sentiment_view;

-- --------------------
-- Output:
-- sentiment   review_count
-- Negative	    132
-- Positive	    109
-- Neutral	    59
-- --------------------

-- ========================================
-- Key Insights:
--  Order & Revenue Analysis
  -- Total Orders: 500
  -- Total Revenue (from items): ₹414,478
  -- Total Revenue (from Orders): ₹248,145

-- Average Order Value (AOV): ₹496.29
  -- Top 3 Cities by Revenue:
  -- Hyderabad – ₹77,130
  -- Delhi – ₹62,028
  -- Mumbai – ₹45,065

-- Delivery Performance
-- Average Delivery Times (minutes):
  -- Delhi: 40.71
  -- Ahmedabad: 40.43
  -- Hyderabad: 39.88
-- Delayed Orders: Any with delivery time > 45 mins were flagged as delayed.

-- Restaurant & Item Performance
-- Top Restaurants by Orders & Rating:
  -- Restaurant_5 (Orders: 540, Rating: 3.20)
  -- Restaurant_13 (Orders: 375, Rating: 3.47)

-- Best-Selling Items:
  -- Margarita Pizza: 389 units
  -- Chicken Biryani: 377 units

-- Top Revenue-Generating Items:
  -- Chicken Biryani: ₹77,940
  -- Margarita Pizza: ₹76,134

-- Customer Sentiment Analysis
-- Sentiment Classification (based on rating):
  -- Positive (4–5): 109
  -- Neutral (3): 59
  -- Negative (1–2): 132

-- Cities with Highest Review Counts:
  -- Hyderabad: 61
  -- Delhi: 55
  -- Kolkata: 38
-- ========================================

-- ========================================
--  Conclusion:
-- This SQL project:
 -- Highlights patterns in ordering, pricing, and review behavior.
 -- Confirms that city and restaurant factors heavily influence revenue.
 -- Demonstrates how delivery time affects customer experience.
 -- Shows how ratings can be mined to derive sentiment trends.
-- The use of SQL Views (e.g., top_restaurants_view, city_revenue_view, review_sentiment_view) makes the analysis modular, scalable, and ready for dashboard integration.
-- ========================================

-- ========================================
-- Final Recommendations:
 -- Optimize delivery operations in cities with high average delivery time (e.g., Delhi, Ahmedabad).
 -- Bundle best-selling items for offers (e.g., Pizza + Cake combo).
 -- Partner with top-rated restaurants for Zomato Gold or premium programs.
 -- Monitor sentiment monthly to improve customer service in cities with poor reviews.
 -- Use SQL views for dashboards in Power BI or Tableau to track KPIs.
 -- Add cuisine-based revenue analysis to recommend local food trends.
 -- Incorporate NLP in future projects to analyze review text sentiment more deeply.
 -- ========================================
 
 
 
 