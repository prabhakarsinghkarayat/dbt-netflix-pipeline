WITH stg_ratings_cte AS (
    SELECT * FROM {{ ref('stg_ratings') }}
),
transformed_cte AS (
    SELECT
        user_id,
        COUNT(DISTINCT movie_id) AS total_movies_rated,
        ROUND(AVG(rating), 2) AS average_rating_given,
        MIN(rated_at) AS first_activty_at,
        MAX(rated_at) AS last_activity_at
    FROM stg_ratings_cte
    GROUP BY user_id
)
SELECT
    user_id,
    total_movies_rated,
    average_rating_given,
    first_activty_at,
    last_activity_at,
    CASE
        WHEN average_rating_given >= 4.0 THEN 'Generous'
        WHEN average_rating_given <= 2.5 THEN 'Critical'
        ELSE 'Balanced'
    END AS user_sentiment_tier
FROM transformed_cte