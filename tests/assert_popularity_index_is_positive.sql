-- This test checks if any movie has a popularity index below 0.00. 
-- If it returns any rows, the test fails.
SELECT
    movie_id,
    popularity_index
FROM {{ ref('fct_movie_performance') }}
WHERE popularity_index < 0.00