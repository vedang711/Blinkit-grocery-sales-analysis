from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT/'data/raw'

def test_orders_unique():
    df = pd.read_csv(RAW/'blinkit_orders.csv')
    assert df['order_id'].is_unique

def test_product_ids_match():
    items = pd.read_csv(RAW/'blinkit_order_items.csv')
    products = pd.read_csv(RAW/'blinkit_products.csv')
    assert items['product_id'].isin(products['product_id']).all()

def test_order_values_non_negative():
    orders = pd.read_csv(RAW/'blinkit_orders.csv')
    assert (orders['order_total'] >= 0).all()

def test_inventory_values_non_negative():
    inv = pd.read_csv(RAW/'blinkit_inventory.csv')
    assert (inv['stock_received'] >= 0).all()
    assert (inv['damaged_stock'] >= 0).all()

def test_feedback_rating_range():
    fb = pd.read_csv(RAW/'blinkit_customer_feedback.csv')
    assert fb['rating'].between(1, 5).all()
