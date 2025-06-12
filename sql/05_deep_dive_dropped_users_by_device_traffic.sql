-- SQL Script: 05_deep_dive_dropped_users_by_device_traffic.sql
-- Description: Analyzes the device type and traffic source breakdown for users who
--              signed in but neither applied a coupon nor completed a purchase.
-- Author: Sanjay Krishna
-- Date: 2025-06-11

-- Breakdown by Device Type
SELECT
    e.event_property_device_type,
    COUNT(DISTINCT e.user_id) AS distinct_users_dropped_no_coupon
FROM
    `molten-goal-462509-b4.product_usage_data.events` AS e
WHERE
    e.event_name = 'session_end' -- We look at their sessions to get device info
    AND EXISTS (
        SELECT 1
        FROM `molten-goal-462509-b4.product_usage_data.events` AS signed_in_event
        WHERE signed_in_event.user_id = e.user_id
          AND signed_in_event.event_name = 'signed_in_event'
    ) -- User signed in
    AND NOT EXISTS (
        SELECT 1
        FROM `molten-goal-462509-b4.product_usage_data.events` AS coupon_event
        WHERE coupon_event.user_id = e.user_id
          AND coupon_event.event_name = 'coupon_applied'
    ) -- User did NOT apply a coupon
    AND NOT EXISTS (
        SELECT 1
        FROM `molten-goal-462509-b4.product_usage_data.events` AS purchase_event
        WHERE purchase_event.user_id = e.user_id
          AND purchase_event.event_name = 'purchase_completed'
    ) -- User did NOT purchase
GROUP BY
    e.event_property_device_type
ORDER BY
    distinct_users_dropped_no_coupon DESC;

-- Breakdown by Traffic Source
SELECT
    e.event_property_traffic_source,
    COUNT(DISTINCT e.user_id) AS distinct_users_dropped_no_coupon
FROM
    `molten-goal-462509-b4.product_usage_data.events` AS e
WHERE
    e.event_name = 'session_end' -- We look at their sessions to get traffic source
    AND EXISTS (
        SELECT 1
        FROM `molten-goal-462509-b4.product_usage_data.events` AS signed_in_event
        WHERE signed_in_event.user_id = e.user_id
          AND signed_in_event.event_name = 'signed_in_event'
    ) -- User signed in
    AND NOT EXISTS (
        SELECT 1
        FROM `molten-goal-462509-b4.product_usage_data.events` AS coupon_event
        WHERE coupon_event.user_id = e.user_id
          AND coupon_event.event_name = 'coupon_applied'
    ) -- User did NOT apply a coupon
    AND NOT EXISTS (
        SELECT 1
        FROM `molten-goal-462509-b4.product_usage_data.events` AS purchase_event
        WHERE purchase_event.user_id = e.user_id
          AND purchase_event.event_name = 'purchase_completed'
    ) -- User did NOT purchase
GROUP BY
    e.event_property_traffic_source
ORDER BY
    distinct_users_dropped_no_coupon DESC;