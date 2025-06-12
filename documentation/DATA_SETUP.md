# Data Setup Guide: From Raw CSV to BigQuery Events Table

This guide provides precise, step-by-step instructions to set up the necessary data in Google BigQuery, starting from the raw `cleaned_speakers_data.csv` file. Follow these steps to prepare your environment before running any of the analytical SQL queries in the `sql/` directory.

---

### Prerequisites:

* **Google Cloud Platform (GCP) Account:** You need an active GCP account with billing enabled.
* **BigQuery API Enabled:** Ensure the BigQuery API is enabled in your GCP project.
* **`cleaned_speakers_data.csv` File:** Download this raw data file from its source (e.g., Kaggle, your local `data/` folder).

---

### Step 1: Create a BigQuery Dataset

First, you'll create a new dataset within your Google BigQuery project to house your tables.

1.  **Open BigQuery Console:**
    * Go to the Google Cloud Console: `console.cloud.google.com`
    * In the left-hand navigation menu, search for or click on **"BigQuery"**. This will take you to the BigQuery Studio.

2.  **Locate Your Project:**
    * In the left-hand Explorer panel, you should see your GCP project ID (e.g., `molten-goal-462509-b4`).

3.  **Create New Dataset:**
    * Hover over your **Project ID** in the left Explorer panel.
    * Click on the **three vertical dots (⋮)** that appear next to your project ID.
    * Select **"Create dataset"** from the dropdown menu.

4.  **Configure Dataset Settings:**
    * **Dataset ID:** Enter a clear and descriptive ID. We recommend `product_usage_data`.
    * **Data location:** Choose a region that is geographically close to you or your primary users (e.g., `US (multiple regions in United States)` or `Asia (multiple regions in Asia)`). Consistency with where you'd typically query from helps with latency.
    * Leave other settings as default for this project.
    * Click **"CREATE DATASET"**.

    *You should now see `product_usage_data` listed under your project in the left-hand Explorer panel.*

---

### Step 2: Upload `cleaned_speakers_data.csv` to a New BigQuery Table (`raw_sessions`)

Now, you will upload your raw CSV data into a new table within the `product_usage_data` dataset. This table will serve as your `raw_sessions` table.

1.  **Select Your Dataset:**
    * In the left-hand Explorer panel, click directly on the **`product_usage_data`** dataset name you just created.
    * The main window on the right will now show details about this dataset, along with a `+ CREATE TABLE` button.

2.  **Initiate Table Creation:**
    * Click the prominent blue **`+ CREATE TABLE`** button.

3.  **Configure Table Creation - Source:**
    * **Create table from:** Select **"Upload"**.
    * **Browse:** Click this button and navigate to your `cleaned_speakers_data.csv` file on your local computer. Select the file.
    * **File format:** Ensure this is set to **"CSV"**.

4.  **Configure Table Creation - Destination:**
    * **Project name:** This should be pre-filled with your project ID (e.g., `molten-goal-462509-b4`).
    * **Dataset name:** This should be pre-filled with your dataset ID (`product_usage_data`).
    * **Table name:** Enter `raw_sessions`. This will be the name of your new table containing the raw CSV data.

5.  **Configure Table Creation - Schema:**
    * **Schema:** Select **"Auto-detect schema"**. BigQuery is highly effective at inferring column names and data types from CSV files.
    * *(Optional but recommended):* After auto-detect, quickly scan the schema. Pay attention to the inferred types for `timestamp` (should be `INT64`), `time_spent` (should be `INT64`), `revenue` (should be `FLOAT64` or `NUMERIC`), and flags like `conversion_flag`, `bounce_flag` (should be `INT64`). If anything looks incorrect, you can manually adjust it here, but auto-detect is usually reliable for this CSV.

6.  **Configure Table Creation - Advanced options:**
    * Expand the "Advanced options" section.
    * **Header rows to skip:** Enter `1` (because your `cleaned_speakers_data.csv` file has a header row that should not be imported as data).
    * **Field delimiter:** Ensure this is set to **"Comma (,)"**.

7.  **Create the Table:**
    * Review all your settings.
    * Click the blue **"CREATE TABLE"** button at the bottom of the page.

    *The upload process will begin. You'll see a job running status at the bottom of the screen, and once it's complete, your `raw_sessions` table will appear under your `product_usage_data` dataset in the left Explorer panel. You can click on it and go to the "Preview" tab to verify the data was loaded correctly.*

---

### Step 3: Create the `events` Table using `03_feature_engineering_events.sql`

With your `raw_sessions` table now available, you can create the main `events` table by executing the feature engineering SQL script provided in this repository.

1.  **Locate the SQL Script:**
    * Find the file `01_feature_engineering_events.sql` within the `sql/` directory of your cloned GitHub repository.

2.  **Open New Query Tab in BigQuery:**
    * In the BigQuery console, click the **`+`** icon next to the "Untitled query" tab (or click "ADD NEW TAB") to open a fresh query editor.

3.  **Copy and Paste the SQL:**
    * Open `01_feature_engineering_events.sql` in a text editor (like VS Code, Sublime Text, Notepad++).
    * **Copy the entire content** of the SQL file.
    * **Paste it into the BigQuery query editor** tab you just opened.

4.  **Update Project and Dataset IDs:**
    * **CRUCIAL STEP:** In the pasted SQL code, you will see references to the placeholder `molten-goal-462509-b4.product_usage_data`.
    * **You MUST replace `molten-goal-462509-b4` with *your* actual GCP Project ID.**
    * **You MUST replace `product_usage_data` with *your* actual Dataset ID** (which should be `product_usage_data` if you followed Step 1).
    * Use the "Find and Replace" feature in the BigQuery editor (Ctrl+H or Cmd+H) for efficiency.

5.  **Execute the Query:**
    * After replacing the project and dataset IDs, click the blue **"RUN"** button.

    *This script will create or replace the `events` table in your `product_usage_data` dataset. This table is the cleaned, transformed, and derived events log that will be used for all subsequent product analytics. The process may take a few moments depending on the size of the data.*

---

### Next Steps:

Once the `events` table is successfully created, you can proceed to execute the remaining SQL scripts in the `sql/` folder (e.g., `02_product_metrics_dau_wau_mau.sql`, `03_funnel_analysis_query.sql`, etc.) against this new `events` table to perform all the product analytics calculations and generate insights.