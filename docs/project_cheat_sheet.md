# 10-Minute Interview Cheat Sheet

## Project in one sentence

I analysed Blinkit-style grocery data across orders, products, customers, delivery, marketing and inventory using Python and MySQL, then built a Power BI dashboard to turn the results into business insights.

## Core numbers

- 5,000 orders
- ₹11.01M order-level revenue
- ₹2,201.86 AOV
- 2,172 active customers in the order file
- 68.7% repeat-customer rate
- 69.4% source-status on-time rate
- 3.34/5 average feedback rating
- 1.97x weighted marketing ROAS
- 54.4% damaged/received inventory ratio

## Most important insight

Sales are not one-dimensional: customer mix, product mix, delivery reliability, marketing efficiency and inventory loss all need to be viewed together.

## Important limitation

The supplied store_id is unique per order, so I did not claim that it measures repeated outlet performance.

## Important technical limitation

Order-level revenue and item-level sales do not reconcile, so I analysed them separately.

## Python answer

I used Pandas for loading, cleaning, type conversion, derived metrics, validation and exploratory analysis.

## SQL answer

I used SQL for aggregations, segment comparisons, category rankings, repeat-customer analysis, delivery analysis, marketing channel performance and inventory damage analysis.

## Power BI answer

I used Power BI to combine the cleaned tables into an analytical model, create DAX KPIs and present the analysis as four management-focused dashboard pages.

## What I would improve

I would add a real outlet master, inventory-on-hand/stock-out data, and a reconciled order-item revenue model.
