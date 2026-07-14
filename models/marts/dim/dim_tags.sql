WITH stg_tags_cte AS (
    SELECT * FROM {{ ref('stg_tags') }}
),
stg_genome_tags_cte AS (
    SELECT * FROM {{ ref('stg_genome_tags') }}
),
transformed AS (
    SELECT
        gt.tag_id,
        gt.tag as tag_name,
        COUNT(t.movie_id) AS total_tag_applications_count 
    FROM stg_genome_tags_cte gt
    LEFT JOIN stg_tags_cte t
    ON gt.tag = t.tag
    GROUP BY gt.tag_id, gt.tag
)
SELECT * FROM transformed