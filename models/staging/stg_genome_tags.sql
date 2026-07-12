WITH raw_genome_tags AS (
    SELECT * FROM {{ source('netflix_source', 'RAW_GENOME_TAGS') }}
),
renamed AS(
    SELECT
        CAST(tagId as INTEGER) as tag_id,
        TRIM(LOWER(tag)) as tag_text,
    FROM raw_genome_tags
)
SELECT
    tag_id,
    CASE
        WHEN  tag_text = '' THEN NULL
        ELSE tag_text
    END AS tag
FROM renamed