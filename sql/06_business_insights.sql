USE blinkit_analytics;

-- 1. Highest-revenue product categories
SELECT category, ROUND(SUM(line_sales),2) AS sales
FROM fact_order_items i
JOIN dim_product p ON i.product_id=p.product_id
GROUP BY category
ORDER BY sales DESC;

-- 2. Highest-sales customer segments
SELECT c.customer_segment, ROUND(SUM(o.order_total),2) AS sales
FROM dim_order o
JOIN dim_customer c ON o.customer_id=c.customer_id
GROUP BY c.customer_segment
ORDER BY sales DESC;

-- 3. Repeat customer share
SELECT ROUND(100.0*SUM(CASE WHEN order_count>1 THEN 1 ELSE 0 END)/COUNT(*),2) AS repeat_customer_rate_pct
FROM (SELECT customer_id, COUNT(*) order_count FROM dim_order GROUP BY customer_id) x;

-- 4. Delivery status mix
SELECT delivery_status, COUNT(*) AS orders
FROM fact_delivery
GROUP BY delivery_status
ORDER BY orders DESC;

-- 5. Marketing channel efficiency
SELECT channel,
       ROUND(SUM(revenue_generated)/NULLIF(SUM(spend),0),2) AS weighted_roas
FROM fact_marketing
GROUP BY channel
ORDER BY weighted_roas DESC;

-- 6. Inventory damage rate
SELECT ROUND(100.0*SUM(damaged_stock)/NULLIF(SUM(stock_received),0),2) AS damage_rate_pct
FROM fact_inventory;
