USE blinkit_analytics;

-- Customer segment performance
SELECT
    c.customer_segment,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(o.order_id) AS orders,
    ROUND(SUM(o.order_total), 2) AS sales,
    ROUND(AVG(o.order_total), 2) AS average_order_value
FROM dim_customer c
JOIN dim_order o ON c.customer_id = o.customer_id
GROUP BY c.customer_segment
ORDER BY sales DESC;

-- Repeat customer rate
SELECT
    ROUND(100.0 * SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS repeat_customer_rate_pct
FROM (
    SELECT customer_id, COUNT(*) AS order_count
    FROM dim_order
    GROUP BY customer_id
) x;

-- Top customer areas by sales
SELECT
    c.area,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(o.order_id) AS orders,
    ROUND(SUM(o.order_total), 2) AS sales,
    ROUND(AVG(o.order_total), 2) AS average_order_value
FROM dim_order o
JOIN dim_customer c ON o.customer_id = c.customer_id
GROUP BY c.area
ORDER BY sales DESC
LIMIT 10;
