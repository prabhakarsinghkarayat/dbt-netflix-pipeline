WITH raw_movies AS (
    SELECT * FROM {{ source('netflix_source', 'RAW_MOVIES')}}
)
SELECT
    CAST(movieId as INTEGER) as movie_id,
    TRIM(title) as movie_title,
    COALESCE(CAST(REGEXP_SUBSTR(title, '\\((\\d{4})\\)', 1, 1, 'e') AS INTEGER), 1900) as release_year,
    genres as raw_genres
FROM raw_movies