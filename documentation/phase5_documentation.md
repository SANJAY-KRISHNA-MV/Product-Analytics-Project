# Phase 5: Predictive Modeling for Conversion Documentation

**Objective:** To develop and evaluate a machine learning model capable of predicting purchase conversion for signed-in users. This phase leverages the cleaned and transformed `events` data to build a proactive analytical tool that can inform targeted interventions and product optimization strategies.

### I. Problem Definition & Approach

Building upon the funnel analysis in Phase 3/4, which identified a major drop-off in the conversion path, this phase aims to predict which signed-in sessions are likely to result in a purchase. This is framed as a binary classification problem: predicting `is_purchased` (1 for conversion, 0 for no conversion).

* **Target Audience:** Signed-in users (sessions where `user_is_signed_in_session` is `True`).

* **Modeling Unit:** Each row in our modeling dataset represents a unique user session.

* **Approach:** Supervised learning using a classification algorithm.

### II. Data Preparation for Modeling

Data for the predictive model was prepared directly within the `notebooks/conversion_prediction_model.ipynb`, by replicating the `df_events` creation logic, ensuring the notebook is self-contained.

1.  **Target Variable Creation:**

    * A new target variable, `is_purchased`, was engineered. It is `1` if a `purchase_completed` event occurred within a given session, and `0` otherwise.

    * The conversion rate within the modeling dataset (signed-in sessions) was approximately `X%` (e.g., 15-20%), indicating a class imbalance that needed to be addressed.
        *(**ACTION:** Replace `X%` with the actual conversion rate you observed in your `y.mean()` output from the notebook.)*

2.  **Feature Selection:**

    * Relevant features were selected from the `df_events` (aggregated to session level) that could influence purchase behavior, excluding identifiers, timestamps, and direct leakage features.

    * Selected features included: `event_property_time_spent_seconds`, `event_property_pages_visited`, `event_property_device_type`, `event_property_traffic_source`, `user_demographic_age`, `user_demographic_age_group`, `user_demographic_gender`, `event_property_coupon_applied_flag`, and `event_property_variant_group`.

3.  **Data Preprocessing Pipeline:**

    * A `scikit-learn` `Pipeline` with a `ColumnTransformer` was used for robust preprocessing.

    * **Numerical Features:** Scaled using `StandardScaler` to normalize their ranges.

    * **Categorical Features:** Converted into numerical format using `OneHotEncoder` (`handle_unknown='ignore'`).

    * This pipeline ensures consistent transformation of both training and test data.

4.  **Train-Test Split:**

    * The prepared dataset was split into training (80%) and testing (20%) sets using `train_test_split`.

    * `stratify=y` was applied to ensure the proportion of converting sessions was maintained across both sets, crucial for reliable evaluation on imbalanced data.

### III. Model Selection & Training

A **RandomForestClassifier** was selected as the primary model due to its robustness, ability to handle various data types (after preprocessing), and its capacity to provide feature importances.

* **Configuration:** `n_estimators=100` (100 decision trees) and `random_state=42` for reproducibility.

* **Class Imbalance Handling:** `class_weight='balanced'` was used to automatically adjust weights inversely proportional to class frequencies, preventing the model from being biased towards the majority non-converting class.

* The model was trained on the preprocessed `X_train` and `y_train` data within the `Pipeline`.

### IV. Model Evaluation

The model's performance was rigorously evaluated on the unseen `X_test` data using several key metrics:

1.  **AUC Score:** The Random Forest Classifier achieved an exceptional **AUC score of 0.99**. This indicates outstanding discriminatory power, meaning the model is highly effective at ranking positive instances (purchases) higher than negative instances (non-purchases). The ROC curve confirms this near-perfect separation.

    ![ROC Curve plot](../screenshots/ROC%20curve%20plot.png)

2.  **Classification Report:**

    * **Precision (Purchase Class):** *(0.99)* - Indicates a very low rate of false positives when predicting a purchase.

    * **Recall (Purchase Class):** *(0.98)* - Shows the model correctly identifies a very high percentage of actual purchasers.

    * **F1-Score (Purchase Class):** *(0.98)* - A strong combined measure of precision and recall for the positive class.

3.  **Confusion Matrix:** The confusion matrix visually confirmed the high accuracy, with a very small number of false positives and false negatives, especially relative to the overall dataset size.

    ![Confusion Matrix](../screenshots/Confusion%20Matrix.png)

### V. Feature Importance & Business Implications

The feature importance analysis (derived from the Random Forest model) identified the most significant drivers of purchase conversion:

* **Top Predictors:** The feature importance analysis clearly identified the most significant drivers of purchase conversion:
    * `event_property_coupon_applied_flag` (importance: **0.8785**): This is by far the most dominant predictor, indicating a very strong correlation between applying a coupon and completing a purchase. This validates the earlier funnel analysis insights and suggests that coupon usage is a critical signal of high purchase intent.
    * `event_property_time_spent_seconds` (importance: **0.0357**): Higher session durations are a significant positive indicator of conversion, showing that engaged users are more likely to complete a purchase.
    * `user_demographic_age` (importance: **0.0293**): User's age also plays a notable role, suggesting that certain age groups might have a higher propensity to convert.
    * `event_property_pages_visited` (importance: **0.0185**): Users who visit more pages during a session are more likely to convert, reinforcing the importance of depth of engagement.
    * `event_property_variant_group_Cold` (importance: **0.0040**): Being in the 'Cold' variant group shows a minor but measurable impact on conversion likelihood, possibly indicating differences in user experience or targeting within that group.
    * `event_property_traffic_source_Organic` (importance: **0.0029**): Organic traffic, while a major source of users, has a smaller direct predictive importance on *whether* a signed-in user converts compared to direct behavioral signals like coupon application.

* **Business Implications:** The model's insights allow for:

    1.  **Proactive Targeting:** Identify high-propensity users in real-time to offer personalized incentives or streamline their checkout experience.

    2.  **Early Intervention:** Detect users at risk of not converting and deploy targeted re-engagement strategies (e.g., nudges, customer service outreach).

    3.  **Product Feature Prioritization:** Focus product development efforts on enhancing elements correlated with high importance (e.g., further optimizing coupon application if it's a top feature).

    4.  **Optimized Resource Allocation:** Direct marketing and sales efforts more efficiently by prioritizing segments with higher predicted conversion rates.

### VI. Limitations and Future Work

While the model shows exceptional performance, it's essential to consider context and future enhancements:

* **Synthetic Data Generalizability:** The high AUC may reflect the clear patterns in the synthetic dataset. Real-world data often introduces more noise, complexities, and unexpected behaviors.

* **Feature Engineering Depth:** Further advanced feature engineering (e.g., recency, frequency of activity, sequence of events, time-to-event features) could be explored to potentially improve robustness or capture more nuanced behaviors for real-world scenarios.

* **Model Interpretability:** While Random Forest provides feature importance, exploring techniques like SHAP (SHapley Additive exPlanations) or LIME (Local Interpretable Model-agnostic Explanations) could offer more granular, instance-level explanations for individual predictions.

* **Model Deployment & Monitoring:** For a production system, the model would need to be deployed (e.g., as an API endpoint) and continuously monitored for performance degradation (data drift, concept drift) to ensure ongoing accuracy.

* **A/B Testing Integration:** Model predictions should be validated through A/B tests to measure their causal impact on real users and business outcomes.