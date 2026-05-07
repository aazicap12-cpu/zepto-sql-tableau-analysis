drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150)NOT NULL,
mrp NUMERIC(8,2),
discountprecent NUMERIC(5,2),
availableQuantity INTEGER ,
discountedsellingprice NUMERIC(8,2),
weightinGms INTEGER,
Outofstock BOOLEAN,
quantity INTEGER
);

--data exploration ABORT

--count of raw

SELECT count(*) FROM zepto;

--sample data 

SELECT * from zepto 
LIMIT 10;

--null values 

SELECT * from zepto
WHERE name IS NULL
or 
category IS NULL
or 
mrp IS NULL
or 
discountPrecent IS NULL
or 
discountedsellingprice IS NULL
or 
weightingms IS NULL
or 
availablequantity IS NULL
or 
outofstock IS NULL
or 
quantity IS NULL;

--different product categories
SELECT DISTINCT category FROM zepto
ORDER by category ;

-- product in stock vs out of stock
SELECT outofstock, count(sku_id)
from zepto
group by outofstock;

--product name present multpl times 
SELECT name , count(sku_id) as "number of SKUS"
FROM zepto
GROUP by name 
having count(sku_id) > 1
ORDER by count(sku_id) DESC;

--data cleaning 

--products with price = 0

SELECT * from zepto
where mrp = 0
or discountedsellingprice = 0;

DELETE FROM zepto 
where mrp =0;

--convert paise to rupee

UPDATE zepto 
SET mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;

SELECT mrp, discountedsellingprice FROM zepto;

-- Found top 10 best-value products based on discount percentage
SELECT distinct name, mrp, discountprecent
FROM zepto
order by discountprecent DESC
LIMIT 10;

-- Identified high-MRP products that are currently out of stock

SELECT distinct name, mrp FROM zepto
where outofstock = True and mrp > 300
order by mrp desc;
 

-- Estimated potential revenue for each product category
SELECT category, 
sum(discountedsellingprice * availablequantity) AS total_revenue
from zepto
group by category
order by total_revenue;


-- Filtered expensive products (MRP > ₹500) with minimal discount
SELECT distinct name, mrp, discountprecent
from zepto
where mrp > 500 and discountprecent < 10
order by mrp desc, discountprecent desc;

-- Ranked top 5 categories offering highest average discounts
select category,
ROUND(AVG(discountprecent),2) as avg_discount
from zepto
group by category
order by avg_discount desc
LIMIT 5;



-- Calculated price per gram to identify value-for-money products

SELECT distinct name, weightingms , discountedsellingprice,
round(discountedsellingprice/weightingms, 2) as price_per_gram
from zepto
where weightingms >= 100
order by price_per_gram;

-- Grouped products based on weight into Low, Medium, and Bulk categories
SELECT distinct name, weightingms,
case when weightingms < 1000 then 'low'
   WHEN weightingms < 5000 then 'medium'
   else 'bulk'
   end as weight_category 
   from zepto;
-- Measured total inventory weight per product category

SELECT category,
sum(weightingms * availablequantity) as total_weight
from zepto
group by category
order by total_weight;