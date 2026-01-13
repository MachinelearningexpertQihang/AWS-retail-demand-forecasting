import json
import boto3
import pandas as pd
from datetime import datetime, timedelta
import joblib
import os

s3 = boto3.client('s3')
bucket = 'your-bucket-name'  # Replace with your S3 bucket

def lambda_handler(event, context):
    # Load models from S3
    models = {}
    for product in ['A', 'B', 'C', 'D', 'E']:
        for store in ['Store1', 'Store2', 'Store3']:
            key = f'models/{product}_{store}_model.joblib'
            local_path = f'/tmp/{product}_{store}_model.joblib'
            s3.download_file(bucket, key, local_path)
            models[f'{product}_{store}'] = joblib.load(local_path)

    # Generate tomorrow's features (simplified)
    tomorrow = datetime.now() + timedelta(days=1)
    predictions = []
    for product in ['A', 'B', 'C', 'D', 'E']:
        for store in ['Store1', 'Store2', 'Store3']:
            # Dummy features - in real scenario, load historical data
            features = [50, 45, 40, 35, 30, 0, 0, 0]  # lag1 to lag7, etc.
            pred = models[f'{product}_{store}'].predict([features])[0]
            predictions.append({
                'date': tomorrow.strftime('%Y-%m-%d'),
                'product_id': product,
                'store_id': store,
                'predicted_sales': pred
            })

    # Save predictions to S3
    df = pd.DataFrame(predictions)
    output_key = f'predictions/daily/predictions_{tomorrow.strftime("%Y%m%d")}.csv'
    df.to_csv(f'/tmp/predictions.csv', index=False)
    s3.upload_file(f'/tmp/predictions.csv', bucket, output_key)

    return {
        'statusCode': 200,
        'body': json.dumps('Predictions generated successfully')
    }