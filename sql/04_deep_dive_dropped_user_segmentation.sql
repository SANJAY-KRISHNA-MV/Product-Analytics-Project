-- SQL Script: 04_deep_dive_dropped_user_segmentation.sql
-- Description: Segments signed-in users into key behavioral groups after sign-in,
--              focusing on coupon application and purchase completion.
-- Author: Sanjay Krishna
-- Date: 2025-06-11

SELECT
    COUNT(DISTINCT user_id) AS total_signed_in_users,
    COUNT(DISTINCT CASE WHEN has_coupon_applied = 1 THEN user_id END) AS signed_in_and_coupon_applied, -- CORRECTED HERE
    COUNT(DISTINCT CASE WHEN has_purchase_completed = 1 AND has_coupon_applied = 0 THEN user_id END) AS signed_in_purchased_no_coupon, -- CORRECTED HERE
    COUNT(DISTINCT CASE WHEN has_coupon_applied = 0 AND has_purchase_completed = 0 THEN user_id END) AS signed_in_no_coupon_no_purchase -- CORRECTED HERE
FROM (
    SELECT
        t1.user_id,
        MAX(CASE WHEN t2.event_name = 'signed_in_event' THEN 1 ELSE 0 END) AS has_signed_in,
        MAX(CASE WHEN t2.event_name = 'coupon_applied' THEN 1 ELSE 0 END) AS has_coupon_applied,
        MAX(CASE WHEN t2.event_name = 'purchase_completed' THEN 1 ELSE 0 END) AS has_purchase_completed
    FROM
        `molten-goal-462509-b4.product_usage_data.events` AS t1
    JOIN
        `molten-goal-462509-b4.product_usage_data.events` AS t2
    ON
        t1.user_id = t2.user_id
    WHERE
        t1.event_name = 'signed_in_event' -- Start with users who signed in
    GROUP BY
        t1.user_id
)
WHERE
    has_signed_in = 1; -- Ensure we only count users who actually signed in