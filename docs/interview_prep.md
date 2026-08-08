# Interview Preparation

## 60-second explanation

I worked on a Blinkit grocery analytics case study using MySQL, Python and Power BI. The dataset contained order, product, customer, delivery, marketing, inventory and feedback information. I first cleaned and validated the data in Python, then used MySQL for business questions such as sales by customer segment, product-category performance, repeat-customer rate, delivery status and marketing-channel efficiency. Finally, I used Power BI to build an interactive dashboard covering executive sales performance, product analysis, delivery/customer experience, and marketing/inventory signals. One important part of the project was documenting data-quality limitations instead of hiding them—for example, order-level revenue did not reconcile with item-level sales, and store IDs were unique per order.

## Why SQL?

SQL is useful for grouping and aggregating structured business data. I used it for sales KPIs, customer segments, product categories, delivery performance, marketing channels and inventory metrics.

## Why Python?

I used Pandas for data cleaning, validation, derived columns and exploratory analysis before creating the Power BI model.

## Why Power BI?

Power BI makes it easier for a business user to interact with the analysis through KPI cards, filters and drill-down visuals.

## What is AOV?

Average Order Value is total order revenue divided by the number of orders.

## What was the most important data-quality issue?

The order-level `order_total` and the item-level `quantity × unit_price` did not reconcile. I therefore kept them as separate analytical measures instead of adding them together.

## Why did you not analyse outlet performance?

The supplied `store_id` is unique for each order, so it does not represent repeated outlet observations. Claiming store-level performance would therefore be misleading. I used customer area and customer segment instead.

## What does repeat-customer rate mean here?

It is the percentage of customers in the order data who placed more than one order in the observed period.

## What is ROAS?

Return on Ad Spend = revenue generated divided by advertising spend. It is a simple efficiency metric and does not by itself prove causality.

## What is the inventory damage rate?

Damaged stock divided by received stock. It is an operational signal, not a complete inventory-health metric because the dataset does not contain closing stock or stock-out events.

## What would you improve?

I would add a proper outlet master, inventory-on-hand and stock-out events, and reconcile order totals with item-level sales, discounts and taxes.

## What did you learn?

I learned that a good analytics project is not only about creating charts. Data validation and clearly stating limitations are just as important because they determine which business conclusions are actually defensible.
