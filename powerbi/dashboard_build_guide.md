# Power BI Dashboard Build Guide

Build four pages. Keep the design clean and interview-friendly.

## Page 1 — Executive Overview

**KPI cards**
- Total Sales
- Total Orders
- Average Order Value
- Active Customers
- Repeat Customer Rate %

**Visuals**
1. Line chart: Total Sales by Month
2. Column chart: Sales by Customer Segment
3. Bar chart: Sales by Customer Area (Top 10)
4. Donut/column chart: Orders by Payment Method

**Slicers**
- Date
- Customer Segment
- Area
- Payment Method

**Narrative:** overall commercial performance and customer mix.

## Page 2 — Product & Basket Analysis

**KPI cards**
- Item Sales
- Units Sold
- Estimated Gross Margin
- Estimated Gross Margin %

**Visuals**
1. Bar chart: Item Sales by Category
2. Bar chart: Top 10 Products by Item Sales
3. Column chart: Units Sold by Category
4. Scatter: Item Sales vs Estimated Gross Margin by Category
5. Table: Product, Category, Units Sold, Item Sales, Estimated Gross Margin

**Important:** estimated gross margin is a proxy based on the product margin percentage, not accounting profit.

## Page 3 — Delivery & Customer Experience

**KPI cards**
- On-Time Rate % (source status)
- Average Delivery Variance
- Delayed Orders
- Average Rating
- Negative Feedback %

**Visuals**
1. Stacked column: Delivery Status
2. Bar: Delay Reasons
3. Scatter: Distance vs Delivery Variance
4. Bar: Average Rating by Feedback Category
5. Column: Sentiment Mix

**Narrative:** operational reliability and customer experience.

## Page 4 — Marketing & Inventory

**KPI cards**
- Marketing Spend
- Marketing Revenue
- Marketing ROAS
- Inventory Damage Rate %

**Visuals**
1. Bar: Weighted ROAS by Channel
2. Column: Conversion Rate by Channel
3. Line: Marketing Revenue by Month
4. Line: Inventory Damage Rate by Month
5. Bar: Damaged Stock by Product Category (requires product join in Power Query/SQL)

**Narrative:** campaign efficiency and inventory loss signals.

## Formatting

- Use one consistent accent color and neutral backgrounds.
- Keep KPI cards at the top.
- Use clear units: ₹, %, minutes, units.
- Avoid 3D charts.
- Limit each page to 5–7 visuals.
- Use descriptive chart titles such as `Sales by Customer Segment` rather than `Segment Analysis`.

## What to say in an interview

> I separated the dashboard into commercial performance, product analysis, delivery/customer experience, and marketing/inventory because each page answers a different management question.

> I also separated order-level revenue from item-level sales because the supplied source data did not reconcile those two measures.
