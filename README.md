# Zomato-Order-Review-SQL
SQL-based data analysis project on Zomato orders, reviews, and delivery performance


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

---

## Key Insights (via SQL queries)

| Category           | Insights                                                                 |
|--------------------|--------------------------------------------------------------------------|
| 🛒 Orders          | 500 total orders, AOV = ₹496.29                                          |
| 💰 Revenue         | Hyderabad is the top revenue-generating city                             |
| 🍔 Top Items       | Chicken Biryani & Margarita Pizza are most sold and most profitable      |
| 📈 Restaurants     | Restaurant_13 has the highest average rating (3.47)                      |
| 🛵 Delivery        | Delhi has the highest average delivery time (40.7 minutes)               |
| 💬 Reviews         | More negative (132) than positive (109) sentiments                       |

---

## SQL Views Created
- `top_restaurants_view`
- `city_revenue_view`
- `delivery_performance_view`
- `popular_items_view`
- `review_sentiment_view`

These views enable easy integration with BI dashboards like Power BI/Tableau.

---

## Conclusion

This project demonstrates:
- SQL proficiency across joins, aggregates, views, and CASE statements.
- Data-driven insights into Zomato’s operations.
- Readiness for BI tools through pre-built summary views.

---

## Recommendations

- Optimize delivery in Delhi & Ahmedabad.
- Promote top-rated restaurants via Zomato Gold.
- Track monthly sentiment trends.
- Bundle top-selling food items for offers.
- Expand analysis to include NLP on review text.

---
