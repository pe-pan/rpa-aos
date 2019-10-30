namespace: AOS.user.remove.db.bulk
flow:
  name: remove_users_from_excel
  inputs:
    - excel_path: "C:\\\\Enablement\\\\HotLabs\\\\AOS\\\\shopping_list.xlsx"
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
          - success: remove_users
    - remove_users:
        do:
          AOS.user.remove.db.bulk.remove_users:
            - login_name_list: '${login_name_list}'
        publish:
          - deleted_users
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - deleted_users: '${deleted_users}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_Cell:
        x: 64
        'y': 123
      remove_users:
        x: 245
        'y': 120
        navigate:
          8e46f956-0902-c36c-5760-de05f8622a14:
            targetId: ec2a89c7-51c9-ca9a-485c-31be1b90bf2d
            port: SUCCESS
    results:
      SUCCESS:
        ec2a89c7-51c9-ca9a-485c-31be1b90bf2d:
          x: 440
          'y': 125
