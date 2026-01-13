-- Sample EDA queries for Athena

-- 1. Data quality check
SELECT COUNT(*) as total_records,
       COUNT(CASE WHEN sales_quantity IS NULL THEN 1 END) as null_sales
FROM sales_forecast_db.raw_data;

-- 2. Daily sales trend
SELECT date, SUM(sales_quantity) as total_sales
FROM sales_forecast_db.raw_data
GROUP BY date
ORDER BY date;

-- 3. Product performance
SELECT product_id, SUM(sales_quantity) as total_sales
FROM sales_forecast_db.raw_data
GROUP BY product_id
ORDER BY total_sales DESC;

-- 4. Promotion effect
SELECT promotion, AVG(sales_quantity) as avg_sales
FROM sales_forecast_db.raw_data
GROUP BY promotion;

-- 5. Weekend vs weekday
SELECT is_weekend, AVG(sales_quantity) as avg_sales
FROM sales_forecast_db.raw_data
GROUP BY is_weekend;