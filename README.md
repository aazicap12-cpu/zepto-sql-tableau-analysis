# Zepto Inventory & Sales Analysis Dashboard

## Project Overview

This project analyzes Zepto product inventory, pricing, discounts, and stock availability using PostgreSQL and Tableau.

The dataset was cleaned, transformed, and analyzed using SQL queries, and insights were visualized through an interactive Tableau dashboard.

---

## Tools Used

* PostgreSQL
* SQL
* Tableau Public
* CSV Dataset

---

# Database Schema

```sql
CREATE TABLE zepto(
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountprecent NUMERIC(5,2),
    availableQuantity INTEGER,
    discountedsellingprice NUMERIC(8,2),
    weightinGms INTEGER,
    Outofstock BOOLEAN,
    quantity INTEGER
);
```

---

# Data Exploration

## Count of Total Records

```sql
SELECT COUNT(*) FROM zepto;
```

---

## Sample Dataset Preview

```sql
SELECT * FROM zepto
LIMIT 10;
```

---

## Checking Null Values

```sql
SELECT * FROM zepto
WHERE name IS NULL
OR category IS NULL
OR mrp IS NULL
OR discountPrecent IS NULL
OR discountedsellingprice IS NULL
OR weightingms IS NULL
OR availablequantity IS NULL
OR outofstock IS NULL
OR quantity IS NULL;
```

---

## Distinct Product Categories

```sql
SELECT DISTINCT category
FROM zepto
ORDER BY category;
```

---

## Product Availability Status

```sql
SELECT outofstock, COUNT(sku_id)
FROM zepto
GROUP BY outofstock;
```

Insight:
Analyzed the number of products currently in stock vs out of stock.

---

## Duplicate Product Detection

```sql
SELECT name, COUNT(sku_id) AS "number of SKUS"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;
```

Insight:
Identified products appearing multiple times with different SKU entries.

---

# Data Cleaning

## Products with Invalid Pricing

```sql
SELECT * FROM zepto
WHERE mrp = 0
OR discountedsellingprice = 0;
```

---

## Removing Zero MRP Products

```sql
DELETE FROM zepto
WHERE mrp = 0;
```

---

## Converting Paise to Rupees

```sql
UPDATE zepto
SET mrp = mrp / 100.0,
    discountedsellingprice = discountedsellingprice / 100.0;
```

---

## Verification Query

```sql
SELECT mrp, discountedsellingprice
FROM zepto;
```

---

# Business Questions & SQL Analysis

## 1. What are the Top Discounted Products?

```sql
SELECT DISTINCT name, mrp, discountprecent
FROM zepto
ORDER BY discountprecent DESC
LIMIT 10;
```

Insight:
Identified products offering the highest discounts to customers.

---

## 2. Which High-Priced Products Are Out of Stock?

```sql
SELECT DISTINCT name, mrp
FROM zepto
WHERE outofstock = TRUE
AND mrp > 300
ORDER BY mrp DESC;
```

Insight:
Detected premium products unavailable in inventory.

---

## 3. Which Product Categories Generate the Highest Revenue?

```sql
SELECT category,
SUM(discountedsellingprice * availablequantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;
```

Insight:
Estimated revenue contribution across product categories.

---

## 4. Which Expensive Products Have Minimal Discounts?

```sql
SELECT DISTINCT name, mrp, discountprecent
FROM zepto
WHERE mrp > 500
AND discountprecent < 10
ORDER BY mrp DESC, discountprecent DESC;
```

Insight:
Found premium products receiving very low discounts.

---

## 5. Which Categories Offer the Highest Average Discounts?

```sql
SELECT category,
ROUND(AVG(discountprecent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;
```

Insight:
Compared average discounts across product categories.

---

## 6. Which Products Provide the Best Value Based on Price Per Gram?

```sql
SELECT DISTINCT name,
weightingms,
discountedsellingprice,
ROUND(discountedsellingprice / weightingms, 2) AS price_per_gram
FROM zepto
WHERE weightingms >= 100
ORDER BY price_per_gram;
```

Insight:
Calculated price efficiency using price-per-gram analysis.

---

## 7. How Are Products Distributed Across Weight Categories?

```sql
SELECT DISTINCT name,
weightingms,
CASE
    WHEN weightingms < 1000 THEN 'low'
    WHEN weightingms < 5000 THEN 'medium'
    ELSE 'bulk'
END AS weight_category
FROM zepto;
```

Insight:
Grouped products into Low, Medium, and Bulk segments.

---

## 8. Which Categories Contain the Highest Inventory Weight?

```sql
SELECT category,
SUM(weightingms * availablequantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;
```

Insight:
Measured inventory load across product categories.

---

# Tableau Dashboard Features

* Revenue by Category
* Average Discount by Category
* Top Discount Products
* Out of Stock Premium Products
* Weight Category Distribution
* Price Per Gram Analysis
* Total Inventory Weight by Category
* Stock Availability Status

---

# Dashboard Preview

Add your dashboard screenshot below:

```text
/dashboard.png
```

---

# Files Included

* `zepto_analysis.sql`
* `zepto_dashboard.twb`
* `zepto_cleaned.csv`
* `dashboard.png`
* `README.md`

---

# Conclusion

This project demonstrates SQL-based business analysis and Tableau dashboard development using real-world inventory and sales data.

The analysis helps identify discount trends, revenue opportunities, inventory distribution, and stock availability insights for better business decision-making.
