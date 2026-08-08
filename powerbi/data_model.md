# Power BI Data Model

## Recommended model

Use a simple star-style model with an order bridge:

```text
DimDate ─────┬──── DimOrder ───── FactOrderItems ───── DimProduct
             │          │
             │          ├──────── FactDelivery
             │          └──────── FactCustomerFeedback
             │
             ├──────── FactInventory
             └──────── FactMarketing

DimCustomer ───── DimOrder
```

## Relationships

| From | To | Cardinality | Purpose |
|---|---|---|---|
| DimCustomer[customer_id] | DimOrder[customer_id] | 1:* | Customer segmentation |
| DimOrder[order_id] | FactOrderItems[order_id] | 1:* | Product analysis by order |
| DimProduct[product_id] | FactOrderItems[product_id] | 1:* | Product/category analysis |
| DimOrder[order_id] | FactDelivery[order_id] | 1:1 | Delivery performance |
| DimOrder[order_id] | FactCustomerFeedback[order_id] | 1:1 | Feedback analysis |
| DimDate[Date] | DimOrder[order_date_only] | 1:* | Order trends |
| DimDate[Date] | FactDelivery[actual_date] | 1:* | Delivery trends |
| DimDate[Date] | FactInventory[date] | 1:* | Inventory trends |
| DimDate[Date] | FactMarketing[date] | 1:* | Marketing trends |
| DimDate[Date] | FactCustomerFeedback[feedback_date] | 1:* | Feedback trends |

## Important modeling decision

`DimOrder[order_total]` and `FactOrderItems[line_sales]` do **not reconcile** in the supplied data. Therefore:

- Executive sales KPIs use **order-level revenue**.
- Product/category sales visuals use **item-level sales**.
- Never add the two together.
- Do not label item-level sales as the same metric as order-level revenue.

## Store limitation

`store_id` is unique for each order in the supplied file. It is therefore not a reliable repeated-outlet dimension. The dashboard uses **customer area** and **customer segment** for geographic/customer analysis rather than claiming store-level performance.
