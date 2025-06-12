-- SQL Script: 01_feature_engineering_events.sql
-- Description: Transforms raw session and event data into a unified 'events' table
--              with derived event names, session properties, and user-level flags.
-- Author: Sanjay Krishna
-- Date: 2025-06-11

CREATE OR REPLACE TABLE `molten-goal-462509-b4.product_usage_data.events` AS
SELECT
    GENERATE_UUID() AS event_id, -- Unique ID for each event
    T2.user_id,
    T2.session_id,
    -- Corrected event_timestamp generation block to ensure INT64 for INTERVAL
    TIMESTAMP_ADD(
        TIMESTAMP_ADD(
            TIMESTAMP('2024-01-01 00:00:00 UTC'),
            INTERVAL CAST(MOD(FARM_FINGERPRINT(T2.session_id), (365 * 24 * 60 * 60)) AS INT64) SECOND
        ),
        INTERVAL
        CAST(
            CASE
                WHEN event_type = 'session_start' THEN 0
                WHEN event_type = 'session_end' THEN T2.time_spent * 60
                WHEN event_type = 'purchase_completed' THEN T2.time_spent * 60 * 0.9
                WHEN event_type = 'signup_completed' THEN T2.time_spent * 60 * 0.5
                WHEN event_type = 'coupon_applied' THEN T2.time_spent * 60 * 0.3
                WHEN event_type = 'signed_in_event' THEN T2.time_spent * 60 * 0.1
                WHEN event_type = 'bounced_session_event' THEN T2.time_spent * 60 * 0.05
                ELSE 0
            END AS INT64 -- CHANGED FROM FLOAT64 TO INT64
        ) SECOND
    ) AS event_timestamp,

    -- THIS IS THE CORRECTED CASE STATEMENT WHERE 'event_name' IS DEFINED
    CASE
        -- Prioritize coupon_applied if it happened, as it's a specific action before purchase/signup
        WHEN T2.coupon_applied = 'Yes' THEN 'coupon_applied' -- MOVED TO HIGHER PRIORITY
        WHEN event_type = 'session_start' THEN 'session_start'
        WHEN event_type = 'session_end' THEN 'session_end'
        -- Now conversions
        WHEN T2.conversion_flag = 1 AND T2.conversion_type = 'Purchase' THEN 'purchase_completed'
        WHEN T2.conversion_flag = 1 AND T2.conversion_type = 'Signup' THEN 'signup_completed'
        -- Other events
        WHEN T2.sign_in = 'Email' THEN 'signed_in_event'
        WHEN T2.bounce_flag = 1 THEN 'bounced_session_event'
        ELSE 'other_event' -- Catch-all for any unhandled events
    END AS event_name,

    -- User properties
    T2.name AS user_name,
    T2.demographic_age AS user_demographic_age,
    T2.demographic_age_group AS user_demographic_age_group,
    T2.demographic_gender AS user_demographic_gender,
    T2.email AS user_email,
    T2.location AS user_location,
    T2.country AS user_country,
    (T2.sign_in = 'Email') AS user_is_signed_in_session, -- BOOLEAN
    (T2.bounce_flag = 1) AS user_is_bounced_session, -- BOOLEAN (if session bounced)


    -- Event properties (conditional or direct)
    T2.device_type AS event_property_device_type,
    T2.traffic_source AS event_property_traffic_source,
    T2.pages_visited AS event_property_pages_visited,
    T2.revenue AS event_property_revenue,
    T2.product_purchased AS event_property_product_purchased,
    (T2.coupon_applied != 'ND') AS event_property_coupon_applied_flag, -- BOOLEAN if coupon was applied
    T2.time_spent * 60 AS event_property_time_spent_seconds -- Convert minutes to seconds

FROM
    `molten-goal-462509-b4.product_usage_data.raw_sessions` AS T2
CROSS JOIN
    UNNEST(['session_start', 'session_end', 'conversion_event', 'coupon_event', 'signin_event', 'bounce_event']) AS event_type
WHERE
    -- Filter for actual 'conversion_event' when conversion_flag is 1
    (event_type = 'conversion_event' AND T2.conversion_flag = 1) OR
    -- Filter for actual 'coupon_event' when coupon was applied
    (event_type = 'coupon_event' AND T2.coupon_applied = 'Yes') OR
    -- Filter for actual 'signin_event' when user signed in via email
    (event_type = 'signin_event' AND T2.sign_in = 'Email') OR
    -- Filter for actual 'bounce_event' when bounce flag is 1
    (event_type = 'bounce_event' AND T2.bounce_flag = 1) OR
    -- Always include session start and end for all sessions
    (event_type IN ('session_start', 'session_end'))