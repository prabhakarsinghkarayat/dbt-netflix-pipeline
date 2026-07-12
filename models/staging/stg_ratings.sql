WITH raw_ratings AS(
    SELECT * FROM {{ source('netflix_source', 'RAW_RATINGS') }}
),
renamed AS (
    SELECT
        CAST(userId as INTEGER) as user_id,
        CAST(movieId as INTEGER) as movie_id,
        CAST(RATING as FLOAT) as rating,
        TO_TIMESTAMP_NTZ(TIMESTAMP) as rated_at
    FROM raw_ratings
),
date_derivations AS (
    SELECT 
        *,
        DATE(rated_at) as rated_date,
        HOUR(rated_at) as rating_hour,
        CASE
            WHEN DAYNAME(rated_at) IN ('Sat', 'Sun') THEN TRUE
            ELSE FALSE
        END AS is_weekend_rating
    FROM renamed
)
Select * FROM date_derivations
