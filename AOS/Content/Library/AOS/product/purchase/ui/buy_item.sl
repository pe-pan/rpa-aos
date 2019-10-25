namespace: AOS.product.purchase.ui
flow:
  name: buy_item
  inputs:
    - host
    - user
    - password
    - catalog
    - item
  workflow:
    - buy_item_act:
        do:
          AOS.product.purchase.ui.buy_item_act:
            - host: '${host}'
            - user: '${user}'
            - password: '${password}'
            - catalog: '${catalog}'
            - item: '${item}'
        publish:
          - total_price
        navigate:
          - SUCCESS: SUCCESS
          - WARNING: SUCCESS
          - FAILURE: on_failure
  outputs:
    - total_price: '${total_price}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      buy_item_act:
        x: 231
        'y': 139
        navigate:
          3f4552ea-c3ed-b447-a985-85c7f7dd3d62:
            targetId: ca414f4e-8322-f716-4bb3-2ad1031064dc
            port: SUCCESS
          0f77e4d7-9266-3eaa-a6c6-cfadb0a380c9:
            targetId: ca414f4e-8322-f716-4bb3-2ad1031064dc
            port: WARNING
    results:
      SUCCESS:
        ca414f4e-8322-f716-4bb3-2ad1031064dc:
          x: 453
          'y': 132
