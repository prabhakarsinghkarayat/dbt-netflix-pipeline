-- 1. Snapshot for Raw Movies Data
{% snapshot snapshot_raw_movies %}

{{
    config(
      target_database=target.database,
      target_schema='snapshots',
      unique_key='movie_id',
      strategy='check',
      check_cols=['movie_title', 'genres']
    )
}}

SELECT 
    movie_id,
    movie_title,
    genres
FROM {{ source('netflix_source', 'RAW_MOVIES') }}

{% endsnapshot %}


-- 2. Snapshot for Raw Tags Data (Tracks if users modify/remove metadata tags)
{% snapshot snapshot_raw_tags %}

{{
    config(
      target_database=target.database,
      target_schema='snapshots',
      unique_key='movie_id || \'-\' || user_id || \'-\' || tag',
      strategy='check',
      check_cols=['tag']
    )
}}

SELECT 
    movie_id,
    user_id,
    tag,
    timestamp
FROM {{ source('netflix_source', 'RAW_TAGS') }}

{% endsnapshot %}


-- 3. Snapshot for Raw Links Data (Tracks internal system ID mappings)
{% snapshot snapshot_raw_links %}

{{
    config(
      target_database=target.database,
      target_schema='snapshots',
      unique_key='movie_id',
      strategy='check',
      check_cols=['imdb_id', 'tmdb_id']
    )
}}

SELECT 
    movie_id,
    imdb_id,
    tmdb_id
FROM {{ source('netflix_source', 'RAW_LINKS') }}

{% endsnapshot %}