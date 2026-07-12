WITH raw_links AS (
    SELECT * FROM {{ source('netflix_source', 'RAW_LINKS') }}
),
renamed AS (
    SELECT
        CAST(movieId as INTEGER) as movie_id,
        CAST(imdbId as INTEGER) as imdb_id,
        CAST(tmdbId as INTEGER) as tmdb_id
    FROM raw_links
),
data_quality_deduplication AS (
    SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY movie_id ORDER BY tmdb_id desc nulls LAST) as rn
    FROM renamed
)
SELECT 
    movie_id,
    imdb_id,
    tmdb_id 
FROM data_quality_deduplication
WHERE rn < 2