# Zomato-Order-Review-SQL
SQL-based data analysis project on Zomato orders, reviews, and delivery performance


# Cracking the Crust: Zomato Order & Review Analytics (SQL Project)

This project is a comprehensive SQL-based analysis of Zomato’s customer orders, restaurant reviews, and delivery patterns. It covers database design, data cleaning, analytical queries, performance metrics, and view creation for reporting.

---

## Project Objective
To analyze Zomato’s user behavior and restaurant performance using SQL to:
- Track revenue and order trends.
- Understand delivery performance city-wise.
- Identify top restaurants and best-selling items.
- Analyze sentiment from user ratings and reviews.

---

## Technologies Used
- **SQL** (MySQL syntax)
- Relational Database Design
- Views and Aggregations
- CASE Statements for Classification

---

## Database Schema
- `Users`: User details and city
- `Restaurants`: Restaurant name, location, cuisine
- `Orders`: Order timestamp, total amount
- `Order_Items`: Line-item data (item, quantity, price)
- `Reviews`: User feedback, ratings, and review text

*You can find the schema in the `.sql` file or `schema_design.png`.*

---

## Key Insights (via SQL queries)
- Total orders, revenue, and average order value (AOV)
- City-wise revenue and delivery duration
- Top-rated restaurants with high order volume
- Best-selling food items and their revenue contribution
- Customer sentiment classification (Positive, Neutral, Negative)

---

## SQL Views Created
- `top_restaurants_view`
- `city_revenue_view`
- `delivery_performance_view`
- `popular_items_view`
- `review_sentiment_view`

These views enable easy integration with BI dashboards like Power BI/Tableau.

---


