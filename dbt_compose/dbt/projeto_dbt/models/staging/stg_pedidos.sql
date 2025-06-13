{{ config(
    schema='staging',
    alias='stg_pedidos'
) }}

with source as (
    select 
        CAST(id AS INT) AS id_pedido,
        CAST(user_id AS INT) AS id_cliente,
        CAST(order_date AS TIMESTAMP) AS data_pedido,
        status
    from {{ ref('raw_pedidos') }}
),

renamed as (
    select 
        id_pedido,
        id_cliente,
        data_pedido,
        status
    from source
)

select * from renamed

{% if is_incremental() %}
WHERE
    data_pedido > (SELECT MAX(data_pedido) FROM {{ this }})
{% endif %}