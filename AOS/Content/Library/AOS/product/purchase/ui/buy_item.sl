########################################################################################################################
#!!
#! @description: Shops for an item.
#!!#
########################################################################################################################
namespace: AOS.product.purchase.ui
flow:
  name: buy_item
  inputs:
    - url:
        required: false
    - username
    - password:
        sensitive: true
    - catalog
    - item
  workflow:
    - buy_item_uft:
        do:
          AOS.product.purchase.ui.buy_item_uft:
            - url: "${get('url', get_sp('aos_url'))}"
            - username: '${username}'
            - password: '${password}'
            - catalog: '${catalog}'
            - item: '${item}'
        publish:
          - price
        navigate:
          - SUCCESS: SUCCESS
          - WARNING: SUCCESS
          - FAILURE: on_failure
  outputs:
    - price: '${price}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      buy_item_uft:
        x: 235
        'y': 133
        navigate:
          47e9b274-239c-4b8b-8c27-00e9ff62adec:
            targetId: ca414f4e-8322-f716-4bb3-2ad1031064dc
            port: SUCCESS
          98cd0e9d-5abd-1557-6883-e575b74a1ca0:
            targetId: ca414f4e-8322-f716-4bb3-2ad1031064dc
            port: WARNING
    results:
      SUCCESS:
        ca414f4e-8322-f716-4bb3-2ad1031064dc:
          x: 453
          'y': 132
