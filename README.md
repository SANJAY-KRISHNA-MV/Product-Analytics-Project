# 📈 Product Analytics & Conversion Optimization Project

## Unlocking User Behavior & Driving Growth Through Data

---

## 🎯 Introduction

This project delivers an end-to-end product analytics solution, from raw data acquisition and transformation to in-depth behavioral analysis, actionable recommendations, and predictive modeling for user conversion. By simulating real-world product usage data and leveraging cloud analytics with Google BigQuery and advanced Python capabilities, this project aims to provide deep insights into the user journey and identify key opportunities for product optimization and business growth.

---

## ✨ Project Phases & Key Components

The project is structured into six comprehensive phases, each documented in detail within the `documentation/` directory:

### [Phase 1: Data Acquisition & Setup](documentation/phase1_documentation.md)
* **Objective:** Set up Google BigQuery, ingest raw synthetic user session data, and transform it into a granular event stream (`events` table) mimicking a real product analytics data model (e.g., Pendo/Amplitude).
* **Key Output:** `raw_sessions` and `events` tables in BigQuery, `01_feature_engineering_events.sql` script.

### [Phase 2: Exploratory Data Analysis (EDA)](documentation/phase2_documentation.md)
* **Objective:** Conduct thorough Exploratory Data Analysis on the raw and transformed datasets to understand data structure, quality, distributions, and initial relationships.
* **Key Output:** `exploratory_data_analysis.ipynb` notebook, initial hypotheses about user behavior.

### [Phase 3: Product Metrics Calculation & Analysis](documentation/phase3_documentation.md)
* **Objective:** Calculate, analyze, and visualize core product analytics metrics, including Daily/Weekly/Monthly Active Users (DAU/WAU/MAU), session engagement, conversion rates, and funnel performance.
* **Key Output:** `product_metrics_analysis.ipynb` notebook, foundational understanding of product health.

### [Phase 4: Deep Dive Analysis & Recommendations](documentation/phase4_documentation.md)
* **Objective:** Conduct a deep dive into the most significant user drop-off points identified in the funnel analysis, formulate hypotheses, and propose actionable, data-driven recommendations.
* **Key Output:** specific strategies for conversion optimization.

### [Phase 5: Predictive Modeling for Conversion](documentation/phase5_documentation.md)
* **Objective:** Develop and evaluate a machine learning model to predict purchase conversion for signed-in users, enabling proactive interventions.
* **Key Output:** `conversion_prediction_model.ipynb` notebook, a high-performing classification model, feature importances.

### [Phase 6: Conclusion, Limitations & Future Work](documentation/phase6_documentation.md)
* **Objective:** Summarize the entire project, highlight overall achievements and insights, acknowledge project limitations, and outline future work and continuous improvement opportunities.
* **Key Output:** Comprehensive project summary and strategic roadmap.

---

## 💡 Key Insights & Business Impact

Through this project, we uncovered critical insights and developed tools that can directly impact business outcomes:

* **Identified a Critical Funnel Bottleneck:** A significant **74% user drop-off** was pinpointed between the "Signed In" and "Coupon Applied" stages, representing a major lost conversion opportunity.
* **Actionable Recommendations:** Data-driven strategies were proposed to enhance coupon discoverability and streamline the application process, particularly for mobile users.
* **High-Accuracy Predictive Model:** A Random Forest Classifier achieved an **AUC score of 0.99** in predicting purchase conversion, allowing for proactive identification of high-propensity converters.
* **Feature Importance Revealed:** Key drivers of conversion were identified (e.g., `coupon_applied_flag`, `time_spent_seconds`, `pages_visited`), empowering targeted product and marketing efforts.
* **Strategic Decision Making:** The entire pipeline provides a framework for continuous monitoring, A/B testing, and data-informed decision-making to optimize the user journey and boost conversion rates.

---

## 🛠️ Technologies Used

* **Cloud Platform:** Google Cloud Platform (GCP)
    * **Data Warehouse:** Google BigQuery
* **Programming Language:** Python
* **Core Libraries:**
    * `pandas` (Data manipulation and analysis)
    * `numpy` (Numerical operations)
    * `matplotlib` (Static visualizations)
    * `seaborn` (Enhanced statistical visualizations)
    * `scikit-learn` (Machine learning for preprocessing, modeling, evaluation)
    * `google-cloud-bigquery` (BigQuery integration)
    * `db-dtypes` (BigQuery data type handling for Pandas)
* **Environment:** Jupyter Notebooks (`.ipynb`)
* **SQL:** For data transformation and querying in BigQuery

---

## 📂 Project Structure
product-analytics-project/  
├── documentation/  
│   ├── DATA_SETUP.md # Instructions for setting up BigQuery   
│   ├── phase1_documentation.md # Data Acquisition & Setup    
│   ├── phase2_documentation.md # Exploratory Data Analysis (EDA)  
│   ├── phase3_documentation.md # Product Metrics Calculation & Analysis  
│   ├── phase4_documentation.md # Deep Dive Analysis & Recommendations  
│   ├── phase5_documentation.md # Predictive Modeling for Conversion  
│   └── phase6_documentation.md # Conclusion, Limitations & Future Work  
├── notebooks/  
│   ├── exploratory_data_analysis.ipynb  
│   ├── product_metrics_analysis.ipynb  
│   └── conversion_prediction_model.ipynb  
├── sql/  
│   ├── 01_feature_engineering_events.sql  
│   ├── 02_product_metrics_dau_wau_mau.sql  
|   ├── 03_funnel_analysis_query.sql  
|   ├── 04_deep_dive_dropped_user_segmentation.sql  
|   ├── 02_product_metrics_dau_wau_mau.sql  
│   └── 05_deep_dive_dropped_users_by_device_traffic.sql  
├── screenshots/ # Directory for project screenshots   
│   ├── ...             
├── .gitignore # Specifies intentionally untracked files  
├── README.md # This file  
├── requirements.txt # Python dependencies  
└── ...  

---

## 🚀 Setup & Usage

To set up and run this project locally, follow these steps:

1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/SANJAY-KRISHNA-MV/Product-Analytics-Project.git](https://github.com/SANJAY-KRISHNA-MV/Product-Analytics-Project.git)
    cd product-analytics-project
    ```

2.  **Google Cloud Project Setup:**
    * Follow the instructions in `documentation/DATA_SETUP.md` to set up your Google Cloud Project, enable BigQuery API, and configure authentication.
    * Upload the `cleaned_speakers_data.csv` to a BigQuery table named `raw_sessions` as per `DATA_SETUP.md`.

3.  **Create BigQuery `events` Table:**
    * Execute the SQL script `sql/01_feature_engineering_events.sql` in your BigQuery console to transform `raw_sessions` into the `events` table. Ensure your dataset and table names match those in the SQL script or update accordingly.

4.  **Python Environment Setup:**
    ```bash
    python -m venv .venv
    source .venv\Scripts\activate
    pip install -r requirements.txt
    ```

5.  **Run Jupyter Notebooks:**
    ```bash
    jupyter notebook
    ```
    Navigate to the `notebooks/` directory and open the notebooks to follow the analysis pipeline.

---

## 📊 Visual Highlights

A `screenshots/` directory is included to provide visual context for various stages of the project, including:

* BigQuery table schemas (raw and engineered `events` tables).
* Key plots and visualizations from EDA and product metrics analysis (DAU/WAU/MAU trends, conversion rates by device, user funnel).
* Machine learning model evaluation plots (ROC curve, confusion matrix, feature importances).

---

## ✍️ Author

* **Sanjay Krishna MV** - [[LinkedIn](www.linkedin.com/in/sanjay-krishna-mv)] | [[GitHub](https://github.com/SANJAY-KRISHNA-MV)]

---