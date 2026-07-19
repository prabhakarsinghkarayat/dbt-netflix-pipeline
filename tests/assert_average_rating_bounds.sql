-- Objective: Double-check that no unexpected database math anomalies allowed the calculated average_rating to float outside the true system bounds of a standard movie review (0.00 to 5.00).

-- Ensures the final computed average rating stays perfectly inside the strict 0 to 5 bounds.
SELECT 
    movie_id,
    average_rating
FROM {{ ref('fct_movie_performance') }}
WHERE average_rating < 0.00 OR average_rating > 5.00