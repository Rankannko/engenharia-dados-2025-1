{% set metodos_pagamento = ['credit_card', 'coupon', 'bank_transfer', 'gift_card'] %}

with pedidos as (
    select id_pedido, id_cliente, data_pedido, status 
    from {{ ref('stg_pedidos') }}
),

pagamentos as (
    select id_pedido, metodo_pagamento, valor_pagamento 
    from {{ ref('stg_pagamentos') }}
),

pagamentos_pedidos as (
    select
        id_pedido,

        {% for metodo_pagamento in metodos_pagamento -%}
        sum(case when metodo_pagamento = '{{ metodo_pagamento }}' then valor_pagamento else 0 end) 
        as {{ metodo_pagamento }}_valor_pagamento,
        {% endfor -%}

        sum(valor_pagamento) as pagamento_total

    from pagamentos
    group by id_pedido
),

final as (
    select
        pedidos.id_pedido,
        pedidos.id_cliente,
        pedidos.data_pedido,
        pedidos.status,

        {% for metodo_pagamento in metodos_pagamento -%}
        pagamentos_pedidos.{{ metodo_pagamento }}_valor_pagamento,
        {% endfor -%}

        pagamentos_pedidos.pagamento_total 

    from pedidos
    left join pagamentos_pedidos
        on pedidos.id_pedido = pagamentos_pedidos.id_pedido
)

select * from final;