-- Blinkit Grocery Sales Analysis
-- MySQL 8.0+ schema

CREATE DATABASE IF NOT EXISTS blinkit_analytics;
USE blinkit_analytics;

DROP TABLE IF EXISTS fact_customer_feedback;
DROP TABLE IF EXISTS fact_marketing;
DROP TABLE IF EXISTS fact_inventory;
DROP TABLE IF EXISTS fact_delivery;
DROP TABLE IF EXISTS fact_order_items;
DROP TABLE IF EXISTS dim_order;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_product;

CREATE TABLE dim_customer (
    customer_id BIGINT PRIMARY KEY,
    area VARCHAR(100),
    registration_date DATE,
    customer_segment VARCHAR(50),
    total_orders INT,
    avg_order_value DECIMAL(12,2)
);

CREATE TABLE dim_product (
    product_id BIGINT PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(100),
    brand VARCHAR(150),
    price DECIMAL(12,2),
    mrp DECIMAL(12,2),
    margin_percentage DECIMAL(6,2),
    shelf_life_days INT,
    min_stock_level INT,
    max_stock_level INT
);

CREATE TABLE dim_order (
    order_id BIGINT PRIMARY KEY,
    customer_id BIGINT,
    order_date DATETIME,
    payment_method VARCHAR(30),
    store_id BIGINT,
    delivery_partner_id BIGINT,
    delivery_status VARCHAR(50),
    order_total DECIMAL(14,2),
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id)
);

CREATE TABLE fact_order_items (
    order_id BIGINT,
    product_id BIGINT,
    quantity INT,
    unit_price DECIMAL(12,2),
    line_sales DECIMAL(14,2),
    FOREIGN KEY (order_id) REFERENCES dim_order(order_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);

CREATE TABLE fact_delivery (
    order_id BIGINT,
    delivery_partner_id BIGINT,
    promised_time DATETIME,
    actual_time DATETIME,
    delivery_time_minutes DECIMAL(8,2),
    distance_km DECIMAL(8,2),
    delivery_status VARCHAR(50),
    reasons_if_delayed VARCHAR(100),
    delivery_variance_minutes DECIMAL(8,2),
    is_on_time_by_timestamp BOOLEAN
);

CREATE TABLE fact_inventory (
    product_id BIGINT,
    date DATE,
    stock_received INT,
    damaged_stock INT,
    damage_rate DECIMAL(8,4)
);

CREATE TABLE fact_marketing (
    campaign_id BIGINT,
    campaign_name VARCHAR(100),
    date DATE,
    target_audience VARCHAR(50),
    channel VARCHAR(50),
    impressions INT,
    clicks INT,
    conversions INT,
    spend DECIMAL(14,2),
    revenue_generated DECIMAL(14,2),
    roas DECIMAL(10,4),
    ctr DECIMAL(10,6),
    conversion_rate DECIMAL(10,6)
);

CREATE TABLE fact_customer_feedback (
    feedback_id BIGINT PRIMARY KEY,
    order_id BIGINT,
    customer_id BIGINT,
    rating INT,
    feedback_category VARCHAR(50),
    sentiment VARCHAR(30),
    feedback_date DATE
);
