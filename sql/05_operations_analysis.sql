USE blinkit_analytics;

-- Delivery performance using the source delivery_status field.
SELECT
    delivery_status,
    COUNT(*) AS orders,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS share_pct
FROM fact_delivery
GROUP BY delivery_status
ORDER BY orders DESC;

-- Average delivery variance vs promised time.
SELECT
    ROUND(AVG(delivery_variance_minutes), 2) AS avg_variance_minutes,
    ROUND(AVG(CASE WHEN delivery_variance_minutes > 0 THEN delivery_variance_minutes END), 2) AS avg_delay_when_late
FROM fact_delivery;

-- Delay reasons
SELECT
    reasons_if_delayed,
    COUNT(*) AS delayed_orders,
    ROUND(AVG(delivery_variance_minutes), 2) AS avg_delay_minutes
FROM fact_delivery
WHERE delivery_variance_minutes > 0
GROUP BY reasons_if_delayed
ORDER BY delayed_orders DESC;

-- Inventory damage rate by month
SELECT
    DATE_FORMAT(date, '%Y-%m') AS month,
    SUM(stock_received) AS stock_received,
    SUM(damaged_stock) AS damaged_stock,
    ROUND(100.0 * SUM(damaged_stock) / NULLIF(SUM(stock_received), 0), 2) AS damage_rate_pct
FROM fact_inventory
GROUP BY DATE_FORMAT(date, '%Y-%m')
ORDER BY month;

-- Marketing channel performance
SELECT
    channel,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(conversions) AS conversions,
    ROUND(SUM(spend), 2) AS spend,
    ROUND(SUM(revenue_generated), 2) AS revenue_generated,
    ROUND(SUM(revenue_generated) / NULLIF(SUM(spend), 0), 2) AS weighted_roas,
    ROUND(100.0 * SUM(clicks) / NULLIF(SUM(impressions), 0), 2) AS ctr_pct,
    ROUND(100.0 * SUM(conversions) / NULLIF(SUM(clicks), 0), 2) AS conversion_rate_pct
FROM fact_marketing
GROUP BY channel
ORDER BY weighted_roas DESC;
