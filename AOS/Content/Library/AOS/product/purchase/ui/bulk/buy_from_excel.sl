########################################################################################################################
#!!
#! @description: Shops for items listed in an excel sheet. Each item can be purchased by a different user.
#!!#
########################################################################################################################
namespace: AOS.product.purchase.ui.bulk
flow:
  name: buy_from_excel
  inputs:
    - excel_path: "C:\\\\Enablement\\\\HotLabs\\\\AOS\\\\shopping_list.xlsx"
    - users_sheet: Users
    - items_sheet: Shopping List
    - login_header: Username
    - password_header: Password
    - catalog_header: Catalog
    - item_header: Item
  workflow:
    - get_users:
        do_external:
          5060d8cc-d03c-43fe-946f-7babaaec589f:
            - excelFileName: '${excel_path}'
            - worksheetName: '${users_sheet}'
            - hasHeader: 'yes'
            - firstRowIndex: '0'
            - rowIndex: '0:1000'
            - columnIndex: '0:100'
            - rowDelimiter: '|'
            - columnDelimiter: ','
            - login_header: '${login_header}'
            - password_header: '${password_header}'
        publish:
          - data: '${returnResult}'
          - header
          - login_index: '${str(header.split(",").index(login_header))}'
          - password_index: '${str(header.split(",").index(password_header))}'
          - map: '${str({row.split(",")[int(login_index)]: row.split(",")[int(password_index)] for row in data.split("|")})}'
        navigate:
          - failure: on_failure
          - success: get_items
    - get_items:
        do_external:
          5060d8cc-d03c-43fe-946f-7babaaec589f:
            - excelFileName: '${excel_path}'
            - worksheetName: '${items_sheet}'
            - hasHeader: 'yes'
            - firstRowIndex: '0'
            - rowIndex: '0:1000'
            - columnIndex: '0:100'
            - rowDelimiter: '|'
            - columnDelimiter: ','
            - login_header: '${login_header}'
            - catalog_header: '${catalog_header}'
            - item_header: '${item_header}'
        publish:
          - data: '${returnResult}'
          - header
          - login_index: '${str(header.split(",").index(login_header))}'
          - catalog_index: '${str(header.split(",").index(catalog_header))}'
          - item_index: '${str(header.split(",").index(item_header))}'
        navigate:
          - failure: on_failure
          - success: buy_item
    - buy_item:
        parallel_loop:
          for: 'row in data.split("|")'
          do:
            AOS.product.purchase.ui.buy_item:
              - url: "${get_sp('aos_url')}"
              - username: '${row.split(",")[int(login_index)]}'
              - password: '${eval(map).get(username)}'
              - catalog: '${row.split(",")[int(catalog_index)]}'
              - item: '${row.split(",")[int(item_index)]}'
        publish:
          - price: '${str(branches_context[0]["price"])}'
          - price_list: '${str([str(x["price"]) for x in branches_context])}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_users:
        x: 58
        'y': 107
      get_items:
        x: 52
        'y': 271
      buy_item:
        x: 207
        'y': 269
        navigate:
          3e1cf163-da36-7635-03c5-e9aa6bf8312f:
            targetId: 83dafc1b-24bb-69e0-f817-7c4f03ee6692
            port: SUCCESS
    results:
      SUCCESS:
        83dafc1b-24bb-69e0-f817-7c4f03ee6692:
          x: 200
          'y': 109
