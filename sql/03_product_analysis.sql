USE blinkit_analytics;

-- Category sales using the item-level fact.
SELECT
    p.category,
    SUM(i.quantity) AS units_sold,
    COUNT(DISTINCT i.order_id) AS orders,
    ROUND(SUM(i.line_sales), 2) AS item_sales
FROM fact_order_items i
JOIN dim_product p ON i.product_id = p.product_id
GROUP BY p.category
ORDER BY item_sales DESC;

-- Top products by item-level sales
SELECT
    p.product_name,
    p.category,
    SUM(i.quantity) AS units_sold,
    ROUND(SUM(i.line_sales), 2) AS item_sales
FROM fact_order_items i
JOIN dim_product p ON i.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY item_sales DESC
LIMIT 10;

-- Estimated gross margin using the product margin percentage.
-- This is a proxy, not an accounting profit measure.
SELECT
    p.category,
    ROUND(SUM(i.line_sales), 2) AS item_sales,
    ROUND(SUM(i.line_sales * p.margin_percentage / 100), 2) AS estimated_gross_margin
FROM fact_order_items i
JOIN dim_product p ON i.product_id = p.product_id
GROUP BY p.category
ORDER BY estimated_gross_margin DESC;
