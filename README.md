# AWS End-to-End Sales Forecasting and Inventory Optimization System

## Project Overview
This project builds a complete machine learning system on AWS to forecast retail sales and optimize inventory. It predicts the next 30 days of sales using time series models, helping stores make smarter decisions on stock levels.

**Note**: This project was developed and executed on Amazon SageMaker, utilizing its managed Jupyter notebooks for model training and experimentation.

Key benefits: 44% better prediction accuracy, 20-40% lower inventory costs, and fewer stockouts.

## Technical Architecture
- Data: Stored in S3 with Parquet format, cataloged by Glue.
- Processing: Cleaned with Glue ETL, analyzed via Athena SQL.
- Modeling: Trained in SageMaker using XGBoost for best results.
- Automation: Daily predictions via Lambda, scheduled by EventBridge, monitored with CloudWatch.
- Visualization: Dashboards in QuickSight.

## Project Structure
```
aws-sales-forecast/
├── data_generation.py          # Script to generate simulated sales data
├── lambda_function.py          # Lambda code for automated predictions
├── requirements.txt            # Python dependencies
├── README.md                   # Project documentation
├── sql_queries/
│   └── eda_queries.sql         # SQL queries for EDA and analysis
├── notebooks/
│   └── model_training.ipynb    # Jupyter notebook for model training
├── screenshots/                # Screenshots of AWS services setup
├── Image_And_Final_Result/     # Final result images and visualizations
└── Architecture/               # Architecture diagrams and design docs
```

## How It Works
I started with generating realistic sales data for 5 products across 3 stores. Then, I cleaned and engineered features like sales lags and rolling averages. After training models (XGBoost performed best), I set up automated daily forecasts. The system runs fully on AWS serverless services for low cost.

## Results
- Accuracy: 12.66% MAPE (down from 22.70% baseline).
- Business Impact: Saves money on inventory, reduces waste, and improves sales planning.
- Automation: Runs daily without manual effort, costing about $50/month.

## Why It Matters
This shows how to turn data into real business value using cloud tools. It's efficient, scalable, and practical for retail operations.
