-- Objective: Validate time-based logic in your customer profile dimension (dim_users). 
-- A user's very first platform interaction date can never occur after their last recorded interaction date.

-- Enforces that first activity timestamps are chronologically earlier than or equal to last activity timestamps.
-- Any returned rows indicate a corruption in the date tracking logic.
SELECT 
    user_id,
    first_activty_at,
    last_activity_at
FROM {{ ref('dim_users') }}
WHERE first_activty_at > last_activity_at