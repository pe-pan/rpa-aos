namespace: AOS.product.list.api.sub_flows
flow:
  name: iterate_categories
  inputs:
    - json
    - category_id
    - file_path
  workflow:
    - get_category:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: '${"$[?(@.categoryId == %s)]" % category_id}'
        publish:
          - category_json: '${return_result}'
        navigate:
          - SUCCESS: get_category_name
          - FAILURE: on_failure
    - get_category_name:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${category_json}'
            - json_path: '$.*.categoryName'
        publish:
          - category_name: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: get_product_ids
          - FAILURE: on_failure
    - iterate_products:
        loop:
          for: product_id in product_ids
          do:
            AOS.product.list.api.sub_flows.iterate_products:
              - json: '${category_json}'
              - category_name: '${category_name}'
              - category_id: '${category_id}'
              - product_id: '${product_id}'
              - file_path: '${file_path}'
          break:
            - FAILURE
          publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - get_product_ids:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${category_json}'
            - json_path: '$.*.products.*.productId'
        publish:
          - product_ids: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: iterate_products
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_category:
        x: 73
        'y': 75
      get_category_name:
        x: 64
        'y': 297
      iterate_products:
        x: 226
        'y': 81
        navigate:
          0b916874-61a7-5e7e-00d6-6813283a1168:
            targetId: cb52b646-9ed7-ddb6-39f3-1181bddd212c
            port: SUCCESS
      get_product_ids:
        x: 235
        'y': 292
    results:
      SUCCESS:
        cb52b646-9ed7-ddb6-39f3-1181bddd212c:
          x: 445
          'y': 90
