# Data Dictionary

The project uses the following cleaned/anonymised tables.

## dim_order

| Column | Meaning |
|---|---|
| order_id | Unique order identifier |
| customer_id | Customer identifier |
| order_date | Order timestamp |
| order_date_only | Date portion used for date relationships |
| payment_method | Payment method used |
| store_id | Source store identifier; unique per order in this dataset |
| delivery_partner_id | Delivery partner identifier |
| delivery_status | Source delivery status |
| order_total | Order-level revenue |

## dim_product

Contains product name, category, brand, price/MRP, margin percentage and shelf-life/stock thresholds.

## dim_customer

The GitHub version is anonymised and excludes name, email, phone and address. It contains customer area, segment, registration date, total orders and average order value.

## fact_order_items

Contains product quantities and item-level calculated sales (`quantity × unit_price`). This metric does not reconcile to order-level revenue in the supplied source data.

## fact_delivery

Contains promised/actual timestamps, delivery status, distance, delay reason and a derived `delivery_variance_minutes` field.

## fact_inventory

Contains stock received and damaged stock by product/date. `damage_rate` is calculated as damaged stock divided by received stock.

## fact_marketing

Contains campaign, channel, impressions, clicks, conversions, spend, revenue generated and calculated CTR/conversion rate/ROAS.

## fact_customer_feedback

Contains rating, feedback category, sentiment and date. Raw feedback text is excluded from the GitHub-ready dataset to avoid publishing unnecessary free-text data.
