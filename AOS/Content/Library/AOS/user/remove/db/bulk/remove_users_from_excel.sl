namespace: AOS.user.remove.db.bulk
flow:
  name: remove_users_from_excel
  inputs:
    - excel_path: "C:\\\\Enablement\\\\HotLabs\\\\AOS\\\\AOS-shopping-list.xlsx"
    - sheet: Users
    - login_header: Username
  workflow:
    - Get_Cell:
        do_external:
          5060d8cc-d03c-43fe-946f-7babaaec589f:
            - excelFileName: '${excel_path}'
            - worksheetName: '${sheet}'
            - hasHeader: 'yes'
            - firstRowIndex: '0'
            - rowIndex: '0:1000'
            - columnIndex: '0:100'
            - rowDelimiter: '|'
            - columnDelimiter: ','
            - login_header: '${login_header}'
        publish:
          - data: '${returnResult}'
          - header
          - login_name_list: '${str(tuple(str(row.split(",")[header.split(",").index(login_header)]) for row in data.split("|")))}'
        navigate:
          - failure: on_failure
          - success: delete_shippingaddress
    - delete_account:
        do:
          io.cloudslang.base.database.sql_command:
            - db_server_name: "${get_sp('db_host')}"
            - db_type: PostgreSQL
            - username: "${get_sp('db_user')}"
            - password:
                value: "${get_sp('db_password')}"
                sensitive: true
            - database_name: adv_account
            - command: "${'DELETE FROM account WHERE login_name IN '+login_name_list+';'}"
            - trust_all_roots: 'true'
        publish:
          - update_count
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - delete_shippingaddress:
        do:
          io.cloudslang.base.database.sql_command:
            - db_server_name: "${get_sp('db_host')}"
            - db_type: PostgreSQL
            - username: "${get_sp('db_user')}"
            - password:
                value: "${get_sp('db_password')}"
                sensitive: true
            - database_name: adv_account
            - command: "${'DELETE FROM shippingaddress WHERE user_id IN (SELECT user_id FROM account where login_name IN '+login_name_list+');'}"
            - trust_all_roots: 'true'
        publish:
          - update_count
        navigate:
          - SUCCESS: delete_account
          - FAILURE: on_failure
  outputs:
    - deleted_users: '${update_count}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_Cell:
        x: 64
        'y': 123
      delete_shippingaddress:
        x: 192
        'y': 119
      delete_account:
        x: 312
        'y': 119
        navigate:
          28b5b68e-6b25-9d2a-ac86-91e7e39c5145:
            targetId: ec2a89c7-51c9-ca9a-485c-31be1b90bf2d
            port: SUCCESS
    results:
      SUCCESS:
        ec2a89c7-51c9-ca9a-485c-31be1b90bf2d:
          x: 440
          'y': 125
