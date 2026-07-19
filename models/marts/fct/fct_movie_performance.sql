WITH stg_movies_cte AS (
    SELECT * FROM {{ ref('stg_movies') }}
),
stg_ratings_cte AS (
    SELECT * FROM {{ ref('stg_ratings') }}
),
ratings_aggregated AS (
    SELECT
        movie_id,
        COUNT(rating) AS total_reviews,
        Round(AVG(rating), 2) AS average_rating,
        MIN(rating) AS lowest_rating_received,
        MAX(rating) AS highest_rating_received,
        COUNT(CASE WHEN rating = 5.0 THEN 1 END) AS total_five_star_ratings,
        COUNT(CASE WHEN rating <= 2.0 THEN 1 END) AS total_low_tier_ratings 
    FROM stg_ratings_cte 
    GROUP BY movie_id
),
transformed_cte AS (
    SELECT
        m.movie_id,
        m.movie_title,
        m.release_year,

        COALESCE(r.total_reviews, 0) AS total_reviews,
        COALESCE(r.average_rating, 0.00) AS average_rating,
        COALESCE(r.lowest_rating_received, 0.00) AS lowest_rating_received,
        COALESCE(r.highest_rating_received, 0) AS highest_rating_received,
        COALESCE(r.total_five_star_ratings, 0) AS total_five_star_ratings,
        COALESCE(r.total_low_tier_ratings, 0) AS total_low_tier_ratings 
    FROM stg_movies_cte m
    LEFT JOIN ratings_aggregated r
    ON m.movie_id = r.movie_id
)
SELECT
    movie_id,
    movie_title,
    release_year,
    total_reviews,
    average_rating,
    lowest_rating_received,
    highest_rating_received,
    total_five_star_ratings,
    total_low_tier_ratings,
    ROUND(
        (average_rating * 0.6) + (LOG(10, total_reviews + 1) * 0.4), 
        2
    ) AS popularity_index
FROM transformed_cte