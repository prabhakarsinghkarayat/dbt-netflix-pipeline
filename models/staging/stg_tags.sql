WITH raw_tags AS (
    SELECT * FROM {{ source('netflix_source', 'RAW_TAGS') }}
),
renamed AS (
    SELECT
        CAST(userId as INTEGER) as user_id,
        CAST(movieId as INTEGER) as movie_id,
        TRIM(LOWER(tag)) as cleaned_tag,
        TO_TIMESTAMP_NTZ(TIMESTAMP) as tag_timestamp 
    FROM raw_tags
),
data_quality_enforcement AS (
    SELECT
        user_id,
        movie_id,
        tag_timestamp,
        CASE
            WHEN cleaned_tag IS NULL THEN NULL
            WHEN cleaned_tag IN ('', 'none', 'null', 'na', 'n/a') THEN NULL
            ELSE cleaned_tag
        END AS tag
    FROM renamed
)
SELECT * FROM data_quality_enforcement

