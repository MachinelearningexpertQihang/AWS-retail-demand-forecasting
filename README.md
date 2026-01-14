# AWS End-to-End Sales Forecasting and Inventory Optimization System

## Project Overview
This project builds a complete machine learning system on AWS to forecast retail sales and optimize inventory. It predicts the next 30 days of sales using time series models, helping stores make smarter decisions on stock levels.

**Note**: This project was developed and executed on Amazon SageMaker, utilizing its managed Jupyter notebooks for model training and experimentation.

Key benefits: 44% better prediction accuracy, 20-40% lower inventory costs, and fewer stockouts.

## Technical Architecture
- **Ingestion & Storage**: Historic and operational sales data are stored in S3 in columnar format (Parquet) for efficient storage and query.
- **Catalog & Discovery**: Glue Data Catalog provides table metadata to enable schema discovery across datasets.
- **ETL & Feature Engineering**: Batch ETL and feature engineering run as Glue jobs or as SageMaker Processing jobs, producing features such as lags, rolling aggregates, holiday flags, and store/product metadata.
- **Querying & Analysis**: Athena is used for ad-hoc SQL exploration and validation of data and features.
- **Model Training & Tuning**: Model training is executed in SageMaker using XGBoost (and hyperparameter tuning when applicable).
- **Model Registry & Packaging**: Trained models are registered and versioned for reproducibility and controlled deployment.
- **Deployment & Inference**: Inference is performed by a scheduled serverless job (Lambda) that loads the model artifacts and writes predictions back to S3 for downstream consumption.
- **Scheduling & Automation**: EventBridge (CloudWatch Events) triggers scheduled inference jobs and periodic evaluation runs.
- **Monitoring & Alerts**: CloudWatch monitors job health, logs and custom metrics (e.g., MAPE drift); alarms notify on failures or performance regressions.
- **Visualization & BI**: Results and business KPIs are visualized in QuickSight and/or downstream BI tools.

## Project Structure
```
AWS-retail-demand-forecasting/
├── data_generation.py          # Example helper for preparing sample datasets / reference utilities
├── lambda_function.py          # Lambda code used for scheduled batch inference
├── requirements.txt            # Python dependencies
├── README.md                   # Project documentation (this file)
├── sql_queries/
│   └── eda_queries.sql         # SQL queries for EDA and validation
├── notebooks/
│   └── model_training.ipynb    # Notebooks for feature engineering and model training
├── Screenshot/                 # Diagrams and screenshots (architecture, dashboards)
└── Architecture.png            # Architecture diagram (visual reference)
```

## How It Works
1. **Data landing**: Sales and related operational records are landed and stored in S3 under a defined partitioning scheme (date / store / product).
2. **Catalog & validation**: Glue Data Catalog tables and Athena SQL validate schema and data quality checks.
3. **Feature engineering**: ETL jobs compute features (lags, rolling statistics, calendar features, promotions/price metadata) and materialize feature tables in S3.
4. **Model training**: Experiments and training runs are executed in SageMaker; best models are validated and registered.
5. **Scheduled inference**: A scheduled job (EventBridge → Lambda) loads the registered model, runs batch inference for the prediction window, and writes outputs to S3.
6. **Post-processing & publishing**: Predictions are joined with store/product metadata, aggregated as needed, and exposed to downstream consumers (dashboards, APIs, or manual exports).
7. **Monitoring & retraining**: Evaluation jobs compute model performance and data drift metrics; alarms trigger investigation or retraining as needed.

> Notes:
> - This README focuses on the system architecture and workflow. Implementation details and runnable examples are left in the notebooks and scripts under `notebooks/` and `sql_queries/`.
> - The repository includes example helpers for dataset handling; production data ingestion and bucket names should be configured via environment variables or deployment templates.

## Results
- Accuracy: 12.66% MAPE (down from 22.70% baseline).
- Business Impact: Saves money on inventory, reduces waste, and improves sales planning.
- Automation: Runs daily without manual effort, costing about $50/month.

## Why It Matters
In today's competitive retail landscape, accurate demand forecasting is not just a nice-to-have—it's a strategic imperative. This project demonstrates how advanced machine learning and cloud infrastructure can transform raw data into actionable insights, driving significant bottom-line impact.

**Financial Benefits:**
- **Cost Reduction:** By optimizing inventory levels, retailers can reduce carrying costs by 20-40%, minimizing overstock and associated storage, insurance, and obsolescence expenses.
- **Revenue Growth:** Improved forecast accuracy (achieving 12.66% MAPE) enables better stock availability, reducing lost sales from stockouts and increasing customer satisfaction, potentially boosting revenue by 5-10% through enhanced sales planning.

**Operational Efficiency:**
- **Scalability:** The serverless architecture on AWS scales seamlessly with business growth, handling millions of products and stores without manual intervention.
- **Automation:** Daily automated predictions eliminate human error and free up teams to focus on strategic decisions, with total operational costs under $50/month.

**Competitive Advantage:**
- **Data-Driven Decisions:** Empowers retailers to anticipate market trends, respond to promotions, and adapt to seasonal fluctuations faster than competitors relying on intuition or outdated methods.
- **Sustainability:** Reduces waste from unsold inventory, aligning with environmental goals and improving brand reputation.

This solution isn't merely technical—it's a catalyst for retail transformation, proving that investing in AI-driven forecasting yields measurable ROI and positions companies for long-term success in an increasingly data-centric world.
