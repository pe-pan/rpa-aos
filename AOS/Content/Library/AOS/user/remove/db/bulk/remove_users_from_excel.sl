namespace: AOS.user.remove.db.bulk
flow:
  name: remove_users_from_excel
  inputs:
    - excel_path: "C:\\\\Users\\\\Administrator\\\\Desktop\\\\AOS-shopping-list.xlsx"
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
          - success: sql_command
    - sql_command:
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
  outputs:
    - deleted_users: '${update_count}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_Cell:
        x: 90
        'y': 123
      sql_command:
        x: 253
        'y': 123
        navigate:
          28b5b68e-6b25-9d2a-ac86-91e7e39c5145:
            targetId: ec2a89c7-51c9-ca9a-485c-31be1b90bf2d
            port: SUCCESS
    results:
      SUCCESS:
        ec2a89c7-51c9-ca9a-485c-31be1b90bf2d:
          x: 436
          'y': 127
