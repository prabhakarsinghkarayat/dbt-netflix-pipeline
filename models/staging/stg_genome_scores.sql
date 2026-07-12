WITH raw_genome_scores AS (
    SELECT * FROM {{ source('netflix_source', 'RAW_GENOME_SCORES') }}
),
renamed AS (
    SELECT
        CAST(movieId as INTEGER) as movie_id,
        CAST(tagId as INTEGER) as tag_id,
        CAST(relevance as DECIMAL(5,4)) as relevance 
    FROM raw_genome_scores
),
data_integrity_guard AS (
    SELECT
        movie_id,
        tag_id,
        relevance
    FROM renamed
    WHERE relevance BETWEEN 0.0 AND 1.0
)
SELECT * FROM data_integrity_guard