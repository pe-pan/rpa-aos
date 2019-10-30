########################################################################################################################
#!!
#! @description: Reads the list of product items from AOS and persists the list into a text file or an excel sheet. It decides on the file_path extension; if being *.xls or *.xlsx, it saves to an excel sheet, otherwise to a text file.
#!
#! @input file_path: If *.xls or *.xlsx, it saves to an excel sheet; to a text file otherwise.
#!!#
########################################################################################################################
namespace: AOS.product.list.api
flow:
  name: get_products
  inputs:
    - aos_url: 'http://rpa.mf-te.com:8080'
    - file_path: "c:\\\\temp\\\\products.txt"
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: '${aos_url+"/catalog/api/v1/categories/all_data"}'
        publish:
          - json: '${return_result}'
        navigate:
          - SUCCESS: is_excel
          - FAILURE: on_failure
    - get_categories:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: '$.*.categoryId'
        publish:
          - category_id_list: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: iterate_categories
          - FAILURE: on_failure
    - iterate_categories:
        loop:
          for: category_id in category_id_list
          do:
            AOS.product.list.api.sub_flows.iterate_categories:
              - json: '${json}'
              - category_id: '${category_id}'
              - file_path: '${file_path}'
          break:
            - FAILURE
          publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - write_header:
        do:
          io.cloudslang.base.filesystem.write_to_file:
            - file_path: '${file_path}'
            - text: "${'+'+'+'.join([''.center(13,'-'),''.center(15,'-'),''.center(12,'-'),''.center(51,'-'),''.center(15,'-'),''.center(60,'-')])+'+\\n'+\\\n'|'+'|'.join(['Category ID'.center(13),'Category Name'.center(15),'Product ID'.center(12),'Product Name'.center(51),'Product Price'.center(15),'Color Codes'.center(60)])+'|\\n'+\\\n'+'+'+'.join([''.center(13,'-'),''.center(15,'-'),''.center(12,'-'),''.center(51,'-'),''.center(15,'-'),''.center(60,'-')])+'+\\n'}"
        navigate:
          - SUCCESS: get_categories
          - FAILURE: on_failure
    - is_excel:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(file_path.endswith("xls") or file_path.endswith("xlsx"))}'
        navigate:
          - 'TRUE': delete
          - 'FALSE': write_header
    - New_Excel_Document:
        do_external:
          9d21ca68-7d03-4fb3-9478-03956532bf6f:
            - excelFileName: '${file_path}'
            - worksheetNames: "${get_sp('worksheet')}"
            - delimiter: ','
        publish:
          - result: '${returnResult}'
        navigate:
          - failure: on_failure
          - success: get_categories
    - delete:
        do:
          io.cloudslang.base.filesystem.delete:
            - source: '${file_path}'
        navigate:
          - SUCCESS: New_Excel_Document
          - FAILURE: New_Excel_Document
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_get:
        x: 75
        'y': 158
      get_categories:
        x: 460
        'y': 159
      iterate_categories:
        x: 602
        'y': 154
        navigate:
          7e079e4a-a61e-729f-2180-1169f387de57:
            targetId: d4fb690f-9a7d-8636-d260-4a6176a6973d
            port: SUCCESS
      write_header:
        x: 322
        'y': 313
      is_excel:
        x: 248
        'y': 152
      New_Excel_Document:
        x: 410
        'y': 14
      delete:
        x: 268
        'y': 20
    results:
      SUCCESS:
        d4fb690f-9a7d-8636-d260-4a6176a6973d:
          x: 756
          'y': 156
