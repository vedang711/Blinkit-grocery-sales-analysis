# Blinkit Grocery Sales Analysis — Business Insights

## Executive snapshot

- **Total order revenue:** ₹11,009,308.50 across 5,000 orders.
- **Average order value:** ₹2,201.86.
- **Active customers in the order file:** 2,172.
- **Repeat-customer rate:** 68.7% of customers placed more than one order in the order data.
- **On-time delivery rate (source status):** 69.4%.
- **Average feedback rating:** 3.34/5.
- **Weighted marketing ROAS:** 1.97x.
- **Inventory damage rate:** 54.4% of received stock units in the inventory file were marked damaged.

## 1. Product performance

**Dairy & Breakfast** is the highest-sales product category in the item-level data, with ₹639,222.19 in calculated line sales. The next categories are **Pharmacy** and **Fruits & Vegetables**.

This supports prioritising availability and merchandising analysis around the categories that already generate the most item-level sales.

## 2. Customer segments

The **Regular** segment contributes the highest order-level revenue at ₹2,890,148.66. The segment-level view should be used to compare revenue, order volume and average order value rather than assuming that a segment is inherently more profitable.

## 3. Customer retention

Approximately **68.7%** of customers appearing in the order data placed more than one order. This indicates that repeat purchasing is a meaningful part of the observed order base and is worth monitoring by segment and area.

## 4. Delivery performance

The source `delivery_status` field classifies **69.4%** of orders as On Time, with the remainder marked as slightly or significantly delayed. Among records where the actual timestamp is later than the promised timestamp, the recorded delay reason is dominated by **Traffic**.

**Data-quality note:** the source delivery status does not perfectly agree with the timestamp-derived on-time flag. The repository keeps both views and does not silently overwrite the source status.

## 5. Marketing performance

**Email** has the highest weighted ROAS among the channels in the marketing dataset at **2.05x**. This makes it a useful benchmark for comparing campaign efficiency, but ROAS alone should not be treated as causal evidence that one channel is responsible for revenue.

## 6. Inventory risk

The inventory dataset shows a **54.4%** damaged-stock ratio based on total received units. This is a useful operational signal, but the dataset does not contain closing stock or stock-out events, so the project should not claim that it directly measures inventory optimisation.

## 7. Important data limitations

1. `store_id` is unique for each order in the supplied order file, so store-level performance cannot be reliably interpreted as repeat outlet performance.
2. `order_total` and the sum of `quantity × unit_price` in `order_items` do not reconcile; therefore order-level revenue and item-level sales are analysed separately.
3. The project contains customer PII in the original source file. The GitHub-ready repository uses an anonymised customer dimension and excludes names, emails, phone numbers and addresses.
4. No direct inventory-on-hand or stock-out field is available, so inventory conclusions are limited to received and damaged stock.
5. Product `margin_percentage` is used only for an estimated gross-margin proxy, not accounting profit.

## 8. Recommended actions

- **Prioritise high-sales categories:** monitor availability, assortment and campaign support for the leading categories.
- **Monitor repeat customers:** compare repeat behaviour across customer segments and areas to identify retention opportunities.
- **Investigate traffic-related delays:** use delivery variance and delayed-order patterns to review peak-hour routing and operational capacity.
- **Use channel efficiency as a screening metric:** compare campaigns using ROAS, conversion rate and spend together rather than ROAS alone.
- **Reduce avoidable stock damage:** investigate products and periods with unusually high damage rates before increasing replenishment.
