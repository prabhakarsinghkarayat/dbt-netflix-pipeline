-- Objective: Verify that the summary count of reviews in your movie performance fact table matches the exact number of rows in the staging ratings table for that movie. 
-- If they don't match, rows were accidentally lost during a join or aggregation step.

-- Checks if the aggregated review count in the fact table differs 
-- from the raw transactional record count.


WITH fact_counts AS (
    SELECT 
        movie_id,
        total_reviews AS fact_review_count
    FROM {{ ref('fct_movie_performance') }}
),

staging_counts AS (
    SELECT 
        movie_id,
        COUNT(*) AS staging_review_count
    FROM {{ ref('stg_ratings') }}
    GROUP BY movie_id
)

SELECT 
    f.movie_id,
    f.fact_review_count,
    s.staging_review_count
FROM fact_counts f
JOIN staging_counts s ON f.movie_id = s.movie_id
WHERE f.fact_review_count != s.staging_review_count