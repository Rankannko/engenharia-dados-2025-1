{{ config(
    schema='staging',
    alias='stg_pagamentos'
) }}

with source as (
    select 
        id AS id_pagamento,
        order_id AS id_pedido,
        payment_method AS metodo_pagamento,
        CAST(amount AS FLOAT) / 100 AS valor_pagamento
    from {{ ref('raw_pagamentos') }}
),

renamed as (
    select 
        id_pagamento,
        id_pedido,
        metodo_pagamento,
        valor_pagamento
    from source
)

select * from renamed