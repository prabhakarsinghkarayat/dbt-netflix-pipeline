WITH stg_movies_cte AS (
    SELECT * FROM {{ ref('stg_movies')}}
),
stg_links_cte AS (
    SELECT * FROM {{ ref('stg_links') }}
),
transformed_cte AS (
    SELECT
        m.movie_id,
        m.release_year,
        l.imdb_id,
        l.tmdb_id,
        SPLIT(m.raw_genres, '|') AS raw_genres,
        CASE
            WHEN m.release_year < 1980 THEN 'Classic'
            WHEN m.release_year >= 1980 AND m.release_year <= 1999 THEN 'Vintage Modern'
            WHEN m.release_year >= 2000 AND m.release_year <= 2015 THEN 'Modern'
            WHEN m.release_year > 2015 THEN 'New Release'
        END AS movie_era,

        IFF(
            CONTAINS(LOWER(m.raw_genres), 'action') or CONTAINS(LOWER(m.raw_genres), 'adventure'),
            TRUE,
            FALSE
        ) AS is_action_packed
    FROM stg_movies_cte m
    LEFT JOIN stg_links_cte l
    ON m.movie_id = l.movie_id
)
SELECT * FROM transformed_cte