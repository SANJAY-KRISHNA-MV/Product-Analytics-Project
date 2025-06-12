-- SQL Script: 02_product_metrics_dau_wau_mau.sql
-- Description: Queries to calculate Daily, Weekly, and Monthly Active Users (DAU, WAU, MAU).
-- Author: Sanjay Krishna
-- Date: 2025-06-11

-- 1. Daily Active Users (DAU)
SELECT
    DATE(event_timestamp) AS activity_date,
    COUNT(DISTINCT user_id) AS dau
FROM
    `molten-goal-462509-b4.product_usage_data.events`
GROUP BY
    activity_date
ORDER BY
    activity_date;

-- 2. Weekly Active Users (WAU)
SELECT
    FORMAT_DATE('%Y-%W', event_timestamp) AS activity_week, -- ISO week number
    COUNT(DISTINCT user_id) AS wau
FROM
    `molten-goal-462509-b4.product_usage_data.events`
GROUP BY
    activity_week
ORDER BY
    activity_week;

-- 3. Monthly Active Users (MAU)
SELECT
    FORMAT_DATE('%Y-%m', event_timestamp) AS activity_month,
    COUNT(DISTINCT user_id) AS mau
FROM
    `molten-goal-462509-b4.product_usage_data.events`
GROUP BY
    activity_month
ORDER BY
    activity_month;