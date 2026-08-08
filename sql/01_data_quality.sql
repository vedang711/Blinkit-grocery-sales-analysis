USE blinkit_analytics;

-- 1. Duplicate orders
SELECT order_id, COUNT(*) AS row_count
FROM dim_order
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 2. Orders with missing customers
SELECT COUNT(*) AS missing_customer_links
FROM dim_order o
LEFT JOIN dim_customer c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 3. Product link coverage
SELECT
    COUNT(*) AS order_item_rows,
    SUM(CASE WHEN p.product_id IS NULL THEN 1 ELSE 0 END) AS missing_product_links
FROM fact_order_items i
LEFT JOIN dim_product p ON i.product_id = p.product_id;

-- 4. Revenue reconciliation check.
-- The dataset contains order-level revenue and a separate item-level sales amount.
-- These figures should NOT be added together without a defined business rule.
SELECT
    SUM(order_total) AS order_level_revenue,
    (SELECT SUM(line_sales) FROM fact_order_items) AS item_level_sales;

-- 5. Delivery status vs timestamp-derived status.
SELECT
    delivery_status,
    COUNT(*) AS records,
    SUM(CASE WHEN is_on_time_by_timestamp = 1 THEN 1 ELSE 0 END) AS on_time_by_timestamp
FROM fact_delivery
GROUP BY delivery_status;
