{{ config(
    schema='staging',
    alias='stg_clientes'
) }}

with source as (
    select 
        id as id_cliente,
        concat(first_name, ' ', last_name) as nome_completo
    from {{ ref('raw_clientes') }}
),

renamed as (
    select
        id_cliente,
        nome_completo
    from source
)

select * from renamed