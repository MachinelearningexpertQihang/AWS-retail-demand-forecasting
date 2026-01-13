-- Real SQL queries for AWS retail sales forecasting project

-- Query 1: Calculate upper bound and buffer for future predictions
SELECT
    date,
    product_id,
    store_id,
    predicted_sales,
    -- Use rolling_30d as "upper bound" (or add 20% buffer)
    ROUND(sales_rolling_30d * 1.2, 0) AS upper_bound,
    ROUND(sales_rolling_30d * 1.2 - predicted_sales, 0) AS buffer_quantity,
    CASE
        WHEN ROUND(sales_rolling_30d * 1.2, 0) > 100 THEN 'Large Order'
        WHEN ROUND(sales_rolling_30d * 1.2, 0) > 50 THEN 'Medium Order'
        ELSE 'Small Order'
    END AS order_size
FROM future_predictions
ORDER BY date, product_id, store_id;

-- Query 2: Inventory optimization logic with safety stock and reorder points
WITH daily_stats AS (
  SELECT
    date,
    product_id,
    store_id,
    predicted_sales,
    0 AS current_inventory
  FROM future_predictions
),
inventory_logic AS (
  SELECT
    date,
    product_id,
    store_id,
    predicted_sales,
    current_inventory,
    AVG(predicted_sales) OVER (
      PARTITION BY product_id, store_id
      ORDER BY date
      ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS avg_daily_demand,
    STDDEV(predicted_sales) OVER (
      PARTITION BY product_id, store_id
      ORDER BY date
      ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS std_daily_demand
  FROM daily_stats
),
reorder_calc AS (
  SELECT
    date,
    product_id,
    store_id,
    predicted_sales,
    current_inventory,
    avg_daily_demand,
    std_daily_demand,
    ROUND(avg_daily_demand + 2 * COALESCE(std_daily_demand, 0), 0) AS safety_stock,
    ROUND((avg_daily_demand + 2 * COALESCE(std_daily_demand, 0)) + 3 * avg_daily_demand, 0) AS reorder_point,
    GREATEST(0, ROUND((avg_daily_demand + 2 * COALESCE(std_daily_demand, 0)) + 3 * avg_daily_demand - current_inventory, 0)) AS suggested_replenishment
  FROM inventory_logic
)
SELECT
  date,
  product_id,
  store_id,
  predicted_sales AS demand_forecast,
  safety_stock,
  reorder_point,
  suggested_replenishment AS daily_replenishment_qty
FROM reorder_calc
ORDER BY date, product_id, store_id
LIMIT 500;

-- Query 3: Compare raw vs processed data statistics
SELECT
    'Raw' AS stage,
    COUNT(*) AS row_count,
    AVG(sales_quantity) AS avg_sales,
    STDDEV(sales_quantity) AS std_sales,
    MIN(sales_quantity) AS min_sales,
    MAX(sales_quantity) AS max_sales
FROM raw_data

UNION ALL

SELECT
    'Processed' AS stage,
    COUNT(*) AS row_count,
    AVG(sales_quantity) AS avg_sales,
    STDDEV(sales_quantity) AS std_sales,
    MIN(sales_quantity) AS min_sales,
    MAX(sales_quantity) AS max_sales
FROM processed_data;

-- Query 4: Correlation between lag1 and actual sales (overall and by product)
WITH lag_data AS (
    SELECT
        product_id,
        store_id,
        sales_quantity,
        sales_lag1
    FROM processed_data
    WHERE sales_lag1 IS NOT NULL  -- Exclude first day
)
SELECT
    'Overall' AS scope,
    CORR(sales_quantity, sales_lag1) AS corr_lag1
FROM lag_data

UNION ALL

SELECT
    CONCAT('Product ', product_id) AS scope,
    CORR(sales_quantity, sales_lag1) AS corr_lag1
FROM lag_data
GROUP BY product_id
ORDER BY corr_lag1 DESC;

-- Query 5: Product performance analysis
SELECT
    product_id,
    SUM(sales_quantity) as total_sales,
    AVG(sales_quantity) as avg_daily_sales,
    SUM(sales_quantity * price) as revenue
FROM raw_data
GROUP BY product_id
ORDER BY revenue DESC;

-- Query 6: Promotion effect analysis
SELECT
    product_id,
    AVG(CASE WHEN promotion = 1 THEN sales_quantity END) as sales_with_promo,
    AVG(CASE WHEN promotion = 0 THEN sales_quantity END) as sales_no_promo,
    (AVG(CASE WHEN promotion = 1 THEN sales_quantity END) -
     AVG(CASE WHEN promotion = 0 THEN sales_quantity END)) /
     AVG(CASE WHEN promotion = 0 THEN sales_quantity END) * 100 as promo_lift_pct
FROM raw_data
GROUP BY product_id;

-- Query 7: Data overview
SELECT
    COUNT(*) as total_records,
    COUNT(DISTINCT product_id) as num_products,
    COUNT(DISTINCT store_id) as num_stores,
    MIN(date) as start_date,
    MAX(date) as end_date
FROM raw_data;

-- Query 8: Daily sales trends
SELECT
    date,
    SUM(sales_quantity) as total_sales,
    AVG(price) as avg_price,
    SUM(promotion) as promo_count
FROM raw_data
GROUP BY date
ORDER BY date;

-- Query 9: Weekend effect analysis
SELECT
    is_weekend,
    AVG(sales_quantity) as avg_sales,
    COUNT(*) as num_records
FROM raw_data
GROUP BY is_weekend;

-- Query 10: Data quality checks
SELECT
    'Missing dates' as check_type,
    COUNT(*) as issue_count
FROM (
    SELECT date FROM raw_data GROUP BY date HAVING COUNT(*) < 15
)
UNION ALL
SELECT
    'Negative sales',
    COUNT(*)
FROM raw_data
WHERE sales_quantity < 0
UNION ALL
SELECT
    'Zero price',
    COUNT(*)
FROM raw_data
WHERE price = 0;