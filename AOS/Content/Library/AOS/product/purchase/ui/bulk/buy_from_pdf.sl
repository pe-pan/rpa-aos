########################################################################################################################
#!!
#! @description: Shops for items listed in a pdf file. Each item can be purchased by a different user (their passwords listed in an excel sheet).
#!!#
########################################################################################################################
namespace: AOS.product.purchase.ui.bulk
flow:
  name: buy_from_pdf
  inputs:
    - excel_path: "C:\\\\Enablement\\\\HotLabs\\\\AOS\\\\shopping_list.xlsx"
    - users_sheet: Users
    - pdf_path: "C:\\\\Enablement\\\\HotLabs\\\\AOS\\\\shopping_list_letter.pdf"
    - login_header: Username
    - password_header: Password
  workflow:
    - get_users:
        do:
          io.cloudslang.base.excel.get_cell:
            - excel_file_name: '${excel_path}'
            - worksheet_name: '${users_sheet}'
            - login_header: '${login_header}'
            - password_header: '${password_header}'
        publish:
          - data: '${return_result}'
          - header
          - login_index: '${str(header.split(",").index(login_header))}'
          - password_index: '${str(header.split(",").index(password_header))}'
          - map: '${str({row.split(",")[int(login_index)]: row.split(",")[int(password_index)] for row in data.split("|")})}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: extract_text_from_pdf
    - extract_text_from_pdf:
        do:
          io.cloudslang.tesseract.ocr.extract_text_from_pdf:
            - file_path: '${pdf_path}'
            - data_path: "C:\\Enablement\\tessdata"
            - language: ENG
        publish:
          - text_string
          - items: '${text_string.split("Username Catalog Item")[1].split("Cheers")[0][1:]}'
        navigate:
          - SUCCESS: buy_item
          - FAILURE: on_failure
    - buy_item:
        parallel_loop:
          for: row in items.splitlines()
          do:
            AOS.product.purchase.ui.buy_item:
              - url: "${get_sp('aos_url')}"
              - username: '${row.split()[0]}'
              - password: '${eval(map).get(username)}'
              - catalog: '${row.split()[1]}'
              - item: '${row.split(None, 2)[2]}'
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
        x: 81
        'y': 145
      extract_text_from_pdf:
        x: 79
        'y': 300
      buy_item:
        x: 285
        'y': 301
        navigate:
          6eafe5eb-950e-eddd-d5a2-1c85c4b4db2a:
            targetId: ff55bf25-70df-c554-74e2-9c9de2b4bb73
            port: SUCCESS
    results:
      SUCCESS:
        ff55bf25-70df-c554-74e2-9c9de2b4bb73:
          x: 273
          'y': 131
