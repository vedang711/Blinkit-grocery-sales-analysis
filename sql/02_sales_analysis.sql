USE blinkit_analytics;

-- Overall sales KPIs
SELECT
    COUNT(*) AS orders,
    ROUND(SUM(order_total), 2) AS total_sales,
    ROUND(AVG(order_total), 2) AS average_order_value,
    COUNT(DISTINCT customer_id) AS active_customers
FROM dim_order;

-- Monthly sales trend
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(*) AS orders,
    ROUND(SUM(order_total), 2) AS sales,
    ROUND(AVG(order_total), 2) AS average_order_value
FROM dim_order
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- Payment method performance
SELECT
    payment_method,
    COUNT(*) AS orders,
    ROUND(SUM(order_total), 2) AS sales,
    ROUND(AVG(order_total), 2) AS average_order_value
FROM dim_order
GROUP BY payment_method
ORDER BY sales DESC;
