namespace: AOS.product.purchase.ui.bulk
flow:
  name: buy_from_pdf
  workflow:
    - extract_text_from_pdf:
        do:
          io.cloudslang.tesseract.ocr.extract_text_from_pdf:
            - file_path: "C:\\Enablement\\exercises\\AOS\\shopping_list.pdf"
            - data_path: "C:\\Enablement\\tessdata"
            - language: ENG
        publish:
          - text_string
          - items: '${text_string.split("Username Catalog Item")[1].split("Cheers")[0][1:]}'
        navigate:
          - SUCCESS: buy_item
          - FAILURE: on_failure
    - buy_item:
        loop:
          for: row in items.splitlines()
          do:
            AOS.product.purchase.ui.buy_item:
              - host: host
              - user: user
              - url
              - username: '${row.split()[0]}'
              - password
              - catalog: '${row.split()[1]}'
              - item: '${row.split(None, 2)[2]}'
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      extract_text_from_pdf:
        x: 101
        'y': 112
      buy_item:
        x: 250
        'y': 117
        navigate:
          6eafe5eb-950e-eddd-d5a2-1c85c4b4db2a:
            targetId: ff55bf25-70df-c554-74e2-9c9de2b4bb73
            port: SUCCESS
    results:
      SUCCESS:
        ff55bf25-70df-c554-74e2-9c9de2b4bb73:
          x: 435
          'y': 120
