{% snapshot snp_customer %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_id',
        strategy='check',
        check_cols=['territory_id', 'store_id', 'person_id'],
    )
}}

select * from {{ ref('stg_sales__customer') }}

{% endsnapshot %}