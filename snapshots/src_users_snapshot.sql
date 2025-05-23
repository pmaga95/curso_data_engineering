{% snapshot src_users_snapshot %}
-- since we have already have a timestamp field we're gonna use that
{{
    config(
      target_schema='snapshots',
      unique_key='user_id',
      strategy='timestamp',
      updated_at='updated_at',
      hard_deletes='invalidate',
    )
}}


select * from {{ source('sql_server_dbo', 'users') }}

{% endsnapshot %}