-- Business logic check: lowest_rating_received must always be less than or equal to highest_rating_received.
-- Returning rows here means our aggregation logic or raw data is corrupted.
SELECT
    movie_id,
    lowest_rating_received,
    highest_rating_received
FROM {{ ref('fct_movie_performance') }}
WHERE lowest_rating_received > highest_rating_received