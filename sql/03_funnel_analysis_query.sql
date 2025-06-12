-- SQL Script: 03_funnel_analysis_query.sql
-- Description: Calculates user counts at each step of the product funnel:
--              Session Start -> Signed In -> Coupon Applied -> Purchase Completed.
-- Author: Sanjay Krishna
-- Date: 2025-06-11

SELECT
    'Session Start' AS step,
    COUNT(DISTINCT user_id) AS user_count
FROM
    `molten-goal-462509-b4.product_usage_data.events`
WHERE
    event_name = 'session_start'
UNION ALL
SELECT
    'Signed In' AS step,
    COUNT(DISTINCT user_id) AS user_count
FROM
    `molten-goal-462509-b4.product_usage_data.events`
WHERE
    event_name = 'signed_in_event'
UNION ALL
SELECT
    'Coupon Applied' AS step,
    COUNT(DISTINCT user_id) AS user_count
FROM
    `molten-goal-462509-b4.product_usage_data.events`
WHERE
    event_name = 'coupon_applied'
UNION ALL
SELECT
    'Purchase Completed' AS step,
    COUNT(DISTINCT user_id) AS user_count
FROM
    `molten-goal-462509-b4.product_usage_data.events`
WHERE
    event_name = 'purchase_completed'
ORDER BY
    user_count DESC; -- Order to show funnel progression.