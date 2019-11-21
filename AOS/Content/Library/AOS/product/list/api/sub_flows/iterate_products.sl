namespace: AOS.product.list.api.sub_flows
flow:
  name: iterate_products
  inputs:
    - json
    - category_name
    - category_id
    - product_id
    - file_path
  workflow:
    - get_product_name:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: "${'$.*.products[?(@.productId == %s)].productName' % product_id}"
        publish:
          - product_name: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: get_product_price
          - FAILURE: on_failure
    - get_product_price:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: "${'$.*.products[?(@.productId == %s)].price' % product_id}"
        publish:
          - product_price: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: get_color_codes
          - FAILURE: on_failure
    - Add_Excel_Data:
        do_external:
          4552e495-4595-4916-b58b-ce521bdb1e9a:
            - excelFileName: '${file_path}'
            - worksheetName: "${get_sp('worksheet')}"
            - headerData: "${'Category ID,Category Name,Product ID,Product Name,Product Price,'+','.join(['Color Code'] * 8)}"
            - rowData: "${','.join([category_id,category_name,product_id,product_name,product_price,color_codes])}"
            - columnDelimiter: ','
            - rowsDelimiter: '|'
            - rowIndex: ''
            - columnIndex: ''
            - overwriteData: 'false'
        publish:
          - result: '${returnResult}'
        navigate:
          - failure: on_failure
          - success: SUCCESS
    - add_product:
        do:
          io.cloudslang.base.filesystem.add_text_to_file:
            - file_path: '${file_path}'
            - text: "${\"|\"+\"|\".join([category_id.rjust(13),category_name.ljust(15),product_id.rjust(12),product_name.ljust(51),product_price.rjust(15),color_codes.ljust(60)])+\"|\\n\"}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - is_excel:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(file_path.endswith("xls") or file_path.endswith("xlsx"))}'
        navigate:
          - 'TRUE': Add_Excel_Data
          - 'FALSE': add_product
    - get_color_codes:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: "${'$.*.products[?(@.productId == %s)].colors.*.code' % product_id}"
        publish:
          - color_codes: "${filter(lambda ch: ch not in '\"', return_result)[1:-1]}"
        navigate:
          - SUCCESS: is_excel
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_product_name:
        x: 104
        'y': 96
      get_product_price:
        x: 99
        'y': 273
      Add_Excel_Data:
        x: 430
        'y': 16
        navigate:
          677bae73-735c-9801-d27c-4c48b9c4d5e7:
            targetId: cb52b646-9ed7-ddb6-39f3-1181bddd212c
            port: success
      add_product:
        x: 431
        'y': 262
        navigate:
          62d55fa1-0b87-71e0-44bb-3aa5cdc662bf:
            targetId: cb52b646-9ed7-ddb6-39f3-1181bddd212c
            port: SUCCESS
      is_excel:
        x: 305
        'y': 85
      get_color_codes:
        x: 280
        'y': 274
    results:
      SUCCESS:
        cb52b646-9ed7-ddb6-39f3-1181bddd212c:
          x: 580
          'y': 119
