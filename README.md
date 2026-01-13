# AWS End-to-End Sales Forecasting and Inventory Optimization System

## Project Overview
This project builds a complete machine learning system on AWS to forecast retail sales and optimize inventory. It predicts the next 30 days of sales using time series models, helping stores make smarter decisions on stock levels.

Key benefits: 44% better prediction accuracy, 20-40% lower inventory costs, and fewer stockouts.

## Technical Architecture
- Data: Stored in S3 with Parquet format, cataloged by Glue.
- Processing: Cleaned with Glue ETL, analyzed via Athena SQL.
- Modeling: Trained in SageMaker using XGBoost for best results.
- Automation: Daily predictions via Lambda, scheduled by EventBridge, monitored with CloudWatch.
- Visualization: Dashboards in QuickSight.

![Architecture Diagram](images/architecture.png)

## How It Works
I started with generating realistic sales data for 5 products across 3 stores. Then, I cleaned and engineered features like sales lags and rolling averages. After training models (XGBoost performed best), I set up automated daily forecasts. The system runs fully on AWS serverless services for low cost.

## Results
- Accuracy: 12.66% MAPE (down from 22.70% baseline).
- Business Impact: Saves money on inventory, reduces waste, and improves sales planning.
- Automation: Runs daily without manual effort, costing about $50/month.

## Why It Matters
This shows how to turn data into real business value using cloud tools. It's efficient, scalable, and practical for retail operations.
