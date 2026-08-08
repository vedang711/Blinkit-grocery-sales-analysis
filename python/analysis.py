"""Blinkit Grocery Sales Analysis - reproducible Python analysis."""
from pathlib import Path
import pandas as pd
import numpy as np

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / 'data' / 'raw'
OUT = ROOT / 'reports'
OUT.mkdir(exist_ok=True)

orders = pd.read_csv(RAW/'blinkit_orders.csv', parse_dates=['order_date','promised_delivery_time','actual_delivery_time'])
items = pd.read_csv(RAW/'blinkit_order_items.csv')
products = pd.read_csv(RAW/'blinkit_products.csv')
customers = pd.read_csv(RAW/'blinkit_customers_anonymized.csv', parse_dates=['registration_date'])
delivery = pd.read_csv(RAW/'blinkit_delivery_performance.csv', parse_dates=['promised_time','actual_time'])
inventory = pd.read_csv(RAW/'blinkit_inventory.csv')
inventory['date'] = pd.to_datetime(inventory['date'], format='%d-%m-%Y', errors='coerce')
marketing = pd.read_csv(RAW/'blinkit_marketing_performance.csv', parse_dates=['date'])
feedback = pd.read_csv(RAW/'blinkit_customer_feedback.csv', parse_dates=['feedback_date'])

# Basic cleaning
orders = orders.drop_duplicates('order_id')
items = items.drop_duplicates()
products = products.drop_duplicates('product_id')
customers = customers.drop_duplicates('customer_id')

delivery['delivery_variance_minutes'] = (delivery['actual_time'] - delivery['promised_time']).dt.total_seconds()/60
delivery['on_time_by_timestamp'] = delivery['delivery_variance_minutes'] <= 0

items = items.merge(products[['product_id','product_name','category','brand','margin_percentage','shelf_life_days']], on='product_id', how='left')
items['line_sales'] = items['quantity'] * items['unit_price']
items['estimated_gross_margin'] = items['line_sales'] * items['margin_percentage'] / 100

inventory['damage_rate'] = inventory['damaged_stock'] / inventory['stock_received'].replace(0, np.nan)
marketing['ctr'] = marketing['clicks'] / marketing['impressions'].replace(0, np.nan)
marketing['conversion_rate'] = marketing['conversions'] / marketing['clicks'].replace(0, np.nan)
marketing['roas_calc'] = marketing['revenue_generated'] / marketing['spend'].replace(0, np.nan)

# KPIs
kpis = {
    'orders': int(len(orders)),
    'total_sales': float(orders.order_total.sum()),
    'average_order_value': float(orders.order_total.mean()),
    'active_customers': int(orders.customer_id.nunique()),
    'repeat_customer_rate_pct': float((orders.groupby('customer_id').size().gt(1).mean())*100),
    'item_level_sales': float(items.line_sales.sum()),
    'delivery_status_on_time_pct': float((orders.delivery_status == 'On Time').mean()*100),
    'marketing_weighted_roas': float(marketing.revenue_generated.sum()/marketing.spend.sum()),
    'inventory_damage_rate_pct': float(inventory.damaged_stock.sum()/inventory.stock_received.sum()*100),
    'avg_feedback_rating': float(feedback.rating.mean()),
}

# Tables for reports
cat = items.groupby('category').agg(units_sold=('quantity','sum'), item_sales=('line_sales','sum'), estimated_gross_margin=('estimated_gross_margin','sum')).sort_values('item_sales', ascending=False)
segment = orders.merge(customers[['customer_id','customer_segment','area']], on='customer_id', how='left').groupby('customer_segment').agg(orders=('order_id','nunique'), sales=('order_total','sum'), aov=('order_total','mean')).sort_values('sales', ascending=False)
area = orders.merge(customers[['customer_id','area']], on='customer_id', how='left').groupby('area').agg(orders=('order_id','nunique'), sales=('order_total','sum'), aov=('order_total','mean')).sort_values('sales', ascending=False)
channel = marketing.groupby('channel').agg(impressions=('impressions','sum'), clicks=('clicks','sum'), conversions=('conversions','sum'), spend=('spend','sum'), revenue=('revenue_generated','sum'))
channel['ctr_pct'] = channel.clicks/channel.impressions*100
channel['conversion_rate_pct'] = channel.conversions/channel.clicks*100
channel['weighted_roas'] = channel.revenue/channel.spend

# Save processed analytical tables
cat.to_csv(OUT/'category_performance.csv')
segment.to_csv(OUT/'customer_segment_performance.csv')
area.to_csv(OUT/'area_performance.csv')
channel.to_csv(OUT/'marketing_channel_performance.csv')
pd.DataFrame([kpis]).to_csv(OUT/'kpis.csv', index=False)

# Business insights with actual values
best_cat = cat.index[0]
best_seg = segment.index[0]
best_area = area.index[0]
best_channel = channel.weighted_roas.idxmax()
report = f'''# Blinkit Grocery Sales Analysis — Business Insights\n\n## Executive snapshot\n\n- **Total order revenue:** ₹{kpis['total_sales']:,.2f} across {kpis['orders']:,} orders.\n- **Average order value:** ₹{kpis['average_order_value']:,.2f}.\n- **Active customers in the order file:** {kpis['active_customers']:,}.\n- **Repeat-customer rate:** {kpis['repeat_customer_rate_pct']:.1f}% of customers placed more than one order in the order data.\n- **On-time delivery rate (source status):** {kpis['delivery_status_on_time_pct']:.1f}%.\n- **Average feedback rating:** {kpis['avg_feedback_rating']:.2f}/5.\n- **Weighted marketing ROAS:** {kpis['marketing_weighted_roas']:.2f}x.\n- **Inventory damage rate:** {kpis['inventory_damage_rate_pct']:.1f}% of received stock units in the inventory file were marked damaged.\n\n## 1. Product performance\n\n**{best_cat}** is the highest-sales product category in the item-level data, with ₹{cat.iloc[0].item_sales:,.2f} in calculated line sales. The next categories are **{cat.index[1]}** and **{cat.index[2]}**.\n\nThis supports prioritising availability and merchandising analysis around the categories that already generate the most item-level sales.\n\n## 2. Customer segments\n\nThe **{best_seg}** segment contributes the highest order-level revenue at ₹{segment.iloc[0].sales:,.2f}. The segment-level view should be used to compare revenue, order volume and average order value rather than assuming that a segment is inherently more profitable.\n\n## 3. Customer retention\n\nApproximately **{kpis['repeat_customer_rate_pct']:.1f}%** of customers appearing in the order data placed more than one order. This indicates that repeat purchasing is a meaningful part of the observed order base and is worth monitoring by segment and area.\n\n## 4. Delivery performance\n\nThe source `delivery_status` field classifies **{kpis['delivery_status_on_time_pct']:.1f}%** of orders as On Time, with the remainder marked as slightly or significantly delayed. Among records where the actual timestamp is later than the promised timestamp, the recorded delay reason is dominated by **Traffic**.\n\n**Data-quality note:** the source delivery status does not perfectly agree with the timestamp-derived on-time flag. The repository keeps both views and does not silently overwrite the source status.\n\n## 5. Marketing performance\n\n**{best_channel}** has the highest weighted ROAS among the channels in the marketing dataset at **{channel.loc[best_channel,'weighted_roas']:.2f}x**. This makes it a useful benchmark for comparing campaign efficiency, but ROAS alone should not be treated as causal evidence that one channel is responsible for revenue.\n\n## 6. Inventory risk\n\nThe inventory dataset shows a **{kpis['inventory_damage_rate_pct']:.1f}%** damaged-stock ratio based on total received units. This is a useful operational signal, but the dataset does not contain closing stock or stock-out events, so the project should not claim that it directly measures inventory optimisation.\n\n## 7. Important data limitations\n\n1. `store_id` is unique for each order in the supplied order file, so store-level performance cannot be reliably interpreted as repeat outlet performance.\n2. `order_total` and the sum of `quantity × unit_price` in `order_items` do not reconcile; therefore order-level revenue and item-level sales are analysed separately.\n3. The project contains customer PII in the original source file. The GitHub-ready repository uses an anonymised customer dimension and excludes names, emails, phone numbers and addresses.\n4. No direct inventory-on-hand or stock-out field is available, so inventory conclusions are limited to received and damaged stock.\n5. Product `margin_percentage` is used only for an estimated gross-margin proxy, not accounting profit.\n\n## 8. Recommended actions\n\n- **Prioritise high-sales categories:** monitor availability, assortment and campaign support for the leading categories.\n- **Monitor repeat customers:** compare repeat behaviour across customer segments and areas to identify retention opportunities.\n- **Investigate traffic-related delays:** use delivery variance and delayed-order patterns to review peak-hour routing and operational capacity.\n- **Use channel efficiency as a screening metric:** compare campaigns using ROAS, conversion rate and spend together rather than ROAS alone.\n- **Reduce avoidable stock damage:** investigate products and periods with unusually high damage rates before increasing replenishment.\n'''
(OUT/'business_insights.md').write_text(report, encoding='utf-8')
print('KPI summary:', kpis)
print('Top categories:', cat.head(5).round(2).to_string())
print('Segments:', segment.round(2).to_string())
print('Channels:', channel.round(3).to_string())
