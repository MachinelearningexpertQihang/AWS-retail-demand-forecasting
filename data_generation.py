import pandas as pd
import numpy as np
from datetime import datetime, timedelta

# Generate simulated sales data
def generate_sales_data():
    np.random.seed(42)
    start_date = datetime(2024, 1, 1)
    end_date = start_date + timedelta(days=180)
    dates = pd.date_range(start_date, end_date)

    products = ['A', 'B', 'C', 'D', 'E']
    stores = ['Store1', 'Store2', 'Store3']

    data = []
    for date in dates:
        for product in products:
            for store in stores:
                # Base sales with trends and seasonality
                base_sales = 50
                trend = 0.1 * (date - start_date).days / 180  # Trend for product A
                if product == 'A':
                    base_sales += trend * 20
                elif product == 'C':
                    base_sales -= 0.05 * (date - start_date).days / 180 * 20

                # Weekend boost
                if date.weekday() >= 5:
                    base_sales *= 1.3

                # Promotion (random 30% chance)
                promotion = np.random.choice([0, 1], p=[0.7, 0.3])
                if promotion:
                    base_sales *= 1.5

                # Noise
                sales = max(0, base_sales + np.random.normal(0, 5))

                data.append({
                    'date': date,
                    'product_id': product,
                    'store_id': store,
                    'sales_quantity': round(sales),
                    'price': np.random.uniform(10, 50),
                    'promotion': promotion,
                    'day_of_week': date.weekday(),
                    'is_weekend': 1 if date.weekday() >= 5 else 0
                })

    df = pd.DataFrame(data)
    df.to_csv('sales_data.csv', index=False)
    print("Data generated and saved to sales_data.csv")

if __name__ == "__main__":
    generate_sales_data()